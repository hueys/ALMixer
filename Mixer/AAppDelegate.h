//
//  AAppDelegate.h
//  Mixer
//
//  Created by Steven Huey on 6/29/12.
//  Copyright (c) 2012 ArtLogic. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AViewController;

@interface AAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) AViewController *viewController;

@end
