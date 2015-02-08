//  AppDelegate.m
//  AlertViewControllerDemo
//  Created by Michael McEvoy on 2/8/15.
//  Copyright (c) 2015 Mustard Seed Software LLC. All rights reserved.
// Header import
#import "AppDelegate.h"
// Other imports
#import "ViewController.h"
@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window                     = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController  = [[ViewController alloc] init];
    [self.window makeKeyAndVisible];
    return YES;
}
@end