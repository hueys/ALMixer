//
//  AAppDelegate.m
//  Mixer
//
//  Created by Steven Huey on 6/29/12.
//  Copyright (c) 2012 ArtLogic. All rights reserved.
//

#import "AAppDelegate.h"

#import "AViewController.h"

@implementation AAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

   self.viewController = [[AViewController alloc] initWithNibName:@"AViewController" bundle:nil];
   self.window.rootViewController = self.viewController;
   [self.window makeKeyAndVisible];
   
   return YES;
}

@end
