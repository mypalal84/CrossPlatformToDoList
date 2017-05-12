//
//  Todo.m
//  CrossPlatformToDoList
//
//  Created by A Cahn on 5/9/17.
//  Copyright © 2017 A Cahn. All rights reserved.
//

#import "Todo.h"

@implementation Todo

-(instancetype)initWithEmail:(NSString *)email withUniqueKey:(NSString *)uniqueKey withTitle:(NSString *)title withContent:(NSString *)content andIsCompleted:(NSNumber *)isCompleted{
    
    self.email = email;
    self.uniqueKey = uniqueKey;
    self.title = title;
    self.content = content;
    self.isCompleted = @0;
    
    return self;
}

@end
