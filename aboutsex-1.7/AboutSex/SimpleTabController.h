//
//  SimpleTopTabController.h
//  BTT
//
//  Created by Wen Shane on 12-12-8.
//  Copyright (c) 2012年 Wen Shane. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+SimpleTabBarItem.h"
#import "SimpleTabControllerStyle.h"
#import "SimpleTabBar.h"

//delegate protcolor for simple tab controller
@protocol SimpleTabControllerDelegate <NSObject>

@optional
//invoked before selection.
- (BOOL)simpleTabController:(SimpleTabController *)tabBarController shouldSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index;

//invoked after selection.
- (void)simpleTabController:(SimpleTabController *)tabBarController didSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index;
@end


//SimpleTabController, a tab bar controller, by which you can organized a group of hirachicalized tab controllers, with different in-built styles.
@interface SimpleTabController : UIViewController<SimpleTabBarDelegate>

@property (nonatomic, assign) id<SimpleTabControllerDelegate> mDelegate;
@property (nonatomic, assign) CGSize mContainedViewSize;

- (id)initWithViewControllers:(NSArray *)aViewControllers style:(SimpleTabControllerStyleType)aStyle;
- (id)initWithViewControllers:(NSArray *)aViewControllers style:(SimpleTabControllerStyleType)aStyle yOffset:(CGFloat)aYOffset InitSelectedIndex:(NSInteger)aInitSelectedIndex;

- (CGSize) getTabBarSize;

- (void) STCPushViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void) setNavigationBarColor:(UIColor*)aColor;
- (void) gotoTabByIndex:(NSInteger)aIndex;
- (void) setYOffset:(CGFloat)aYOffset;
- (void) setInitSelectedIndex:(NSInteger)aSelectedIndex;
- (NSInteger) getSelectedIndex;
- (NSInteger) getNumOfChildViewControllers;
- (UIViewController*) getChildViewControllerByIndex:(NSInteger)aIndex;
- (UIViewController*) getCurrentViewController;

@end
