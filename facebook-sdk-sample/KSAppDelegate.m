//
//  KSAppDelegate.m
//  facebook-sdk-sample
//
//  Created by Shintaro Kaneko on 1/28/14.
//  Copyright (c) 2014 kaneshinth.com. All rights reserved.
//

#import "KSAppDelegate.h"

#import "KSFacebookManager.h"

@implementation KSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    return YES;
}
							
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[KSFacebookManager sharedManager] applicationDidBecomeActive:application];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[KSFacebookManager sharedManager] applicationWillTerminate:application];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [[KSFacebookManager sharedManager] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}

@end
