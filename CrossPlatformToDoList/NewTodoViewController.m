//
//  NewTodoViewController.m
//  CrossPlatformToDoList
//
//  Created by A Cahn on 5/8/17.
//  Copyright © 2017 A Cahn. All rights reserved.
//

#import "NewTodoViewController.h"

@import Firebase;
@import FirebaseAuth;

@interface NewTodoViewController ()

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *contentTextField;


@end

@implementation NewTodoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)addTodoButtonPressed:(id)sender {
    
    FIRDatabaseReference *databaseReference = [[FIRDatabase database]reference];
    
    FIRUser *currentUser = [[FIRAuth auth]currentUser];
    
    FIRDatabaseReference *userReference = [[databaseReference child:@"users"]child:currentUser.uid];
    
    FIRDatabaseReference *newTodoReference = [[userReference child:@"todos"]childByAutoId];
    
    [[newTodoReference child:@"title"]setValue:self.titleTextField.text];
    [[newTodoReference child:@"content"]setValue:self.contentTextField.text];
    [[newTodoReference child:@"isCompleted"]setValue:@0];
}


@end
