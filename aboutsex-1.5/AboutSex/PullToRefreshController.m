//
//  PullToRefreshController.m
//  BTT
//
//  Created by Wen Shane on 12-12-19.
//  Copyright (c) 2012年 Wen Shane. All rights reserved.
//

#import "PullToRefreshController.h"
#import "MKInfoPanel.h"
#import <QuartzCore/QuartzCore.h>
#import "NSDateFormatter+MyDateFormatter.h"

#define REFRESH_HEADER_HEIGHT 52.0f


@interface PullToRefreshController ()

@end

@implementation PullToRefreshController

@synthesize mTextPull, mTextRelease, mTextLoading, mRefreshHeaderView, mRefreshNoticeLabel, mLastUpdateTimeLabel,mRefreshArrow, mRefreshSpinner;
@synthesize mIsDragging, mIsLoading;
@synthesize mIsAutoRefresh;
@synthesize mNeedShowNetworkErrorStatus;
@synthesize mLastUpdateTime;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}


- (void) dealloc
{    
    self.mRefreshHeaderView = nil;
    self.mRefreshNoticeLabel = nil;
    self.mLastUpdateTimeLabel = nil;
    self.mRefreshArrow = nil;
    self.mRefreshSpinner = nil;
    self.mTextPull = nil;
    self.mTextRelease = nil;
    self.mTextLoading = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self addPullToRefreshHeader];

    self.mLastUpdateTime = [self getLastUpdateTime];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupStrings{
    self.mTextPull = NSLocalizedString(@"Pull down to refresh...", nil);
    self.mTextRelease = NSLocalizedString(@"Release to refresh...", nil);
    self.mTextLoading = NSLocalizedString(@"Loading...", nil);
}

- (void) setup
{
    [self setupStrings];
    
    
    return;
}

- (void)addPullToRefreshHeader {
    mRefreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, 320, REFRESH_HEADER_HEIGHT)];
    mRefreshHeaderView.backgroundColor = [UIColor clearColor];
    
    self.mRefreshNoticeLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 10, 320, 20)] autorelease];
    self.mRefreshNoticeLabel.backgroundColor = [UIColor clearColor];
    self.mRefreshNoticeLabel.font = [UIFont systemFontOfSize:12.0];
    self.mRefreshNoticeLabel.textAlignment = UITextAlignmentCenter;
    self.mRefreshNoticeLabel.textColor = [UIColor blackColor];
    
    CGFloat sY = mRefreshNoticeLabel.frame.origin.y+mRefreshNoticeLabel.frame.size.height;
    mLastUpdateTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, mRefreshNoticeLabel.frame.origin.y+mRefreshNoticeLabel.frame.size.height, 320, REFRESH_HEADER_HEIGHT-sY-10)];
    mLastUpdateTimeLabel.backgroundColor = [UIColor clearColor];
    mLastUpdateTimeLabel.font = [UIFont systemFontOfSize:12.0];
    mLastUpdateTimeLabel.textAlignment = UITextAlignmentCenter;
    mLastUpdateTimeLabel.textColor = [UIColor grayColor];
    
    self.mRefreshArrow = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]] autorelease];
    self.mRefreshArrow.frame = CGRectMake(floorf((REFRESH_HEADER_HEIGHT - 18) / 2),
                                    (floorf(REFRESH_HEADER_HEIGHT - 44) / 2),
                                    18, 44);
    
    self.mRefreshSpinner = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
    self.mRefreshSpinner.frame = CGRectMake(floorf(floorf(REFRESH_HEADER_HEIGHT - 20) / 2), floorf((REFRESH_HEADER_HEIGHT - 20) / 2), 20, 20);
    self.mRefreshSpinner.hidesWhenStopped = YES;
    
    [self.mRefreshHeaderView addSubview:mRefreshNoticeLabel];
    [self.mRefreshHeaderView addSubview:mLastUpdateTimeLabel];
    [self.mRefreshHeaderView addSubview:mRefreshArrow];
    [self.mRefreshHeaderView addSubview:mRefreshSpinner];
    //for now, we dont need self-refresh functionality.
    [self.tableView addSubview:mRefreshHeaderView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.mIsLoading)
    {
        return;
    }
    self.mIsDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.mIsLoading) {
        // Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0)
            self.tableView.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
            self.tableView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (mIsDragging && scrollView.contentOffset.y < 0) {
        // Update the arrow direction and label
        [UIView animateWithDuration:0.25 animations:^{
            if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
                // User is scrolling above the header
                mRefreshNoticeLabel.text = self.mTextRelease;
                [self.mRefreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
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

                mRefreshNoticeLabel.text = self.mTextPull;
                [self.mRefreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
            }
        }];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.mIsLoading) return;
    self.mIsDragging = NO;
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
        mRefreshNoticeLabel.text = self.mTextLoading;
        mRefreshArrow.hidden = YES;
        [mRefreshSpinner startAnimating];
    }];
    
    // Refresh action!
    [self refresh];
}

- (void)stopLoading {
    [self unsetLoadingState];
    
    // Hide the header
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.contentInset = UIEdgeInsetsZero;
        [self.mRefreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    }
                     completion:^(BOOL finished) {
                         [self performSelector:@selector(stopLoadingComplete)];
                     }];
}

- (void)stopLoadingComplete
{
    
    if (self.mNeedShowNetworkErrorStatus)
    {
        [self showNetWorkErrorNotice];
        self.mNeedShowNetworkErrorStatus = NO;
    }

    // Reset the header
    self.mRefreshNoticeLabel.text = self.mTextPull;
    self.mRefreshArrow.hidden = NO;
    [self.mRefreshSpinner stopAnimating];
    
    if (self.mIsAutoRefresh)
    {
        self.mIsAutoRefresh = NO;
    }
}

- (void) setLoadingState
{
    if (!(self.mIsLoading))
    {
        self.mIsLoading = YES;
        
    }
}

- (void) unsetLoadingState
{
    if (self.mIsLoading)
    {
        self.mIsLoading = NO;
    }
}

- (void)refresh
{
    // This is just a demo. Override this method with your custom reload action.
    //pull new strem(if any) from server.
//    [self refreshDone];
    
    return;
}

- (void) autoRefresh
{
    if (self.mIsLoading)
    {
        return;
    }
    self.mIsAutoRefresh = YES;
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    [self startLoading];
}


//- (void) autoRefresh
//{    
//    [self setLoadingState];
//    self.mIsAutoRefresh = YES;
//    
//    [self refresh];
//}


- (void) refreshDone:(BOOL)aSuccess
{
    if (aSuccess)
    {
        self.mLastUpdateTime = [NSDate date];
        [self storeLastUpdateTime:self.mLastUpdateTime];
    }
    // Don't forget to call stopLoading at the end.
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:0.0];
}

- (void) showNetWorkErrorNotice
{
    NSString* sNetworkErrorNotice = NSLocalizedString(@"News updating error, there may be something wrong with your network", nil);
    [MKInfoPanel showPanelInViewNoOverlapping:self.view type:MKInfoPanelTypeError title:sNetworkErrorNotice subtitle:nil hideAfter:3];
}

- (NSDate*) getLastUpdateTime
{
    NSUserDefaults* sDefaults = [NSUserDefaults standardUserDefaults];
    NSDate* sLastUpdateTime = [sDefaults objectForKey:@"DEFAULTS_PULL_TO_REFRESH_CONTROLLER_LAST_UPDATE_TIME"];
    
    return sLastUpdateTime;
}

- (void) storeLastUpdateTime:(NSDate*)aDate
{
    if (aDate)
    {
        NSUserDefaults* sDefaults = [NSUserDefaults standardUserDefaults];
        [sDefaults setObject:aDate forKey:@"DEFAULTS_PULL_TO_REFRESH_CONTROLLER_LAST_UPDATE_TIME"];
    }
}

#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    
//    // Configure the cell...
//    
//    return cell;
//}
//
///*
//// Override to support conditional editing of the table view.
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Return NO if you do not want the specified item to be editable.
//    return YES;
//}
//*/
//
///*
//// Override to support editing the table view.
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        // Delete the row from the data source
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    }   
//    else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }   
//}
//*/
//
///*
//// Override to support rearranging the table view.
//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
//{
//}
//*/
//
///*
//// Override to support conditional rearranging of the table view.
//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Return NO if you do not want the item to be re-orderable.
//    return YES;
//}
//*/
//
//#pragma mark - Table view delegate
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Navigation logic may go here. Create and push another view controller.
//    /*
//     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
//     // ...
//     // Pass the selected object to the new view controller.
//     [self.navigationController pushViewController:detailViewController animated:YES];
//     [detailViewController release];
//     */
//}

@end
