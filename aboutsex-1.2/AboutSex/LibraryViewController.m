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

#import "StoreManager.h"
#import "UserConfiger.h"

#import "XLCycleScrollView.h"
#import "GridViewPage.h"


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
}

@property (nonatomic, retain) NSMutableArray* mIconDataArray;
@property (nonatomic, assign) NSInteger mIndexOfIconTouched;
@property (nonatomic, retain) XLCycleScrollView* mHorizontalScrollView;
@property (nonatomic, retain) NSMutableArray* mGridViewPages;

- (void) returToLibrary;

@end


@implementation LibraryViewController

@synthesize mIconDataArray;
@synthesize mIndexOfIconTouched;
@synthesize mHorizontalScrollView;
@synthesize mGridViewPages;


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
        
        UIBarButtonItem* sRefershBarButtonItem =  [[UIBarButtonItem alloc]initWithCustomView:sPresentBaiduButton];
//        UIBarButtonItem* sRefershBarButtonItem =  [[UIBarButtonItem alloc]initWithTitle:@"问答" style:UIBarButtonItemStyleBordered target:self action:@selector(presentBaiduViewController)];

        sRefershBarButtonItem.style = UIBarButtonItemStylePlain;
        
            
        self.navigationItem.rightBarButtonItem = sRefershBarButtonItem;
        [sRefershBarButtonItem release];

    
        [self loadIconData];
    }
    
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        
//    [self loadIconData];
//    [self.mGridView reloadData];
}

- (void) dealloc
{
    self.mIconDataArray = nil;
    self.mHorizontalScrollView = nil;
    self.mGridViewPages = nil;
    [super dealloc];
}


- (void) loadView 
{
    [super loadView];
    
    CGRect sViewBounds = self.view.bounds;

    CGFloat sHeightOfNavigationBar = self.navigationController.navigationBar.bounds.size.height;
    CGFloat sHeightOfTabBar = self.tabBarController.tabBar.bounds.size.height;
    sViewBounds.size.height -= sHeightOfNavigationBar+sHeightOfTabBar;
    

    [self prepareGridViewPages];
    
    XLCycleScrollView* sHorizontalScrollView = [[XLCycleScrollView alloc]initWithFrame:sViewBounds IsRepeating:NO NeedPageControl:YES];
    sHorizontalScrollView.datasource = self;
    sHorizontalScrollView.delegate = self;
    sHorizontalScrollView.backgroundColor = [UIColor clearColor];
    [self.mMainView addSubview:sHorizontalScrollView];
    
    self.mHorizontalScrollView = sHorizontalScrollView;
    [sHorizontalScrollView release];

//    self.view = mGridView;
    //mGridView memory leak here?
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
    [self.mGridViewPages addObject:sGridViewPage0];
    [self.mGridViewPages addObject:sGridViewPage1];
    
    
    [sGridViewPage0 release];
    [sGridViewPage1 release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) presentBaiduViewController
{
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

- (void) loadIconData
{
    NSMutableArray* sDataOnPage0 = [NSMutableArray arrayWithCapacity:4];
    IconData* sIcon1 = [[IconData alloc]init];
    sIcon1.mTitle = NSLocalizedString(@"Physiology", nil);
    sIcon1.mImage = [UIImage imageNamed:@"physiology140*100.png"];
//    sIcon1.mJSONFilePath = nil;
//    sIcon1.mSectionNameOrURL = SECTION_NAME_COMMONSENSE;
//    sIcon1.mTotal = [StoreManager getTotalOfItemsInsection:sPhysiologyIcon.mSectionNameOrURL];
//    sIcon1.mReadCount = [StoreManager getReadCountInSection:sPhysiologyIcon.mSectionNameOrURL];
    [sDataOnPage0 addObject: sIcon1];
    [sIcon1 release];

    IconData* sIcon2 = [[IconData alloc]init];
    sIcon2.mTitle = NSLocalizedString(@"Health", nil);
    sIcon2.mImage = [UIImage imageNamed:@"health140*100.png"];
    [sDataOnPage0 addObject: sIcon2];
    [sIcon2 release];

    IconData* sIcon3 = [[IconData alloc]init];
    sIcon3.mTitle = NSLocalizedString(@"Diet", nil);
    sIcon3.mImage = [UIImage imageNamed:@"diet140*100.png"];
    [sDataOnPage0 addObject: sIcon3];
    [sIcon3 release];

    IconData* sIcon4 = [[IconData alloc]init];
    sIcon4.mTitle = NSLocalizedString(@"Life", nil);
    sIcon4.mImage = [UIImage imageNamed:@"life140*100.png"];
    [sDataOnPage0 addObject: sIcon4];
    [sIcon4 release];

    
    NSMutableArray* sDataOnPage1 = [NSMutableArray arrayWithCapacity:4];
    
    IconData* sIcon5 = [[IconData alloc]init];
    sIcon5.mTitle = NSLocalizedString(@"Contraception", nil);
    sIcon5.mImage = [UIImage imageNamed:@"contraception140*100.png"];
    [sDataOnPage1 addObject: sIcon5];
    [sIcon5 release];
    
    IconData* sIcon6 = [[IconData alloc]init];
    sIcon6.mTitle = NSLocalizedString(@"Pregnancy", nil);
    sIcon6.mImage = [UIImage imageNamed:@"pregancy140*100.png"];
    [sDataOnPage1 addObject: sIcon6];
    [sIcon6 release];
    
    IconData* sIcon7 = [[IconData alloc]init];
    sIcon7.mTitle = NSLocalizedString(@"Culture", nil);
    sIcon7.mImage = [UIImage imageNamed:@"culture140*100.png"];
    [sDataOnPage1 addObject: sIcon7];
    [sIcon7 release];
    
    IconData* sIcon8 = [[IconData alloc]init];
    sIcon8.mTitle = NSLocalizedString(@"Terms", nil);
    sIcon8.mImage = [UIImage imageNamed:@"terms140*100.png"];
    [sDataOnPage1 addObject: sIcon8];
    [sIcon8 release];
    
    self.mIconDataArray = [NSMutableArray arrayWithCapacity:2];
    
    [self.mIconDataArray addObject:sDataOnPage0];
    [self.mIconDataArray addObject:sDataOnPage1];
    
}



////////////////////////////////////////////////////////////////
//#pragma mark GMGridViewDataSource
////////////////////////////////////////////////////////////////
//
//- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
//{
//    return [self.mIconDataArray count];
//}
//
//- (CGSize)sizeForItemsInGMGridView:(GMGridView *)gridView
//{
//    return SIZE_OF_CELL;
//}
//
//- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
//{
//    //NSLog(@"Creating view indx %d", index);
//    
//    
//    GMGridViewCell *cell = [gridView dequeueReusableCell];
//    
//    if (!cell) 
//    {
//        cell = [[[GMGridViewCell alloc] init] autorelease];
////        cell.deleteButtonIcon = [UIImage imageNamed:@"icon72.png"];
////        cell.deleteButtonOffset = CGPointMake(-15, -15);
//        CGSize size = [self sizeForItemsInGMGridView:gridView];
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
//        view.backgroundColor = BGCOLOR_OF_CELL;
//        view.layer.masksToBounds = NO;
//        view.layer.cornerRadius = 8;
//        view.layer.shadowColor = [UIColor grayColor].CGColor;
//        view.layer.shadowOffset = CGSizeMake(0, 5);
////        view.layer.shadowPath = [UIBezierPath bezierPathWithRect:view.bounds].CGPath;
////        view.layer.shadowRadius = 8;
////        view.layer.shadowOpacity = 1.0f;
//        
//        cell.contentView = view;
//        [view release];
//    }
//    
//    if ([UserConfiger isNightModeOn])
//    {
//        cell.contentView.backgroundColor = [UIColor grayColor];
//    }
//    else
//    {
//        cell.contentView.backgroundColor = BGCOLOR_OF_CELL;
//    }
//    
//    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    
//    
//    IconData* sIconData = (IconData*)[mIconDataArray objectAtIndex:index];
//    
//    //label displaying the title for the corresponding category.
//    UILabel *sTitleLabel = [[UILabel alloc] initWithFrame:cell.contentView.bounds];
//    sTitleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    sTitleLabel.text = sIconData.mTitle;
//    sTitleLabel.textAlignment = UITextAlignmentCenter;
//    sTitleLabel.backgroundColor = [UIColor clearColor];
//    sTitleLabel.textColor = [UIColor blackColor];
////    sTitleLabel.font = [UIFont boldSystemFontOfSize:20];
//    [sTitleLabel sizeToFit];
//    sTitleLabel.center = cell.contentView.center;
//    [cell.contentView addSubview:sTitleLabel];
//    [sTitleLabel release];
//    
//    //label displaying number of items read and item in total respectively.
//    if (sIconData.mIsLocal)
//    {
//        UILabel* sCountLabel = [[UILabel alloc] initWithFrame:cell.contentView.bounds];
//        sCountLabel.text = [NSString stringWithFormat:@"%d / %d", sIconData.mReadCount, sIconData.mTotal];
//        sCountLabel.font = [UIFont fontWithName:@"Helvetica" size:10];
//        sCountLabel.textColor = [UIColor grayColor];
//        sCountLabel.backgroundColor = [UIColor clearColor];
//        [sCountLabel sizeToFit];
//        sCountLabel.center = CGPointMake(cell.contentView.bounds.size.width-sCountLabel.bounds.size.width/2, 
//                                         sCountLabel.bounds.size.height/2);
//        sCountLabel.tag = TAG_FOR_READCOUNT_LABEL;
//        [cell.contentView addSubview:sCountLabel];
//        [sCountLabel release];
//    }
//    
//    return cell;
//}
//
//- (void)GMGridView:(GMGridView *)gridView deleteItemAtIndex:(NSInteger)index
//{
//    //icon data now cannot be removed by user!!!
////    [mIconDataArray removeObjectAtIndex:index];
//}
//
////////////////////////////////////////////////////////////////
//#pragma mark GMGridViewActionDelegate
////////////////////////////////////////////////////////////////
//
//- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
//{
//    self.mIndexOfIconTouched = position;
//    
//    GMGridViewCell* sCell = [gridView cellForItemAtIndex:position];
//    
//    //1. haha, the cell has to shake for a moment before open a page for you.
//    CGFloat rotation = 0.03;
//    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"transform"];
//    shake.duration = 0.1;
//    shake.autoreverses = YES;
//    shake.repeatCount  = 1;
//    shake.removedOnCompletion = YES;
//    shake.delegate = self;
//    shake.fromValue = [NSValue valueWithCATransform3D:CATransform3DRotate(sCell.contentView.layer.transform,-rotation, 0.0 ,0.0 ,1.0)];
//    shake.toValue   = [NSValue valueWithCATransform3D:CATransform3DRotate(sCell.contentView.layer.transform, rotation, 0.0 ,0.0 ,1.0)];
//    
//    [sCell.layer addAnimation:shake forKey:nil];                        
//    
//    return;
//}
//
//- (void) returToLibrary
//{
//    [self dismissViewControllerAnimated:YES completion:nil];
//    return;
//}
//
////-(void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
////{
////    //2. present a new viewcontroller holding items for corresponding content.
////   if (INVALID_INDEX != mIndexOfIconTouched)
////    {
////        IconData* sIconData = (IconData*)[self.mIconDataArray objectAtIndex:mIndexOfIconTouched];
////        NSString* sTitle = sIconData.mTitle;
////        NSString* sSectionName = sIconData.mSectionNameOrURL;
////        
////        UIViewController* sSectionViewController;
////        if (sIconData.mIsLocal)
////        {
////            sSectionViewController = [[SectionViewController alloc] initWithTitle:sTitle AndSectionName:sSectionName];
////        }
////        else 
////        {
////            sSectionViewController = [[BaiduWrapperViewController alloc]initWithTitle:sTitle];
////        }
////        sSectionViewController.hidesBottomBarWhenPushed = YES;
////        [self.navigationController pushViewController:sSectionViewController animated:YES];
////        [sSectionViewController release];
////#ifdef DEBUG
////        NSLog(@"Did tap at index %d", mIndexOfIconTouched);
////#endif
////    }
////}
//
//
//
//#pragma mark -
//#pragma mark -
//#pragma mark cos we now disable the rotation,sorting, pinching recognizer, the below methods for the corresponding delegates are useless. you may implemet them as you like when you need these funcionalities, in the future.
//#pragma mark -
//
////////////////////////////////////////////////////////////////
//#pragma mark GMGridViewSortingDelegate
////////////////////////////////////////////////////////////////
//
//- (void)GMGridView:(GMGridView *)gridView didStartMovingCell:(GMGridViewCell *)cell
//{
////    [UIView animateWithDuration:0.3 
////                          delay:0 
////                        options:UIViewAnimationOptionAllowUserInteraction 
////                     animations:^{
////                         cell.contentView.backgroundColor = [UIColor orangeColor];
////                         cell.contentView.layer.shadowOpacity = 0.7;
////                     } 
////                     completion:nil
////     ];
//}
//
//- (void)GMGridView:(GMGridView *)gridView didEndMovingCell:(GMGridViewCell *)cell
//{
////    [UIView animateWithDuration:0.3 
////                          delay:0 
////                        options:UIViewAnimationOptionAllowUserInteraction 
////                     animations:^{  
////                         cell.contentView.backgroundColor = [UIColor greenColor];
////                         cell.contentView.layer.shadowOpacity = 0;
////                     }
////                     completion:nil
////     ];
//}
//
//- (BOOL)GMGridView:(GMGridView *)gridView shouldAllowShakingBehaviorWhenMovingCell:(GMGridViewCell *)cell atIndex:(NSInteger)index
//{
//    return YES;
//}
//
//- (void)GMGridView:(GMGridView *)gridView moveItemAtIndex:(NSInteger)oldIndex toIndex:(NSInteger)newIndex
//{
////    NSObject *object = [_data objectAtIndex:oldIndex];
////    [_data removeObject:object];
////    [_data insertObject:object atIndex:newIndex];
//}
//
//- (void)GMGridView:(GMGridView *)gridView exchangeItemAtIndex:(NSInteger)index1 withItemAtIndex:(NSInteger)index2
//{
////    [mIconDataArray exchangeObjectAtIndex:index1 withObjectAtIndex:index2];
//}
//
//
////////////////////////////////////////////////////////////////
//#pragma mark DraggableGridViewTransformingDelegate
////////////////////////////////////////////////////////////////
//
//- (CGSize)GMGridView:(GMGridView *)gridView sizeInFullSizeForCell:(GMGridViewCell *)cell atIndex:(NSInteger)index
//{
////    return CGSizeMake(310, 310);
//    return CGSizeZero;
//}
//
//- (UIView *)GMGridView:(GMGridView *)gridView fullSizeViewForCell:(GMGridViewCell *)cell atIndex:(NSInteger)index
//{
////    UIView *fullView = [[UIView alloc] init];
////    fullView.backgroundColor = [UIColor yellowColor];
////    fullView.layer.masksToBounds = NO;
////    fullView.layer.cornerRadius = 8;
////    
////    CGSize size = [self GMGridView:gridView sizeInFullSizeForCell:cell atIndex:index];
////    fullView.bounds = CGRectMake(0, 0, size.width, size.height);
////    
////    UILabel *label = [[UILabel alloc] initWithFrame:fullView.bounds];
////    label.text = [NSString stringWithFormat:@"Fullscreen View for cell at index %d", index];
////    label.textAlignment = UITextAlignmentCenter;
////    label.backgroundColor = [UIColor clearColor];
////    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
////    
////
////    label.font = [UIFont boldSystemFontOfSize:15];
////    
////    
////    [fullView addSubview:label];
////    
////    
////    return fullView;
//    return nil;
//}
//
//- (void)GMGridView:(GMGridView *)gridView didStartTransformingCell:(GMGridViewCell *)cell
//{
////    [UIView animateWithDuration:0.5 
////                          delay:0 
////                        options:UIViewAnimationOptionAllowUserInteraction 
////                     animations:^{
////                         cell.contentView.backgroundColor = [UIColor blueColor];
////                         cell.contentView.layer.shadowOpacity = 0.7;
////                     } 
////                     completion:nil];
//}
//
//- (void)GMGridView:(GMGridView *)gridView didEndTransformingCell:(GMGridViewCell *)cell
//{
////    [UIView animateWithDuration:0.5 
////                          delay:0 
////                        options:UIViewAnimationOptionAllowUserInteraction 
////                     animations:^{
////                         cell.contentView.backgroundColor = [UIColor redColor];
////                         cell.contentView.layer.shadowOpacity = 0;
////                     } 
////                     completion:nil];
//}
//
//- (void)GMGridView:(GMGridView *)gridView didEnterFullSizeForCell:(UIView *)cell
//{
//    
//}


@end
