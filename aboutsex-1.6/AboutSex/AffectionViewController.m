//
//  AffectionViewController.m
//  AboutSex
//
//  Created by Wen Shane on 13-6-7.
//
//

#import "AffectionViewController.h"
#import "NewStreamController.h"
#import "HotStreamController.h"
#import "HotCommentsViewController.h"
#import "SidebarViewController.h"

#define SIDEBAR_OFFSET 150

@interface AffectionViewController ()
{
    ENUM_AFFECTION_TYPE mCurAffectionType;
    UIView* mContentView;
    
    //
    UIBarButtonItem* mRefreshButtonBarButtonItem;
    UIBarButtonItem* mLoadingIndicatorBarButtonItem;

}

@property (nonatomic, assign) ENUM_AFFECTION_TYPE mCurAffectionType;
@property (nonatomic, retain) UIView* mContentView;
@property (nonatomic, retain) UIBarButtonItem* mRefreshButtonBarButtonItem;
@property (nonatomic, retain) UIBarButtonItem* mLoadingIndicatorBarButtonItem;

@end

@implementation AffectionViewController
@synthesize mCurAffectionType;
@synthesize mContentView;

@synthesize mRefreshButtonBarButtonItem;
@synthesize mLoadingIndicatorBarButtonItem;

+ (AffectionViewController*) shared
{
    static AffectionViewController* S_AffectionViewController;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        S_AffectionViewController = [[self alloc] init];
    });
    
    return S_AffectionViewController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.mCurAffectionType = ENUM_AFFECTION_TYPE_INVALID;
    }
    return self;
}

- (void) dealloc
{
    self.mContentView = nil;
    self.mRefreshButtonBarButtonItem = nil;
    self.mLoadingIndicatorBarButtonItem = nil;

    
    [super dealloc];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(preloadLeft) object:nil];
    [self performSelector:@selector(preloadLeft) withObject:nil afterDelay:0.3];

}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.revealSideViewController unloadViewControllerForSide:PPRevealSideDirectionLeft];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIButton* sSideBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sSideBarButton addTarget:self action:@selector(presentSidebar) forControlEvents:UIControlEventTouchDown];
    sSideBarButton.frame = CGRectMake(0, 0, 40, 40);
    [sSideBarButton setImage:[UIImage imageNamed:@"menu20"] forState:UIControlStateNormal];
    
    UIBarButtonItem* sBarItem = [[UIBarButtonItem alloc] initWithCustomView:sSideBarButton];
    self.navigationItem.leftBarButtonItem = sBarItem;
    [sBarItem release];

    CGRect sViewBounds = self.view.bounds;
    CGFloat sHeightOfNavigationBar = self.navigationController.navigationBar.bounds.size.height;
    CGFloat sHeightOfTabBar = self.tabBarController.tabBar.bounds.size.height;
    sViewBounds.size.height -= sHeightOfNavigationBar+sHeightOfTabBar;
    
    self.view.frame = CGRectMake(0, 0, sViewBounds.size.width, sViewBounds.size.height);
    
    [self switchToItem:ENUM_AFFECTION_TYPE_LATEST_ARTICLES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)preloadLeft
{
    [self.revealSideViewController preloadViewController:[SidebarViewController shared] forSide:PPRevealSideDirectionLeft withOffset:SIDEBAR_OFFSET];
}

- (void) refresh
{
    //
    if ([[NewStreamController shared] respondsToSelector:@selector(refreshViaButton)])
    {
        [[NewStreamController shared] performSelector:@selector(refreshViaButton)];
    }
    
    return;
}


- (void) switchToItem:(ENUM_AFFECTION_TYPE)aType
{
    UIViewController* sViewController = nil;
    if (self.mCurAffectionType != aType)
    {
        sViewController = [self getSubViewControllerByType:aType];
        if (sViewController)
        {
            [sViewController viewWillAppear:NO];
            if (self.mContentView)
            {
                [self.mContentView removeFromSuperview];
            }
            
            self.mContentView = sViewController.view;
            
            self.mContentView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
            [self.view addSubview:self.mContentView];
            
            
            //
            self.mCurAffectionType = aType;
            switch (self.mCurAffectionType) {
                case ENUM_AFFECTION_TYPE_LATEST_ARTICLES:
                {
                    self.navigationItem.title = NSLocalizedString(@"Latest Articles", nil);
                    if (!self.mRefreshButtonBarButtonItem)
                    {
                        UIButton* sRefreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
                        [sRefreshButton setImage:[UIImage imageNamed:@"singlerefresh24.png"] forState:UIControlStateNormal];
                        sRefreshButton.frame = CGRectMake(0, 0, 24, 24);
                        //    sRefreshButton.showsTouchWhenHighlighted = YES;
                        [sRefreshButton addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchDown];
                        
                        UIBarButtonItem* sRefershBarButtonItem =  [[UIBarButtonItem alloc]initWithCustomView:sRefreshButton];
                        sRefershBarButtonItem.style = UIBarButtonItemStylePlain;
                        
                        self.mRefreshButtonBarButtonItem = sRefershBarButtonItem;
                        [sRefershBarButtonItem release];
                    }
                    self.navigationItem.rightBarButtonItem = self.mRefreshButtonBarButtonItem;
                }
                    break;
                case ENUM_AFFECTION_TYPE_TOP_ARTICLES:
                {
                    self.navigationItem.title = NSLocalizedString(@"Top Articles", nil);
                    self.navigationItem.rightBarButtonItem = nil;

                }
                    break;
                case ENUM_AFFECTION_TYPE_HOTCOMMENTS:
                {
                    self.navigationItem.title = NSLocalizedString(@"Hot Comments", nil);
                    self.navigationItem.rightBarButtonItem = nil;

                }
                    break;
                default:
                    break;
            }        
        }
    }
}

- (ENUM_AFFECTION_TYPE) getCurAffectionType
{
    return self.mCurAffectionType;
}

- (UIViewController*) getCurSubViewController
{
    return [self getSubViewControllerByType:self.mCurAffectionType];
}

- (UIViewController*) getSubViewControllerByType:(ENUM_AFFECTION_TYPE)aType
{
    UIViewController* sViewController = nil;
    switch (aType)
    {
        case ENUM_AFFECTION_TYPE_LATEST_ARTICLES:
        {
            [NewStreamController shared].mDelegate = self;
            sViewController = [NewStreamController shared];
        }
            break;
        case ENUM_AFFECTION_TYPE_TOP_ARTICLES:
            [HotStreamController shared].mDelegate = self;
            sViewController = [HotStreamController shared];
            break;
        case ENUM_AFFECTION_TYPE_HOTCOMMENTS:
            [HotCommentsViewController shared].mDelegate = self;
            sViewController = [HotCommentsViewController shared];
            break;
        default:
            break;
    }

    return sViewController;
}

- (void) presentSidebar
{
//    [self.revealSideViewController changeOffset:200 forDirection:PPRevealSideDirectionLeft];
//    [self.revealSideViewController pushViewController:[SidebarViewController shared] onDirection:PPRevealSideDirectionLeft animated:YES completion:^{}];
    
    [self.revealSideViewController pushViewController:[SidebarViewController shared] onDirection:PPRevealSideDirectionLeft withOffset:SIDEBAR_OFFSET animated:YES completion:^{
    }];
}

#pragma mark - AffectionViewControllerDelegate
- (void) beginLoading
{
    if (!self.mLoadingIndicatorBarButtonItem)
    {
        UIActivityIndicatorView* sLoadingIndicatorView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
        [sLoadingIndicatorView setFrame:CGRectMake(0, 0, 24, 24)];
        UIBarButtonItem* sLoadingIndicatorBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sLoadingIndicatorView];
        self.mLoadingIndicatorBarButtonItem = sLoadingIndicatorBarButtonItem;
        [sLoadingIndicatorBarButtonItem release];
    }
    
    self.navigationItem.rightBarButtonItem = self.mLoadingIndicatorBarButtonItem;
    
    [(UIActivityIndicatorView*)self.mLoadingIndicatorBarButtonItem.customView startAnimating];
    
}

- (void) endLoading
{
    self.navigationItem.rightBarButtonItem = self.mRefreshButtonBarButtonItem;
}

- (void) pushController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self.navigationController pushViewController:viewController animated:animated];
}


#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController == self)
    {
        UIViewController* sSubVC = [self getCurSubViewController];
        if (sSubVC)
        {
            [sSubVC viewDidAppear:animated];
        }
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController == self)
    {
        UIViewController* sSubVC = [self getCurSubViewController];
        if (sSubVC)
        {
            [sSubVC viewWillAppear:animated];
        }
    }
}

@end
