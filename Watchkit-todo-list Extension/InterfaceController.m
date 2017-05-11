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

@import WatchConnectivity;

@interface InterfaceController ()<WCSessionDelegate>

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

-(void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex{
    
    [self pushControllerWithName:@"TodoDetailsInterfaceController" context:[self.allTodos objectAtIndex:rowIndex]];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    [[WCSession defaultSession]setDelegate:self];
    [[WCSession defaultSession]activateSession];
    
    //The message parameter is where you would want to hand the iOS app new Todo data to save to Firebase
    [[WCSession defaultSession]sendMessage:@{} replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
        NSArray *todoDictionaries = replyMessage[@"todos"];
        
        NSMutableArray *allTodos = [[NSMutableArray alloc]init];
        
        for (NSDictionary *todoObject in todoDictionaries) {
            
            Todo *newTodo = [[Todo alloc]init];
            newTodo.title = todoObject[@"title"];
            newTodo.content = todoObject[@"content"];
            //assign any other values here...
            [allTodos addObject:newTodo];
        }
        self.allTodos = allTodos.copy;
        [self setupTable];
        
    } errorHandler:^(NSError * _Nonnull error) {
        
        NSLog(@"%@", error.localizedDescription);
    }];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (IBAction)newTodoPressed {
    
    NSArray *suggestions = @[@"Hello There", @"Hashtag#", @"I really should walk the dog."];
    
    [self presentTextInputControllerWithSuggestions:suggestions allowedInputMode:WKTextInputModeAllowEmoji completion:^(NSArray * _Nullable results) {
        NSLog(@"%@", results);
    }];
}

@end



