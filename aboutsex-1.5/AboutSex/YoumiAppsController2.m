////
////  NoneRewardedWallViewController.m
////  YouMiSDK_Sample_Wall
////
////  Created by  on 12-1-5.
////  Copyright (c) 2012年 YouMi Mobile Co. Ltd. All rights reserved.
////
//
//#import "YoumiAppsController2.h"
//#import "CustomCellBackgroundView.h"
//#import "UIImageView+WebCache.h"
//#import "SharedVariables.h"
//#import <QuartzCore/QuartzCore.h>
//#import "ATMHud.h"
//#import "SharedStates.h"
//#import "NSDate-Utilities.h"
//#import "MobClick.h"
//
//#define TAG_INDEX_LABEL         989
//#define TAG_ICON_IMAGE_VIEW    990
//#define TAG_NAME_LABEL          991
//#define TAG_PRICE_LABEL         992
//#define TAG_DESC_LABEL          993
//
//#define NUM_OF_APPS_EVERY_FETCH  10
//
//@implementation YoumiAppsController2
//@synthesize mTableView;
//@synthesize mPageLoadingIndicator;
//@synthesize mHasRequestedSuccessfully;
//
//- (id)init{
//    self = [super init];
//    if (self) {
//        openApps = [[NSMutableArray alloc] init];
//        //
//        //disable location listening.
//        [YouMiWall setShouldGetLocation:NO];
//        
//        wall = [[YouMiWall alloc] initWithAppID:SECRET_ID_YOUMI withAppSecret:SECRET_KEY_YOUMI];        
//        wall.delegate = self;
//        self.mHasRequestedSuccessfully = NO;
//    }
//    return self;
//}
//
//- (void)dealloc {
//    [wall release];
//    [openApps release];
//    
//    self.mTableView = nil;
//    self.mPageLoadingIndicator = nil;
//    
//    [super dealloc];
//}
//
//- (void)didReceiveMemoryWarning {
//    // Releases the view if it doesn't have a superview.
//    [super didReceiveMemoryWarning];
//    
//    // Release any cached data, images, etc that aren't in use.
//}
//
//#pragma mark - View lifecycle
//
//- (void) loadView
//{
//    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
//    UIView* sView = [[UIView alloc] initWithFrame:applicationFrame];
//    
//    self.view = sView;
//    [sView release];
//    
//    CGFloat sPosX = 0;
//    CGFloat sPosY = 0;
//    
//    //tableview
//    UITableView* sTableView = [[UITableView alloc]initWithFrame:CGRectMake(sPosX, sPosY, self.view.bounds.size.width, self.view.bounds.size.height-sPosY) style:UITableViewStylePlain];
//    sTableView.dataSource = self;
//    sTableView.delegate = self;
//    sTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//    [sTableView setBackgroundView:nil];
//    [sTableView setBackgroundColor:[UIColor clearColor]];
//    sTableView.rowHeight = 130;
//    sTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    
//    [self.view addSubview:sTableView];
//    
//    self.mTableView = sTableView;
//    [sTableView release];
//    
//    
//    UIActivityIndicatorView* sPageLoadingIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
//    [sPageLoadingIndicator setCenter:self.view.center];
//    sPageLoadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
//    
//    [self.view addSubview: sPageLoadingIndicator];
//    self.mPageLoadingIndicator = sPageLoadingIndicator;
//    [sPageLoadingIndicator release];
//    
//    [self.mPageLoadingIndicator startAnimating];
//    
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//        
//    // Uncomment the following line to preserve selection between presentations.
////    self.mTableView.clearsSelectionOnViewWillAppear = NO;
//    
//    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//}
//
//- (void)viewDidUnload {
//    [super viewDidUnload];
//    // Release any retained subviews of the main view.
//    // e.g. self.myOutlet = nil;
//}
//
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//}
//
//- (NSString*) getCacheFilePath
//{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    
//    NSString* sCacheFilePath = [documentsDirectory stringByAppendingPathComponent:@"recommand_apps_data.data"];
//    return sCacheFilePath;
//}
//
//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    
//    // 请求开源数据
//    [openApps removeAllObjects];
//    [self.mTableView reloadData];
//    
//    NSString* sCacheFilePath = [self getCacheFilePath];
//    if ([[NSFileManager defaultManager] fileExistsAtPath:sCacheFilePath])
//    {
//        NSDictionary *fileAttributes= [[NSFileManager defaultManager] attributesOfItemAtPath:sCacheFilePath error:nil];
//        NSDate* sModifiedDate = [fileAttributes objectForKey:NSFileModificationDate];
//        if (sModifiedDate
//            && [sModifiedDate isToday])
//        {
//            NSArray* sApps = [NSKeyedUnarchiver unarchiveObjectWithFile:[self getCacheFilePath]];
//            if (sApps
//                && sApps.count > 0)
//            {
//                [self didReceiveOffersAppData:nil offersApp:sApps];
//                self.mHasRequestedSuccessfully = NO;
//                return;
//            }
//        }
//        
//    }
//    
//    //if there is no valid cache file for today, fetch it from youmi server.
//    [wall requestOffersAppData:NO pageCount:NUM_OF_APPS_EVERY_FETCH];
////    
////    // 请求Web源
////    self.navigationItem.rightBarButtonItem = nil;
////    
////    [wall requestOffers:NO];
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//}
//
//- (void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
//}
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
//    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}
//
//
//- (void) fetchMoreApps
//{
////    [openApps removeAllObjects];    
////    [self.mTableView reloadData];
//   
////    if ([[SharedStates getInstance] decreaseLuckOfToday])
//    {
//        self.navigationItem.rightBarButtonItem.title = [self getTitleForLuckButton];
//        
//        if (!self.mHasRequestedSuccessfully)
//        {
//            [wall requestOffersAppData:NO pageCount:NUM_OF_APPS_EVERY_FETCH];
//        }
//        else
//        {
//            [wall requestMoreOffersAppData]; 
//        }
//
//    }
////    else
////    {
////        [self showLuckOutNotice];
////        [MobClick event:@"UEID_APPS_CHANGE_OUT"];
////    }
//    [MobClick event:@"UEID_APPS_CHANGE"];
//
//}
//
//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return [openApps count];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    UITableViewCell* sCell = nil;
//    sCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    
//    UILabel* sIndexLabel = nil;
//    UIImageView* sIconView = nil;
//    UILabel* sNameLabel = nil;
//    UILabel* sDescLabel = nil;
//    UILabel* sPriceLabel = nil;
//    
//    if (!sCell)
//    {
//        sCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"] autorelease];
//        sCell.backgroundColor = [UIColor clearColor];
//        
//        CustomCellBackgroundView* sBGView = [CustomCellBackgroundView backgroundCellViewWithFrame:sCell.frame Row:[indexPath row] totalRow:[tableView numberOfRowsInSection:[indexPath section]] borderColor:SELECTED_CELL_COLOR fillColor:SELECTED_CELL_COLOR tableViewStyle:tableView.style];
//        sCell.selectedBackgroundView = sBGView;
//        
////        sIndexLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 30, 50)];
////        sIndexLabel.font = [UIFont italicSystemFontOfSize:16];
////        sIndexLabel.backgroundColor = [UIColor clearColor];
////        sIndexLabel.textColor = [UIColor lightGrayColor];
////        sIndexLabel.tag = TAG_INDEX_LABEL;
////        [sCell.contentView addSubview:sIndexLabel];
////        [sIndexLabel release];
//
//        sIconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 25, 60, 60)];
//        sIconView.tag = TAG_ICON_IMAGE_VIEW;
//        sIconView.layer.cornerRadius = 5.0f;
//        sIconView.layer.masksToBounds = YES;
//        [sCell.contentView addSubview:sIconView];
//        [sIconView release];
//        
//        sNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 10, 170, 20)];
//        sNameLabel.backgroundColor = [UIColor clearColor];
//        sNameLabel.tag = TAG_NAME_LABEL;
//        [sCell.contentView addSubview:sNameLabel];
//        [sNameLabel release];
//        
//        sPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(260, 10, 50, 20)];
//        sPriceLabel.font = [UIFont systemFontOfSize:13];
//        sPriceLabel.textAlignment = UITextAlignmentRight;
//        sPriceLabel.textColor = MAIN_BGCOLOR;
//        sPriceLabel.tag = TAG_PRICE_LABEL;
//        sPriceLabel.backgroundColor = [UIColor clearColor];
//        [sCell.contentView addSubview:sPriceLabel];
//        [sPriceLabel release];
//        
//        sDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 35, 225, tableView.rowHeight-35-5)];
//        sDescLabel.numberOfLines = 5;
//        sDescLabel.font = [UIFont systemFontOfSize:13];
//        sDescLabel.textColor = [UIColor grayColor];
//        sDescLabel.lineBreakMode = UILineBreakModeTailTruncation;
//        sDescLabel.backgroundColor = [UIColor clearColor];
//        sDescLabel.tag = TAG_DESC_LABEL;
//        [sCell.contentView addSubview:sDescLabel];
//        [sDescLabel release];
//        
//        UIView* sSeperatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, tableView.rowHeight-1, tableView.bounds.size.width, 1)];
//        sSeperatorLineView.backgroundColor = RGBA_COLOR(222, 222, 222, 1);
//        sSeperatorLineView.layer.shadowColor = [RGBA_COLOR(224, 224, 224, 1) CGColor];
//        sSeperatorLineView.layer.shadowOffset = CGSizeMake(0, -10);
//        sSeperatorLineView.layer.shadowOpacity = .5f;
//        sSeperatorLineView.layer.shadowRadius = 2.0f;
//        sSeperatorLineView.clipsToBounds = NO;
//        sSeperatorLineView.layer.cornerRadius = 5;
//        
//        [sCell.contentView addSubview:sSeperatorLineView];
//        [sSeperatorLineView release];
//        
//    }
//    else
//    {
//        sIndexLabel = (UILabel*)[sCell.contentView viewWithTag:TAG_INDEX_LABEL];
//        sIconView = (UIImageView*)[sCell.contentView viewWithTag:TAG_ICON_IMAGE_VIEW];
//        sNameLabel = (UILabel*)[sCell.contentView viewWithTag:TAG_NAME_LABEL];
//        sPriceLabel = (UILabel*)[sCell.contentView viewWithTag:TAG_PRICE_LABEL];
//        sDescLabel = (UILabel*)[sCell.contentView viewWithTag:TAG_DESC_LABEL];
//    }
//    
//    NSInteger sRow = [indexPath row];
//    YouMiWallAppModel *sAppInfo = [openApps objectAtIndex:sRow];
//    
//    
//    sIndexLabel.text = [NSString stringWithFormat:@"%d", sRow+1];
//    [sIconView setImageWithURL:[NSURL URLWithString:sAppInfo.smallIconURL]
//                    placeholderImage:[UIImage imageNamed:@"app40.png"]];
//    sNameLabel.text = sAppInfo.name;
//    
//    if (!sAppInfo.price
//        || sAppInfo.price.length == 0)
//    {
//        sPriceLabel.text = NSLocalizedString(@"Free", nil);
//    }
//    else
//    {
//        sPriceLabel.text = sAppInfo.price;
//    }
//    sDescLabel.text = sAppInfo.desc;
//
//    return sCell;
//
//}
//
//#pragma mark - Table view delegate
//
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    cell.imageView.layer.cornerRadius = 5;
//    cell.imageView.frame = CGRectMake(0, 0, 40, 40);
//
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    // deselect cell
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    
//    // 
//    if (indexPath.row >= [openApps count]) return;
//    
//    YouMiWallAppModel *model = [openApps objectAtIndex:indexPath.row];
//    [wall userInstallOffersApp:model];
//    
//    //
//    NSDictionary* sDict = [NSDictionary dictionaryWithObject:model.name forKey:@"app"];
//    [MobClick event:@"UEID_APPS_CLICK" attributes: sDict];
//}
//
//- (NSString*) getTitleForLuckButton
//{
//    NSString* sString = [NSString stringWithFormat:@"%@(%d)", NSLocalizedString(@"Good Luck", nil), [[SharedStates getInstance] getLucksOfToday]];
//    return sString;
//}
//
//#pragma mark - YouMiWall delegate
//
//- (void)didReceiveOffersAppData:(YouMiWall *)adWall offersApp:(NSArray *)apps {
//    NSLog(@"--*-1--didReceiveOffersAppData:offersApp:-*---");
//    
//    self.mHasRequestedSuccessfully = YES;
//
//    if (adWall)
//    {
//        [NSKeyedArchiver archiveRootObject: apps toFile:[self getCacheFilePath]];
//        NSDictionary* attr = [ NSDictionary dictionaryWithObjectsAndKeys: [NSDate date], NSFileModificationDate, nil ];
//        [ [ NSFileManager defaultManager ] setAttributes: attr ofItemAtPath: [self getCacheFilePath] error: nil ];
//    }
//    
//    [openApps removeAllObjects];
//    [openApps addObjectsFromArray:apps];
//    
//    [self.mPageLoadingIndicator stopAnimating];
//    [self.mTableView reloadData];
//
//    if (!self.navigationItem.rightBarButtonItem)
//    {
//        UIBarButtonItem *showOffersItem = [[UIBarButtonItem alloc] initWithTitle:[self getTitleForLuckButton] style:UIBarButtonItemStyleBordered target:self action:@selector(fetchMoreApps)];
//        self.navigationItem.rightBarButtonItem = showOffersItem;
//        [showOffersItem release];
//    }
//}
//
//- (void)didFailToReceiveOffersAppData:(YouMiWall *)adWall error:(NSError *)error {
//    NSLog(@"--*-2--didFailToReceiveOffersAppData:error:-*---"); 
//    // do nothing
//    if (openApps.count <= 0)
//    {
//        [self showNotice:NSLocalizedString(@"fail to load the latest data, please retry later.", nil)];
//    }
//    else
//    {
//        [self showLuckBadNotice];
//    }
//}
//
//- (void)didReceiveMoreOffersAppData:(YouMiWall *)adWall offersApp:(NSArray *)apps
//{
//    if (apps
//        && apps.count > 0)
//    {
//        [openApps removeAllObjects];
//        
//        [openApps addObjectsFromArray:apps];
//        [self.mTableView reloadData];
//    }
//    else
//    {
//        [self showLuckBadNotice];
//    }
//}
//
//- (void)didFailToReceiveMoreOffersAppData:(YouMiWall *)adWall error:(NSError *)error
//{
//    [self showLuckBadNotice];
//    return;
//}
//
//- (void) showLuckBadNotice
//{
//    [self showNotice:NSLocalizedString(@"Sorry, You are out of luck.", nil)];
//}
//
//- (void) showLuckOutNotice
//{
//    [self showNotice:NSLocalizedString(@"Sorry, Your luck for today has been used up", nil)];
//}
//
//- (void) showNotice:(NSString*)aNotice
//{
//    ATMHud* sHudForSaveSuccess = [[[ATMHud alloc] initWithDelegate:self] autorelease];
//    [sHudForSaveSuccess setAlpha:0.6];
//    [sHudForSaveSuccess setDisappearScaleFactor:1];
//    [sHudForSaveSuccess setShadowEnabled:YES];
//    [self.view addSubview:sHudForSaveSuccess.view];
//    
//    [sHudForSaveSuccess setCaption:aNotice];
//    [sHudForSaveSuccess show];
//    [sHudForSaveSuccess hideAfter:1.2];
//
//}
//
////- (void)didReceiveOffers:(YouMiWall *)adWall {
////    NSLog(@"--*-3--didReceiveOffers:-*---");
////    
////    UIBarButtonItem *showOffersItem = [[UIBarButtonItem alloc] initWithTitle:@"更多推荐" style:UIBarButtonItemStyleBordered target:self action:@selector(showOffersAction:)];
////    self.navigationItem.rightBarButtonItem = showOffersItem;
////    [showOffersItem release];
////}
////
////- (void)didFailToReceiveOffers:(YouMiWall *)adWall error:(NSError *)error {
////    NSLog(@"--*-4--didFailToReceiveOffers:error:-*---");
////    // do nothing
////}
//
//
//@end
