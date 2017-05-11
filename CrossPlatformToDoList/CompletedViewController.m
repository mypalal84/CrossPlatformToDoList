//
//  CompletedViewController.m
//  CrossPlatformToDoList
//
//  Created by A Cahn on 5/10/17.
//  Copyright © 2017 A Cahn. All rights reserved.
//

#import "CompletedViewController.h"
#import "ViewController.h"
#import "Todo.h"

@interface CompletedViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong, nonatomic)NSMutableArray *allTodos;

@end

@implementation CompletedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

//MARK: TableView Methods
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    Todo *currentTodo = self.allTodos[indexPath.row];
    
    cell.textLabel.numberOfLines = 0;
    
    cell.textLabel.text = [NSString stringWithFormat:@"Title: %@\nContent: %@", currentTodo.title, currentTodo.content];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    tableView.estimatedRowHeight = 85.0;
    
    tableView.rowHeight = UITableViewAutomaticDimension;
    
    return [self.allTodos count];
}


@end
