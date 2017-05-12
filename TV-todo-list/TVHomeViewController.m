//
//  TVHomeViewController.m
//  CrossPlatformToDoList
//
//  Created by A Cahn on 5/9/17.
//  Copyright © 2017 A Cahn. All rights reserved.
//

#import "TVHomeViewController.h"
#import "TVTodoDetailsViewController.h"
#import "Todo.h"
#import "FirebaseAPI.h"
#import "TVLoginViewController.h"

@interface TVHomeViewController ()<UITableViewDataSource, UITableViewDelegate>

@property(strong, nonatomic)NSArray<Todo *> *allTodos;
@property(strong, nonatomic)NSString *userEmail;
@property(weak, nonatomic)IBOutlet UITableView *tableView;

@end

@implementation TVHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self checkEmail];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [FirebaseAPI fetchAllTodos:^(NSArray<Todo *> *allTodos) {
        NSLog(@"%@", allTodos);
        
        self.allTodos = allTodos;
        [self.tableView reloadData];
    }];
}

-(void)checkEmail{
    
    if (!self.userEmail) {
        TVLoginViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"TVLoginViewController"];
        
        [self presentViewController:view animated:YES completion:nil];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"PresentTodoDetailsViewController"]) {
        
        TVTodoDetailsViewController *detailVC = segue.destinationViewController;
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        detailVC.todo = self.allTodos[indexPath.row];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.allTodos[indexPath.row].title;
    cell.detailTextLabel.text = self.allTodos[indexPath.row].content;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.allTodos.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self performSegueWithIdentifier:@"PresentTodoDetailsViewController" sender:indexPath];
}

@end
