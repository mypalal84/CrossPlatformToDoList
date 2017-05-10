//
//  TodoDetailsInterfaceController.m
//  CrossPlatformToDoList
//
//  Created by A Cahn on 5/9/17.
//  Copyright © 2017 A Cahn. All rights reserved.
//

#import "TodoDetailsInterfaceController.h"
#import "InterfaceController.h"
#import "Todo.h"

@interface TodoDetailsInterfaceController ()

@property(strong, nonatomic)Todo *todo;

@end

@implementation TodoDetailsInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    self.todo = context;
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    [self.titleLabel setText:self.todo.title];
    [self.contentLabel setText:self.todo.content];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



