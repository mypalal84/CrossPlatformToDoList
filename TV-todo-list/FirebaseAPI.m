//
//  FirebaseAPI.m
//  CrossPlatformToDoList
//
//  Created by A Cahn on 5/10/17.
//  Copyright © 2017 A Cahn. All rights reserved.
//

#import "FirebaseAPI.h"
#import "Credentials.h"

@implementation FirebaseAPI

+(void)fetchAllTodos:(AllTodosCompletion)completion{
    
    NSString *urlString = [NSString stringWithFormat:@"https://crossplatformtodolist-4208c.firebaseio.com/users.json?auth=%@", APP_KEY];
    
    NSURL *databaseURL = [NSURL URLWithString:urlString];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration]];
    
    [[session dataTaskWithURL:databaseURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary *rootObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"Root Object: %@", rootObject);
        
    }] resume];
}

@end
