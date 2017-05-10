//
//  FirebaseAPI.h
//  CrossPlatformToDoList
//
//  Created by A Cahn on 5/10/17.
//  Copyright © 2017 A Cahn. All rights reserved.
//

#import "Todo.h"
#import <Foundation/Foundation.h>

typedef void(^AllTodosCompletion)(NSArray<Todo *> *allTodos);

@interface FirebaseAPI : NSObject

+(void)fetchAllTodos:(AllTodosCompletion)completion;

@end
