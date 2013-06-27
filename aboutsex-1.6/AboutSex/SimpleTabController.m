//
//  SimpleTopTabController.m
//  BTT
//
//  Created by Wen Shane on 12-12-8.
//  Copyright (c) 2012年 Wen Shane. All rights reserved.
//

#import "SimpleTabController.h"
#import "UIViewController+SimpleTabBarItem.h"
#import "UINavigationController+FullScreenPushInSimpleTabController.h"

//#define DEFAULT_TAB_BAR_HEIGHT 30
#define INVALID_SELECTED_INDEX -1

@interface SimpleTabController ()
{
    CGFloat mYOffset;
    
    NSArray* mChildViewControllers;
    CGSize mContainedViewSize;
    
    SimpleTabBar* mTabBar;
    UIView* mContentView;
    
    NSInteger mInitSelectedIndex;
    NSInteger mSelectedIndex;
    
    SimpleTabControllerStyle* mStyle;
    
    id<SimpleTabControllerDelegate> mDelegate;
    
}

@property (nonatomic, assign) CGFloat mYOffset;
@property (nonatomic, retain) NSArray *mChildViewControllers;
@property (nonatomic, retain) SimpleTabBar* mTabBar;
@property (nonatomic, assign) UIView* mContentView;
@property (nonatomic, assign) NSInteger mSelectedIndex;
@property (nonatomic, assign) NSInteger mInitSelectedIndex;
@property (nonatomic, retain) SimpleTabControllerStyle* mStyle;

@end

@implementation SimpleTabController

@synthesize mYOffset;
@synthesize mChildViewControllers;
@synthesize mContainedViewSize;
@synthesize mTabBar;
@synthesize mContentView;
@synthesize mInitSelectedIndex;
@synthesize mSelectedIndex;
@synthesize mStyle;
@synthesize mDelegate;

- (id)initWithViewControllers:(NSArray *)aViewControllers style:(SimpleTabControllerStyleType)aStyle
{
    return [self initWithViewControllers:aViewControllers style:aStyle yOffset:0 InitSelectedIndex:0];
}

- (id)initWithViewControllers:(NSArray *)aViewControllers style:(SimpleTabControllerStyleType)aStyle yOffset:(CGFloat)aYOffset InitSelectedIndex:(NSInteger)aInitSelectedIndex
{
    self = [super init];
    if (self)
    {
        self.mYOffset = aYOffset;
        self.mInitSelectedIndex = aInitSelectedIndex;
        self.mChildViewControllers = aViewControllers;
        for (UIViewController* aViewController in self.mChildViewControllers)
        {
            [aViewController setSimpleTabController: self];
        }
        
        self.mSelectedIndex = INVALID_SELECTED_INDEX;
        
        self.mStyle = [SimpleTabControllerStyle getSimpleTabControllerStyleByType:aStyle];
    }
    return self;

}

- (void) dealloc
{
    self.mChildViewControllers = nil;
    self.mTabBar = nil;
    self.mContentView = nil;
    self.mStyle = nil;
    self.mContentView = nil;
    
    [super dealloc];
}


- (void)loadView
{
    CGSize sViewSize = [UIScreen mainScreen].applicationFrame.size;
    
    if ([self getSimpleTabController])
    {
        sViewSize = [self getSimpleTabController].mContainedViewSize;
    }
    else
    {
        CGFloat sHeightOfPossilbeNavBarAndTabBar = 0;        
        if (self.navigationController
            && !self.navigationController.navigationBarHidden)
        {
            sHeightOfPossilbeNavBarAndTabBar += self.navigationController.navigationBar.bounds.size.height;
        }
        
        sViewSize.height -= sHeightOfPossilbeNavBarAndTabBar;

    }
    
//    sViewSize.height -= self.mYOffset;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sViewSize.width, sViewSize.height)];
    self.view = view;
    [view release];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    NSMutableArray* sBarItems = [NSMutableArray arrayWithCapacity:self.mChildViewControllers.count];
    for (int i=0; i<self.mChildViewControllers.count; i++)
    {
        UIViewController* sVC = [self.mChildViewControllers objectAtIndex:i];
        [sBarItems addObject:[sVC getSimpleTabBarItem]];
    }
    
    CGFloat sHeighForTabBar;
    NSString* sSampleText = NSLocalizedString(@"Mainpage", nil);
    sHeighForTabBar = [sSampleText sizeWithFont:self.mStyle.mItemFont].height + self.mStyle.mTabBarPadding.top+self.mStyle.mTabBarPadding.bottom;
    
    SimpleTabBar* sTabBar = [[SimpleTabBar alloc] initWithFrame:CGRectMake(0, self.mYOffset, self.view.bounds.size.width, sHeighForTabBar) BarItems:sBarItems Delegate:self];
    sTabBar.backgroundColor = self.mStyle.mTabBarColor;
    
    [self.view addSubview:sTabBar];
    
    self.mTabBar = sTabBar;
    [sTabBar release];
    
    self.mContainedViewSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height-self.mTabBar.bounds.size.height);
    
    
//    [self moveTo:self.mInitSelectedIndex];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    for (SimpleTabBarItem* sBarItem in self.mTabBar.mBarItems) {
        [sBarItem addTarget:self action:@selector(tabBarItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self moveTo:self.mInitSelectedIndex withViewAppearMustCalled:YES];

}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self moveTo:self.mInitSelectedIndex];

}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self moveTo:self.mInitSelectedIndex];
    [self.view bringSubviewToFront:self.mTabBar];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) moveTo:(NSInteger)aNewIndex
{
    [self moveTo:aNewIndex withViewAppearMustCalled:NO];
}


- (void) moveTo:(NSInteger)aNewIndex withViewAppearMustCalled:(BOOL)aViewAppearMustCalled
{
    if (aNewIndex < 0
        || aNewIndex >= self.mChildViewControllers.count)
    {
        return;
    }
    
    if (aNewIndex == self.mSelectedIndex)
    {
        return;
    }
    
    UIViewController* sNewSelectedViewController = [self.mChildViewControllers objectAtIndex:aNewIndex];
    
    if (self.mDelegate
        && [self.mDelegate respondsToSelector:@selector(simpleTabController:shouldSelectViewController:atIndex:)])
    {
        if (![self.mDelegate simpleTabController:self shouldSelectViewController:sNewSelectedViewController atIndex:aNewIndex])
        {
            return;
        }
    }
    
    
    [self.mTabBar moveTo:aNewIndex];
    
    if (self.mContentView)
    {
        UIViewController* sOldSelectedViewController = nil;
        if (self.mSelectedIndex != INVALID_SELECTED_INDEX)
        {
            sOldSelectedViewController = [self.mChildViewControllers objectAtIndex:self.mSelectedIndex];
        }
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 5.0)
        {
            [sOldSelectedViewController viewWillDisappear:YES];
        }
        [self.mContentView removeFromSuperview];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 5.0)
        {
            [sOldSelectedViewController viewDidDisappear:YES];
        }
        
    }
    
    self.mContentView = sNewSelectedViewController.view;
    self.mContentView.frame = CGRectMake(0, self.mTabBar.frame.origin.y +self.mTabBar.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height-self.mYOffset-self.mTabBar.bounds.size.height);
    
    if (aViewAppearMustCalled
        || [[[UIDevice currentDevice] systemVersion] floatValue] < 5.0)
    {
        [sNewSelectedViewController viewWillAppear:YES];
    }
    
    [self.view addSubview:self.mContentView];
    
    if (aViewAppearMustCalled
        || [[[UIDevice currentDevice] systemVersion] floatValue] < 5.0)
    {
        [sNewSelectedViewController viewDidAppear:YES];
    }
    
    
    self.mSelectedIndex = aNewIndex;
    if (self.mDelegate
        && [self.mDelegate respondsToSelector:@selector(simpleTabController:didSelectViewController:atIndex:)])
    {
        [self.mDelegate simpleTabController:self didSelectViewController:sNewSelectedViewController atIndex:self.mSelectedIndex];
    }
    
    [self adjustBackTextIfNeeded];

}

- (void) tabBarItemPressed:(id)aBarItem
{
    for (int i=0; i<self.mTabBar.mBarItems.count; i++)
    {
        SimpleTabBarItem* sBarItem = [self.mTabBar.mBarItems objectAtIndex:i];
        if (sBarItem == aBarItem)
        {
            [self moveTo:i];
        }
    }
}

- (void) adjustBackTextIfNeeded
{
    if ([self getRootSimpleTabController] == self)
    {
        SimpleTabController* sRootSimpleTabController = [self getRootSimpleTabController];
        if (!sRootSimpleTabController.navigationItem.backBarButtonItem)
        {
            UIBarButtonItem* sBackBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Custom Title"style:UIBarButtonItemStyleBordered target:nil action:nil] autorelease];
            sRootSimpleTabController.navigationItem.backBarButtonItem = sBackBarButtonItem;
        }
        switch (self.mStyle.mBackTextType)
        {
            case ENUM_BACK_TEXT_TYPE_FIRST_LEVEL_TABBARITEM_TITLE:
            {
                UIViewController* sSelectedViewController = [self.mChildViewControllers objectAtIndex:self.mSelectedIndex];
                NSString* sTabButtonItemTitle = [sSelectedViewController getSimpleTabBarItem].mTitle;
                if (sTabButtonItemTitle)
                {
                    sRootSimpleTabController.navigationItem.backBarButtonItem.title = sTabButtonItemTitle;
                }
                else if (sRootSimpleTabController.title)
                {
                    sRootSimpleTabController.navigationItem.backBarButtonItem.title = sRootSimpleTabController.title;
                }
                else
                {
                    sRootSimpleTabController.navigationItem.backBarButtonItem.title = NSLocalizedString(@"Return", nil);
                }
            }
                break;
            case ENUM_BACK_TEXT_TYPE_RETURN:
            {
                sRootSimpleTabController.navigationItem.backBarButtonItem.title = NSLocalizedString(@"Return", nil);
            }
                break;
            case ENUM_BACK_TEXT_TYPE_ROOTNAV_TITLE:
            default:
            {
                if (sRootSimpleTabController.title)
                {
                    sRootSimpleTabController.navigationItem.backBarButtonItem.title = sRootSimpleTabController.title;
                }
                else
                {
                    sRootSimpleTabController.navigationItem.backBarButtonItem.title = NSLocalizedString(@"Return", nil);
                }
            }
                break;
        }

    }
  
}

- (CGSize) getTabBarSize
{
    if (self.mTabBar)
    {
        return self.mTabBar.bounds.size;
    }
    else
    {
        return CGSizeZero;
    }
}

- (SimpleTabController*) getRootSimpleTabController
{
    SimpleTabController* sSimpleTabController = self;
    while ([sSimpleTabController getSimpleTabController]) {
        sSimpleTabController = [sSimpleTabController getSimpleTabController];
    }
    return sSimpleTabController;
}

- (UINavigationController*) getRootNavigationController
{
    return [self getRootSimpleTabController].navigationController;
}

- (void) STCPushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    UINavigationController* sRootNavigationConroller = [self getRootNavigationController];
    [sRootNavigationConroller prepareFullScreenPush];
    [sRootNavigationConroller pushViewController:viewController animated:YES];
}

- (void) setNavigationBarColor:(UIColor*)aColor
{
    UINavigationController* sRootNavigationConroller = [self getRootNavigationController];
    sRootNavigationConroller.navigationBar.tintColor = aColor;
}

- (void) gotoTabByIndex:(NSInteger)aIndex
{
    [self moveTo:aIndex];
}

- (void) setYOffset:(CGFloat)aYOffset
{
    if (self.mYOffset != aYOffset)
    {
        
        if (self.mTabBar)
        {
            self.mTabBar.frame = CGRectOffset(self.mTabBar.frame, 0, aYOffset-self.mYOffset);
            if (self.mContentView)
            {
                self.mContentView.frame = CGRectOffset(self.mContentView.frame, 0, aYOffset-self.mYOffset);
                self.mContentView.frame = CGRectMake(self.mContentView.frame.origin.x, self.mContentView.frame.origin.y, self.mContentView.frame.size.width, self.mContentView.frame.size.height-(aYOffset-self.mYOffset));
            }
        }
        self.mYOffset = aYOffset;
    }
}

- (void) setInitSelectedIndex:(NSInteger)aSelectedIndex
{
    self.mInitSelectedIndex = aSelectedIndex;
}

- (NSInteger) getSelectedIndex
{
    return self.mSelectedIndex;
}

- (NSInteger) getNumOfChildViewControllers
{
    return self.mChildViewControllers.count;
}

- (UIViewController*) getChildViewControllerByIndex:(NSInteger)aIndex
{
    if (aIndex >=0
        && aIndex < self.mChildViewControllers.count)
    {
        return [self.mChildViewControllers objectAtIndex:aIndex];
    }
    else
    {
        return nil;      
    }
}

- (UIViewController*) getCurrentViewController
{
    return [self getChildViewControllerByIndex:[self getSelectedIndex]];
}
//- (void) hideTabbar
//{
//    self.navigationController.navigationBarHidden = YES;
//    self.mTabBar.hidden = YES;
//    
//    self.mContentView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
//}
//
//- (void) showTabbar
//{
//    self.navigationController.navigationBarHidden = NO;
//    self.mTabBar.hidden = NO;
//    
//    self.mContentView.frame = CGRectMake(0, self.mTabBar.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height-self.mTabBar.bounds.size.height);
//}

#pragma - mark SimpleTabBarDelegate
- (SimpleTabControllerStyle*) getStyleOfCorrespondingController
{
    return self.mStyle;
}

@end
