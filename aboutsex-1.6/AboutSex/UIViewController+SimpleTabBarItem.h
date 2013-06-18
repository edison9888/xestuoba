//
//  UIViewController+SimpleTabBarItem.h
//  BTT
//
//  Created by Wen Shane on 12-12-8.
//  Copyright (c) 2012年 Wen Shane. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimpleTabBarItem.h"

@class SimpleTabController;

@interface UIViewController (SimpleTabBarItem)

- (void) setSimpleTabBarItem:(SimpleTabBarItem*) aItem;
- (SimpleTabBarItem*) getSimpleTabBarItem;

- (void) setSimpleTabController: (SimpleTabController*)aSimpleTabController;
- (SimpleTabController*) getSimpleTabController;
- (void) BTTpushViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void) setNavigationBarColor:(UIColor*)aColor;

@end
