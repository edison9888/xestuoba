//
//  RecommandedAppsViewController.m
//  AboutSex
//
//  Created by Wen Shane on 13-1-11.
//
//

#import "RecommandedAppsController.h"
#import "MobClick.h"
#import "SharedVariables.h"
#import "SharedStates.h"
#import "CustomCellBackgroundView.h"
#import "AppInfo.h"
#import "UIImageView+WebCache.h"

#define DEFUALT_RECOMMAND_APP_NAME  @"减肥记记"
#define DEFAULT_RECOMMAND_APP_URL   @"https://itunes.apple.com/cn/app/jian-fei-ji-ji/id583710058"


@interface RecommandedAppsController ()
{
    UITableView* mTableView;
    UIActivityIndicatorView* mPageLoadingIndicator;


    NSString* mRecommandedAppName;
    NSString* mRecommandedAppUrl;
    MyURLConnection* mURLConnection;
    
    NSMutableArray* mAppList;
    
}
@property (nonatomic, retain) UITableView* mTableView;
@property (nonatomic, retain) UIActivityIndicatorView* mPageLoadingIndicator;

@property (nonatomic, retain) NSString* mRecommandedAppName;
@property (nonatomic, retain) NSString* mRecommandedAppUrl;

@property (nonatomic, retain) MyURLConnection* mURLConnection;

@property (nonatomic, retain) NSMutableArray* mAppList;


@end

@implementation RecommandedAppsController
@synthesize mTableView;
@synthesize mPageLoadingIndicator;
@synthesize mRecommandedAppName;
@synthesize mRecommandedAppUrl;
@synthesize mURLConnection;

@synthesize mAppList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setRecommandedAppInfo];
//        [self configTableview];
    }
    return self;
}

- (void) dealloc
{
    self.mTableView = nil;
    self.mPageLoadingIndicator = nil;
    self.mRecommandedAppName = nil;
    self.mRecommandedAppUrl = nil;
    self.mURLConnection = nil;

    self.mAppList = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.mURLConnection)
    {
        [self.mURLConnection stop];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadView
{
    //    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    //
    //    UIView* sView = [[UIView alloc] initWithFrame:applicationFrame];
    //    self.view = sView;
    //    [sView release];
    
    [super loadView];
    
    
    
    CGFloat sPosX = 0;
    CGFloat sPosY = 0;
    
    //tableview
    UITableView* sTableView = [[UITableView alloc]initWithFrame:CGRectMake(sPosX, sPosY, self.mMainView.bounds.size.width, self.mMainView.bounds.size.height-sPosY) style:UITableViewStyleGrouped];
    sTableView.dataSource = self;
    sTableView.delegate = self;
    [sTableView setBackgroundView:nil];
    [sTableView setBackgroundColor:[UIColor clearColor]];
    sTableView.rowHeight = 65;
    //    sTableView.scrollEnabled = FALSE;
    
    [self.mMainView addSubview:sTableView];
    
    self.mTableView = sTableView;
    [sTableView release];
    
    
    UIActivityIndicatorView* sPageLoadingIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    [sPageLoadingIndicator setCenter:self.mMainView.center];
    sPageLoadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    
    [self.mMainView addSubview: sPageLoadingIndicator];
    self.mPageLoadingIndicator = sPageLoadingIndicator;
    [sPageLoadingIndicator release];
    
    [self.mPageLoadingIndicator startAnimating];
    
}

- (void) setRecommandedAppInfo;
{
    NSData* sAppsCacheData = [[SharedStates getInstance] getRecommandedAppCacheData];
    if (sAppsCacheData && sAppsCacheData.length>1)
    {
        NSTimer* sTimer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(parseCachedAppData) userInfo:nil repeats:NO];
        [sTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
    else
    {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        NSString* sURLStr = [NSString stringWithFormat:@"%@?channed_id=%@", GET_RECOMMANDED_APP_INFO, CHANNEL_ID];
        
        NSMutableURLRequest* sURLRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:sURLStr]];
        
        [sURLRequest setHTTPMethod:@"GET"];
        
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
    
    
    return;
}

- (void) parseCachedAppData
{
    NSData* sAppsCacheData = [[SharedStates getInstance] getRecommandedAppCacheData];
    [self parseAppsJSONData:sAppsCacheData];
    [self.mPageLoadingIndicator stopAnimating];
    [self.mTableView reloadData];
}

- (void) showDataLoadedError
{
    UILabel* sLabel = [[UILabel alloc] initWithFrame:self.mTableView.frame];
    sLabel.numberOfLines = 0;
    sLabel.text = NSLocalizedString(@"fail to load the latest data, please retry later.", nil);
    sLabel.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:sLabel];
    [sLabel release];
}

#pragma mark -
#pragma mark delegate methods for MyURLConnectionDelegate

- (void) failWithConnectionError: (NSError*)aErr
{
    [self showDataLoadedError];
    return;
}

- (void) failWithServerError: (NSInteger)aStatusCode
{
    [self showDataLoadedError];
    return;
}

- (void) succeed: (NSMutableData*)aData
{
    [self.mPageLoadingIndicator stopAnimating];
    
    if ([self parseAppsJSONData:aData])
    {
        [self.mTableView reloadData];
        [[SharedStates getInstance] cacheRecommandedAppData:aData];
    }

    
    return;
}

- (BOOL) parseAppsJSONData:(NSData*) aData
{
    NSError* sErr = nil;
    
    id sJSONObject =  [JSONWrapper JSONObjectWithData: aData
                                              options:NSJSONReadingMutableContainers
                                                error:&sErr];
    if ([sJSONObject isKindOfClass:[NSArray class]])
    {
        
        NSMutableArray* sAppList = [NSMutableArray arrayWithCapacity:((NSArray *)sJSONObject).count];
        for (NSDictionary* sItemDict in (NSArray *)sJSONObject)
        {
            AppInfo* sAppInfo = [[AppInfo alloc] init];
            sAppInfo.mName = (NSString*)[sItemDict objectForKey:@"app_name"];
            sAppInfo.mURLStr = (NSString*)[sItemDict objectForKey:@"app_url"];
            sAppInfo.mDetail = (NSString*)[sItemDict objectForKey:@"app_detail"];
            sAppInfo.mIconURL = (NSString*)[sItemDict objectForKey:@"app_icon_url"];
            sAppInfo.mProvider = (NSString*)[sItemDict objectForKey:@"app_icon_provider"];
            
            [sAppList addObject:sAppInfo];
            [sAppInfo release];
        }
        self.mAppList = sAppList;
        return YES;
    }
    return NO;
}


#pragma mark -
#pragma mark methods for datasource interface

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mAppList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell* sCell = nil;
    sCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!sCell)
    {
        sCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"] autorelease];
        sCell.backgroundColor = [UIColor clearColor];
        
        CustomCellBackgroundView* sBGView = [CustomCellBackgroundView backgroundCellViewWithFrame:sCell.frame Row:[indexPath row] totalRow:[tableView numberOfRowsInSection:[indexPath section]] borderColor:SELECTED_CELL_COLOR fillColor:SELECTED_CELL_COLOR tableViewStyle:tableView.style];
        sCell.selectedBackgroundView = sBGView;
        sCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        sCell.detailTextLabel.numberOfLines = 0;
    }
    
    NSInteger sRow = [indexPath row];
    AppInfo* sAppInfo = [self.mAppList objectAtIndex:sRow];
    
    sCell.textLabel.text = sAppInfo.mName;
    sCell.detailTextLabel.text = sAppInfo.mDetail;
//    [sCell.imageView setImage: [self getImageForURLStr:sAppInfo.mIconURL]];

    [sCell.imageView setImageWithURL:[NSURL URLWithString:sAppInfo.mIconURL]
                   placeholderImage:[UIImage imageNamed:@"app40.png"]];
    
   return sCell;
}

#pragma mark -
#pragma mark methods for delegate interface

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self presentRecommandedApp:[indexPath row]];
    return;
}


- (void) presentRecommandedApp:(NSInteger)aIndex
{
    AppInfo* sAppInfo = [self.mAppList objectAtIndex:aIndex];

    NSDictionary* sDict = [NSDictionary dictionaryWithObjectsAndKeys:
                           sAppInfo.mName, @"app_name", nil];
    [MobClick event:@"UEID_RECOMMAND_APP_HIT" attributes: sDict];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: sAppInfo.mURLStr]];
}

- (UIImage*) getImageForURLStr:(NSString*)aURLStr
{
    
    UIImage* sImage = [[SharedStates getInstance] getCachedObjectForKey:aURLStr];

    if (sImage)
    {
        return sImage;
    }
    else
    {
        NSURL* sURL = [NSURL URLWithString:aURLStr];
        NSData* sData = [NSData dataWithContentsOfURL:sURL];
                
        sImage = [[[UIImage alloc] initWithData:sData] autorelease];
        
//        if ([UIScreen mainScreen].scale == 1.0)
        {
            sImage = [UIImage imageWithCGImage: sImage.CGImage scale:2.0 orientation:UIImageOrientationUp];
        }
        [[SharedStates getInstance] cacheObject:sImage forKey:aURLStr];
        
        return sImage;

    }
    
    
}

@end
