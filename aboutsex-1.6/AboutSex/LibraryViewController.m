//
//  LibraryViewController.m
//  AboutSex
//
//  Created by Shane Wen on 12-6-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "SharedVariables.h"
#import "SharedStates.h"
#import "LibraryViewController.h"
#import "IconData.h"

#import "SectionViewController.h"
#import "BaiduWrapperViewController.h"

#import "StoreManagerEx.h"
#import "UserConfiger.h"

#import "XLCycleScrollView.h"
#import "GridViewPage.h"
#import "MobClick.h"

#import "AdSpotManager.h"

#import "AdBannerManager.h"
#import "GuomobAdSDK.h"
#import "TaggedButton.h"

//#define SPACING 10
//#define SIZE_OF_CELL  CGSizeMake(140, 100)
//#define BGCOLOR_OF_CELL CELL_BGCOLOR
//#define INVALID_INDEX -1
//
//#define TAG_FOR_READCOUNT_LABEL 201

@interface LibraryViewController () <XLCycleScrollViewDatasource,XLCycleScrollViewDelegate,GridViewPageDelegate>
{
    NSMutableArray* mIconDataArray;
    NSInteger mIndexOfIconTouched;
    
    XLCycleScrollView* mHorizontalScrollView;
    NSMutableArray* mGridViewPages;
    BannerAdapter* mAdBannerView;
    TaggedButton* mAdBannerCloseButton;
}

@property (nonatomic, retain) NSMutableArray* mIconDataArray;
@property (nonatomic, assign) NSInteger mIndexOfIconTouched;
@property (nonatomic, retain) XLCycleScrollView* mHorizontalScrollView;
@property (nonatomic, retain) NSMutableArray* mGridViewPages;
@property (nonatomic, retain) BannerAdapter* mAdBannerView;
@property (nonatomic, retain) TaggedButton* mAdBannerCloseButton;

@end


@implementation LibraryViewController

@synthesize mIconDataArray;
@synthesize mIndexOfIconTouched;
@synthesize mHorizontalScrollView;
@synthesize mGridViewPages;
@synthesize mAdBannerView;
@synthesize mAdBannerCloseButton;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
#ifdef DEBUG
        NSLog(@"library ....");
#endif

    }
    return self;
}

- (id) init
{
    self = [super init];
    
    if (self)
    {
        self.title =  NSLocalizedString(@"Library", nil);
//        self.mIndexOfIconTouched = INVALID_INDEX;
        
        UIButton* sPresentBaiduButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [sPresentBaiduButton setImage:[UIImage imageNamed:@"baidu 24.png"] forState:UIControlStateNormal];
        sPresentBaiduButton.frame = CGRectMake(0, 0, 32, 32);
        //    sRefreshButton.showsTouchWhenHighlighted = YES;
        [sPresentBaiduButton addTarget:self action:@selector(presentBaiduViewController) forControlEvents:UIControlEventTouchDown];
        
        UIBarButtonItem* sAskBarButtonItem =  [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"AskandAnswer", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(presentBaiduViewController)];
        sAskBarButtonItem.style = UIBarButtonItemStylePlain;
        self.navigationItem.rightBarButtonItem = sAskBarButtonItem;
        [sAskBarButtonItem release];

        [self loadIconData];
    }
    
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self refreshIconInfo];
    [MobClick beginLogPageView:@"Library"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"Library"];
}

- (void) dealloc
{
    self.mAdBannerView.mDelegate = nil;
    self.mAdBannerView = nil;
    self.mAdBannerCloseButton = nil;
    
    self.mIconDataArray = nil;
    self.mHorizontalScrollView = nil;
    self.mGridViewPages = nil;
    

    [super dealloc];
}

//refresh icon info and make gridviewpages reload the new icon info.
- (void) refreshIconInfo
{
    if (!self.mIconDataArray)
    {
        [self loadIconData];
    }
    else
    {
        for (NSMutableArray* sIconArray in self.mIconDataArray)
        {
            for (IconData* sIconData in sIconArray)
            {
                sIconData.mReadCount = [[StoreManagerEx shared] getReadCountInSection:sIconData.mSectionNameOrURL];
            }
        }
        
    }
    
    //
    for (GridViewPage* sPage in self.mGridViewPages)
    {
        [sPage reloadIcons];
    }

}

- (void) loadView 
{
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    
    UIView* sView = [[UIView alloc] initWithFrame:applicationFrame];
    sView.backgroundColor = [UIColor whiteColor];
    self.view = sView;
    [sView release];
    
    CGRect sViewBounds = self.view.bounds;

    CGFloat sHeightOfNavigationBar = self.navigationController.navigationBar.bounds.size.height;
    CGFloat sHeightOfTabBar = self.tabBarController.tabBar.bounds.size.height;
    sViewBounds.size.height -= sHeightOfNavigationBar+sHeightOfTabBar;
    

    [self prepareGridViewPages];
    
    XLCycleScrollView* sHorizontalScrollView = [[XLCycleScrollView alloc]initWithFrame:sViewBounds IsRepeating:NO NeedPageControl:YES];
    sHorizontalScrollView.datasource = self;
    sHorizontalScrollView.delegate = self;
    sHorizontalScrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:sHorizontalScrollView];
    
    self.mHorizontalScrollView = sHorizontalScrollView;
    [sHorizontalScrollView release];
    
    //
    BannerAdapter* sBanner = [AdBannerManager adBannerWithPlaceType:E_BANNER_AD_PLACE_TYPE_LIBRARY];
    if (sBanner)
    {
        sBanner.frame = CGRectMake(0, self.mHorizontalScrollView.bounds.size.height-sBanner.bounds.size.height, sBanner.bounds.size.width, sBanner.bounds.size.height);
        sBanner.mDelegate = self;
        sBanner.hidden = YES;
        [self.mHorizontalScrollView addSubview:sBanner];
        
        //
        TaggedButton* sAdCloseButton = [TaggedButton buttonWithType:UIButtonTypeCustom];
        [sAdCloseButton setImage:[UIImage imageNamed:@"close24"] forState:UIControlStateNormal];
        CGRect sFrame = sBanner.frame;
        sFrame.size = CGSizeMake(24, 24);
        sFrame.origin = CGPointMake(320-sFrame.size.width-5, sBanner.frame.origin.y-sFrame.size.height+5);
        sAdCloseButton.frame = sFrame;
        [sAdCloseButton addTarget:self  action:@selector(closeBannerAD:) forControlEvents:UIControlEventTouchDown];
        sAdCloseButton.alpha = 0;
        [self.mHorizontalScrollView addSubview:sAdCloseButton];
        
        self.mAdBannerCloseButton = sAdCloseButton;
    }
    self.mAdBannerView = sBanner;
}

//
#pragma mark - AdBannerDelegate
- (void) didGetAd:(BOOL)aSuccess
{
    if (aSuccess)
    {
        [UIView animateWithDuration:5 animations:^{
            self.mAdBannerCloseButton.alpha = 1;
        }];
        self.mAdBannerView.hidden = NO;
        
        NSLog(@"did get get ad in library.");
    }
    else
    {
        NSLog(@"did fail to get get ad in library.");
    }
}

- (void) closeBannerAD:(id)aButton
{
    [MobClick event:@"UEID_CLOSE_BANNER_AD"];
    
    [UIView animateWithDuration:1 animations:^{
        self.mAdBannerView.alpha = 0;
        self.mAdBannerCloseButton.alpha = 0;
    }
    completion:^(BOOL finished)
    {
        self.mAdBannerView.mDelegate = nil;
        [self.mAdBannerView removeFromSuperview];
        self.mAdBannerView = nil;
        [self.mAdBannerCloseButton removeFromSuperview];
        self.mAdBannerCloseButton = nil;
    }];
}

- (void) prepareGridViewPages
{
    NSInteger sPageIndex = 0;
    GridViewPage* sGridViewPage0 = [[GridViewPage alloc] initWithFrame:self.view.bounds andDelegate:self withPageIndex:sPageIndex++];
    GridViewPage* sGridViewPage1 = [[GridViewPage alloc] initWithFrame:self.view.bounds andDelegate:self withPageIndex:sPageIndex++];

    if (!self.mGridViewPages)
    {
        self.mGridViewPages = [NSMutableArray arrayWithCapacity:2];
    }
    else//in 1.2, if enter foreground again, LoadView will, sometimes, be invoked, and this method be called too. so there will be 4 pages and 4 dots on the second tab.  SO, IMPORTANTLY, to handle the enter foreground issue.
    {
        [self.mGridViewPages removeAllObjects];
    }
    [self.mGridViewPages addObject:sGridViewPage0];
    [self.mGridViewPages addObject:sGridViewPage1];
    
    
    [sGridViewPage0 release];
    [sGridViewPage1 release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void) viewWillUnload
{
    NSLog(@"----------library will unload---------");
    [super viewWillUnload];
    
}
- (void)viewDidUnload
{
    [super viewDidUnload];

    self.mHorizontalScrollView = nil;
    self.mGridViewPages = nil;
    self.mAdBannerView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) loadIconData
{
    NSMutableArray* sDataOnPage0 = [NSMutableArray arrayWithCapacity:4];
    IconData* sIcon1 = [[IconData alloc]init];
    sIcon1.mTitle = NSLocalizedString(@"Physiology", nil);
    sIcon1.mImage = [UIImage imageNamed:@"physiology140*100.png"];
    //    sIcon1.mJSONFilePath = nil;
    sIcon1.mSectionNameOrURL = SECTION_NAME_PHYSILOGY;
    sIcon1.mTotal = [[StoreManagerEx shared] getTotalOfItemsInsection:sIcon1.mSectionNameOrURL];
    sIcon1.mReadCount = [[StoreManagerEx shared] getReadCountInSection:sIcon1.mSectionNameOrURL];
    [sDataOnPage0 addObject: sIcon1];
    [sIcon1 release];
    
    IconData* sIcon2 = [[IconData alloc]init];
    sIcon2.mTitle = NSLocalizedString(@"Health", nil);
    sIcon2.mImage = [UIImage imageNamed:@"health140*100.png"];
    sIcon2.mSectionNameOrURL = SECTION_NAME_HEALTH;
    sIcon2.mTotal = [[StoreManagerEx shared] getTotalOfItemsInsection:sIcon2.mSectionNameOrURL];
    sIcon2.mReadCount = [[StoreManagerEx shared] getReadCountInSection:sIcon2.mSectionNameOrURL];
    
    [sDataOnPage0 addObject: sIcon2];
    [sIcon2 release];
    
    IconData* sIcon3 = [[IconData alloc]init];
    sIcon3.mTitle = NSLocalizedString(@"Diet", nil);
    sIcon3.mImage = [UIImage imageNamed:@"diet140*100.png"];
    sIcon3.mSectionNameOrURL = SECTION_NAME_DIET;
    sIcon3.mTotal = [[StoreManagerEx shared] getTotalOfItemsInsection:sIcon3.mSectionNameOrURL];
    sIcon3.mReadCount = [[StoreManagerEx shared] getReadCountInSection:sIcon3.mSectionNameOrURL];
    [sDataOnPage0 addObject: sIcon3];
    [sIcon3 release];
    
    IconData* sIcon4 = [[IconData alloc]init];
    sIcon4.mTitle = NSLocalizedString(@"Life", nil);
    sIcon4.mImage = [UIImage imageNamed:@"life140*100.png"];
    sIcon4.mSectionNameOrURL = SECTION_NAME_LIFE;
    sIcon4.mTotal = [[StoreManagerEx shared] getTotalOfItemsInsection:sIcon4.mSectionNameOrURL];
    sIcon4.mReadCount = [[StoreManagerEx shared] getReadCountInSection:sIcon4.mSectionNameOrURL];
    [sDataOnPage0 addObject: sIcon4];
    [sIcon4 release];
    
    
    NSMutableArray* sDataOnPage1 = [NSMutableArray arrayWithCapacity:4];
    
    IconData* sIcon5 = [[IconData alloc]init];
    sIcon5.mTitle = NSLocalizedString(@"Contraception", nil);
    sIcon5.mImage = [UIImage imageNamed:@"contraception140*100.png"];
    sIcon5.mSectionNameOrURL = SECTION_NAME_CONTRACEPTION;
    sIcon5.mTotal = [[StoreManagerEx shared] getTotalOfItemsInsection:sIcon5.mSectionNameOrURL];
    sIcon5.mReadCount = [[StoreManagerEx shared] getReadCountInSection:sIcon5.mSectionNameOrURL];
    [sDataOnPage1 addObject: sIcon5];
    [sIcon5 release];
    
    IconData* sIcon6 = [[IconData alloc]init];
    sIcon6.mTitle = NSLocalizedString(@"Pregnancy", nil);
    sIcon6.mImage = [UIImage imageNamed:@"pregancy140*100.png"];
    sIcon6.mSectionNameOrURL = SECTION_NAME_PREGNANCY;
    sIcon6.mTotal = [[StoreManagerEx shared] getTotalOfItemsInsection:sIcon6.mSectionNameOrURL];
    sIcon6.mReadCount = [[StoreManagerEx shared] getReadCountInSection:sIcon6.mSectionNameOrURL];
    [sDataOnPage1 addObject: sIcon6];
    [sIcon6 release];
    
    IconData* sIcon7 = [[IconData alloc]init];
    sIcon7.mTitle = NSLocalizedString(@"Culture", nil);
    sIcon7.mImage = [UIImage imageNamed:@"culture140*100.png"];
    sIcon7.mSectionNameOrURL = SECIION_NAME_CULTURE;
    sIcon7.mTotal = [[StoreManagerEx shared] getTotalOfItemsInsection:sIcon7.mSectionNameOrURL];
    sIcon7.mReadCount = [[StoreManagerEx shared] getReadCountInSection:sIcon7.mSectionNameOrURL];
    [sDataOnPage1 addObject: sIcon7];
    [sIcon7 release];
    
    IconData* sIcon8 = [[IconData alloc]init];
    sIcon8.mTitle = NSLocalizedString(@"Terms", nil);
    sIcon8.mImage = [UIImage imageNamed:@"terms140*100.png"];
    sIcon8.mSectionNameOrURL = SECTION_NAME_TERMS;
    sIcon8.mTotal = [[StoreManagerEx shared] getTotalOfItemsInsection:sIcon8.mSectionNameOrURL];
    sIcon8.mReadCount = [[StoreManagerEx shared] getReadCountInSection:sIcon8.mSectionNameOrURL];
    [sDataOnPage1 addObject: sIcon8];
    [sIcon8 release];
    
    self.mIconDataArray = [NSMutableArray arrayWithCapacity:2];
    
    [self.mIconDataArray addObject:sDataOnPage0];
    [self.mIconDataArray addObject:sDataOnPage1];
    
}

- (void) presentBaiduViewController
{
    UIViewController* sViewController = [[BaiduWrapperViewController alloc]initWithTitle:NSLocalizedString(@"AskandAnswer", nil)];
    sViewController.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:sViewController animated:YES];
    [sViewController release];

    [MobClick event:@"UEID_ASK_VIEW"];
    return;
}

#pragma mark -
#pragma mark XLCycleScrollViewDatasource methods
- (NSInteger)numberOfPages
{
    if (self.mGridViewPages)
    {
        return [self.mGridViewPages count];
    }
    else
    {
        return 0;
    }
}

- (UIView *)pageAtIndex:(NSInteger)index aIsCurPage:(BOOL)aIsCurPage;
{
    if (index < 0
        || index >= self.mGridViewPages.count)
    {
        return nil;
    }
    //rember to reset the origin of subviews, cos it has been modified by mSchrollView in XLCycleScrollView
    GridViewPage* sChildScrollView = (GridViewPage*)[self.mGridViewPages objectAtIndex:index];
    [sChildScrollView setFrame:CGRectMake(0, 0, sChildScrollView.bounds.size.width, sChildScrollView.bounds.size.height)];
    
//    if (aIsCurPage
//        && (self.mIndexOfDisplayedChildView == -1
//            || ((RecentView*)[self.mChildViews objectAtIndex:self.mIndexOfDisplayedChildView]).mType != sChildScrollView.mType))
//    {
//        self.mIndexOfDisplayedChildView = index;
//        [self childViewChanged];
//    }
    return sChildScrollView;
}

#pragma mark -
#pragma mark XLCycleScrollViewDelegate methods
- (void)didClickPage:(XLCycleScrollView *)csView atIndex:(NSInteger)index
{
    
}


#pragma mark - GridViewPageDelegate

- (NSInteger) getNumberOfCellsOnPage:(NSInteger)aPageIndex
{
    if (aPageIndex>=0
        && aPageIndex < self.mIconDataArray.count)
    {
        NSInteger sNumberOfCellsOnPage = ((NSMutableArray*)[self.mIconDataArray objectAtIndex:aPageIndex]).count;
        return sNumberOfCellsOnPage;
    }
    else
    {
        return 0;
    }
}

- (IconData*) getIconDataForCellIndex:(NSInteger)aCellIndex onPage:(NSInteger)aPageIndex
{
    if (aPageIndex >=0
        && aPageIndex < self.mIconDataArray.count)
    {
        NSMutableArray* sIconsOnPage = (NSMutableArray*)[self.mIconDataArray objectAtIndex:aPageIndex];
        if (aCellIndex>=0
            && aCellIndex < sIconsOnPage.count)
        {
            IconData* sIconData = [sIconsOnPage objectAtIndex:aCellIndex];
            return sIconData; 
        }
    }
    return nil;
}

- (void) pushViewController:(UIViewController*)sViewController animated:(BOOL)animated
{
    if (sViewController)
    {
        [self.navigationController pushViewController:sViewController animated:animated];
    }
}

@end
