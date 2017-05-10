//
//  Todo.m
//  CrossPlatformToDoList
//
//  Created by A Cahn on 5/9/17.
//  Copyright © 2017 A Cahn. All rights reserved.
//

#import "Todo.h"

@implementation Todo

-(instancetype)initWithTitle:(NSString *)title withContent:(NSString *)content{
    
    self.title = title;
    self.content = content;
    
    return self;
}

@end