//
//  AboutViewController.m
//  AboutSex
//
//  Created by Shane Wen on 12-7-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AboutViewController.h"
#import "UMFeedback.h"
#import "SharedVariables.h"
#import "NSURL+WithChanelID.h"

#import "MobClick.h"
#import "SVProgressHUD.h"
#import <QuartzCore/QuartzCore.h>
#import "CustomCellBackgroundView.h"
#import "CopyrightView.h"
#import "UMFeedbackViewController.h"
#import "SharedStates.h"

#define MAX_TIME_OF_UPDATE_CHECK    7
#define TIME_OF_CHECK_RESULTS_BEFORE_DISAPPEAR  1.7
#define AboutViewController_TAG_FOR_LEFT_VERSION_TITLE_LABEL 1110
#define AboutViewController_TAG_FOR_RIGHT_VERSION_NUMBER_LABEL 1111

#define HEIGHT_HEADER_VIEW   110
#define HEIGHT_FOOTER_VIEW   100

@interface AboutViewController ()
{
    BOOL mIsCheckingUpdate;
    NSTimer* mUpdateCheckOuttimeTimer;
    NSString* mPathForUpdate;
}

@property (nonatomic, assign) BOOL mIsCheckingUpdate;
@property (nonatomic, retain) NSTimer* mUpdateCheckOuttimeTimer;
@property (nonatomic, retain)     NSString* mPathForUpdate;

- (void)updateCheckCallBack:(NSDictionary *)appInfo;
- (void) showNewUpdateInfoOnMainThread:(id) aAppInfo;


@end

@implementation AboutViewController

@synthesize mIsCheckingUpdate;
@synthesize mUpdateCheckOuttimeTimer;
@synthesize mPathForUpdate;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) loadView 
{
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    
    UIView* sView = [[UIView alloc] initWithFrame:applicationFrame];
    sView.backgroundColor = [UIColor whiteColor];
    self.view = sView;
    [sView release];
    
    CGFloat sPosX = 0;
    CGFloat sPosY = 0;
    
    UITableView* sTableView = [[UITableView alloc]initWithFrame:CGRectMake(sPosX, sPosY, self.view.bounds.size.width, self.view.bounds.size.height-sPosY) style:UITableViewStyleGrouped];
    sTableView.dataSource = self;
    sTableView.delegate = self;
    [sTableView setBackgroundView:nil];
    [sTableView setBackgroundColor:[UIColor clearColor]];
    
    [self.view addSubview:sTableView];
    
    [sTableView release];
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

- (void) dealloc
{
    [self.mUpdateCheckOuttimeTimer invalidate];
    self.mUpdateCheckOuttimeTimer = nil;
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)showFeedbackViewController
{
    UMFeedbackViewController *feedbackViewController = [[UMFeedbackViewController alloc] initWithNibName:@"UMFeedbackViewController" bundle:nil];
    feedbackViewController.appkey = APP_KEY_UMENG;
    [self.navigationController pushViewController:feedbackViewController animated:YES];
    [feedbackViewController release];

//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:feedbackViewController];
//    navigationController.navigationBar.tintColor = MAIN_BGCOLOR;
//    [self presentModalViewController:navigationController animated:YES];
//    [navigationController release];
    
//    UIViewController* sViewController = [[UIViewController alloc]init];
//    [UMFeedback showFeedback:self withAppkey:APP_KEY_UMENG];
//    [sViewController release];
    

}

- (void) presentCommentsController
{
    //    Class sClass = NSClassFromString(@"SKStoreProductViewController");
    //    if (sClass)
    //    {
    //        SKStoreProductViewController *storeProductViewController = [[SKStoreProductViewController alloc] init];
    //        // Configure View Controller
    //        [storeProductViewController setDelegate:self];
    //        [storeProductViewController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier: APP_ID}     completionBlock:^(BOOL result, NSError *error) {
    //                                                  if (error)
    //                                                  {
    //                                                      NSLog(@"Error %@ with User Info %@.", error, [error userInfo]);
    //                                                  }
    //                                                  else
    //                                                  {
    //                                                  }
    //        }];
    //        // Present Store Product View Controller
    //        [self presentViewController:storeProductViewController animated:YES completion:nil];
    //    }
    //    else
    {
        NSString* sCommentsURL = [[SharedStates getInstance] getCommentURL];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: sCommentsURL]];
        
        [MobClick event:@"UEID_ACTIVE_COMMENT"];
    }
}



#pragma mark -
#pragma mark methods for datasource interface

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return 2;
        case 1:
            return 2;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger sSection = [indexPath section];
    NSInteger sRow = [indexPath row];
    
    
    if (0 == sSection
        && 0 == sRow)
    {
        UITableViewCell* sCell = [tableView dequeueReusableCellWithIdentifier:@"TwoLabels"];
        UILabel* sRightVersionNumberLable;
        if (!sCell)
        {
            sCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TwoLabels"] autorelease]; 
            sCell.backgroundColor = [UIColor clearColor];
            
            sCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            sRightVersionNumberLable = [[UILabel alloc]initWithFrame:CGRectMake(200, 0, 90, tableView.rowHeight)];
            sRightVersionNumberLable.tag = AboutViewController_TAG_FOR_RIGHT_VERSION_NUMBER_LABEL;
            sRightVersionNumberLable.textAlignment = UITextAlignmentRight;
            sRightVersionNumberLable.backgroundColor = [UIColor clearColor];
            [sCell.contentView addSubview:sRightVersionNumberLable];
            [sRightVersionNumberLable release];
        }
        else 
        {
            sRightVersionNumberLable = (UILabel*)[sCell.contentView viewWithTag:AboutViewController_TAG_FOR_RIGHT_VERSION_NUMBER_LABEL];
        }
        sCell.textLabel.text = NSLocalizedString(@"Version", nil);
        sRightVersionNumberLable.text = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleVersion"];
        
        return sCell;

    }
    else 
    {
        UITableViewCell* sCell = [tableView dequeueReusableCellWithIdentifier:@"TitleOnly"];
        if (!sCell)
        {
            sCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TitleOnly"] autorelease]; 
            sCell.backgroundColor = [UIColor clearColor];
            
            CustomCellBackgroundView* sBGView = [CustomCellBackgroundView backgroundCellViewWithFrame:sCell.frame Row:[indexPath row] totalRow:[tableView numberOfRowsInSection:[indexPath section]] borderColor:SELECTED_CELL_COLOR fillColor:SELECTED_CELL_COLOR tableViewStyle:tableView.style];
            sCell.selectedBackgroundView = sBGView;            
        }
        if (0 == sSection)
        {
            if (1 == sRow)
            {
                sCell.textLabel.text = NSLocalizedString(@"Check for update", nil);
                sCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
        else if (1 == sSection)
        {
            if (0 == sRow)
            {
                sCell.textLabel.text = [[SharedStates getInstance] getCommentNotice];
                sCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            else
            {
                sCell.textLabel.text = NSLocalizedString(@"User Feedback", nil);
                sCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
        else
        {
            //nothing to do.
        }

        return sCell;
    }
    
}

#pragma mark -
#pragma mark methods for delegate interface
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger sSection = [indexPath section];
    NSInteger sRow = [indexPath row];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (sSection == 0)
    {
        if (sRow == 0)
        {
            return;
            
        }
        else if (sRow == 1)
        {
            if (!self.mIsCheckingUpdate)
            {
                self.mIsCheckingUpdate = YES;
                [SVProgressHUD showWithStatus:NSLocalizedString(@"Checking", nil) maskType:SVProgressHUDMaskTypeClear];
                [SVProgressHUD setBackgroudColorForHudView:COLOR_ACTIVITY_INDICATOR];
                [MobClick checkUpdateWithDelegate:self selector:@selector(updateCheckCallBack:)];
                
                
                //set outtime timer
                if(self.mUpdateCheckOuttimeTimer
                   && [self.mUpdateCheckOuttimeTimer isValid])
                {
                    [self.mUpdateCheckOuttimeTimer invalidate];
                }
            
                NSTimer* sTimer = [[NSTimer alloc]initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:MAX_TIME_OF_UPDATE_CHECK]  interval:1 target:self selector:@selector(updateCheckOuttimerHandler) userInfo:nil repeats:NO];
                self.mUpdateCheckOuttimeTimer  = sTimer;
                [sTimer release];                
                [[NSRunLoop currentRunLoop] addTimer:self.mUpdateCheckOuttimeTimer forMode:NSDefaultRunLoopMode];

            }
        }
        else 
        {
            //nothing done.
        }
    }
    else if (sSection == 1) 
    {
        if (sRow == 0)
        {
            [self presentCommentsController];
        }
        else if (sRow == 1)
        {
            [self showFeedbackViewController];
        }
    }
    else 
    {
        //nothing done.
    }
    
    return;
}

#pragma mark -
#pragma mark methods for delegate interface

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section)
    {
        return HEIGHT_HEADER_VIEW;
    }
    else
    {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (0  == section)
    {

        UIView* sHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0, 5, HEIGHT_HEADER_VIEW, tableView.bounds.size.width)] autorelease];

        CGFloat sPosX = 0;
        CGFloat sPosY = 5;

        //0. icon
        UIImage* sImage = [UIImage imageNamed:@"Icon-72_Rounded.png"];
        UIImageView* sImageView = [[UIImageView alloc]initWithImage:sImage];
        [sImageView setFrame:CGRectMake(sPosX, sPosY, 72, 72)];
        sImageView.center = CGPointMake(self.view.center.x, sImageView.center.y);
        [sHeaderView addSubview:sImageView];

        [sImageView release];

        sPosX =43;
        sPosY = sImageView.frame.origin.y+sImageView.frame.size.height+5;
        //1. intro
        UILabel* sIntroLabel = [[UILabel alloc] initWithFrame:CGRectMake(sPosX, sPosY, 270, 400)];
        sIntroLabel.numberOfLines = 0;
        NSString* sBundleDisplayName = nil;
        
//        sBundleDisplayName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
        
        sBundleDisplayName = NSLocalizedString(@"Aboutsex", nil);
        sIntroLabel.text = sBundleDisplayName;
        sIntroLabel.textAlignment = UITextAlignmentCenter;
        sIntroLabel.font = [UIFont systemFontOfSize:17];
        sIntroLabel.backgroundColor = [UIColor clearColor];
        [sIntroLabel sizeToFit];
        sIntroLabel.center = CGPointMake(self.view.center.x, sIntroLabel.center.y);

        [sHeaderView addSubview:sIntroLabel];
        [sIntroLabel release];

//        UILabel* sVersionLabel = [[UILabel alloc] initWithFrame: CGRectMake(sIntroLabel.frame.origin.x+sIntroLabel.bounds.size.width, sIntroLabel.frame.origin.y, 25, 13)];
//        NSString* sVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleVersion"];
//        sVersionLabel.text = sVersion;
//        sVersionLabel.textColor = [UIColor whiteColor];
//        sVersionLabel.textAlignment = UITextAlignmentCenter;
//        sVersionLabel.font = [UIFont systemFontOfSize:12];
//        sVersionLabel.layer.cornerRadius = 5;
//        sVersionLabel.backgroundColor = MAIN_BGCOLOR_SHALLOW;
//
//        [sHeaderView addSubview:sVersionLabel];
//        [sVersionLabel release];

        return sHeaderView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (1 == section)
    {
        return HEIGHT_FOOTER_VIEW;
    }
    else
    {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (1 == section)
    {
        UIView* sFooterView =[[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, HEIGHT_FOOTER_VIEW)] autorelease];
        
        CopyrightView* sCopyRightView = [CopyrightView getView];
        sCopyRightView.frame = CGRectMake(0, sFooterView.bounds.size.height-sCopyRightView.bounds.size.height, sCopyRightView.bounds.size.width, sCopyRightView.bounds.size.height);
        
        [sFooterView addSubview:sCopyRightView];
        
        return sFooterView;
    }
    else
    {
        return nil;
    }
}

- (void)updateCheckCallBack:(NSDictionary *)appInfo
{
//    NSEnumerator* sEnum = [appInfo keyEnumerator];
//    
//    id sKey;
//    while (sKey = [sEnum nextObject]) {
//        NSLog(@"%@-%@:\t %@", [sKey class], sKey, [appInfo objectForKey:sKey]);
//    }

    if (self.mIsCheckingUpdate)
    {
        if (self.mUpdateCheckOuttimeTimer
            && [self.mUpdateCheckOuttimeTimer isValid])
        {
            [self.mUpdateCheckOuttimeTimer invalidate];
        }
        
        BOOL sNeedUpdate = ((NSNumber*)[appInfo objectForKey:@"update"]).boolValue;
        CGFloat sCurVersion = [(NSString*)[[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleVersion"] doubleValue];
        CGFloat sNewVersion = [((NSString*)[appInfo objectForKey:@"version"]) doubleValue];
        if (sNeedUpdate
            && sNewVersion>sCurVersion)
        {
            //note that the display of alertview must take place on main thread, otherwise it loads very slowly.
            [self performSelectorOnMainThread:@selector(showNewUpdateInfoOnMainThread:) withObject:appInfo waitUntilDone:NO];
            [SVProgressHUD dismiss];
        }
        else 
        {
            [SVProgressHUD dismissWithSuccess:NSLocalizedString(@"No updates found", nil) afterDelay: TIME_OF_CHECK_RESULTS_BEFORE_DISAPPEAR];
        }
        self.mIsCheckingUpdate = NO;
    }
    
    return;
}

- (void) showNewUpdateInfoOnMainThread:(id) aAppInfo
{   
    
    NSDictionary* sAppInfo = (NSDictionary*)aAppInfo;
    
    
    NSString* sVersionStr = (NSString*)[sAppInfo objectForKey:@"version"];
    NSString* sUpdateLogStr = (NSString*)[sAppInfo objectForKey:@"update_log"];
    self.mPathForUpdate = (NSString*) [sAppInfo objectForKey:@"path"];
    
    
    NSString* sAlertViewTitle = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"New Version Found", nil), sVersionStr];
    UIAlertView* sAlertView = [[UIAlertView alloc] initWithTitle:sAlertViewTitle message:sUpdateLogStr  delegate:self cancelButtonTitle:NSLocalizedString(@"Ignore", nil) otherButtonTitles:NSLocalizedString(@"Update now", nil), nil];            
    [sAlertView show];
    [sAlertView release];

}

- (void) updateCheckOuttimerHandler
{
    if (self.mIsCheckingUpdate)
    {
        self.mIsCheckingUpdate = NO;
        [SVProgressHUD dismissWithError:NSLocalizedString(@"Update checking error", nil) afterDelay: TIME_OF_CHECK_RESULTS_BEFORE_DISAPPEAR];
    }
}

#pragma mark -
#pragma mark delegate for update checking's alertview
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1 == buttonIndex)
    {
        if (self.mPathForUpdate)
        {
            NSURL *sURL = [NSURL MyURLWithString:self.mPathForUpdate];
            [[UIApplication sharedApplication] openURL:sURL];
        }
    }
}

- (void)appUpdate:(NSDictionary *)appInfo {
    NSLog(@"自定义更新 %@",appInfo);
} 

@end
