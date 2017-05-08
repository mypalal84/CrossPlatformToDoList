//
//  ViewController.m
//  CrossPlatformToDoList
//
//  Created by A Cahn on 5/8/17.
//  Copyright © 2017 A Cahn. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewController.h"

@import FirebaseAuth;
@import Firebase;

@interface ViewController ()

@property(strong, nonatomic)FIRDatabaseReference *userReference;
@property(strong, nonatomic)FIRUser *currentUser;

@property(nonatomic)FIRDatabaseHandle allTodosHandler;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

@end
