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

@interface ViewController ()

@property(strong, nonatomic)FIRDatabaseReference *userReference;
@property(strong, nonatomic)FIRUser *currentUser;

@property(nonatomic)FIRDatabaseHandle allTodosHandler;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *todoViewTopConstraint;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.todoViewTopConstraint.constant = -214;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self checkUserStatus];
}

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    [super prepareForSegue:segue sender:sender];
//    
//    NSLog(@"%@", segue.destinationViewController);
//}


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
        
        NSMutableArray *allTodos = [[NSMutableArray alloc]init];
        
        for (FIRDataSnapshot *child in snapshot.children) {
            
            NSDictionary *todoData = child.value;
            
            NSString *todoTitle = todoData[@"title"];
            NSString *todoContent = todoData[@"content"];
            
            //for lab append new 'todo' to allTodos array
            NSLog(@"Todo Title: %@ - Content: %@", todoTitle, todoContent);
        }
    }];
}



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
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}


@end
