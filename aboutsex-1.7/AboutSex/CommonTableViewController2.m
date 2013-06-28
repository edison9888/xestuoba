//
//  CommonTableViewController.m
//  AboutSex
//
//  Created by Shane Wen on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CommonTableViewController2.h"
#import "ContentViewController2.h"
#import "TaggedButton.h"
#import "MobClick.h"
#import "UserConfiger.h"

@interface CommonTableViewController2 ()
{
    UITableView* mTableView;
}
@end

@implementation CommonTableViewController2

@synthesize mTableView;
@synthesize mHasAppearedBefore;
@synthesize mDelegate;

- (id) initWithTitle:(NSString*)aTitle
{
    self = [super init];
    if (self)
    {   
        if (aTitle)
        {
            self.navigationItem.title = aTitle;
            self.mHasAppearedBefore = NO;
        } 
        
//        [self configTableView];
    }
    return self;
}

- (void) dealloc
{    
    self.mTableView = nil;
    [super dealloc];
}

- (void) loadView
{
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    
    UIView* sView = [[UIView alloc] initWithFrame:applicationFrame];
    sView.backgroundColor = [UIColor whiteColor];
    self.view = sView;
    [sView release];
    
    CGFloat sHeightOfPossilbeNavBarAndTabBar = 0;
    
    UITableView* sTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-sHeightOfPossilbeNavBarAndTabBar)];
    sTableView.autoresizesSubviews = YES;
    sTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview:sTableView];
    
    self.mTableView = sTableView;
    [sTableView release];
    
    [self configTableView];


//    self.view.backgroundColor = [UIColor clearColor];
//    sTableView.backgroundColor = [UIColor blueColor];
//    self.mMainView.backgroundColor = [UIColor greenColor];
    
}

- (void) configTableView
{
    self.mTableView.dataSource = self;
    self.mTableView.delegate = self;
    [self.mTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    self.mTableView.scrollEnabled = YES;
    self.mTableView.allowsSelection = YES;
    self.mTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;

//    self.tableView.allowsMultipleSelection = NO;
    self.mTableView.backgroundColor = [UIColor clearColor];

//    //test

    return;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshTableView];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (!(self.mHasAppearedBefore))
    {
        self.mHasAppearedBefore = YES;        
    }
}

- (void) refreshTableView
{
    [self loadData];
    [self.mTableView reloadData];
}

- (BOOL) appearFirstTime
{
    return (!(self.mHasAppearedBefore));
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.mTableView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) markItemOfSeletedRowAsReaded:(NSIndexPath*)aIndexPath
{
    StreamItem* sItem = [self getItemByIndexPath:aIndexPath];
    
    if (!sItem.mIsRead)
    {
//        sItem.mIsRead = YES;
        [sItem updateReadStatus];
//        [StoreManager updateItemReadStatus:YES ItemID:sItem.mItemID];
    }
}


- (StreamItem*) getItemByIndexPath:(NSIndexPath*)aIndexPath
{
    return nil;
}

- (BOOL) canCollectOnContentPage
{
    return YES;
}

- (void) loadData
{    
    return;
}

//- (BOOL) getCollectionStatuForSelectedRow
//{
//    NSIndexPath* sSelectedIndexPath = [self.mTableView indexPathForSelectedRow];    
//    Item* sItem = [self getItemByIndexPath:sSelectedIndexPath];
//    return sItem.mIsMarked;
//}

- (BOOL) toggleCollectedStatusByButton:(id)aButton
{
#ifdef DEBUG
    NSLog(@"aButton: %@", [aButton class]);
#endif
    TaggedButton* sFavButton = (TaggedButton*)aButton;
    NSIndexPath* sIndexPath = sFavButton.mIndexPath;
    
    BOOL sRet = [self reverseColletedStatus:sIndexPath];
    
    if (sRet)
    {
        [sFavButton setImage: [UIImage imageNamed:@"favorite24.png"] forState:UIControlStateNormal];
    }
    else 
    {
        [sFavButton setImage: [UIImage imageNamed:@"favorite_inactive24.png"] forState:UIControlStateNormal];
    }   
    
    
    return sRet;
}

//- (BOOL) toggleColletedStatusOfSelectedRow
//{
//    NSIndexPath* sSelectedIndexPath =  [self.mTableView indexPathForSelectedRow];
//    
//    BOOL sRet = [self reverseColletedStatus:sSelectedIndexPath];
//    //the following line does not work, strangely, so use UITableView selectRowAtIndexPath:
//    //        [self.tableView cellForRowAtIndexPath:sSelectedIndexPath].selected = YES;
//    //    [self.tableView selectRowAtIndexPath:sSelectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
//    return sRet;    
//}


#pragma mark -
#pragma mark methods to chanage message's collection status.
- (BOOL) reverseColletedStatus:(NSIndexPath*)aIndexPath
{
    Item* sItem = [self getItemByIndexPath:aIndexPath];
    
    sItem.mIsMarked = !sItem.mIsMarked;
    [sItem updateMarkedStaus:sItem.mIsMarked];
    
    return sItem.mIsMarked;
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self markItemOfSeletedRowAsReaded:indexPath];
    
    StreamItem* sItem = (StreamItem*)[self getItemByIndexPath:indexPath];
    
    ContentViewController2* sContentViewController;
    sContentViewController = [[ContentViewController2 alloc]init];
    sContentViewController.hidesBottomBarWhenPushed = YES;
    sContentViewController.mItemListViewController = self;
    [sContentViewController setItem:sItem AndWithCollectionSupport:[self canCollectOnContentPage]];

    if ([self.mDelegate respondsToSelector:@selector(pushController:animated:)])
    {
        [self.mDelegate pushController:sContentViewController animated:YES];
    }
    
    [sContentViewController release];

    
    //record the title of the page read by the user.
    NSDictionary* sDict = [NSDictionary dictionaryWithObjectsAndKeys:
                           sItem.mName, @"title", nil];
    [MobClick event:@"UEID_READ_ITEM" attributes: sDict];

    
    return;
}
@end
