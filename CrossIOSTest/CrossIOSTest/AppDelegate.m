//
//  AppDelegate.m
//  CrossIOSTest
//
//  Created by Sascha Timme on 20.07.17.
//  Copyright © 2017 Sascha Timme. All rights reserved.
//

#import "AppDelegate.h"
#include <stdio.h>
#include <string.h>

extern int fib(int n);
extern char * format_result(int n);
extern char * match_string(char * pattern, char * string);
extern void ocaml_init(void);

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    int result;
    
    /* Initialize OCaml code */
    ocaml_init();
    /* Do some computation */
    result = fib(23);
    printf("fib(23) = %s\n", format_result(result));
    
    printf("%s", match_string("[lo]+", "hellollo3"));
    
    return YES;
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


@end
