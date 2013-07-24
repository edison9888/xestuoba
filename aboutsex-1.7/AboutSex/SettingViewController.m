//
//  SettingViewController.m
//  AboutSex
//
//  Created by Wen Shane on 12-11-28.
//
//

#import "SettingViewController.h"
//#import "UMFeedback.h"
#import "SharedVariables.h"
#import "SharedStates.h"
#import "MobClick.h"
#import "SVProgressHUD.h"

#import "TapkuLibrary.h"

#import "UserConfiger.h"

#import "FontSizeSettingController.h"
#import "RecommandedAppsController.h"
#import "FavoriteViewController.h"
#import "CustomCellBackgroundView.h"
#import "CustomBadge.h"
#import "NSDateFormatter+MyDateFormatter.h"
#import "AboutViewController.h"
#import "KKPasscodeLock.h"
#import "KKPasscodeSettingsViewController.h"

#import "PointsManager.h"
#import "SpotTimer.h"
#import "PeriodViewController.h"

#define MAX_TIME_OF_UPDATE_CHECK    7
#define TIME_OF_CHECK_RESULTS_BEFORE_DISAPPEAR  1.7
#define AboutViewController_TAG_FOR_LEFT_VERSION_TITLE_LABEL 1110
#define AboutViewController_TAG_FOR_RIGHT_VERSION_NUMBER_LABEL 1111
#define TAG_FOR_DATE4RECOMMANDEDAPPS_LABEL 1113

#define HEADER_HEIGHT_VIEW   110
#define TAG_BADGE_VIEW          1111


@interface SettingViewController ()
{
    UITableView* mTableView;
    
    BOOL mIsCheckingUpdate;
    NSTimer* mUpdateCheckOuttimeTimer;
    NSString* mPathForUpdate;
    
    //
}
@property (nonatomic, retain) UITableView* mTableView;

@property (nonatomic, assign) BOOL mIsCheckingUpdate;
@property (nonatomic, retain) NSTimer* mUpdateCheckOuttimeTimer;
@property (nonatomic, retain) NSString* mPathForUpdate;

- (void)updateCheckCallBack:(NSDictionary *)appInfo;
- (void) showNewUpdateInfoOnMainThread:(id) aAppInfo;

@end

@implementation SettingViewController
@synthesize mTableView;
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

- (id) initWithTitle:(NSString*)aTitle
{
    self = [super init];
    if (self)
    {
        if (aTitle)
        {
            self.navigationItem.title = aTitle;
        }
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
    
    //tableview
    UITableView* sTableView = [[UITableView alloc]initWithFrame:CGRectMake(sPosX, sPosY, self.view.bounds.size.width, self.view.bounds.size.height-sPosY) style:UITableViewStyleGrouped];
    sTableView.dataSource = self;
    sTableView.delegate = self;
    [sTableView setBackgroundView:nil];
    [sTableView setBackgroundColor:[UIColor clearColor]];
    sTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    
    //test
    sTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    //    sTableView.scrollEnabled = FALSE;
    
    [self.view addSubview:sTableView];
    
    self.mTableView = sTableView;
    [sTableView release];
    
    //
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    self.mTableView = nil;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[PointsManager shared] refreshPoints];
    [self.mTableView reloadData];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [[SpotTimer shared] startWithDelay:30];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    [[SpotTimer shared] cancel];
}

- (void) dealloc
{
    self.mTableView = nil;
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            if ([[SharedStates getInstance] wallEnabled])
            {
                return 3;
            }
            else
            {
                return 2;
            }
        case 1:
            return 3;
        case 2:
            return 1;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger sSection = [indexPath section];
    NSInteger sRow = [indexPath row];
    
    UITableViewCell* sCell = nil;
    
    if (1 == sSection
        && 1 == sRow)
    {
        sCell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
        if (!sCell)
        {
            sCell = [[[TKSwitchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SwitchCell"] autorelease];
            sCell.backgroundColor = [UIColor clearColor];
            
            CustomCellBackgroundView* sBGView = [CustomCellBackgroundView backgroundCellViewWithFrame:sCell.frame Row:[indexPath row] totalRow:[tableView numberOfRowsInSection:[indexPath section]] borderColor:SELECTED_CELL_COLOR fillColor:SELECTED_CELL_COLOR tableViewStyle:tableView.style];
            sCell.selectedBackgroundView = sBGView;
            
            
            sCell.textLabel.text = NSLocalizedString(@"nightmode", nil);
            [sCell.imageView setImage:[UIImage imageNamed:@"pie24"]];
            if ([((TKSwitchCell*)sCell).switcher respondsToSelector:@selector(onTintColor)])
            {
                ((TKSwitchCell*)sCell).switcher.onTintColor = MAIN_BGCOLOR;
            }
            [((TKSwitchCell*)sCell).switcher addTarget:self action:@selector(nightModeChanged:) forControlEvents:UIControlEventValueChanged];
            sCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if ([UserConfiger isNightModeOn])
        {
            ((TKSwitchCell*)sCell).switcher.on = YES;
        }
        else
        {
            ((TKSwitchCell*)sCell).switcher.on = NO;
        }
        
    }
    else
    {
        sCell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (!sCell)
        {
            sCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"] autorelease];
            CustomCellBackgroundView* sBGView = [CustomCellBackgroundView backgroundCellViewWithFrame:sCell.frame Row:[indexPath row] totalRow:[tableView numberOfRowsInSection:[indexPath section]] borderColor:SELECTED_CELL_COLOR fillColor:SELECTED_CELL_COLOR tableViewStyle:tableView.style];
            sCell.selectedBackgroundView = sBGView;
            sCell.backgroundColor = [UIColor clearColor];
        }
        else
        {
            sCell.detailTextLabel.text = nil;
        }
        
        if (0 == sSection)
        {
            if (0 == sRow)
            {
                sCell.textLabel.text = NSLocalizedString(@"My Favorites", nil);
                sCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [sCell.imageView setImage:[UIImage imageNamed:@"heart24"]];
                sCell.detailTextLabel.text = [NSString stringWithFormat:@"%d", [[StoreManagerEx shared] getFavoritesNumber]];
            }
            else if (2 == sRow)
            {
                sCell.textLabel.text = NSLocalizedString(@"My Points", nil);
                sCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [sCell.imageView setImage:[UIImage imageNamed:@"basket24"]];
                sCell.detailTextLabel.text = [NSString stringWithFormat:@"%d", [[PointsManager shared] getPoints]];
            }
            else if (1 == sRow)
            {
                sCell.textLabel.text = NSLocalizedString(@"Period Prediction", nil);
                sCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [sCell.imageView setImage:[UIImage imageNamed:@"cal24"]];
                
                ENUM_DAY_PERIOD_STATUS sStatus = [PeriodViewController getStatusForDate:[NSDate date]];
                if (sStatus == ENUM_DAY_PERIOD_STATUS_MENSTRUAL )
                {
                    sCell.detailTextLabel.text = NSLocalizedString(@"Forbidden", nil);
                }
                else if (sStatus == ENUM_DAY_PERIOD_STATUS_OVULATORY)
                {
                    sCell.detailTextLabel.text = NSLocalizedString(@"Not Safe", nil);
                }
                else if (sStatus == ENUM_DAY_PERIOD_STATUS_SAFE)
                {
                    sCell.detailTextLabel.text = NSLocalizedString(@"Safe", nil);
                }
                else
                {
                    sCell.detailTextLabel.text = nil;
                }
            }
            else
            {
                //
            }
        }
        else if (1 == sSection)
        {
            if (0 == sRow)
            {
                sCell.textLabel.text =  NSLocalizedString(@"contentsfontsize", nil);
                [sCell.imageView setImage:[UIImage imageNamed:@"fontsize24"]];
                sCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                NSString* sFontSizeStr = nil;
                switch ([UserConfiger getFontSizeType]) {
                    case ENUM_FONT_SIZE_SMALL:
                        sFontSizeStr = NSLocalizedString(@"small", nil);
                        break;
                    case ENUM_FONT_SIZE_NORMAL:
                        sFontSizeStr = NSLocalizedString(@"medium", nil);
                        break;
                    case ENUM_FONT_SIZE_LARGE:
                        sFontSizeStr = NSLocalizedString(@"large", nil);
                        break;
                    default:
                        break;
                }
                sCell.detailTextLabel.text = sFontSizeStr;
            }
            else if (2 == sRow)
            {
                sCell.textLabel.text = NSLocalizedString(@"Password setting", nil);
                if ([[KKPasscodeLock sharedLock] isPasscodeRequired])
                {
                    sCell.detailTextLabel.text = NSLocalizedString(@"On", nil);
                } else
                {
                    sCell.detailTextLabel.text = NSLocalizedString(@"Off", nil);
                }
                
                sCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [sCell.imageView setImage:[UIImage imageNamed:@"lock24"]];
            }
            else
            {
                //
            }
            
        }
        else if (2 == sSection)
        {
            if (0 == sRow)
            {
                sCell.textLabel.text = NSLocalizedString(@"About", nil);
                sCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [sCell.imageView setImage:[UIImage imageNamed:@"board24"]];
            }
            else
            {
                //nothing done.
            }
        }
        else
        {
            //nothing done here.
        }
        
    }
    
    return sCell;
}

- (void) nightModeChanged:(id)aSwitch
{
    UISwitch* sNightModeSwitch = (UISwitch*)aSwitch;
    [UserConfiger setNightMode:sNightModeSwitch.on];
    
    if (sNightModeSwitch.on)
    {
        [MobClick event:@"UEID_NIGHT_MODE"];
    }
}


#pragma mark -
#pragma mark methods for delegate interface
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger sSection = [indexPath section];
    NSInteger sRow = [indexPath row];
    
    if (sSection == 0)
    {
        if (0 == sRow)
        {
            [self presentFavoritesController];
        }
        else if (2 == sRow)
        {
            [self presentPointsGetterController];
            return;
        }
        else if (1 == sRow)
        {
            [self presentPeriodViewController];
            return;
        }
        else
        {
            //nothing
        }
    }
    else if (sSection == 1)
    {
        if (0 == sRow)
        {
            [self presentFontSizeSettingViewController];
        }
        else if (2 == sRow)
        {
            [self presentPasswordSettingController];
        }
        else
        {
            //
        }
        
    }
    else if (sSection == 2)
    {
        if (sRow == 0)
        {
            [self presentAboutController];
        }
        else
        {
            //nothing done.
        }
    }
    else
    {
        //nothing done.
    }
    
    return;
}

- (void) presentFontSizeSettingViewController
{
    
    FontSizeSettingController* sFontSizeSettingViewController = [[FontSizeSettingController alloc] initWithStyle:UITableViewStyleGrouped];
    sFontSizeSettingViewController.hidesBottomBarWhenPushed = YES;
    sFontSizeSettingViewController.title = NSLocalizedString(@"contentsfontsize", nil);
    
    [self.navigationController pushViewController:sFontSizeSettingViewController animated:YES];
    
    
    [sFontSizeSettingViewController release];
    
    [MobClick event:@"UEID_FONTSETTING"];
}

- (void) presentPasswordSettingController
{
    KKPasscodeSettingsViewController* sPasswordController = [[KKPasscodeSettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
    sPasswordController.hidesBottomBarWhenPushed = YES;
    sPasswordController.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController pushViewController:sPasswordController animated:YES];
    [sPasswordController release];
}

- (void) presentAboutController
{
    AboutViewController* sAboutViewController = [[AboutViewController alloc] init];
    sAboutViewController.hidesBottomBarWhenPushed = YES;
    sAboutViewController.title = NSLocalizedString(@"About", nil);
    
    [self.navigationController pushViewController:sAboutViewController animated:YES];
    
    
    [sAboutViewController release];
}

- (void) presentFavoritesController
{
    FavoriteViewController* sFavoriteViewController = [[FavoriteViewController alloc] initWithTitle:NSLocalizedString(@"My Favorites", nil)];
    sFavoriteViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sFavoriteViewController animated:YES];
    
    [sFavoriteViewController release];
}

- (void) presentPointsGetterController
{
    [[PointsManager shared] showWallFromViewController:self];
    [MobClick event:@"UEID_APPS_VIEW"];
}

- (void) presentPeriodViewController
{
    PeriodViewController* sPeriodViewController = [[PeriodViewController alloc] init];
    [sPeriodViewController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:sPeriodViewController animated:YES];
    [sPeriodViewController release];
    
    [MobClick event:@"UEID_PERIOD_VIEW"];
}


- (void) presentFeedbackController
{
    UIViewController* sViewController = [[UIViewController alloc]init];
//    [UMFeedback showFeedback:self withAppkey:APP_KEY_UMENG];
    [sViewController release];
}

#pragma mark - SKStoreProductViewControllerDelegate
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
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

- (void)appUpdate:(NSDictionary *)appInfo
{
    NSLog(@"自定义更新 %@",appInfo);
}

@end
