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

@interface TVHomeViewController ()<UITableViewDataSource, UITableViewDelegate>

@property(strong, nonatomic)NSArray<Todo *> *allTodos;

@property(weak, nonatomic)IBOutlet UITableView *tableView;

@end

@implementation TVHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

-(NSArray *)allTodos{
    
        Todo *firstTodo = [[Todo alloc]init];
        firstTodo.title = @"First Todo";
        firstTodo.content = @"This is a todo";
    
        Todo *secondTodo = [[Todo alloc]init];
        secondTodo.title = @"Second Todo";
        secondTodo.content = @"This is also a todo";
    
        Todo *thirdTodo = [[Todo alloc]init];
        thirdTodo.title = @"Third Todo";
        thirdTodo.content = @"Yet another todo";
    
        return @[firstTodo, secondTodo, thirdTodo];
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
