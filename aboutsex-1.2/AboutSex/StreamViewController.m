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
#import "StreamViewController.h"
#import "NSDateFormatter+MyDateFormatter.h"
#import "TaggedButton.h"

#import "MyURLConnection.h"

#import "SharedStates.h"

#define REFRESH_HEADER_HEIGHT 52.0f

#define TAG_FOR_CELL_TITLE_LABEL              11
#define TAG_FOR_CELL_FAVORITE_IMGVIEW         12
#define TAG_FOR_CELL_DATE_LABEL               13
#define TAG_FOR_CELL_VISITS_COUNT_LABEL       14
#define TAG_FOR_CELL_SUMMARY_LABEL            15

#define MAX_NUMBER_OF_STREAM_DISPLAYED 25
#define MAX_NUMBER_OF_STREAM_STORED     500

@interface StreamViewController ()
{
    NewStreamSniffer * mNewStreamSniffer;
    NSDate* mTimeOfLastSuccessfulUpdate;
    BOOL mIsAutoRefresh;
}

@property (nonatomic, retain) NewStreamSniffer * mNewStreamSniffer;
@property (nonatomic, retain) NSDate* mTimeOfLastSuccessfulUpdate;
@property (nonatomic, assign) BOOL mIsAutoRefresh;

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

@implementation StreamViewController

@synthesize textPull, textRelease, textLoading, refreshHeaderView, refreshLabel, refreshArrow, refreshSpinner;
@synthesize isLoading;

@synthesize mStreamItems;
@synthesize mURLConnection;
@synthesize mNewStreamSniffer;
@synthesize mTimeOfLastSuccessfulUpdate;
@synthesize mIsAutoRefresh;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self != nil) {
        [self setup];
    }
    return self;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addPullToRefreshHeader];
}

- (void)dealloc {
    [refreshHeaderView release];
    [refreshLabel release];
    [refreshArrow release];
    [refreshSpinner release];
    [textPull release];
    [textRelease release];
    [textLoading release];
    
    self.mURLConnection = nil;
    self.mNewStreamSniffer = nil;
    self.mTimeOfLastSuccessfulUpdate = nil;
    [super dealloc];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([self appearFirstTime])
    {
        [self refresh:YES];
        [self startNewStreamSnifferTimer];
        [self cleanStreamItemsInDatabaseIfNecessary];
    }

}

- (void)setupStrings{
    textPull = NSLocalizedString(@"Pull down to refresh...", nil);
    textRelease = NSLocalizedString(@"Release to refresh...", nil);
    textLoading = NSLocalizedString(@"Loading...", nil);
}

- (void) setup
{
    [self setupStrings];
    
    UIButton* sRefreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sRefreshButton setImage:[UIImage imageNamed:@"singlerefresh24.png"] forState:UIControlStateNormal];
    sRefreshButton.frame = CGRectMake(0, 0, 24, 24);
//    sRefreshButton.showsTouchWhenHighlighted = YES;
    [sRefreshButton addTarget:self action:@selector(refreshViaButton) forControlEvents:UIControlEventTouchDown];
    
    UIBarButtonItem* sRefershBarButtonItem =  [[UIBarButtonItem alloc]initWithCustomView:sRefreshButton];

    
//    UIBarButtonItem* sRefershBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshViaButton)];
    sRefershBarButtonItem.style = UIBarButtonItemStylePlain;
    self.navigationItem.rightBarButtonItem = sRefershBarButtonItem;
    [sRefershBarButtonItem release];
    self.tableView.backgroundColor = TAB_PAGE_BGCOLOR;

    return;
}

- (void) configTableView
{   
    [super configTableView];
    
//    self.tableView.rowHeight = 60;
    self.tableView.rowHeight = 85;
    return;
}

- (void) loadData
{
//    self.mSection = [StoreManager getStreamSectionForRecentNDays: NUMBER_OF_RECENTDAYS_OF_STREAM_DISPLAYED];
//    self.mSection = [StoreManager getLatestStreamItems:50];
//    self.mSection.mIsCategoryZebraed = YES;
    
    self.mStreamItems = [StoreManager getLatestStreamItems:MAX_NUMBER_OF_STREAM_DISPLAYED];
    
    return;
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
    
    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, REFRESH_HEADER_HEIGHT)];
    refreshLabel.backgroundColor = [UIColor clearColor];
    refreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
    refreshLabel.textAlignment = UITextAlignmentCenter;
    
    refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    refreshArrow.frame = CGRectMake(floorf((REFRESH_HEADER_HEIGHT - 27) / 2),
                                    (floorf(REFRESH_HEADER_HEIGHT - 44) / 2),
                                    27, 44);
    
    refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    refreshSpinner.frame = CGRectMake(floorf(floorf(REFRESH_HEADER_HEIGHT - 20) / 2), floorf((REFRESH_HEADER_HEIGHT - 20) / 2), 20, 20);
    refreshSpinner.hidesWhenStopped = YES;
    
    [refreshHeaderView addSubview:refreshLabel];
    [refreshHeaderView addSubview:refreshArrow];
    [refreshHeaderView addSubview:refreshSpinner];
    //for now, we dont need self-refresh functionality.
    [self.tableView addSubview:refreshHeaderView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (isLoading) return;
    isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (isLoading) {
        // Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0)
            self.tableView.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
            self.tableView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (isDragging && scrollView.contentOffset.y < 0) {
        // Update the arrow direction and label
        [UIView animateWithDuration:0.25 animations:^{
            if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
                // User is scrolling above the header
                refreshLabel.text = self.textRelease;
                [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
            } else { 
                // User is scrolling somewhere within the header
                refreshLabel.text = self.textPull;
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
        self.tableView.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
        refreshLabel.text = self.textLoading;
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
        self.tableView.contentInset = UIEdgeInsetsZero;
        [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    } 
                     completion:^(BOOL finished) {
                         [self performSelector:@selector(stopLoadingComplete)];
                     }];
}

- (void)stopLoadingComplete {
    // Reset the header
    refreshLabel.text = self.textPull;
    refreshArrow.hidden = NO;
    [refreshSpinner stopAnimating];
}

- (void) refresh: (BOOL) aIsAutoRefresh
{
    self.mIsAutoRefresh = aIsAutoRefresh;
    
    [self refresh];
}

- (void)refresh {
    // This is just a demo. Override this method with your custom reload action.
    //pull new strem(if any) from server.
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];  
    NSMutableURLRequest* sURLRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:GET_STREAM_URL_STR]];
    
    [sURLRequest setHTTPMethod:@"POST"];
    
    [sURLRequest setValue:[NSString stringWithFormat:@"%d", 0] forHTTPHeaderField:@"Content-length"];
    [sURLRequest setHTTPBody:nil];
    
    MyURLConnection* sURLConnection = [[MyURLConnection alloc]initWithDelegate:sURLRequest withDelegate:self];
    self.mURLConnection = sURLConnection;
    [sURLRequest release];
    [sURLConnection release];
    
    if (![self.mURLConnection start])
    {
#ifdef DEBUG
        NSLog(@"conncetin creation error.");
#endif
    }    
}


- (void) refreshViaButton
{
    if (isLoading) 
    {
        return;
    }

    self.tableView.contentOffset = CGPointMake(0, -REFRESH_HEADER_HEIGHT);
    
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
        
        UIButton* sRefreshButton = (UIButton*)self.navigationItem.rightBarButtonItem.customView;
        [sRefreshButton setImage:[UIImage imageNamed:@"loading24.png"] forState:UIControlStateNormal];
    }
}

- (void) unsetLoadingState
{
    if (self.isLoading)
    {
        self.isLoading = NO;
        
        UIButton* sRefreshButton = (UIButton*)self.navigationItem.rightBarButtonItem.customView;
        [sRefreshButton setImage:[UIImage imageNamed:@"singlerefresh24.png"] forState:UIControlStateNormal]; 
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
    [StoreManager removeUncollectedStreamItemsIfExceeds:MAX_NUMBER_OF_STREAM_STORED aMinCount:MAX_NUMBER_OF_STREAM_DISPLAYED+5];
}

#pragma mark -
#pragma mark tableview datasource 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.mStreamItems count]; 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{            
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
        sTitleLabel.backgroundColor = TAB_PAGE_BGCOLOR;
        sTitleLabel.tag = TAG_FOR_CELL_TITLE_LABEL;
        [sCell.contentView addSubview:sTitleLabel];
        [sTitleLabel release];
                
        //date label
        sDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 29, 50, 15)];
        sDateLabel.backgroundColor = TAB_PAGE_BGCOLOR;
        sDateLabel.font = [UIFont systemFontOfSize:10];
        sDateLabel.textColor = [UIColor grayColor];
        sDateLabel.textAlignment = UITextAlignmentLeft;
        sDateLabel.tag = TAG_FOR_CELL_DATE_LABEL;
        [sCell.contentView addSubview:sDateLabel];
        [sDateLabel release];
        
        //visits label
        sVisitsCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(60+10, 29, 100, 15)];
        sVisitsCountLabel.backgroundColor = TAB_PAGE_BGCOLOR;
        sVisitsCountLabel.font = [UIFont systemFontOfSize:10];
        sVisitsCountLabel.textColor = [UIColor grayColor];
        sVisitsCountLabel.textAlignment = UITextAlignmentLeft;
        sVisitsCountLabel.tag = TAG_FOR_CELL_VISITS_COUNT_LABEL;
        [sCell.contentView addSubview:sVisitsCountLabel];
        [sVisitsCountLabel release];

        
        //summary label
        sSummaryLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 42, 300, 35)];
        sSummaryLabel.backgroundColor = TAB_PAGE_BGCOLOR;
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

        sFavButton.mIndexPath = indexPath;
        sFavButton.tag = TAG_FOR_CELL_FAVORITE_IMGVIEW;
        sFavButton.showsTouchWhenHighlighted = YES;
        [sFavButton addTarget:self action:@selector(toggleCollectedStatusByButton:) forControlEvents:UIControlEventTouchDown];
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
    NSDateFormatter* sDateFormatter = [[NSDateFormatter alloc]init];
    NSString* sDateStr = [sDateFormatter stringFromDateForStreams:sItem.mReleasedTime];

    [sDateFormatter release];
    sDateLabel.text = sDateStr;
    
    //visits count
    if (sItem.mNumVisits != -1)
    {
        NSString* sVisitsCountStr;
        sVisitsCountStr = [NSString stringWithFormat: @"%d %@", sItem.mNumVisits, NSLocalizedString(@"people have read", nil)];
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


#pragma mark -
#pragma mark delegate methods for MyURLConnectionDelegate

- (void) failWithConnectionError: (NSError*)aErr
{
    [self refreshFailure];
}

- (void) failWithServerError: (NSInteger)aStatusCode
{
    [self refreshFailure];
}

- (void) succeed: (NSMutableData*)aData
{
    NSError* sErr = nil;
    
    //api for json is only available on ios 5.0 and later, so you should do it yourself on versions before 5.0.
    id sJSONObject =  [NSJSONSerialization JSONObjectWithData: aData 
                                                      options:NSJSONReadingMutableContainers
                                                        error:&sErr];
    //note that we only take into account the strem item really loaded. some of the stream items fetched from server may alreay exist in database and have been read or collected by user. we refetch them just in order to update their numVisit values, in passing. 
    NSInteger sNumOfNewStreamReallyLoaded = 0;
    
    if ([sJSONObject isKindOfClass:[NSArray class]])
    {
        
        NSArray *sItemsArr = (NSArray *)sJSONObject;
        NSMutableArray* sStreamItemsArray = [NSMutableArray arrayWithCapacity:sItemsArr.count];
        for (NSDictionary* sItemDict in sItemsArr)
        {
            StreamItem* sStreamItem = [[StreamItem alloc]init];
            sStreamItem.mItemID = [((NSNumber*)[sItemDict objectForKey:@"itemID"]) integerValue];
            sStreamItem.mName = (NSString*) [sItemDict objectForKey:@"title"];
            sStreamItem.mLocation = (NSString*) [sItemDict objectForKey:@"url"];
            sStreamItem.mIsRead = NO;
            sStreamItem.mIsMarked = NO;
            sStreamItem.mReleasedTime = [NSDate dateWithTimeIntervalSince1970:[(NSString*) [sItemDict objectForKey:@"time"] integerValue]];
            sStreamItem.mMarkedTime = [NSDate date];
            sStreamItem.mIconURL = (NSString*) [sItemDict objectForKey:@"iconURL"];
            sStreamItem.mSummary = (NSString*) [sItemDict objectForKey:@"summary"];
            sStreamItem.mNumVisits = [((NSNumber*)[sItemDict objectForKey:@"numVisits"]) integerValue];
            sStreamItem.mTag = [((NSNumber*)[sItemDict objectForKey:@"tag"]) integerValue];

#ifdef DEBUG
//            NSLog(@"%d \t %@ \t %@ \t %d \t %@", sStreamItem.mItemID, sStreamItem.mName , sStreamItem.mLocation, sStreamItem.mNumVisits, [sStreamItem.mReleasedTime description]);
#endif
            [sStreamItemsArray addObject:sStreamItem];
            [sStreamItem release];
        }
        
        sNumOfNewStreamReallyLoaded = [StoreManager addOrUpdateStreamItems:sStreamItemsArray];
    }
    
    [self refreshDone];
    self.mTimeOfLastSuccessfulUpdate = [NSDate date];
    
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
            if (sNumOfNewStreamReallyLoaded > MAX_NUMBER_OF_STREAM_DISPLAYED)
            {
                sNumOfNewStreamReallyLoaded = MAX_NUMBER_OF_STREAM_DISPLAYED;
            }
            sUpdateSuccessNotice = [NSString stringWithFormat:@"%@ %d %@",  NSLocalizedString(@"You've got", nil), sNumOfNewStreamReallyLoaded,  NSLocalizedString(@"piece(s) of news", nil)];
        }
        [MKInfoPanel showPanelInViewNoOverlapping:self.view type:MKInfoPanelTypeInfo title:sUpdateSuccessNotice subtitle:nil hideAfter:1.5];        
        [self removeNewStreamNumberTag];
    }
    return;
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
            if (aNumOfNewStream > MAX_NUMBER_OF_STREAM_DISPLAYED)
            {
                sTag = [NSString stringWithFormat:@"%d", MAX_NUMBER_OF_STREAM_DISPLAYED];
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
    return self.mTimeOfLastSuccessfulUpdate;
}



@end
