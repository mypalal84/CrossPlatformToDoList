//
//  Todo.h
//  CrossPlatformToDoList
//
//  Created by A Cahn on 5/9/17.
//  Copyright © 2017 A Cahn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Todo : NSObject

@property(strong, nonatomic)NSString *email;
@property(strong, nonatomic)NSString *uniqueKey;
@property(strong, nonatomic)NSString *title;
@property(strong, nonatomic)NSString *content;
@property(strong, nonatomic)NSNumber *isCompleted;


@end
