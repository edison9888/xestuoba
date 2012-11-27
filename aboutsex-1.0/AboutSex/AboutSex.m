//
//  AboutSex.m
//  AboutSex
//
//  Created by Shane Wen on 12-6-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AboutSex.h"
#import "StreamListViewController.h"
#import "FavoriteViewController.h"
#import "LibraryViewController.h"

#import "SharedVariables.h"
#import "MobClick.h"


static UITabBarController* MTabBarController = nil; //when is static variable released?


@implementation AboutSex


+ (UITabBarController*) getMainTabController
{
    if (nil == MTabBarController)
    {
        MTabBarController = [[[UITabBarController alloc] init] autorelease];
        
        NSString* sTitle = nil;
        UITabBarItem* sTabBarItem = nil;
        
       
 // message vc       
        sTitle = NSLocalizedString(@"News", "new message type of which may be dictations");
        UINavigationController* sNaviContainerOfMessageViewController = [[UINavigationController alloc]initWithRootViewController:[[[StreamListViewController alloc] initWithTitle:sTitle AndSectionName: @"stream"] autorelease]];
        
//        sNaviContainerOfMessageViewController.navigationBar.barStyle = UIBarStyleBlack;
//        sNaviContainerOfMessageViewController.navigationBar.tintColor = [UIColor colorWithRed:RGB_DIV_255(102) green:RGB_DIV_255(57) blue:RGB_DIV_255(26) alpha:1.0f];
//        [sNaviContainerOfMessageViewController.navigationBar setBackgroundImage:[UIImage imageNamed:@"library32.png"] forBarMetrics:UIBarMetricsDefault];
//        sNaviContainerOfMessageViewController.navigationBar.translucent = YES;

        sTabBarItem = [[UITabBarItem alloc]initWithTitle:sTitle image:nil tag:0];
//        sTabBarItem.badgeValue = @"N";
        sTabBarItem.image = [UIImage imageNamed:@"new24.png"];
        sNaviContainerOfMessageViewController.tabBarItem = sTabBarItem;
        [sTabBarItem release];
      
 //library vc       
        UINavigationController* sNaviContainerOfLibraryViewController =  [[UINavigationController alloc]initWithRootViewController:[[[LibraryViewController alloc] init] autorelease]];
        sNaviContainerOfLibraryViewController.navigationBar.barStyle = UIBarStyleBlack;
        sTitle = NSLocalizedString(@"Library", "Library where user get whatever he/she wants on sex");
        sTabBarItem = [[UITabBarItem alloc]initWithTitle:sTitle image:nil tag:0];
        sTabBarItem.image = [UIImage imageNamed:@"library32.png"];
        sNaviContainerOfLibraryViewController.tabBarItem = sTabBarItem;
        [sTabBarItem release];       
     
//favorite vc
        UINavigationController* sNaviContainerOfFavoriteViewController =  [[UINavigationController alloc]initWithRootViewController:[[[FavoriteViewController alloc] initWithTitle:NSLocalizedString(@"Favorite", nil)] autorelease]];
        sNaviContainerOfFavoriteViewController.navigationBar.barStyle = UIBarStyleBlack;
        sTitle = NSLocalizedString(@"Favorite", "user's favorite articles");
        sTabBarItem = [[UITabBarItem alloc]initWithTitle:sTitle image:nil tag:0];
        sTabBarItem.image = [UIImage imageNamed:@"favorite32.png"];
        
        sNaviContainerOfFavoriteViewController.tabBarItem = sTabBarItem;
        [sTabBarItem release];

        
        
        NSArray* sControllers = [NSArray arrayWithObjects:sNaviContainerOfMessageViewController, sNaviContainerOfLibraryViewController,sNaviContainerOfFavoriteViewController, nil];
        
        //only show 2 tabs.
//        NSArray* sControllers = [NSArray arrayWithObjects:sNaviContainerOfMessageViewController,sNaviContainerOfFavoriteViewController, nil];

        MTabBarController.viewControllers = sControllers;
        MTabBarController.selectedIndex = 0;
        
        [self configApperance:MTabBarController];
        
        

        
        [sNaviContainerOfMessageViewController release];
        [sNaviContainerOfLibraryViewController release];
        [sNaviContainerOfFavoriteViewController release];      
    }
    return MTabBarController;
}

+ (void) configApperance: (UITabBarController*)aTabBarController 
{
    for (UINavigationController* sChildViewController in aTabBarController.viewControllers)
    {
        if ([sChildViewController.navigationBar respondsToSelector:@selector(setTintColor:)])
        {
            sChildViewController.navigationBar.tintColor = MAIN_BGCOLOR;
        }
    }
    
    if ([aTabBarController.tabBar respondsToSelector:@selector(setTintColor:)])
    {
        aTabBarController.tabBar.tintColor =  MAIN_BGCOLOR;
    }
    else 
    {
        //it does not work on ios5, why?
        CGRect sFrame = CGRectMake(0, 0, aTabBarController.tabBar.bounds.size.width,  aTabBarController.tabBar.bounds.size.height);
        UIView *sBGView = [[UIView alloc] initWithFrame:sFrame];
        sBGView.backgroundColor = MAIN_BGCOLOR;
        [aTabBarController.tabBar insertSubview:sBGView atIndex:0];
        [sBGView release];
    }
    
}

+ (void) checkUpdateAutomatically
{
    [MobClick checkUpdate:NSLocalizedString(@"New Version Found", nil) cancelButtonTitle:NSLocalizedString(@"Skip", nil) otherButtonTitles:NSLocalizedString(@"Update now", nil)];
}


//+ (UIView*) getHeaderViewForTab
//{
//    UIView* sUIView = [[[UIView alloc] init] autorelease];
//    [sUIView setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] applicationFrame].size.width, HEADER_HEIGHT)];
//    sUIView.backgroundColor = [UIColor blackColor];
//    
//    return sUIView;
//}

@end
