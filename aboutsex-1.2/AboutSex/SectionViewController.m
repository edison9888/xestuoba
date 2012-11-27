//
//  MessageStreamViewControllerIndexed.m
//  AboutSex
//
//  Created by Shane Wen on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SectionViewController.h"
#import "IndexViewController.h"
#import "FPPopover/FPPopoverController.h"

#import "StoreManager.h"
#import "TaggedButton.h"

#import "SharedStates.h"

#define TAG_FOR_CELL_TITLE_LABEL              111
#define TAG_FOR_CELL_FAVORITE_IMGVIEW         112

#define INVALID_DELTA -1

@interface SectionViewController ()
{
    UIButton* mProgressButton;
    CGFloat mDeltaPerRow;

}

@property (nonatomic, retain) UIButton* mProgressButton;
@property (nonatomic, assign) CGFloat mDeltaPerRow;


- (void) presentIndex;
- (void) refreshProgressIndicator;

@end

@implementation SectionViewController

@synthesize mProgressButton;
@synthesize mDeltaPerRow;
@synthesize mSection;
@synthesize mSectionName;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) init
{
    return [self initWithTitle:nil  AndSectionName:nil];
}

- (id) initWithTitle:(NSString*)aTitle AndSectionName: (NSString*) aSectionName
{
    self = [super initWithTitle:aTitle];
    if (self)
    {
        self.mSectionName = aSectionName;

        //init progress button and add action to it.
//        self.mProgressButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.mProgressButton = [UIButton buttonWithType:UIButtonTypeCustom];
        mProgressButton.titleLabel.font = [UIFont systemFontOfSize: 12];
        NSString* sSampleText = @"1000/1000";
        CGSize sSize = [sSampleText sizeWithFont:mProgressButton.titleLabel.font];
        mProgressButton.frame = CGRectMake(0, 0, sSize.width, sSize.height);
        mProgressButton.titleLabel.backgroundColor = [UIColor clearColor];
        mProgressButton.titleLabel.textAlignment = UITextAlignmentRight;
        mProgressButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        mProgressButton.backgroundColor = [UIColor clearColor];
        [mProgressButton addTarget:self action:@selector(presentIndex) forControlEvents:UIControlEventTouchDown];
        UIBarButtonItem* sBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:mProgressButton];
        
        self.navigationItem.rightBarButtonItem = sBarButtonItem;
        [sBarButtonItem release];
        
        //set bottom inset for tableview
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 5, 0);
        
        self.mDeltaPerRow = INVALID_DELTA;
    }
    return self;
}

- (void) configTableView
{   
    [super configTableView];
    
    self.tableView.rowHeight = 44;
    
    return;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.mProgressButton = nil;
    // Release any retained subviews of the main view.
}

- (void) dealloc
{
    self.mSection = nil;
    self.mSectionName = nil;
    self.mProgressButton = nil;
    [super dealloc];
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableView.contentOffset = CGPointMake(0, self.mSection.mOffset); 
    [self refreshProgressIndicator];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //on devices whose ios version is 4.3 or lower, the progress indicatore should be refreshed after view appearing,
    //because the there are no visible rows detected when we are in viewWillAppear:.
    if([[[UIDevice currentDevice] systemVersion] integerValue] < 5){
        [self refreshProgressIndicator];
    };
    
    if ([[SharedStates getInstance] needUserGuideOnSectionIndex])
    {
        [self presentIndex];
        [[SharedStates getInstance] closeUserGuideOnSectionIndex];
    }

}

- (void)viewWillDisappear:(BOOL)animated
{
    self.mSection.mOffset = self.tableView.contentOffset.y;
    
    [StoreManager updateSectionOffset:self.mSection.mOffset ForSection:self.mSection.mSectionID];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark overide methods in parent class CommonTableViewController
- (void) loadData
{
    self.mSection = [StoreManager getSectionByName: self.mSectionName];
    
    return;
}

- (BOOL) canCollectOnContentPage
{
    return YES;
}

- (Item*) getItemByIndexPath:(NSIndexPath*)aIndexPath
{
    NSInteger sRow = [aIndexPath row];
    Item* sItem = [self.mSection getItemByIndex:sRow];
    return sItem;
}

//- (BOOL) getCollectionStatuForSelectedRow
//{
//    NSIndexPath* sSelectedIndexPath = [self.tableView indexPathForSelectedRow];    
//    Item* sItem = [self getItemByIndexPath:sSelectedIndexPath];
//    return sItem.mIsMarked;
//}
//
//- (BOOL) toggleCollectedStatusByButton:(id)aButton
//{
//#ifdef DEBUG
//    NSLog(@"aButton: %@", [aButton class]);
//#endif
//    TaggedButton* sFavButton = (TaggedButton*)aButton;
//    NSIndexPath* sIndexPath = sFavButton.mIndexPath;
//    
//    BOOL sRet = [self reverseColletedStatus:sIndexPath];
//    
//    if (sRet)
//    {
//        [sFavButton setImage: [UIImage imageNamed:@"favorite24.png"] forState:UIControlStateNormal];
//    }
//    else 
//    {
//        [sFavButton setImage: [UIImage imageNamed:@"favorite_inactive24.png"] forState:UIControlStateNormal];
//    }   
//    
//    
//    return sRet;
//}
//
//- (BOOL) toggleColletedStatusOfSelectedRow
//{
//    NSIndexPath* sSelectedIndexPath =  [self.tableView indexPathForSelectedRow];
//    
//    BOOL sRet = [self reverseColletedStatus:sSelectedIndexPath];
//    //the following line does not work, strangely, so use UITableView selectRowAtIndexPath:
//    //        [self.tableView cellForRowAtIndexPath:sSelectedIndexPath].selected = YES;
//    //    [self.tableView selectRowAtIndexPath:sSelectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
//    return sRet;
//    
//}
//
//
//#pragma mark -
//#pragma mark methods to chanage message's collection status.
//- (BOOL) reverseColletedStatus:(NSIndexPath*)aIndexPath
//{
//    Item* sItem = [self getItemByIndexPath:aIndexPath];
//    
//    sItem.mIsMarked = !sItem.mIsMarked;
//    [StoreManager updateItemMarkedStatus:sItem.mIsMarked ItemID:sItem.mItemID];
//    
//    return sItem.mIsMarked;
//}


#pragma mark -

- (void) refreshProgressIndicator
{
    NSInteger sCurPosAdjusted;
    NSInteger sTotal = self.mSection.mItemCount;
    
    if (sTotal <= 0)
    {
        sCurPosAdjusted = 0;
    }
    else 
    {
        NSArray* sIndexPathsForVisibleRows = self.tableView.indexPathsForVisibleRows;
        if (sIndexPathsForVisibleRows
            && sIndexPathsForVisibleRows.count>0)
        {
            NSIndexPath* sIndexpath = (NSIndexPath*)[sIndexPathsForVisibleRows objectAtIndex:0];
            sCurPosAdjusted = [sIndexpath row]+1;
            if (sCurPosAdjusted <= 0)
            {
                sCurPosAdjusted = -1;
            }
            if (sCurPosAdjusted > sTotal)
            {
                sCurPosAdjusted = sTotal;
            }
        }
        else 
        {
            sCurPosAdjusted = -1;
        }
    }
    if (-1 != sCurPosAdjusted)
    {
        NSString* sStr = [NSString stringWithFormat:@"%d/%d", sCurPosAdjusted, sTotal];
        [mProgressButton setTitle:sStr forState:UIControlStateNormal];
    }
}

#pragma mark -
#pragma mark tableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section)
    {
        return self.mSection.mItemCount; 
    }
    else
    {
        return 0;
    }
} 

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{            
    static NSString * sIdentifier = @"identifier";
    
    UILabel* sTitleLabel;
    TaggedButton* sFavButton;
    UITableViewCell * sCell = [tableView dequeueReusableCellWithIdentifier:sIdentifier];

    if( sCell == nil )
    {
        sCell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle
                                        reuseIdentifier: sIdentifier] autorelease];
        
        UIView* sBGView = [[UIView alloc] initWithFrame:sCell.frame];
        sBGView.backgroundColor = SELECTED_CELL_COLOR;
        sCell.selectedBackgroundView = sBGView;
        [sBGView release];
        
        //title label
        sTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 8, 255, 30)];
        sTitleLabel.backgroundColor = TAB_PAGE_BGCOLOR;
        sTitleLabel.tag = TAG_FOR_CELL_TITLE_LABEL;
        [sCell.contentView addSubview:sTitleLabel];
        [sTitleLabel release];
                
        //favorite button
        sFavButton = [TaggedButton buttonWithType:UIButtonTypeCustom];
        [sFavButton setFrame:CGRectMake(285, 8, 24, 24)];
        
        sFavButton.mMarginInsets = UIEdgeInsetsMake(24, 20, self.tableView.rowHeight-32, 11);
        sFavButton.mIndexPath = indexPath;
        sFavButton.tag = TAG_FOR_CELL_FAVORITE_IMGVIEW;
        sFavButton.showsTouchWhenHighlighted = YES;
        [sFavButton addTarget:self action:@selector(toggleCollectedStatusByButton:) forControlEvents:UIControlEventTouchDown];
        [sCell.contentView addSubview:sFavButton];


    }
    else 
    {
        sTitleLabel = (UILabel*) [sCell.contentView viewWithTag:TAG_FOR_CELL_TITLE_LABEL];
        sFavButton = (TaggedButton*)[sCell.contentView viewWithTag:TAG_FOR_CELL_FAVORITE_IMGVIEW];
        sFavButton.mIndexPath = indexPath;
    }
    
    NSInteger sRow = [indexPath row];
    Item* sItem = [self.mSection getItemByIndex:sRow];
    
    
    //title
    sTitleLabel.text = [NSString stringWithFormat: @"%d. %@", sRow+1, sItem.mName];
    
    //isRead apperance
    if (sItem.mIsRead)
    {
        sTitleLabel.textColor = [UIColor grayColor];
    }
    else 
    {
        sTitleLabel.textColor = [UIColor blackColor];
    }

    
    
    if (sItem.mIsMarked)
    {
        [sFavButton setImage: [UIImage imageNamed:@"favorite24.png"] forState:UIControlStateNormal];
    }
    else 
    {
        [sFavButton setImage: [UIImage imageNamed:@"favorite_inactive24.png"] forState:UIControlStateNormal];
    }   
    
    return sCell;
}


#pragma mark -
#pragma mark tableview delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self refreshProgressIndicator];
    return;
}

#pragma mark index selection

- (void) presentIndex
{
    IndexViewController* sIndexViewController = [[IndexViewController alloc]initWithStyle:UITableViewStylePlain];
    sIndexViewController.tableView.backgroundColor = POPOVER_TABLEVIEW_COLOR;
    sIndexViewController.title = NSLocalizedString(@"Index", nil);
    sIndexViewController.mDelegate = self;
    
    FPPopoverController *sPopoverController = [[FPPopoverController alloc] initWithViewController:sIndexViewController];
    [sIndexViewController release];
    
    //popover.arrowDirection = FPPopoverArrowDirectionAny;
    sPopoverController.tint = FPPopoverDefaultTint;
    
    CGFloat sWidth;
    CGFloat sHeight;
    sWidth = 180;
    sHeight = 280;
    
    sPopoverController.contentSize = CGSizeMake(sWidth , sHeight);
    sPopoverController.arrowDirection = FPPopoverArrowDirectionAny;
    
    //sender is the UIButton view
    [sPopoverController presentPopoverFromView:self.navigationItem.rightBarButtonItem.customView]; 
    
    
    //man, i should release it,right??? but it seems weird to do this!!!
    [sPopoverController release];
    
    
    
    return;
}

- (NSInteger) getTotalNumberOfIndexes
{
    return [self.mSection.mCategories count];
}

- (IndexInfo*) getIndexInfo: (NSInteger)aSerialNumber
{
    IndexInfo* sIndexInfo = [[[IndexInfo alloc]init]autorelease];
    sIndexInfo.mName = ((Category*)[self.mSection.mCategories objectAtIndex:aSerialNumber]).mName;
    sIndexInfo.mPos = ((NSNumber*)[self.mSection.mIndexOfTheFirstItemForEachCategory objectAtIndex:aSerialNumber]).integerValue;
    return sIndexInfo;
}


- (void) clickTheIndex: (NSInteger) aSeriNumberOfTheClickedIndex;
{
    NSInteger mTargetPos = ((NSNumber*)[self.mSection.mIndexOfTheFirstItemForEachCategory objectAtIndex:aSeriNumberOfTheClickedIndex]).integerValue;

    NSIndexPath* sIndexPath = [NSIndexPath indexPathForRow:mTargetPos inSection:0];
    [self.tableView scrollToRowAtIndexPath:sIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    [self refreshProgressIndicator];
    return;
}


@end
