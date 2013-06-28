//
//  UIViewController+SimpleTabBarItem.m
//  BTT
//
//  Created by Wen Shane on 12-12-8.
//  Copyright (c) 2012年 Wen Shane. All rights reserved.
//

#import "UIViewController+SimpleTabBarItem.h"
#import "SimpleTabController.h"
#import <objc/runtime.h>

static char itemKey4BarItem;
static char itemKey4SimpleTabController;


@implementation UIViewController (SimpleTabBarItem)


- (void) setSimpleTabBarItem:(SimpleTabBarItem*) aItem
{
    objc_setAssociatedObject(self, &itemKey4BarItem, aItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (SimpleTabBarItem*) getSimpleTabBarItem
{
    return objc_getAssociatedObject(self, &itemKey4BarItem);
}

- (void) setSimpleTabController: (SimpleTabController*)aSimpleTabController
{
    objc_setAssociatedObject(self, &itemKey4SimpleTabController, aSimpleTabController, OBJC_ASSOCIATION_ASSIGN);
}

- (SimpleTabController*) getSimpleTabController
{
    return objc_getAssociatedObject(self, &itemKey4SimpleTabController);
}

- (void) BTTpushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self getSimpleTabController])
    {
        [[self getSimpleTabController] STCPushViewController:viewController animated:animated];
    }
    else
    {
        [self.navigationController pushViewController:viewController animated:animated];
    }
}

- (void) setNavigationBarColor:(UIColor*)aColor
{
    if ([self getSimpleTabController])
    {
        [[self getSimpleTabController] setNavigationBarColor:aColor];
    }
    else
    {
        self.navigationController.navigationBar.tintColor = aColor;
    }

}


@end
