//
//  AppDelegate.h
//  AboutSex
//
//  Created by Shane Wen on 12-6-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKPasscodeLock.h"
#import "PPRevealSideViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate, PPRevealSideViewControllerDelegate, KKPasscodeViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
