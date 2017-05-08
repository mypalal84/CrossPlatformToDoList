//
//  LoginViewController.m
//  CrossPlatformToDoList
//
//  Created by A Cahn on 5/8/17.
//  Copyright © 2017 A Cahn. All rights reserved.
//

#import "LoginViewController.h"

@import FirebaseAuth;

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (IBAction)loginPressed:(id)sender {
    
//********All You Need For Sign Out*********
//    NSError *signOutError;
//    [[FIRAuth auth]signOut:&signOutError];
    
    [[FIRAuth auth]signInWithEmail:self.emailTextField.text password:self.passwordTextField.text completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"Error Signing In: %@", error.localizedDescription);
        }
        if (user) {
            NSLog(@"Logged In User: %@", user);
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (IBAction)signupPressed:(id)sender {
    
    [[FIRAuth auth]createUserWithEmail:self.emailTextField.text password:self.passwordTextField.text completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"Error Signing Up: %@", error.localizedDescription);
        }
        if (user) {
            NSLog(@"Successfully Signed Up User: %@", user);
            //for lab, let them log in here
        }
    }];
}

@end
