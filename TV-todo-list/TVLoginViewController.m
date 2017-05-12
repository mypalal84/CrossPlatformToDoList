//
//  TVLoginViewController.m
//  CrossPlatformToDoList
//
//  Created by A Cahn on 5/11/17.
//  Copyright © 2017 A Cahn. All rights reserved.
//

#import "TVLoginViewController.h"
#import "LoginViewController.h"
#import "Todo.h"
#import "Credentials.h"
#import "FirebaseAPI.h"

@interface TVLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property(strong, nonatomic)NSMutableArray *allEmails;

@end

@implementation TVLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (IBAction)goButtonPressed:(id)sender {
    
    
}

@end
