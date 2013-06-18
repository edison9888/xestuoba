//
//  PeriodViewController.m
//  AboutSex
/*
 
 安全期计算方法：
 1、经期前14天为排卵期，排卵期的前5天及后4天，总共10天为危险期。
 2、经期为3-5天，取5天。
 3、周期取28天。
 例如：12月2日经期开始，则12月30日是下次经期的开始，经期结束在12月6日，排卵日在12月16日，危险期为12月11日-12月20日。
 */
//  Created by Wen Shane on 13-5-25.
//
//

#import "PeriodViewController.h"
#import "SharedStates.h"
#import "NSDate+MyDate.h"
#import "NSDateFormatter+MyDateFormatter.h"
#import "PeriodSettingViewController.h"


@interface PeriodViewController ()
{
    BOOL mIsMonthChanging;
    BOOL mSelectSliently;
    NSDate* mCurSelectedDate;
    DMCustomModalViewController* mPeriodSettingController;
}

@property (nonatomic, assign) BOOL mIsMonthChanging;
@property (nonatomic, assign) BOOL mSelectSliently;
@property (nonatomic, retain) NSDate* mCurSelectedDate;
@property (nonatomic, retain) DMCustomModalViewController* mPeriodSettingController;

@end

@implementation PeriodViewController
@synthesize mIsMonthChanging;
@synthesize mSelectSliently;
@synthesize mCurSelectedDate;
@synthesize mPeriodSettingController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Menstrual Period", nil);
        self.mIsMonthChanging = NO;
    }
    return self;
}

- (id) init
{
    self = [super initWithSunday:NO timeZone:[NSTimeZone localTimeZone]];
    if (self)
    {
        
    }
    return self;
}

- (void) dealloc
{
    self.mCurSelectedDate = nil;
    self.mPeriodSettingController =  nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
        
    UIBarButtonItem* sRightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(setPeriods)];
    self.navigationItem.rightBarButtonItem = sRightBarButtonItem;
    [sRightBarButtonItem release];
    
    self.mSelectSliently = YES;
    [self.monthView selectDate:[NSDate date]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setPeriods
{
//    if (!self.mPeriodSettingController)
//    {
//        PeriodSettingViewController* sPeriodSettingViewController = [[PeriodSettingViewController alloc] init];
//        UINavigationController* sNavOfPeriodSettingViewController = [[UINavigationController alloc]initWithRootViewController:sPeriodSettingViewController];
//        DMCustomModalViewController* sPopedViewController = [[DMCustomModalViewController alloc]initWithRootViewController:sNavOfPeriodSettingViewController parentViewController:self];
//        sPopedViewController.rootViewControllerHeight = 200;
//        sPopedViewController.parentViewScaling = 1;
//        sPopedViewController.threeDRotationEnable = NO;
//        sPopedViewController.tapParentViewToClose = NO;
//        sPopedViewController.allowDragRootView = YES;
//        sPopedViewController.allowDragFromBottomToTop = YES;
//        sPopedViewController.draggedRootViewAlphaValue = 1;
//        
//        sPopedViewController.delegate = self;
//        self.mPeriodSettingController = sPopedViewController;
//        [sPeriodSettingViewController release];
//        [sNavOfPeriodSettingViewController release];
//    }
//    
//    [self.mPeriodSettingController presentRootViewControllerWithPresentationStyle:DMCustomModalViewControllerPresentPartScreen
//                                          controllercompletion:^{
//                                              
//                                          }];
    return;
}

//#pragma mark MonthView Delegate & DataSource
- (NSArray*) calendarMonthView:(TKCalendarMonthView*)monthView marksFromDate:(NSDate*)startDate toDate:(NSDate*)lastDate
{
    return nil;
}

- (NSArray*) calendarMonthView:(TKCalendarMonthView*)monthView stylesFromDate:(NSDate*)startDate toDate:(NSDate*)lastDate
{    
    
    NSMutableArray* sStyles = [NSMutableArray arrayWithCapacity:42];

    NSDate *sDate = startDate;
	while(YES)
    {
        ENUM_DAY_STYLE sStyle = ENUM_DAY_STYLE_NO;
		ENUM_DAY_PERIOD_STATUS sDayStatus = [self getStatusForDate:sDate];
		switch (sDayStatus) {
            case ENUM_DAY_PERIOD_STATUS_EMMENIA:
            {
                sStyle = ENUM_DAY_STYLE_FIRST;
            }
                break;
            case ENUM_DAY_PERIOD_STATUS_OVULATION:
            {
                sStyle = ENUM_DAY_STYLE_SECOND;
            }
                break;
            case ENUM_DAY_PERIOD_STATUS_SAFE:
            {
                sStyle = ENUM_DAY_STYLE_NO;
            }
                break;
            default:
                break;
        }
        [sStyles addObject:[NSNumber numberWithInteger:sStyle]];

		NSDateComponents *info = [sDate dateComponentsWithTimeZone:self.monthView.timeZone];
		info.day++;
		sDate = [NSDate dateWithDateComponents:info];
		if([sDate compare:lastDate]==NSOrderedDescending)
        {
            break;
        }
	}

    return sStyles;
}

//
- (void) calendarMonthView:(TKCalendarMonthView*)monthView didSelectDate:(NSDate*)date
{
    if (self.mSelectSliently)
    {
        self.mSelectSliently = NO;
        return;
    }
    
    if (!self.mIsMonthChanging)
    {
        NSDate* sNow = [NSDate date];
        NSLog(@"sNow: %@", sNow);
        if ([date compare:sNow] != NSOrderedDescending)
        {
            self.mCurSelectedDate = date;
            
            NSString* sDateStr = [NSDateFormatter standardYMDFormatedStringLeadigZeroCN: date];
            NSString* sWeekdayStr = [NSDateFormatter weekDay:date];
            NSString* sTitle = [NSString stringWithFormat:@"%@(%@)", sDateStr, sWeekdayStr];
            
            UIActionSheet* sActionSheet = [[UIActionSheet alloc] initWithTitle: sTitle delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:@"经期开始", @"经期结束", nil];
            
            [sActionSheet showInView:self.view];
            [sActionSheet release];
        }
        
    }
    
	NSLog(@"Date Selected: %@",date);
}

- (void) calendarMonthView:(TKCalendarMonthView*)monthView monthWillChange:(NSDate*)month animated:(BOOL)animated
{
    self.mIsMonthChanging = YES;
    NSLog(@"monthWillChange: %@",month);
}

- (void) calendarMonthView:(TKCalendarMonthView*)mv monthDidChange:(NSDate*)d animated:(BOOL)animated
{
    self.mIsMonthChanging = NO;
    NSLog(@"monthDidChange: %@",d);
}


#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    NSLog(@"click %d", buttonIndex);
//    if (buttonIndex == 0)
//    {
//        NSDate* sStartDate = self.mCurSelectedDate;
//        NSDate* sEndDate = [self getPredicatedEndDateByStartDate:sStartDate];
//        [[SharedStates getInstance] addPeriodStartDate:sStartDate EndDate:sEndDate];
//        
//        [self.monthView reloadData];
//    }
//    else if (buttonIndex == 1)
//    {
//        NSDate* sEndDate = self.mCurSelectedDate;
//        NSDate* sStartDate = [[SharedStates getInstance] getLastPeriodStartDate];
//        [[sStartDate retain] autorelease];
//        if (!sStartDate
//            || [sEndDate timeIntervalSinceDate:sStartDate] > MAX_DURATION*SECONDS_FOR_ONE_DAY)
//        {
//            UIAlertView* sAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Notice", nil) message:NSLocalizedString(@"Please set start date first", nil) delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//            [sAlertView show];
//            [sAlertView release];
//            
//            return;
//        }
//        
//        [[SharedStates getInstance] addPeriodStartDate:sStartDate EndDate:sEndDate];
//
//        
//        [self.monthView reloadData];
//    }
//    else
//    {
//        return;
//    }

}

- (NSDate*) getPredicatedEndDateByStartDate:(NSDate*)aStartDate
{
    NSInteger sPredicatedDuration = [[SharedStates getInstance] getDuration];
    NSTimeInterval sPredicatedDurationSeconds = (sPredicatedDuration-1)*SECONDS_FOR_ONE_DAY;
    
    NSDate* sPredicatedEndDate = [NSDate dateWithTimeInterval:sPredicatedDurationSeconds sinceDate:aStartDate];
    
    return sPredicatedEndDate;
}

- (ENUM_DAY_PERIOD_STATUS) getStatusForDate:(NSDate*)aDate
{
    NSArray* sPeriods = [[SharedStates getInstance] getPeriods];
    
    
    return ENUM_DAY_STYLE_FIRST;
}

#pragma mark - Custom modal delegate
- (void)customModalViewControllerDidDismiss:(DMCustomModalViewController *)modalViewController
{
    [self.monthView reloadData];
}


@end
