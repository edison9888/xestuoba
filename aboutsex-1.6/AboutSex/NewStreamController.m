//
//  PullRefreshTableViewController.m
//  Plancast
//
//  Created by Leah Culver on 7/2/10.
//  Copyright (c) 2010 Leah Culver
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import <QuartzCore/QuartzCore.h>
#import "NewStreamController.h"
#import "NSDateFormatter+MyDateFormatter.h"
#import "TaggedButton.h"

#import "MyURLConnection.h"

#import "SharedStates.h"
#import "AFNetworking.h"
#import "NSURL+WithChanelID.h"
#import "InteractivityCountManager.h"
#import "MLNavigationController.h"

#define REFRESH_HEADER_HEIGHT 52.0f

#define TAG_FOR_CELL_TITLE_LABEL              11
#define TAG_FOR_CELL_FAVORITE_IMGVIEW         12
#define TAG_FOR_CELL_DATE_LABEL               13
#define TAG_FOR_CELL_VISITS_COUNT_LABEL       14
#define TAG_FOR_CELL_SUMMARY_LABEL            15
#define TABLEVIEW_CELL_CONTENT_VIEW_LOADING_MORE_NOTICE 16

#define MAX_NUMBER_OF_STREAM_DISPLAYED_PER_FETCH 15
#define MAX_NUMBER_OF_STREAM_STORED     101
#define MAX_DISPALY_ITEMS    31

@interface NewStreamController ()
{
    NewStreamSniffer * mNewStreamSniffer;
    NSDate* mLastUpdateTime;
    BOOL mIsAutoRefresh;
    
    UIBarButtonItem* mRefreshButtonBarButtonItem;
    UIBarButtonItem* mLoadingIndicatorBarButtonItem;
}

@property (nonatomic, retain) NewStreamSniffer * mNewStreamSniffer;
@property (nonatomic, retain) NSDate* mLastUpdateTime;
@property (nonatomic, assign) BOOL mIsAutoRefresh;

@property (nonatomic, retain) UIBarButtonItem* mRefreshButtonBarButtonItem;
@property (nonatomic, retain) UIBarButtonItem* mLoadingIndicatorBarButtonItem;


- (void) setup;
- (void) refreshViaButton;
- (void) refresh: (BOOL) aIsAutoRefresh;
- (void) refreshDone;
- (void) refreshFailure;
- (void) startNewStreamSnifferTimer;
- (void) removeNewStreamNumberTag;
- (void) setLoadingState;
- (void) unsetLoadingState;
- (void) cleanStreamItemsInDatabaseIfNecessary;


@end

@implementation NewStreamController

@synthesize textPull, textRelease, textLoading, refreshHeaderView, refreshNoticeLabel, mLastUpdateTimeLabel, refreshArrow, refreshSpinner;
@synthesize isLoading;

@synthesize mStreamItems;
@synthesize mNewStreamSniffer;
@synthesize mLastUpdateTime;
@synthesize mIsAutoRefresh;

@synthesize mLoadingIndicatorBarButtonItem;
@synthesize mRefreshButtonBarButtonItem;
@synthesize mHasMore;
@synthesize mLoadingMoreActivityIndicator;

+ (NewStreamController*) shared
{
    static NewStreamController* S_NewStreamController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        S_NewStreamController = [[NewStreamController alloc] initWithTitle:NSLocalizedString(@"Latest Articles", nil)];
//        S_NavOfNewStreamController = [[MLNavigationController alloc] initWithRootViewController:sNewStreamController];
        
        
    });
    
    return S_NewStreamController;
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        [self setup];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        [self setup];
    }
    return self;
}

- (id) initWithTitle:(NSString*)aTitle
{
    self = [super initWithTitle:aTitle];
    if (self)
    {
        mLastUpdateTime = [[SharedStates getInstance] getLastUpdateTime];
        [mLastUpdateTime retain];
        
        self.mStreamItems = [NSMutableArray array];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!self.mRefreshButtonBarButtonItem)
    {
        UIButton* sRefreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [sRefreshButton setImage:[UIImage imageNamed:@"singlerefresh24.png"] forState:UIControlStateNormal];
        sRefreshButton.frame = CGRectMake(0, 0, 24, 24);
        //    sRefreshButton.showsTouchWhenHighlighted = YES;
        [sRefreshButton addTarget:self action:@selector(refreshViaButton) forControlEvents:UIControlEventTouchDown];
        
        UIBarButtonItem* sRefershBarButtonItem =  [[UIBarButtonItem alloc]initWithCustomView:sRefreshButton];
        sRefershBarButtonItem.style = UIBarButtonItemStylePlain;
        
        self.mRefreshButtonBarButtonItem = sRefershBarButtonItem;
        [sRefershBarButtonItem release];
    }
    self.navigationItem.rightBarButtonItem = self.mRefreshButtonBarButtonItem;

    
    [self addPullToRefreshHeader];
    
    if ([self appearFirstTime])
    {
        [self refresh:YES];
        [self startNewStreamSnifferTimer];
        [self cleanStreamItemsInDatabaseIfNecessary];
    }
}

- (void) viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc {
    [refreshHeaderView release];
    [refreshNoticeLabel release];
    [mLastUpdateTimeLabel release];
    [refreshArrow release];
    [refreshSpinner release];
    [textPull release];
    [textRelease release];
    [textLoading release];
    
    self.mNewStreamSniffer = nil;
    self.mLastUpdateTime = nil;
    
    self.mLoadingIndicatorBarButtonItem = nil;
    self.mRefreshButtonBarButtonItem = nil;
    [super dealloc];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)setupStrings{
    textPull = NSLocalizedString(@"Pull down to refresh...", nil);
    textRelease = NSLocalizedString(@"Release to refresh...", nil);
    textLoading = NSLocalizedString(@"Loading...", nil);
}

- (void) setup
{
    [self setupStrings];
    self.mTableView.backgroundColor = TAB_PAGE_BGCOLOR;

    return;
}

- (void) configTableView
{   
    [super configTableView];    
//    self.mTableView.rowHeight = 85;
    return;
}

- (void) loadData
{
    NSInteger sNumOfItemsToBeLoaded = 0;
    if (self.mStreamItems.count <= 0)
    {
        sNumOfItemsToBeLoaded = MAX_NUMBER_OF_STREAM_DISPLAYED_PER_FETCH;
    }
    else
    {
        sNumOfItemsToBeLoaded = self.mStreamItems.count;
    }
    self.mStreamItems = [self loadStreamItems:sNumOfItemsToBeLoaded WithOffset:0];
}

- (NSMutableArray*) loadStreamItems:(NSInteger)aNum WithOffset:(NSInteger)aOffset
{
    NSMutableArray* sMoreItems = [StoreManager getLatestStreamItems:aNum+1 Offset:aOffset];
    if (sMoreItems.count > aNum
        && (self.mStreamItems.count+sMoreItems.count) <= MAX_DISPALY_ITEMS)
    {
        self.mHasMore = YES;
        [sMoreItems removeLastObject];
    }
    else
    {
        self.mHasMore = NO;
    }

    return sMoreItems;
}

- (void) loadMoreData
{
    NSMutableArray* sMoreItems = [self loadStreamItems:MAX_NUMBER_OF_STREAM_DISPLAYED_PER_FETCH WithOffset:self.mStreamItems.count];
    if (sMoreItems.count > 0)
    {
        [self.mStreamItems addObjectsFromArray:sMoreItems];
        
        [self.mTableView reloadData];
        
        //get interactivity statics
        NSString* sItemIDs = @"";
        int i=1;
        for (StreamItem* sItem in sMoreItems)
        {
            if (i == sMoreItems.count)
            {
                sItemIDs = [sItemIDs stringByAppendingFormat:@"%d", sItem.mItemID];
            }
            else
            {
                sItemIDs = [sItemIDs stringByAppendingFormat:@"%d,", sItem.mItemID];
            }
            i++;
        }
        
        NSMutableDictionary* sGroupItemsDict = [NSMutableDictionary dictionary];
        [sGroupItemsDict setValue:sItemIDs forKey:@"itemIDs"];
        //
        NSError* sErr = nil;
        NSData* sData = [JSONWrapper dataWithJSONObject:sGroupItemsDict options:NSJSONReadingMutableContainers error:&sErr];
        
        NSMutableURLRequest* sRequest = [NSMutableURLRequest requestWithURL:[NSURL MyURLWithString:URL_GET_GROUP_STREAM]];
        [sRequest setHTTPMethod:@"POST"];
        [sRequest setHTTPBody:sData];
        [sRequest setValue:[NSString stringWithFormat:@"%d", [sData length]] forHTTPHeaderField:@"Content-length"];        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:sRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            //
            [self addOrUpdateStreamsFromJSON:JSON];
            
            NSMutableArray* sMoreIndexPaths = [NSMutableArray arrayWithCapacity:sMoreItems.count];
            for (int i=0; i<sMoreItems.count; i++)
            {
                NSIndexPath* sIndexPath = [NSIndexPath indexPathForRow:self.mStreamItems.count-i-1 inSection:0];
                [sMoreIndexPaths addObject:sIndexPath];
            }
            [self.mTableView reloadRowsAtIndexPaths:sMoreIndexPaths withRowAnimation:UITableViewRowAnimationNone];
            
        } failure:^(NSURLRequest *request , NSHTTPURLResponse *response , NSError *error , id JSON ){
            NSLog(@"ERR:%@", error);
        }];
        [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
        //    operation.JSONReadingOptions = NSJSONReadingAllowFragments;
        [operation start];
    }
    
    [self.mLoadingMoreActivityIndicator stopAnimating];
}

//overide methods in SecionViewController
- (StreamItem*) getItemByIndexPath:(NSIndexPath*)aIndexPath
{
    NSInteger sIndex = [aIndexPath row];
    StreamItem* sItem = (StreamItem*)[self.mStreamItems objectAtIndex:sIndex];
    
    return sItem;
}


- (void)addPullToRefreshHeader {
    refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, 320, REFRESH_HEADER_HEIGHT)];
    refreshHeaderView.backgroundColor = [UIColor clearColor];
    
    refreshNoticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 320, 20)];
    refreshNoticeLabel.backgroundColor = [UIColor clearColor];
    refreshNoticeLabel.font = [UIFont systemFontOfSize:12.0];
    refreshNoticeLabel.textAlignment = UITextAlignmentCenter;
    refreshNoticeLabel.textColor = [UIColor blackColor];
    
    CGFloat sY = refreshNoticeLabel.frame.origin.y+refreshNoticeLabel.frame.size.height;
    mLastUpdateTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, refreshNoticeLabel.frame.origin.y+refreshNoticeLabel.frame.size.height, 320, REFRESH_HEADER_HEIGHT-sY-10)];
    mLastUpdateTimeLabel.backgroundColor = [UIColor clearColor];
    mLastUpdateTimeLabel.font = [UIFont systemFontOfSize:12.0];
    mLastUpdateTimeLabel.textAlignment = UITextAlignmentCenter;
    mLastUpdateTimeLabel.textColor = [UIColor grayColor];
    
    refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    refreshArrow.frame = CGRectMake(floorf((REFRESH_HEADER_HEIGHT - 18) / 2),
                                    (floorf(REFRESH_HEADER_HEIGHT - 44) / 2),
                                    18, 44);
    
    refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    refreshSpinner.frame = CGRectMake(floorf(floorf(REFRESH_HEADER_HEIGHT - 20) / 2), floorf((REFRESH_HEADER_HEIGHT - 20) / 2), 20, 20);
    refreshSpinner.hidesWhenStopped = YES;
    
    [refreshHeaderView addSubview:refreshNoticeLabel];
    [refreshHeaderView addSubview:mLastUpdateTimeLabel];
    [refreshHeaderView addSubview:refreshArrow];
    [refreshHeaderView addSubview:refreshSpinner];
    //for now, we dont need self-refresh functionality.
    [self.mTableView addSubview:refreshHeaderView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (isLoading) return;
    isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (isLoading) {
        // Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0)
            self.mTableView.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
            self.mTableView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (isDragging && scrollView.contentOffset.y < 0) {
        // Update the arrow direction and label
        [UIView animateWithDuration:0.25 animations:^{
            if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
                // User is scrolling above the header
                refreshNoticeLabel.text = self.textRelease;
                [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
            } else { 
                // User is scrolling somewhere within the header
                if (self.mLastUpdateTime)
                {
                    NSString* sLoadingNotice = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Last Update", nil), [NSDateFormatter lastUpdateTimeStringForDate:self.mLastUpdateTime]];
                    if (self.mLastUpdateTimeLabel)
                    {
                        self.mLastUpdateTimeLabel.text = sLoadingNotice;
                    }
                }

                refreshNoticeLabel.text = self.textPull;
                [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
            }
        }];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (isLoading) return;
    isDragging = NO;
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
        // Released above the header
        [self startLoading];
    }
}

- (void)startLoading {
    [self setLoadingState];
    
    // Show the header
    [UIView animateWithDuration:0.3 animations:^{
        self.mTableView.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
        
        refreshNoticeLabel.text = self.textLoading;        
        refreshArrow.hidden = YES;
        [refreshSpinner startAnimating];
    }];
    
    // Refresh action!
    [self refresh:NO];
}

- (void)stopLoading {
    [self unsetLoadingState];
    
    // Hide the header
    [UIView animateWithDuration:0.3 animations:^{
        self.mTableView.contentInset = UIEdgeInsetsZero;
        [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    } 
                     completion:^(BOOL finished) {
                         [self performSelector:@selector(stopLoadingComplete)];
                     }];
}

- (void)stopLoadingComplete {
    // Reset the header
    refreshNoticeLabel.text = self.textPull;
    refreshArrow.hidden = NO;
    [refreshSpinner stopAnimating];
}

- (void) refresh: (BOOL) aIsAutoRefresh
{
    self.mIsAutoRefresh = aIsAutoRefresh;
    
    [self refresh];
}

- (void)refresh {
    
    NSTimeInterval sLastUpdateTimeInterval = [self.mLastUpdateTime timeIntervalSince1970];
    NSString* sURLStr = [NSString stringWithFormat:@"%@?lastUpdateTime=%f", GET_STREAM_URL_STR, sLastUpdateTimeInterval];
    sURLStr = [sURLStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest* sRequest = [NSMutableURLRequest requestWithURL:[NSURL MyURLWithString:sURLStr]];

    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:sRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [self loadSucessfully:JSON];
    } failure:^(NSURLRequest *request , NSHTTPURLResponse *response , NSError *error , id JSON ){
        NSLog(@"ERR:%@", error);
        [self loadVainly];
    }];
//    operation.JSONReadingOptions = NSJSONReadingAllowFragments;
    [operation start];

}

- (NSInteger) addOrUpdateStreamsFromJSON:(id)aJSONObj
{
    NSInteger sNumOfNewStreamReallyLoaded = 0;
    if ([aJSONObj isKindOfClass:[NSArray class]])
    {
        
        NSArray *sItemsArr = (NSArray *)aJSONObj;
        NSMutableArray* sStreamItemsArray = [NSMutableArray arrayWithCapacity:sItemsArr.count];
        for (NSDictionary* sItemDict in sItemsArr)
        {
            StreamItem* sStreamItem = [[StreamItem alloc]init];
            [sStreamItem readJSONDict: sItemDict];            
#ifdef DEBUG
            //            NSLog(@"%d \t %@ \t %@ \t %d \t %@", sStreamItem.mItemID, sStreamItem.mName , sStreamItem.mLocation, sStreamItem.mNumVisits, [sStreamItem.mReleasedTime description]);
#endif
            [sStreamItemsArray addObject:sStreamItem];
            [sStreamItem release];
        }
        
        sNumOfNewStreamReallyLoaded = [StoreManager addOrUpdateStreamItems:sStreamItemsArray];
    }
    return sNumOfNewStreamReallyLoaded;
}

- (void) loadSucessfully:(id)aJSONObj
{
    //note that we only take into account the strem item really loaded. some of the stream items fetched from server may alreay exist in database and have been read or collected by user. we refetch them just in order to update their numVisit values, in passing.
    NSInteger sNumOfNewStreamReallyLoaded = [self addOrUpdateStreamsFromJSON:aJSONObj];
    
    [self refreshDone];
    self.mLastUpdateTime = [NSDate date];
    
    if (sNumOfNewStreamReallyLoaded == 0
        && self.mIsAutoRefresh)
    {
        //nothing done here.
    }
    else
    {
        NSString* sUpdateSuccessNotice = nil;
        
        if (sNumOfNewStreamReallyLoaded == 0)
        {
            if (!(self.mIsAutoRefresh))
            {
                sUpdateSuccessNotice = NSLocalizedString(@"No more news found", nil);
            }
        }
        else
        {
            if (sNumOfNewStreamReallyLoaded > MAX_NUMBER_OF_STREAM_DISPLAYED_PER_FETCH)
            {
                sNumOfNewStreamReallyLoaded = MAX_NUMBER_OF_STREAM_DISPLAYED_PER_FETCH;
            }
            sUpdateSuccessNotice = [NSString stringWithFormat:@"%@ %d %@",  NSLocalizedString(@"You've got", nil), sNumOfNewStreamReallyLoaded,  NSLocalizedString(@"piece(s) of news", nil)];
        }
        [MKInfoPanel showPanelInViewNoOverlapping:self.view type:MKInfoPanelTypeInfo title:sUpdateSuccessNotice subtitle:nil hideAfter:1.5];
        [self removeNewStreamNumberTag];
    }
    return;

}

- (void) loadVainly
{
    [self refreshFailure];
}

- (void) refreshFromOutside
{
    [self refreshViaButton];
}

- (void) refreshViaButton
{
    if (isLoading) 
    {
        return;
    }

    if (self.mLastUpdateTime)
    {
        NSString* sLoadingNotice = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Last Update", nil), [NSDateFormatter lastUpdateTimeStringForDate:self.mLastUpdateTime]];
        if (self.mLastUpdateTimeLabel)
        {
            self.mLastUpdateTimeLabel.text = sLoadingNotice;
        }
    }
    self.mTableView.contentOffset = CGPointMake(0, -REFRESH_HEADER_HEIGHT);
    
    [self startLoading];
}

- (void) refreshDone
{
    // Don't forget to call stopLoading at the end.
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:0.0];
    [self refreshTableView];
}

- (void) refreshFailure
{
    [self refreshDone];
    NSString* sUpdateErrorNotice = nil;
    if (self.mIsAutoRefresh)
    {
        sUpdateErrorNotice = NSLocalizedString(@"News updating error, there may be something wrong with your network", nil);
    }
    else 
    {
        sUpdateErrorNotice= NSLocalizedString(@"News updating error, please try again later.", nil);
    }
    
    [MKInfoPanel showPanelInViewNoOverlapping:self.view type:MKInfoPanelTypeError title:sUpdateErrorNotice subtitle:nil hideAfter:3];
    
    return;

}

- (void) setLoadingState
{
    if (!(self.isLoading))
    {
        self.isLoading = YES;
        
        if ([self.mDelegate respondsToSelector:@selector(beginLoading)])
        {
            [self.mDelegate beginLoading];
        }

    }
}

- (void) unsetLoadingState
{
    if (self.isLoading)
    {
        self.isLoading = NO;

        if ([self.mDelegate respondsToSelector:@selector(endLoading)])
        {
            [self.mDelegate endLoading];
        }
    }
}

- (void) startNewStreamSnifferTimer
{
    if (!(self.mNewStreamSniffer))
    {
        NewStreamSniffer* sNewStreamSnifferSniffer = [[NewStreamSniffer alloc] initWithDelegate:self];
        self.mNewStreamSniffer = sNewStreamSnifferSniffer;
        [sNewStreamSnifferSniffer release];
        [self.mNewStreamSniffer start];
    }
}

- (void) removeNewStreamNumberTag
{
    [self newStreamFound:0];
    return;
}

- (void) cleanStreamItemsInDatabaseIfNecessary
{
    [StoreManager removeUncollectedStreamItemsIfExceeds:MAX_NUMBER_OF_STREAM_STORED aMinCount:MAX_NUMBER_OF_STREAM_DISPLAYED_PER_FETCH+5];
}

- (void) setMLastUpdateTime:(NSDate *)aLastUpdateTime
{
    [mLastUpdateTime release];
    mLastUpdateTime = aLastUpdateTime;
    [mLastUpdateTime retain];
    
    [[SharedStates getInstance] storeLastUpdateTime:aLastUpdateTime];
}

#pragma mark -
#pragma mark tableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.mStreamItems count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.mStreamItems.count)
    {
        static NSString* sCellId = @"LoadMoreCellIdentifier";
        UITableViewCell* sCell = [tableView dequeueReusableCellWithIdentifier:sCellId];
        UILabel* sNoticeLabel = nil;
        if (!sCell)
        {
            sCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:sCellId] autorelease];
            sCell.selectionStyle = UITableViewCellSelectionStyleNone;
            //            sCell.contentView.backgroundColor = BG_COLOR;
            
            CGFloat sHeightOfCell = [self tableView:tableView heightForRowAtIndexPath:indexPath];
            
            
            sNoticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, sHeightOfCell)];
            sNoticeLabel.backgroundColor = [UIColor clearColor];
            sNoticeLabel.center = CGPointMake(tableView.center.x, sNoticeLabel.center.y);
            sNoticeLabel.textAlignment = UITextAlignmentCenter;
            sNoticeLabel.textColor = [UIColor grayColor];
            sNoticeLabel.tag = TABLEVIEW_CELL_CONTENT_VIEW_LOADING_MORE_NOTICE;
            [sCell.contentView addSubview:sNoticeLabel];
            [sNoticeLabel release];
            
            UIActivityIndicatorView* sPageLoadingIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(40, 0.0f, sHeightOfCell, sHeightOfCell)];
            sPageLoadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
            [sCell.contentView addSubview: sPageLoadingIndicator];
            self.mLoadingMoreActivityIndicator = sPageLoadingIndicator;
            [sPageLoadingIndicator release];
            
        }
        else
        {
            sNoticeLabel = (UILabel*)[sCell.contentView viewWithTag:TABLEVIEW_CELL_CONTENT_VIEW_LOADING_MORE_NOTICE];
        }
        
        if (self.mHasMore)
        {
            sNoticeLabel.text = NSLocalizedString(@"Load more", nil);
        }
        else
        {
            sNoticeLabel.text = NSLocalizedString(@"No more", nil);
        }
        
        return sCell;
    }

    static NSString * sIdentifier = @"identifier";
    UILabel* sTitleLabel;
    UILabel* sDateLabel;
    UILabel* sVisitsCountLabel;
    UILabel* sSummaryLabel;
    TaggedButton* sFavButton;

    UITableViewCell * sCell = [tableView dequeueReusableCellWithIdentifier:sIdentifier];
    
    if( sCell == nil )
    {
        sCell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle
                                        reuseIdentifier: sIdentifier] autorelease];
        
//        sCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView* sBGView = [[UIView alloc] initWithFrame:sCell.frame];
        sBGView.backgroundColor = SELECTED_CELL_COLOR;
        sCell.selectedBackgroundView = sBGView;
        [sBGView release];
        
        //title label
        sTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 260, 30)];
        sTitleLabel.backgroundColor = [UIColor clearColor];
        sTitleLabel.tag = TAG_FOR_CELL_TITLE_LABEL;
        [sCell.contentView addSubview:sTitleLabel];
        [sTitleLabel release];
                
        //date label
        sDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 29, 70, 15)];
        sDateLabel.backgroundColor = [UIColor clearColor];
        sDateLabel.font = [UIFont systemFontOfSize:10];
        sDateLabel.textColor = [UIColor grayColor];
        sDateLabel.textAlignment = UITextAlignmentLeft;
        sDateLabel.tag = TAG_FOR_CELL_DATE_LABEL;
        [sCell.contentView addSubview:sDateLabel];
        [sDateLabel release];
        
        //visits label
        sVisitsCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 29, 100, 15)];
        sVisitsCountLabel.backgroundColor = [UIColor clearColor];
        sVisitsCountLabel.font = [UIFont systemFontOfSize:10];
        sVisitsCountLabel.textColor = [UIColor grayColor];
        sVisitsCountLabel.textAlignment = UITextAlignmentLeft;
        sVisitsCountLabel.tag = TAG_FOR_CELL_VISITS_COUNT_LABEL;
        [sCell.contentView addSubview:sVisitsCountLabel];
        [sVisitsCountLabel release];

        
        //summary label
        sSummaryLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 42, 300, 35)];
        sSummaryLabel.backgroundColor = [UIColor clearColor];
        sSummaryLabel.font = [UIFont systemFontOfSize:13];
        sSummaryLabel.numberOfLines = 0;
        sSummaryLabel.textColor = [UIColor grayColor];
        sSummaryLabel.textAlignment = UITextAlignmentLeft;
        sSummaryLabel.tag = TAG_FOR_CELL_SUMMARY_LABEL;
        [sCell.contentView addSubview:sSummaryLabel];
        [sSummaryLabel release];
        
                
        //favorite button
        sFavButton = [TaggedButton buttonWithType:UIButtonTypeCustom];
        [sFavButton setFrame:CGRectMake(290, 2, 24, 24)];

//        sFavButton.mMarginInsets = UIEdgeInsetsMake(20, 20, self.tableView.rowHeight-44, 16);
        sFavButton.mMarginInsets = UIEdgeInsetsMake(0, 20, 18, 6);
        [sFavButton setImage: [UIImage imageNamed:@"heart_inactive24.png"] forState:UIControlStateNormal];
        [sFavButton setImage: [UIImage imageNamed:@"heart_active24.png"] forState:UIControlStateSelected];

        sFavButton.mIndexPath = indexPath;
        sFavButton.tag = TAG_FOR_CELL_FAVORITE_IMGVIEW;
        sFavButton.showsTouchWhenHighlighted = YES;
        [sFavButton addTarget:self action:@selector(collectionButtonPressed:) forControlEvents:UIControlEventTouchDown];
        [sCell.contentView addSubview:sFavButton];
    }
    else 
    {
        sTitleLabel = (UILabel*) [sCell.contentView viewWithTag:TAG_FOR_CELL_TITLE_LABEL];
        sVisitsCountLabel = (UILabel*) [sCell.contentView viewWithTag:TAG_FOR_CELL_VISITS_COUNT_LABEL];
        sDateLabel = (UILabel*) [sCell.contentView viewWithTag:TAG_FOR_CELL_DATE_LABEL];
        sSummaryLabel = (UILabel*) [sCell. contentView viewWithTag:TAG_FOR_CELL_SUMMARY_LABEL];
        sFavButton = (TaggedButton*)[sCell.contentView viewWithTag:TAG_FOR_CELL_FAVORITE_IMGVIEW];
        sFavButton.mIndexPath = indexPath;
    }
    
    StreamItem* sItem = (StreamItem*)[self getItemByIndexPath:indexPath];
        
    //
    sCell.contentView.backgroundColor = [UIColor clearColor];
    
    //title
    sTitleLabel.text = sItem.mName;
    
    //createdTime
//    NSDateFormatter* sDateFormatter = [[NSDateFormatter alloc]init];
//    NSString* sDateStr = [sDateFormatter stringFromDateForStreams:sItem.mReleasedTime];
    NSString* sDateStr = [NSDateFormatter lastUpdateTimeStringForDate:sItem.mReleasedTime];

//    [sDateFormatter release];
    sDateLabel.text = sDateStr;
    
    //visits count
    if (sItem.mNumVisits != -1)
    {
        NSString* sVisitsCountStr;
        sVisitsCountStr = [NSString stringWithFormat: @"%d %@", sItem.mNumVisits, NSLocalizedString(@"people have read", nil)];

        sVisitsCountLabel.text = sVisitsCountStr;
    }
    else
    {
        NSString* sVisitsCountStr;
        sVisitsCountStr = [NSString stringWithFormat: @"%d %@", 0, NSLocalizedString(@"people have read", nil)];
        sVisitsCountLabel.text = sVisitsCountStr;
    }
    
    //summary label
    NSString* sSummaryStr = sItem.mSummary;
    sSummaryLabel.text = sSummaryStr;
    
    //isRead apperance
    if (sItem.mIsRead)
    {
        sTitleLabel.textColor = [UIColor grayColor];
    }
    else 
    {
        sTitleLabel.textColor = MAIN_BGCOLOR;
    }
    
    [sFavButton setSelected:sItem.mIsMarked];

    return sCell;
}

- (void) collectionButtonPressed:(TaggedButton*)aButton
{
    BOOL sCollected = !(aButton.selected);
    [aButton setSelected:sCollected];
    
    StreamItem* sItem = [self getItemByIndexPath:aButton.mIndexPath];
    [sItem updateMarkedStaus:sCollected];
    
    [[InteractivityCountManager shared] collectItem:sItem Collected:sCollected];
    
    return;
}

#pragma mark -
#pragma mark tableview delegate 
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.mStreamItems.count)
    {
        return 40;
    }
    else
    {
        return 85;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.mStreamItems.count)
    {
        if (self.mHasMore)
        {
            [self.mLoadingMoreActivityIndicator startAnimating];
            [self loadMoreData];
        }
    }
    else
    {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

#pragma mark -
#pragma mark delegate methods for NewStreamSnifferDelegate

- (void) newStreamFound:(NSInteger) aNumOfNewStream
{
    UIViewController* sParentVCForStream = [[[[SharedStates getInstance] getMainTabController] viewControllers] objectAtIndex:0];
    if (sParentVCForStream)
    {
        if (aNumOfNewStream <= 0)
        {
            sParentVCForStream.tabBarItem.badgeValue = nil;
        }
        else
        {
            NSString* sTag;
            if (aNumOfNewStream > MAX_NUMBER_OF_STREAM_DISPLAYED_PER_FETCH)
            {
                sTag = [NSString stringWithFormat:@"%d", MAX_NUMBER_OF_STREAM_DISPLAYED_PER_FETCH];
            }
            else 
            {
                sTag = [NSString stringWithFormat:@"%d", aNumOfNewStream];
            }
            sParentVCForStream.tabBarItem.badgeValue = sTag;
        }
    }

}

- (NSDate*) getStartingDate
{
    return self.mLastUpdateTime;
}



@end
