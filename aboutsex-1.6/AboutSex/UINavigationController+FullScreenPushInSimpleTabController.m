//
//  UINavigationController+FullScreenPushInSimpleTabController.m
//  BTT
//
//  Created by Wen Shane on 12-12-17.
//  Copyright (c) 2012年 Wen Shane. All rights reserved.
//

#import "UINavigationController+FullScreenPushInSimpleTabController.h"
#import "UIViewController+SimpleTabBarItem.h"
#import "SimpleTabController.h"
#import "SharedVariables.h"

@implementation UINavigationController (FullScreenPushInSimpleTabController)

- (void) prepareFullScreenPush
{    
    self.delegate = self;
}

- (CGSize) getPushedViewControllerSize
{
    CGRect sFrame = [UIScreen mainScreen].applicationFrame;
    CGFloat sHeightOfBars = 0;
    if (!self.navigationBarHidden)
    {
        sHeightOfBars += self.navigationBar.bounds.size.height;
    }

// for the delegate methods below have not been called at this time, the tabBarHidden is still NO here, not releasign its space.
//    if (self.ng_tabBarController
//        && !self.ng_tabBarController.tabBarHidden)
//    {
//        sHeightOfBars += self.ng_tabBarController.tabBar.bounds.size.height;
//    }
    
    return CGSizeMake(sFrame.size.width, sFrame.size.height-sHeightOfBars);

}

//

//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    if (viewController != [navigationController.viewControllers objectAtIndex:0])
//    {
//        [self.navigationController setTabBarHidden:YES animated:NO];
//    }
//    else
//    {
//        self.navigationBar.tintColor = MAIN_COLOR;
//    }      
//}
//
//- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    if (viewController != [navigationController.viewControllers objectAtIndex:0])
//    {
//        //nothing done here.
//    }
//    else
//    {
//        [self.navigationController setTabBarHidden:NO animated:NO];
//    }
//}
@end
