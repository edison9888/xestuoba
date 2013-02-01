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

#import "MobClick.h"
#import "SVProgressHUD.h"


#define MAX_TIME_OF_UPDATE_CHECK    7
#define TIME_OF_CHECK_RESULTS_BEFORE_DISAPPEAR  1.7
#define AboutViewController_TAG_FOR_LEFT_VERSION_TITLE_LABEL 1110
#define AboutViewController_TAG_FOR_RIGHT_VERSION_NUMBER_LABEL 1111

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
    self.view = sView;
    [sView release];
    
    CGFloat sPosX = 0;
    CGFloat sPosY = 30;

    //0. icon
    UIImage* sImage = [UIImage imageNamed:@"Icon-72_Rounded.png"];
    UIImageView* sImageView = [[UIImageView alloc]initWithImage:sImage];
    sImageView.center = CGPointMake(self.view.center.x, sImageView.center.y+sPosY);
    [self.view addSubview:sImageView];

    [sImageView release];
    
    sPosX =43;
    sPosY = sImageView.frame.origin.y+sImageView.frame.size.height+5;
    //1. intro
    UILabel* sIntroLabel = [[UILabel alloc] initWithFrame:CGRectMake(sPosX, sPosY, 270, 400)];
    sIntroLabel.numberOfLines = 0;
    NSString* sBundleDisplayName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    sIntroLabel.text = sBundleDisplayName;
    sIntroLabel.textAlignment = UITextAlignmentCenter;
//    sIntroLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:17];
    [sIntroLabel sizeToFit];
    sIntroLabel.center = CGPointMake(self.view.center.x, sIntroLabel.center.y);
    [self.view addSubview:sIntroLabel];
    [sIntroLabel release];
    
    //2. contacts and review links
    sPosX = 0;
    sPosY = sIntroLabel.frame.origin.y+ sIntroLabel.frame.size.height+10;
    UITableView* sTableView = [[UITableView alloc]initWithFrame:CGRectMake(sPosX, sPosY, self.view.bounds.size.width, self.view.bounds.size.height-sPosY) style:UITableViewStyleGrouped];
    sTableView.dataSource = self;
    sTableView.delegate = self;
    sTableView.backgroundColor = [UIColor clearColor];
    sTableView.scrollEnabled = FALSE;
    
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
            return 1;
        default:
            return 0;
    }
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    switch (section)
//    {
//        case 0:
//            return @"产品改进讨论区";
//        case 1:
//            return nil;
//        default:
//            return nil;
//    }
//
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger sSection = [indexPath section];
    NSInteger sRow = [indexPath row];
    
    
    if (0 == sSection
        && 0 == sRow)
    {
        UITableViewCell* sCell = [tableView dequeueReusableCellWithIdentifier:@"TwoLabels"];
        UILabel* sLeftVersionTitleLabel;
        UILabel* sRightVersionNumberLable;
        if (!sCell)
        {
            sCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TwoLabels"] autorelease]; 
            sCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            sLeftVersionTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, tableView.rowHeight)];
            sLeftVersionTitleLabel.backgroundColor = [UIColor clearColor];
            sLeftVersionTitleLabel.tag = AboutViewController_TAG_FOR_LEFT_VERSION_TITLE_LABEL;
            [sCell.contentView addSubview:sLeftVersionTitleLabel];
            [sLeftVersionTitleLabel release];
            
            sRightVersionNumberLable = [[UILabel alloc]initWithFrame:CGRectMake(200, 0, 90, tableView.rowHeight)];
            sRightVersionNumberLable.tag = AboutViewController_TAG_FOR_RIGHT_VERSION_NUMBER_LABEL;
            sRightVersionNumberLable.textAlignment = UITextAlignmentRight;
            sRightVersionNumberLable.backgroundColor = [UIColor clearColor];
            [sCell.contentView addSubview:sRightVersionNumberLable];
            [sRightVersionNumberLable release];
        }
        else 
        {
            sLeftVersionTitleLabel = (UILabel*)[sCell.contentView viewWithTag:AboutViewController_TAG_FOR_LEFT_VERSION_TITLE_LABEL];
            sRightVersionNumberLable = (UILabel*)[sCell.contentView viewWithTag:AboutViewController_TAG_FOR_RIGHT_VERSION_NUMBER_LABEL];
        }
        sLeftVersionTitleLabel.text =  NSLocalizedString(@"Version", nil);
        sRightVersionNumberLable.text = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleVersion"];
        
        return sCell;

    }
    else 
    {
        UITableViewCell* sCell = [tableView dequeueReusableCellWithIdentifier:@"TitleOnly"];
        if (!sCell)
        {
            sCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TitleOnly"] autorelease]; 
            sCell.selectionStyle = UITableViewCellSelectionStyleNone;
            sCell.textLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
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
            sCell.textLabel.text = NSLocalizedString(@"Feedback", nil);
            sCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 20;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    if (0  == section)
//    {
//        UILabel* sHeaderLabel = [[[UILabel alloc]init] autorelease];
//        sHeaderLabel.frame = CGRectMake(0, 0, 100, 200);
//        sHeaderLabel.text = @"产品改进讨论区..";
//        sHeaderLabel.font =  [UIFont fontWithName:@"HelveticaNeue-Medium" size:15];
//        [sHeaderLabel sizeToFit];
//        return sHeaderLabel;
//    }
//    return nil;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger sSection = [indexPath section];
    NSInteger sRow = [indexPath row];
    
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
            UIViewController* sViewController = [[UIViewController alloc]init];
            [UMFeedback showFeedback:self withAppkey:APP_KEY_UMENG];
            [sViewController release];
        }
    }
    else 
    {
        //nothing done.
    }
    
    return;
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
            NSURL *sURL = [NSURL URLWithString:self.mPathForUpdate];
            [[UIApplication sharedApplication] openURL:sURL];
        }
    }
}

- (void)appUpdate:(NSDictionary *)appInfo {
    NSLog(@"自定义更新 %@",appInfo);
} 

@end
