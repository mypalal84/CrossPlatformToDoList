//
//  CompletedViewController.m
//  CrossPlatformToDoList
//
//  Created by A Cahn on 5/10/17.
//  Copyright © 2017 A Cahn. All rights reserved.
//

#import "CompletedViewController.h"
#import "LoginViewController.h"
#import "ViewController.h"
#import "Todo.h"

@import Firebase;

@interface CompletedViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong, nonatomic)FIRDatabaseReference *userReference;
@property(strong, nonatomic)FIRUser *currentUser;
@property(nonatomic)FIRDatabaseHandle allTodosHandler;
@property(strong, nonatomic)NSMutableArray *completedTodos;

@end

@implementation CompletedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.completedTodos = [[NSMutableArray alloc]init];
    self.tableView.estimatedRowHeight = 33.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
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
        
        self.completedTodos = [[NSMutableArray alloc]init];
        
        for (FIRDataSnapshot *child in snapshot.children) {
            
            NSDictionary *todoData = child.value;
            
            Todo *currentTodo = [[Todo alloc]init];
            currentTodo.title = todoData[@"title"];
            currentTodo.content = todoData[@"content"];
            currentTodo.uniqueKey = child.key;
            currentTodo.isCompleted = todoData[@"isCompleted"];
            if ([currentTodo.isCompleted isEqual:@1]) {
                
                [self.completedTodos addObject:currentTodo];
            }
            [self.tableView reloadData];
        }
    }];
}


//MARK: TableView Methods
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    Todo *currentTodo = self.completedTodos[indexPath.row];
    
    cell.textLabel.numberOfLines = 0;
    
    cell.textLabel.text = [NSString stringWithFormat:@"Title: %@\nContent: %@", currentTodo.title, currentTodo.content];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.completedTodos count];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    Todo *todo = self.completedTodos[indexPath.row];
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"DELETE" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [[[self.userReference child:@"todos"] child:todo.uniqueKey] removeValue];
    }];
    deleteAction.backgroundColor = [UIColor redColor];
    
    return @[deleteAction];
}


@end
