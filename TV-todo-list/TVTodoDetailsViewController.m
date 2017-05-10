//
//  TVTodoDetailsViewController.m
//  CrossPlatformToDoList
//
//  Created by A Cahn on 5/9/17.
//  Copyright © 2017 A Cahn. All rights reserved.
//

#import "TVTodoDetailsViewController.h"
#import "TVHomeViewController.h"

@interface TVTodoDetailsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *detailTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *detailContentLabel;

@end

@implementation TVTodoDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.detailTitleLabel.text = self.todo.title;
    self.detailContentLabel.text = self.todo.content;
    
}


@end
