//
//  FMStoreController.m
//  AboutSex
//
//  Created by Wen Shane on 13-4-27.
//
//

#import "FMListController.h"
#import "FMInfo.h"
#import "MAConfirmButton.h"
#import "NSDateFormatter+MyDateFormatter.h"
#import "SharedVariables.h"
#import "UIGlossyButton.h"
#import "PointsManager.h"
#import "StoreManagerEx.h"
#import "NSURL+WithChanelID.h"
#import "SharedVariables.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "MobClick.h"
#import "UILabel+VerticalAlign.h"


#define TAG_IMAGEVIEW 101
#define TAG_TITLE_LABEL 102
#define TAG_PROPERTY_LABEL 103
#define TAG_BUY_BUTTON 104

#define FMS_PAGE_SIZE 10

@interface FMListController ()
{
    NSMutableArray* mFMInfos;
    
    NSArray* mDowndoadedFileNames;
    BOOL mHasMoreData;
    NSInteger mPageIndex;
    UIActivityIndicatorView* mPageLoadingIndicator;
    BOOL mIsLoading;
    ENUM_FM_LIST_TYPE mType;


}


@property (nonatomic, retain) NSMutableArray* mFMInfos;
@property (nonatomic, retain) NSArray* mDowndoadedFileNames;
@property (nonatomic, assign) BOOL mHasMoreData;
@property (nonatomic, assign) NSInteger mPageIndex;
@property (nonatomic, retain) UIActivityIndicatorView* mPageLoadingIndicator;
@property (nonatomic, assign) BOOL mIsLoading;
@property (nonatomic, assign) ENUM_FM_LIST_TYPE mType;

@end

@implementation FMListController
@synthesize mFMInfos;
@synthesize mDowndoadedFileNames;
@synthesize mHasMoreData;
@synthesize mPageIndex;
@synthesize mPageLoadingIndicator;
@synthesize mIsLoading;
@synthesize mType;
@synthesize mDelegate;


- (UIImage*) getIconImageForCurrentType
{
    UIImage* sImage = nil;
    switch (self.mType) {
        case ENUM_FM_LIST_TYPE_AFFECTION:
        {
            sImage = [UIImage imageNamed:@"rings32"];
        }
            break;
        case ENUM_FM_LIST_TYPE_SEX:
        {
            sImage = [UIImage imageNamed:@"sex32"];
        }
            break;
        case ENUM_FM_LIST_TYPE_HEALTH:
        {
            sImage = [UIImage imageNamed:@"medicine32"];
        }
            break;
        case ENUM_FM_LIST_TYPE_MUSIC:
        {
             sImage = [UIImage imageNamed:@"music32"];           
        }
            break;
        default:
        {
            sImage = [UIImage imageNamed:@"love"];
        }
            break;
    }
    
    return sImage;
}

- (id) initWithType:(ENUM_FM_LIST_TYPE)aType
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.mType = aType;
        
        self.title = NSLocalizedString(@"FM Store", nil);
        self.title = [NSString stringWithFormat:@"%@(%@)", NSLocalizedString(@"FM Store", nil), [NSDateFormatter standardyyyyMMddFormatedString:[NSDate date]]];
        
        self.mFMInfos = [NSMutableArray array];
//        [[DownloadManager shared] setMDelegate:self];
        [[DownloadManager shared] setMTargetDirPath:[[StoreManagerEx shared] getPathForDocumentsFMItemsDir]];
        [[DownloadManager shared] setMCacheDirPath:[[StoreManagerEx shared] getPathForFMCacheDir]];
    }
    return self;
}

- (void) dealloc
{
    self.mFMInfos = nil;
    self.mDowndoadedFileNames = nil;
    self.mPageLoadingIndicator = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.rowHeight = 75;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    if (!self.mFMInfos
        || self.mFMInfos.count <= 0)
    {        
        UIActivityIndicatorView* sPageLoadingIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
        [sPageLoadingIndicator setCenter:CGPointMake(self.tableView.bounds.size.width/2, self.tableView.bounds.size.height/2-150)];
        sPageLoadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        
        [self.tableView addSubview: sPageLoadingIndicator];
        
        self.mPageLoadingIndicator = sPageLoadingIndicator;
        [sPageLoadingIndicator release];
        
        [self.mPageLoadingIndicator startAnimating];
    }

    self.mIsLoading = NO;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refresh];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self notifyUpdateDate];
}

- (void) notifyUpdateDate
{
    if (!self.mIsLoading)
    {
        if (self.mFMInfos.count > 0)
        {
            NSDate* sDate = ((FMInfo*)[self.mFMInfos objectAtIndex:0]).mDate;
            [self.mDelegate notifyUpdateDate:sDate];
        }
        else
        {
            [self.mDelegate notifyUpdateDate:nil];
        }
    }
}

- (void) refresh
{
    self.mDowndoadedFileNames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[[StoreManagerEx shared] getPathForDocumentsFMItemsDir] error:nil];
    if ( (!self.mFMInfos || self.mFMInfos.count <=0)
        && !self.mIsLoading)
    {
        self.mPageIndex = 0;
        [self loadData];
    }
    
    [self.tableView reloadData];
}


- (void) loadData
{
    self.mIsLoading = YES;
    NSString* sURLStr = URL_GET_FMS(self.mPageIndex++, FMS_PAGE_SIZE, self.mType);
    
    NSURL *url = [NSURL MyURLWithString: sURLStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:10];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [self loadSucessfully:JSON];
    } failure:^( NSURLRequest *request , NSHTTPURLResponse *response , NSError *error , id JSON ){
        [self loadFailed:error];
    }];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"text/html", nil]];
    [operation start];
}

- (void) loadSucessfully:(id)aJSONObj
{
    if (![aJSONObj isKindOfClass:[NSDictionary class]])
    {
        return;
    }
    
    self.mHasMoreData = ((NSNumber*)[aJSONObj objectForKey:@"hasMore"]).boolValue;
    for (NSDictionary* sItemDict in (NSArray*)([aJSONObj objectForKey:@"items"]))
    {
        FMInfo* sFMInfo = [[FMInfo alloc] init];
        sFMInfo.mID = ((NSNumber*)[sItemDict objectForKey:@"id"]).integerValue;
        sFMInfo.mName = [sItemDict objectForKey:@"name"];
        sFMInfo.mIconURLStr = [sItemDict objectForKey:@"iconURL"];
        sFMInfo.mDuration = ((NSNumber*)[sItemDict objectForKey:@"duration"]).integerValue;
        sFMInfo.mSize = ((NSNumber*)[sItemDict objectForKey:@"size"]).doubleValue;
        sFMInfo.mPrice = ((NSNumber*)[sItemDict objectForKey:@"price"]).integerValue;
        sFMInfo.mDownloadURLStr = [sItemDict objectForKey:@"downloadURL"];
        sFMInfo.mDate = [NSDate dateWithTimeIntervalSince1970:[(NSString*) [sItemDict objectForKey:@"time"] integerValue]];
        [self.mFMInfos addObject:sFMInfo];
        
        [sFMInfo release];
    }
    
    //
    if (self.mPageLoadingIndicator)
    {
        [self.mPageLoadingIndicator stopAnimating];
    }
    
    if (self.tableView)
    {
        [self.tableView reloadData];
    }
  
    self.mIsLoading = NO;
    if (self.mFMInfos.count <= 0)
    {
        self.tableView.tableHeaderView = [self headerViewWithNotice:NSLocalizedString(@"No fms yet", nil)];
    }
    else
    {
        self.tableView.tableHeaderView = nil;
    }
    
    [self notifyUpdateDate];

}

- (void) loadFailed:(NSError*)aError
{
    NSLog(@"comments load failure.");
    if (self.mPageLoadingIndicator)
    {
        [self.mPageLoadingIndicator stopAnimating];
    }
    self.mIsLoading = NO;
    
    if (self.mFMInfos.count <= 0)
    {
        self.tableView.tableHeaderView = [self headerViewWithNotice:NSLocalizedString(@"No fms yet", nil)];
    }

    [self notifyUpdateDate];
    return;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) getIndexOfFMInfoByID:(NSInteger)aID
{
    for (int i=0; i < self.mFMInfos.count; i++)
    {
        FMInfo* sFMInfo = [self.mFMInfos objectAtIndex:i];
        if (sFMInfo.mID == aID)
        {
            return i;
        }
    }
    return -1;
}

- (void) buy:(UIButton*)aBuyButton
{
    UITableViewCell* sClickedCell = (UITableViewCell *)[[aBuyButton superview] superview];
    NSIndexPath* sIndexPath = [self.tableView indexPathForCell:sClickedCell];
    
    NSInteger sRow = sIndexPath.row;
    if (sRow >= self.mFMInfos.count)
    {
        return;
    }
    
    FMInfo* sFMInfo = [self.mFMInfos objectAtIndex:sRow];
    
    if ([self isFMDownloaded:sFMInfo]
        || sFMInfo.mISDownloading)
    {
        return;
    }
    
    NSDictionary *sDict = @{
                           @"name" : sFMInfo.mName,
                           @"price" : [NSString stringWithFormat:@"%d", sFMInfo.mPrice],
                           };
    [MobClick event:@"UEID_BUY_FM" attributes: sDict];
    
    //free
    if (sFMInfo.mPrice <= 0)
    {
        [self startDownloadFM:sFMInfo];
    }
    else
    {
        NSInteger sOveallPoints = [[PointsManager shared] getPoints];
        if (sFMInfo.mPrice <= sOveallPoints)
        {
            [self startDownloadFM:sFMInfo];
        }
        else
        {
            UIAlertView* sAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Notice", nil) message:NSLocalizedString(@"Your points is not enough, please earn more via downloading and installing those interesting apps", nil)  delegate:self cancelButtonTitle:NSLocalizedString(@"Later", nil) otherButtonTitles:NSLocalizedString(@"Acquire now", nil), nil];
            [sAlertView show];
            [sAlertView release];
        }
    }
    
    
    return;
}

- (BOOL) startDownloadFM:(FMInfo*)aFMInfo
{
//    [[DownloadManager shared] startTaskForURL:aFMInfo.mDownloadURLStr withTaskID:aFMInfo.mID];
    aFMInfo.mISDownloading = YES;
    [[DownloadManager shared] startTaskForURL:aFMInfo.mDownloadURLStr withFileName:aFMInfo.mName withProgressDelegate:nil withTaskID:aFMInfo.mID withDelegate:self];
    [self refresh];
    
    return YES;
}

#pragma mark -
#pragma mark delegate for update checking's alertview
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    BOOL sIsGet = NO;
    if (1 == buttonIndex)
    {
        [[PointsManager shared] showWallFromViewController:self];
        sIsGet = YES;
    }
    
    NSDictionary* sDict = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithBool:sIsGet], @"IsGet", nil];
    [MobClick event:@"UEID_BUY_FM_GET_POINTS" attributes: sDict];

}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.mHasMoreData
        && self.mFMInfos.count > 0)
    {
        return self.mFMInfos.count+1;
    }
    else
    {
        return self.mFMInfos.count;     
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= self.mFMInfos.count)
    {
        static NSString* sCellIdentifier = @"more_cell";
        UITableViewCell* sCell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
        if (!sCell)
        {
            sCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sCellIdentifier] autorelease];
            
            UIActivityIndicatorView* sLoadingMoreIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            sLoadingMoreIndicator.frame = CGRectMake(100, 0, 40, 40);
            sLoadingMoreIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
            [sLoadingMoreIndicator startAnimating];
            [sCell.contentView addSubview: sLoadingMoreIndicator];
            [sLoadingMoreIndicator release];
            
            UILabel* sLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 0, 80, 40)];
            sLabel.text = NSLocalizedString(@"Loading...", nil);
            sLabel.textColor = [UIColor grayColor];
            [sCell.contentView addSubview:sLabel];
            [sLabel release];
        }
        return sCell;
    }
    else
    {
        static NSString *CellIdentifier = @"Cell";
        
        UIImageView* sIconImageView = nil;
        UILabel* sTitleLabel = nil;
        UILabel* sPropertyLabel = nil;
        UIGlossyButton* sBuyButton = nil;
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell)
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            sIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 32, 32)];
            sIconImageView.image = [self getIconImageForCurrentType];
            sIconImageView.tag = TAG_IMAGEVIEW;
            [cell.contentView addSubview:sIconImageView];
            
            [sIconImageView release];
            
            sTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 7, 190, 40)];
            sTitleLabel.font = [UIFont systemFontOfSize:15];
            sTitleLabel.numberOfLines = 2;
            sTitleLabel.tag = TAG_TITLE_LABEL;
            sTitleLabel.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:sTitleLabel];
            [sTitleLabel release];
            
            sPropertyLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 50, 190, 15)];
            sPropertyLabel.textColor = [UIColor lightGrayColor];
            sPropertyLabel.font = [UIFont systemFontOfSize:11];
            sPropertyLabel.tag = TAG_PROPERTY_LABEL;
            sPropertyLabel.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:sPropertyLabel];
            [sPropertyLabel release];
            
            // App Store like buttons
            sBuyButton = [[[UIGlossyButton alloc] initWithFrame:CGRectMake(260, 27, 50, 25)] autorelease];
            [sBuyButton setNavigationButtonWithColor:[UIColor doneButtonColor]];
            sBuyButton.tag = TAG_BUY_BUTTON;
            [sBuyButton addTarget:self action:@selector(buy:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:sBuyButton];
            
            UIView* sSeperatorLineView = [[UIView alloc] initWithFrame:CGRectMake(1, 74, tableView.bounds.size.width-2, 1)];
            sSeperatorLineView.backgroundColor = RGBA_COLOR(222, 222, 222, 1);
            sSeperatorLineView.layer.shadowColor = [RGBA_COLOR(224, 224, 224, 1) CGColor];
            sSeperatorLineView.layer.shadowOffset = CGSizeMake(0, -10);
            sSeperatorLineView.layer.shadowOpacity = .5f;
            sSeperatorLineView.layer.shadowRadius = 2.0f;
            sSeperatorLineView.clipsToBounds = NO;
            sSeperatorLineView.layer.cornerRadius = 2;
            
            [cell.contentView addSubview:sSeperatorLineView];
            [sSeperatorLineView release];
        }
        else
        {
            sIconImageView = (UIImageView*)[cell.contentView viewWithTag:TAG_IMAGEVIEW];
            sTitleLabel = (UILabel*)[cell.contentView viewWithTag:TAG_TITLE_LABEL];
            sPropertyLabel = (UILabel*)[cell.contentView viewWithTag:TAG_PROPERTY_LABEL];
            sBuyButton = (UIGlossyButton*)[cell.contentView viewWithTag:TAG_BUY_BUTTON];
        }
        
        FMInfo* sFMInfo = [self.mFMInfos objectAtIndex:indexPath.row];
        
        NSString* sTitle = sFMInfo.mName;
        if (sTitle.length>4
            && [sTitle hasSuffix:@".mp3"])
        {
            sTitle = [sTitle substringToIndex:sTitle.length-@".mp3".length];
        }
        sTitleLabel.text = [NSString stringWithFormat:@"%d. %@", indexPath.row+1, sTitle];
        [sTitleLabel alignTop];
        
        sPropertyLabel.text = [NSString stringWithFormat:@"%@: %@\t\t\t\t\t\t%@: %.1f MB", NSLocalizedString(@"Duration", nil), [NSDateFormatter mmssFromSeconds:sFMInfo.mDuration], NSLocalizedString(@"Size", nil), sFMInfo.mSize];
        
        
        
//        [sIconImageView setImage:[self getIconImageForCurrentType]];
        [sIconImageView setImageWithURL:[NSURL URLWithString:sFMInfo.mIconURLStr] placeholderImage:[self getIconImageForCurrentType]];
        
        //if is downloaded
        if ([self isFMDownloaded:sFMInfo])
        {
            [sBuyButton setTitle:NSLocalizedString(@"Downloaded", nil) forState:UIControlStateNormal];
            [sBuyButton setNavigationButtonWithColor:[UIColor darkGrayColor]];
            sBuyButton.enabled = NO;
        }
        else if (sFMInfo.mISDownloading)
        {
            [sBuyButton setTitle:NSLocalizedString(@"Downloading", nil) forState:UIControlStateNormal];
            [sBuyButton setNavigationButtonWithColor: COLOR_PROGRESS];
            
            sBuyButton.enabled = YES;
        }
        else
        {
            [sBuyButton setNavigationButtonWithColor:MAIN_BGCOLOR_SHALLOW];
            sBuyButton.enabled = YES;
            
            if (sFMInfo.mPrice <= 0)
            {
                [sBuyButton setTitle:NSLocalizedString(@"Free", nil) forState:UIControlStateNormal];
            }
            else
            {
                [sBuyButton setTitle:[NSString stringWithFormat:@"%d %@", sFMInfo.mPrice, NSLocalizedString(@"Units", nil)] forState:UIControlStateNormal];
            }
        }
        
        
        return cell;

    }
}

#pragma mark - tableview delegate
- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger sRow = indexPath.row;
    if (self.mHasMoreData
        && sRow == self.mFMInfos.count
        && !self.mIsLoading)
    {
        [self loadData];
    }
}


- (UIView*) headerViewWithNotice:(NSString*)sNotice
{
    UILabel* sNoDataNoticeLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 50)] autorelease];
    sNoDataNoticeLabel.textAlignment = UITextAlignmentCenter;
    sNoDataNoticeLabel.textColor = [UIColor grayColor];
    sNoDataNoticeLabel.text = sNotice;
    sNoDataNoticeLabel.font = [UIFont systemFontOfSize:15];
    
    return sNoDataNoticeLabel;
}

- (BOOL) isFMDownloaded:(FMInfo*)aFMInfo
{
    for (NSString* sDownloadFileName in self.mDowndoadedFileNames)
    {
        if ([aFMInfo.mName isEqualToString:sDownloadFileName])
        {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - DownloadManagerDelegate protocol
- (void) downloadDone:(NSInteger)aTaskID
{
    [self downloadDoneImpl:aTaskID];
    NSInteger sID = [self getIndexOfFMInfoByID:aTaskID];
    if (-1 != sID)
    {
        FMInfo* sFMInfo = [self.mFMInfos objectAtIndex:sID];
        [[PointsManager shared] consume:sFMInfo.mPrice];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_NEW_FM_DOWNLOADED object:self];
    }
    
    NSDictionary *sDict = @{
                            @"success" : @"1",
                            };
    [MobClick event:@"UEID_BUY_FM_DONE" attributes: sDict];

}

- (void) downloadFailed:(NSInteger)aTaskID
{
    [self downloadDoneImpl:aTaskID];
    
    UIAlertView* sAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Notice", nil) message:NSLocalizedString(@"Download error", nil)  delegate:nil cancelButtonTitle:NSLocalizedString(@"Good", nil) otherButtonTitles:nil];
    [sAlertView show];
    [sAlertView release];
    
    NSDictionary *sDict = @{
                            @"success" : @"0",
                            };
    [MobClick event:@"UEID_BUY_FM_DONE" attributes: sDict];

}

- (void) downloadDoneImpl:(NSInteger)aFMID
{
    NSInteger sID = [self getIndexOfFMInfoByID:aFMID];
    if (-1 != sID)
    {
        FMInfo* sFMInfo = [self.mFMInfos objectAtIndex:sID];
        sFMInfo.mISDownloading = NO;
        [self refresh];
    }
}


@end
