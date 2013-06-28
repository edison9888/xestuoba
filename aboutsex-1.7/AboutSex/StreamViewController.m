//
//  StreamViewController.m
//  AboutSex
//
//  Created by Wen Shane on 13-2-2.
//
//

#import "StreamViewController.h"
#import "NewStreamController.h"
#import "HotStreamController.h"
#import "MobClick.h"
#import "SpotTimer.h"
#import "SidebarViewController.h"
#import "MLNavigationController.h"


@interface StreamViewController ()
{
    NSMutableArray* mSubViewControllers;
    UISegmentedControl* mSegmentedControl;
    UIBarButtonItem* mRefreshButtonBarButtonItem;
    UIBarButtonItem* mLoadingIndicatorBarButtonItem;
    
    UIView* mContentView;
}

@property (nonatomic, retain) NSMutableArray* mSubViewControllers;
@property (nonatomic, retain) UISegmentedControl* mSegmentedControl;
@property (nonatomic, retain) UIBarButtonItem* mRefreshButtonBarButtonItem;
@property (nonatomic, retain) UIBarButtonItem* mLoadingIndicatorBarButtonItem;
@property (nonatomic, retain) UIView* mContentView;

@end

@implementation StreamViewController
@synthesize mSubViewControllers;
@synthesize mSegmentedControl;
@synthesize mRefreshButtonBarButtonItem;
@synthesize mLoadingIndicatorBarButtonItem;
@synthesize mContentView;

+ (UINavigationController*) shared
{
    static UINavigationController* S_NavOfStreamViewController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        StreamViewController* sStreamViewController = [[self alloc] init];
        S_NavOfStreamViewController = [[MLNavigationController alloc] initWithRootViewController:sStreamViewController];
        [sStreamViewController release];
        
    });
    return S_NavOfStreamViewController;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        self.title = NSLocalizedString(@"News", "new message type of which may be dictations");
    }
    return self;
}

- (void) dealloc
{
    self.mSubViewControllers = nil;
    self.mSegmentedControl = nil;
    self.mRefreshButtonBarButtonItem = nil;
    self.mLoadingIndicatorBarButtonItem = nil;
    self.mContentView = nil;
    
    [super dealloc];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
       
    UISegmentedControl* sSegmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:NSLocalizedString(@"The Latest", nil), NSLocalizedString(@"The Hottest", nil), nil] ];
    CGRect frame= sSegmentedControl.frame;
    [sSegmentedControl setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 30)];
    sSegmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    [sSegmentedControl addTarget:self action:@selector(segmentedControlSelected:) forControlEvents:UIControlEventValueChanged];
    sSegmentedControl.selectedSegmentIndex = 0;
    
    self.navigationItem.titleView = sSegmentedControl;
    
    self.mSegmentedControl = sSegmentedControl;
    [sSegmentedControl release];
    
    
//    UIButton* sSideBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [sSideBarButton addTarget:self action:@selector(presentSidebar) forControlEvents:UIControlEventTouchDown];
//    sSideBarButton.frame = CGRectMake(0, 0, 40, 40);
//    [sSideBarButton setImage:[UIImage imageNamed:@"menu20"] forState:UIControlStateNormal];
//    
//    UIBarButtonItem* sBarItem = [[UIBarButtonItem alloc] initWithCustomView:sSideBarButton];
//    self.navigationItem.leftBarButtonItem = sBarItem;
//    [sBarItem release];

    
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

    [self buildControllers];
    
    CGRect sViewBounds = self.view.bounds;
    CGFloat sHeightOfNavigationBar = self.navigationController.navigationBar.bounds.size.height;
    CGFloat sHeightOfTabBar = self.tabBarController.tabBar.bounds.size.height;
    sViewBounds.size.height -= sHeightOfNavigationBar+sHeightOfTabBar;
    
    self.view.frame = CGRectMake(0, 0, sViewBounds.size.width, sViewBounds.size.height);
    
    [self switchToIndex:0];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.mSubViewControllers = nil;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.mSegmentedControl.selectedSegmentIndex == 0)
    {
        self.navigationItem.rightBarButtonItem.customView.hidden = NO;
    }
    else
    {
        self.navigationItem.rightBarButtonItem.customView.hidden = YES;        
    }
    
    UIViewController* sCurViewController = [self getSubViewController:self.mSegmentedControl.selectedSegmentIndex];
    if (sCurViewController)
    {
        [sCurViewController viewWillAppear:animated];
    }
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    UIViewController* sCurViewController = [self getSubViewController:self.mSegmentedControl.selectedSegmentIndex];
    if (sCurViewController)
    {
        [sCurViewController viewDidAppear:animated];
    }

//    [[SpotTimer shared] startWithDelay:120];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    UIViewController* sCurViewController = [self getSubViewController:self.mSegmentedControl.selectedSegmentIndex];
    if (sCurViewController)
    {
        [sCurViewController viewWillDisappear:animated];
    }

//    [[SpotTimer shared] cancel];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    UIViewController* sCurViewController = [self getSubViewController:self.mSegmentedControl.selectedSegmentIndex];
    if (sCurViewController)
    {
        [sCurViewController viewDidDisappear:animated];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buildControllers
{
    NewStreamController* sNewStreamController = [[NewStreamController alloc] initWithTitle:@"News"];
    sNewStreamController.mDelegate = self;
    HotStreamController* sTopStreamController = [[HotStreamController alloc] init];
    sTopStreamController.mDelegate = self;
    
    if (!self.mSubViewControllers)
    {
        self.mSubViewControllers = [NSMutableArray arrayWithCapacity:2];
    }
    else
    {
        [self.mSubViewControllers removeAllObjects];
    }
    
    [self.mSubViewControllers addObject:sNewStreamController];
    [self.mSubViewControllers addObject:sTopStreamController];
    
    [sNewStreamController release];
    [sTopStreamController release];
    
}

- (void) switchToIndex:(NSInteger)aIndex
{
    UIViewController* sViewController = [self.mSubViewControllers objectAtIndex:aIndex];
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

    }
    
}

- (void) segmentedControlSelected:(UISegmentedControl*)aSegmentedControl
{
    NSInteger sIndexSelected = aSegmentedControl.selectedSegmentIndex;

    [self switchToIndex:sIndexSelected];
    if (sIndexSelected == 0)
    {
        self.navigationItem.rightBarButtonItem.customView.hidden = NO;
    }
    else
    {
        self.navigationItem.rightBarButtonItem.customView.hidden = YES;
        
    }
    
    return;
}

- (void) refreshFromOutside
{
    self.mSegmentedControl.selectedSegmentIndex = 0;
    [self switchToIndex:self.mSegmentedControl.selectedSegmentIndex];
    [self refresh];
}

- (void) refresh
{
    //
    UIViewController* sCurViewController = [self getSubViewController:self.mSegmentedControl.selectedSegmentIndex];
    if (sCurViewController
        && [sCurViewController respondsToSelector:@selector(refreshViaButton)])
    {
        [sCurViewController performSelector:@selector(refreshViaButton)];
    }

    return;
}

- (UIViewController*) getSubViewController:(NSInteger)aIndex
{
    if (aIndex < 0
        && aIndex >= self.mSubViewControllers.count)
    {
        return nil;
    }
    
    UIViewController* sViewController = [self.mSubViewControllers objectAtIndex:aIndex];
    
    return sViewController;
}

#pragma mark -

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

- (void) pushController:(UIViewController *)viewController animated:(BOOL)animated;
{
    [self.navigationController pushViewController:viewController animated:animated];
}


@end
