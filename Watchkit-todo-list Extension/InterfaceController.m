//
//  InterfaceController.m
//  Watchkit-todo-list Extension
//
//  Created by A Cahn on 5/9/17.
//  Copyright © 2017 A Cahn. All rights reserved.
//

#import "InterfaceController.h"
#import "TodoRowController.h"
#import "Todo.h"

@interface InterfaceController ()

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceTable *table;
@property(strong, nonatomic)NSArray<Todo *> *allTodos;

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    [self setupTable];
    // Configure interface objects here.
}

-(void)setupTable{
    [self.table setNumberOfRows:self.allTodos.count withRowType:@"TodoRowController"];
    
    for (NSInteger i = 0; i < self.allTodos.count; i++) {
        
        TodoRowController *rowController = [self.table rowControllerAtIndex:i];
        
        [rowController.titleLabel setText:self.allTodos[i].title];
        [rowController.contentLabel setText:self.allTodos[i].content];
    }
}

-(NSArray<Todo *> *)allTodos{
    
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

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

-(void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex{
    
    
}


- (IBAction)newTodoPressed {
    
    NSArray *suggestions = @[@"Hello There", @"Hashtag#", @"I really should walk the dog."];
    
    [self presentTextInputControllerWithSuggestions:suggestions allowedInputMode:WKTextInputModeAllowEmoji completion:^(NSArray * _Nullable results) {
        NSLog(@"%@", results);
    }];
}

@end



