//
//  TVHomeViewController.m
//  CrossPlatformToDoList
//
//  Created by A Cahn on 5/9/17.
//  Copyright © 2017 A Cahn. All rights reserved.
//

#import "TVHomeViewController.h"
//#import "Todo.h"

@interface TVHomeViewController ()<UITableViewDataSource>

//@property(strong, nonatomic)NSArray<Todo *> *allTodos;
@property(strong, nonatomic)NSArray *allTodos;
@property(weak, nonatomic)IBOutlet UITableView *tableView;

@end

@implementation TVHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
}

-(NSArray *)allTodos{
    
    NSString *firstTodo = @"First todo";
    NSString *secondTodo = @"Second todo";
    NSString *thirdTodo = @"Third todo";
    return @[firstTodo, secondTodo, thirdTodo];
    //    Todo *firstTodo = [[Todo alloc]init];
    //    firstTodo.title = @"First Todo";
    //    firstTodo.content = @"This is a todo";
    //
    //    Todo *secondTodo = [[Todo alloc]init];
    //    secondTodo.title = @"Second Todo";
    //    secondTodo.content = @"This is also a todo";
    //
    //    Todo *thirdTodo = [[Todo alloc]init];
    //    thirdTodo.title = @"First Todo";
    //    thirdTodo.content = @"Yet another todo";
    //
    //    return @[firstTodo, secondTodo, thirdTodo];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.allTodos[indexPath.row];
    cell.detailTextLabel.text = self.allTodos[indexPath.row];
//    cell.textLabel.text = self.allTodos[indexPath.row].title;
//    cell.detailTextLabel.text = self.allTodos[indexPath.row].content;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.allTodos.count;
}


@end
