//
//  ViewController.m
//  CrossPlatformToDoList
//
//  Created by A Cahn on 5/8/17.
//  Copyright © 2017 A Cahn. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewController.h"
#import "NewTodoViewController.h"
#import "Todo.h"


@import FirebaseAuth;
@import Firebase;

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

//@property(strong, nonatomic)UITableViewRowAction *rowAction;
//@property(strong, nonatomic)UITableViewRowAction *secondRowAction;
@property(strong, nonatomic)FIRDatabaseReference *userReference;
@property(strong, nonatomic)FIRUser *currentUser;
@property(nonatomic)FIRDatabaseHandle allTodosHandler;
@property(strong, nonatomic)NSMutableArray *allTodos;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *todoViewTopConstraint;
@property (weak, nonatomic) IBOutlet UITableView *todoTableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.todoViewTopConstraint.constant = -214;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self checkUserStatus];
    self.todoTableView.dataSource = self;
}

-(void)checkUserStatus{
    
    if (![[FIRAuth auth]currentUser]) {
        
        LoginViewController *loginController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        
        [self presentViewController:loginController animated:YES completion:nil];
        
    } else {
        [self setupFirebase];
        [self startMontiringTodoUpdates];
    }
}

-(void)setupFirebase{
    
    FIRDatabaseReference *databaseReference = [[FIRDatabase database]reference];
    
    self.currentUser = [[FIRAuth auth]currentUser];
    
    self.userReference = [[databaseReference child:@"users"]child:self.currentUser.uid];
    
    NSLog(@"User Reference: %@", self.userReference);
}

-(void)startMontiringTodoUpdates{
    
    self.allTodosHandler = [[self.userReference child:@"todos"]observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        self.allTodos = [[NSMutableArray alloc]init];
        
        for (FIRDataSnapshot *child in snapshot.children) {
            
            NSDictionary *todoData = child.value;
            
            Todo *currentTodo = [[Todo alloc]init];
            currentTodo.title = todoData[@"title"];
            currentTodo.content = todoData[@"content"];
            currentTodo.uniqueKey = child.key;
            currentTodo.isCompleted = todoData[@"isCompleted"];
            
            [self.allTodos addObject:currentTodo];
            [self.todoTableView reloadData];
        }
    }];
}

//MARK: TableView Methods
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    Todo *currentTodo = self.allTodos[indexPath.row];
    
    cell.textLabel.numberOfLines = 0;
    
    cell.textLabel.text = [NSString stringWithFormat:@"Title: %@\nContent: %@", currentTodo.title, currentTodo.content];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    tableView.estimatedRowHeight = 85.0;
    
    tableView.rowHeight = UITableViewAutomaticDimension;
    
    return [self.allTodos count];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Todo *todo = self.allTodos[indexPath.row];
        [[[self.userReference child:@"todos"] child:todo.uniqueKey] removeValue];
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

//MARK: Buttons Pressed
- (IBAction)logoutPressed:(id)sender {
    
    NSError *signOutError;
    [[FIRAuth auth]signOut:&signOutError];
    
    [self.allTodos removeAllObjects];
    [self.todoTableView reloadData];
    
    [self checkUserStatus];
}

- (IBAction)toggleTodoPressed:(id)sender {
    
    if(self.todoViewTopConstraint.constant == 0){
        self.todoViewTopConstraint.constant = -214;
    } else{
        self.todoViewTopConstraint.constant = 0;
    }
    [UIView animateWithDuration:0.4 animations:^{
        [self.view layoutIfNeeded];
    }];
}
@end
