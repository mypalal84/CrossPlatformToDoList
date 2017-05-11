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
#import "CompletedViewController.h"
#import "Todo.h"


@import FirebaseAuth;
@import Firebase;

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic)FIRDatabaseReference *userReference;
@property(strong, nonatomic)FIRUser *currentUser;
@property(nonatomic)FIRDatabaseHandle allTodosHandler;
@property(strong, nonatomic)NSMutableArray<Todo *> *allTodos;
@property(strong, nonatomic)NSMutableArray<Todo *> *completedTodos;
@property(strong, nonatomic)NSMutableArray<Todo *> *filteredTodos; // completed = 0

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *todoViewTopConstraint;
@property (weak, nonatomic) IBOutlet UITableView *todoTableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.completedTodos = [[NSMutableArray alloc]init];
    self.todoViewTopConstraint.constant = -150;
    self.todoTableView.estimatedRowHeight = 33.0;

    self.todoTableView.rowHeight = UITableViewAutomaticDimension;
    
    self.todoTableView.dataSource = self;
    self.todoTableView.delegate = self;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self checkUserStatus];
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
}

-(void)startMontiringTodoUpdates{
    
    self.allTodosHandler = [[self.userReference child:@"todos"]observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        self.allTodos = [[NSMutableArray alloc]init];
        self.filteredTodos = [[NSMutableArray alloc] init];
        
        for (FIRDataSnapshot *child in snapshot.children) {
            
            NSDictionary *todoData = child.value;
            
            Todo *currentTodo = [[Todo alloc]init];
            currentTodo.title = todoData[@"title"];
            currentTodo.content = todoData[@"content"];
            currentTodo.uniqueKey = child.key;
            currentTodo.isCompleted = todoData[@"isCompleted"];
            if ([currentTodo.isCompleted isEqual:@0]) {
                [self.filteredTodos addObject:currentTodo];
            }
            [self.allTodos addObject:currentTodo];
            [self.todoTableView reloadData];
        }
    }];
}

//MARK: TableView Methods
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    Todo *currentTodo = self.filteredTodos[indexPath.row];
    
    
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = [NSString stringWithFormat:@"Title: %@\nContent: %@", currentTodo.title, currentTodo.content];
    
    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [self.filteredTodos count];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected row: %@",indexPath);
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    Todo *todo = self.filteredTodos[indexPath.row];

    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"DELETE" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [[[self.userReference child:@"todos"] child:todo.uniqueKey] removeValue];
    }];
    deleteAction.backgroundColor = [UIColor redColor];
    
    UITableViewRowAction *completedAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"COMPLETED" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
       
        todo.isCompleted = @1;
        [[[self.userReference child:@"todos"]child:todo.uniqueKey]updateChildValues:@{@"isCompleted": @1}];
        [self.completedTodos addObject:todo];
        [self.todoTableView reloadData];
    }];
    completedAction.backgroundColor = [UIColor blueColor];
    
    return @[deleteAction, completedAction];
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
        self.todoViewTopConstraint.constant = -150;

    } else{
        self.todoViewTopConstraint.constant = 0;
    }
    [UIView animateWithDuration:0.4 animations:^{
        [self.view layoutIfNeeded];
    }];
}

@end
