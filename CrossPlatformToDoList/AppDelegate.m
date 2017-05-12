//
//  AppDelegate.m
//  CrossPlatformToDoList
//
//  Created by A Cahn on 5/8/17.
//  Copyright © 2017 A Cahn. All rights reserved.
//

#import "AppDelegate.h"

@import Firebase;
@import WatchConnectivity;

typedef void(^FirebaseCallback)(NSArray *allTodos);

@interface AppDelegate ()<WCSessionDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [FIRApp configure];
    
    [[WCSession defaultSession]setDelegate:self];
    [[WCSession defaultSession]activateSession];
    
    return YES;
}

-(void)startMonitoringTodoUpdates:(FirebaseCallback)callback{
    
    FIRDatabaseReference *databaseReference = [[FIRDatabase database]reference];
    
    FIRUser *currentUser = [[FIRAuth auth]currentUser];
    
    FIRDatabaseReference *userReference = [[databaseReference child:@"users"]child:currentUser.uid];
    
    [[userReference child:@"todos"]observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        NSMutableArray *todoDictionaries = [[NSMutableArray alloc]init];
        
        for (FIRDataSnapshot *todoReference in snapshot.children) {
            
            [todoDictionaries addObject:todoReference.value];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            callback(todoDictionaries.copy);
        });
    }];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)message replyHandler:(void (^)(NSDictionary<NSString *,id> * _Nonnull))replyHandler{
    
    [self startMonitoringTodoUpdates:^(NSArray *allTodos) {
        
        replyHandler(@{@"todos": allTodos});
    }];
}


@end
