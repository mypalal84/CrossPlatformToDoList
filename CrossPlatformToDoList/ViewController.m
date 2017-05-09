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

@import FirebaseAuth;
@import Firebase;

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

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
            
            NSString *todoTitle = todoData[@"title"];
            NSString *todoContent = todoData[@"content"];
            
            [self.allTodos addObject:todoData];
            [self.todoTableView reloadData];
            
            NSLog(@"Todo Title: %@ - Content: %@", todoTitle, todoContent);
        }
    }];
}

//MARK: TableView Methods
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSDictionary *todoData = self.allTodos[indexPath.row];
    
    NSString *todoTitle = todoData[@"title"];
    NSString *todoContent = todoData[@"content"];
    
    cell.textLabel.numberOfLines = 0;
    
    cell.textLabel.text = [NSString stringWithFormat:@"Title: %@\nContent: %@", todoTitle, todoContent];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.allTodos count];
}

//MARK: Buttons Pressed
- (IBAction)logoutPressed:(id)sender {
    
    NSError *signOutError;
    [[FIRAuth auth]signOut:&signOutError];
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
