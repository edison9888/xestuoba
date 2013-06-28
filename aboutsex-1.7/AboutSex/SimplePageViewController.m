//
//  SimplePageViewController.m
//  BTT
//
//  Created by Wen Shane on 13-1-7.
//  Copyright (c) 2013年 Wen Shane. All rights reserved.
//

#import "SimplePageViewController.h"
#import "SharedVariables.h"
#import "ATMHud.h"
#import "NSURL+WithChanelID.h"

#define REQUEST_TIMEOUT_INTERVAL_SECONDS 30 //in the unit of seconds

@interface SimplePageViewController ()
{
    NSMutableArray* mData;
    NSDate* mTimeOfLastUpdate;
    JSONObjProvider* mJSONObjProvider;
    
    NSLock* mDataLock;
}

@property (nonatomic, retain) NSDate* mTimeOfLastUpdate;
@property (nonatomic, retain) JSONObjProvider* mJSONObjProvider;
@end

@implementation SimplePageViewController
@synthesize mData;
@synthesize mTimeOfLastUpdate;
@synthesize mJSONObjProvider;
@synthesize mDataLock;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.mDataLock = [[[NSLock alloc] init] autorelease];
    }
    return self;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        [self.mDataLock lock];
        self.mData = [NSMutableArray array];
        [self.mDataLock unlock];
        
        [self autoRefresh];
    }
    return self;
}

- (void) dealloc
{
    self.mData = nil;
    self.mTimeOfLastUpdate = nil;
    self.mJSONObjProvider = nil;
    self.mDataLock = nil;

    [super dealloc];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self configTableView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//overide methods from pull-to-refresh class
- (void) refresh
{
    [self loadData];
}

- (void) configTableView
{
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
}

- (void) loadData
{
    NSURL *url = [NSURL MyURLWithString:[self getURLStr]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    BOOL sUseCacheIfNeeded = (!self.mData || self.mData.count<=0);
    JSONObjProvider* sProvider = [[JSONObjProvider alloc] initWithURLRequest:request CacheFilePath:[self getCacheFilePath] UseCacheIfNeeded:sUseCacheIfNeeded];
    sProvider.mDelegate = self;
    [sProvider start];
    
    self.mJSONObjProvider = sProvider;
    [sProvider release];
}

- (void) dataLoadedOnline:(id)aJSONObj IsAppendingData:(BOOL)aIsAppendingData
{
    [self.mDataLock lock];
    //
    NSMutableArray* sOldData = nil;
    if (!aIsAppendingData)
    {
        if (self.mData
            && self.mData.count > 0)
        {
            sOldData = [NSMutableArray arrayWithArray:self.mData];
            [self.mData removeAllObjects];
        } 
    }

    
    [self parseData:aJSONObj];
    //
    if (self.mData
        && self.mData.count > 0)
    {
//        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self beforeDisplayTable];
        [self.tableView reloadData];
    }
    else
    {
        //if there is no new data fetched, then use old data if exists.
        if (sOldData
            && sOldData.count > 0)
        {
//            self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            self.mData = sOldData;
        }
        else
        {
//            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;     
        }
        [self presentNoResultsNoticeView];
    }
    //
    
    [self refreshDone:YES];
    [self.mDataLock unlock];

}


#pragma mark - JSONParserDelegate method
- (void) dataLoadedOnline:(id)aJSONObj
{
    [self dataLoadedOnline:aJSONObj IsAppendingData:NO];
}

- (void) dataLoadedLocally:(id)aJSONData
{
    [self.mDataLock lock];

    [self parseData:aJSONData];
    
    if (self.mData
        && self.mData.count > 0)
    {
//        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self beforeDisplayTable];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];//do not worry; reload is synchronous.
        });
        
        
    }
    [self.mDataLock unlock];

//    [self dataLoadedFailed];
}

- (void) dataLoadedFailed
{
    [self.mDataLock unlock];

//    if(!self.mIsAutoRefresh)
    {
        self.mNeedShowNetworkErrorStatus = YES;
    }
    
    if (!self.mData
        || self.mData.count <= 0)
    {
//        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        [self presentNoResultsNoticeView];
    }
    
    [self refreshDone:NO];
    [self.mDataLock unlock];

}

- (void) presentNoResultsNoticeView
{    
    ATMHud* sHud = [[[ATMHud alloc] initWithDelegate:nil] autorelease];
    [self.view addSubview:sHud.view];
    
    [sHud setCaption:NSLocalizedString(@"No results", nil)];
    [sHud show];
    [sHud hideAfter:1.5];
}

//
- (NSString*) getCacheFilePath
{
    return nil;
}

- (NSString*) getURLStr
{
    return nil;
}

- (void) parseData:(id)aJSONObj
{
    return;
}

- (void) beforeDisplayTable
{
    return;
}


@end



///////////////////////////////////////////////////////////////////////////

#define TABLEVIEW_CELL_CONTENT_VIEW_LOADING_MORE_NOTICE 1111
@interface SimplePageViewControllerMore ()
{
    NSInteger mCurPage;
    NSInteger mPageToBeFetched;
    BOOL mIsDataComplete;
    UIActivityIndicatorView* mLoadingMoreActivityIndicator;
}

@property (nonatomic, assign) NSInteger mCurPage;
@property (nonatomic, assign) NSInteger mPageToBeFetched;
@property (nonatomic, retain) UIActivityIndicatorView* mLoadingMoreActivityIndicator;
@end

@implementation SimplePageViewControllerMore
@synthesize mCurPage;
@synthesize mPageToBeFetched;
@synthesize mIsDataComplete;
@synthesize mLoadingMoreActivityIndicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.mCurPage = -1;
        self.mPageToBeFetched =  [self getStartingPageIndex];
        self.mIsDataComplete = NO;
    }
    return self;
}

- (void) dealloc
{
    self.mLoadingMoreActivityIndicator = nil;
    [super dealloc];
}

- (void) refreshForMore
{
    self.mPageToBeFetched = self.mCurPage+1;
    self.mIsLoading = YES;
    [self loadData];
}

#pragma mark - overide the methods of PullToRefreshController
- (void) refresh
{
    self.mPageToBeFetched = [self getStartingPageIndex];
    self.mIsLoading = YES;
    [self loadData];
}


- (void) loadData
{
    if (self.mIsDataComplete
        && self.mPageToBeFetched != [self getStartingPageIndex])
    {
        return;
    }
    
    NSURL *url = [NSURL MyURLWithString:[self getURLStrByPageIndex: self.mPageToBeFetched]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:REQUEST_TIMEOUT_INTERVAL_SECONDS];
    
    BOOL sUseCacheIfNeeded = (!self.mData || self.mData.count<=0);
    JSONObjProvider* sProvider = [[JSONObjProvider alloc] initWithURLRequest:request CacheFilePath:[self getCacheFilePath] UseCacheIfNeeded:sUseCacheIfNeeded];
    sProvider.mDelegate = self;
    [sProvider start];
    
    self.mJSONObjProvider = sProvider;
    [sProvider release];
    
}

- (NSInteger) getStartingPageIndex
{
    return 0;
}

- (NSString*) getURLStrByPageIndex:(NSInteger)aPageIndex
{
    return nil;
}

#pragma mark - JSONParserDelegate method
- (void) dataLoadedOnline:(id)aJSONObj
{
    self.mCurPage = self.mPageToBeFetched;
    [self.mLoadingMoreActivityIndicator stopAnimating];

    //empty the array if refresh the page,  or load data for the first time.
    if ([self getStartingPageIndex] == self.mPageToBeFetched
        && self.mData.count > 0)
    {
//        [self.mData removeAllObjects];
        [self dataLoadedOnline:aJSONObj IsAppendingData:NO];
    }
    else
    {
        [self dataLoadedOnline:aJSONObj IsAppendingData:YES];      
    }


}


- (void) dataLoadedLocally:(id)aJSONObj
{
    self.mIsDataComplete = YES;
    self.mCurPage = self.mPageToBeFetched;
    [super dataLoadedLocally:aJSONObj];
}

- (void) dataLoadedFailed
{
    [self.mLoadingMoreActivityIndicator stopAnimating];

    [super dataLoadedFailed];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section)
    {
        if (!self.mData
            || self.mData.count <= 0)
        {
            return 0;
        }
        else
        {
            return self.mData.count+1; //to ensure one more cells appended to the tableview as a notice for loading more cells or data loaded fully.
        }
    }
    else
    {
        return 0;
    }
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger sRow = [indexPath row];
    
    if (sRow == self.mData.count)
    {
        return 40;
    }
    else
    {
        return tableView.rowHeight;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger sRow = [indexPath row];
    if (sRow == self.mData.count
        &&  !self.mIsDataComplete)
    {
        [self.mLoadingMoreActivityIndicator startAnimating];
        if (!self.mIsLoading)
        {
            [self refreshForMore];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger sRow = [indexPath row];
    
    UITableViewCell* sCell = nil;
    if (sRow == self.mData.count)
    {
        sCell = [tableView dequeueReusableCellWithIdentifier:@"LoadMoreCellIdentifier"];
        UILabel* sNoticeLabel = nil;
        if (!sCell)
        {
            sCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:@"LoadMoreCellIdentifier"] autorelease];
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
        
        if (self.mIsDataComplete)
        {
            sNoticeLabel.text = NSLocalizedString(@"No more data", nil);
        }
        else
        {
            sNoticeLabel.text = NSLocalizedString(@"Load more data", nil);
        }
        
    }
    
    return sCell;

}

@end

