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
#import "SharedVariables.h"
#import "NSDate+MyDate.h"
#import "NSDateFormatter+MyDateFormatter.h"
#import "PeriodSettingViewController.h"
#import "ATMHud.h"
#import "KGModal.h"
#import "UIButtonLarge.h"
#import "PeriodReferenceView.h"
#import "MobClick.h"

@interface PeriodViewController ()
{
    PeriodSettingViewController* mPeriodSettingController;
    PeriodReferenceView* mPeriodReferenceView;
    
    UILabel* mDetailsLabel;
}

@property (nonatomic, retain) PeriodSettingViewController* mPeriodSettingController;
@property (nonatomic, retain) PeriodReferenceView* mPeriodReferenceView;
@property (nonatomic, retain) UILabel* mDetailsLabel;
@end

@implementation PeriodViewController
@synthesize mPeriodSettingController;
@synthesize mPeriodReferenceView;
@synthesize mDetailsLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Period Prediction", nil);
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
    self.mPeriodSettingController =  nil;
    self.mPeriodReferenceView = nil;
    self.mDetailsLabel = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
        
    UIBarButtonItem* sRightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(setPeriods)];
    self.navigationItem.rightBarButtonItem = sRightBarButtonItem;
    [sRightBarButtonItem release];
    
    
    CGFloat sX = 5;
    CGFloat sY = self.monthView.frame.origin.y+ self.monthView.bounds.size.height;
    CGFloat sWidth = self.view.bounds.size.width-2*sX;
    CGFloat sHeight = 20;
    
    UILabel* sDetailsLabel = [[UILabel alloc] initWithFrame:CGRectMake(sX, sY, sWidth, sHeight)];
    sDetailsLabel.numberOfLines = 0;
    sDetailsLabel.font = [UIFont systemFontOfSize:12];
//    sDetailsLabel.backgroundColor = [UIColor redColor];
    [self.view addSubview:sDetailsLabel];
    self.mDetailsLabel = sDetailsLabel;
    [sDetailsLabel release];
    
    //
    sY = self.view.bounds.size.height-60;
    sX = 10;
    sWidth = 40;
    sHeight = 5;
    
    UIImageView* sSeperatorLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dotline"]];
    sSeperatorLine.frame = CGRectMake(5, sY-10, self.view.bounds.size.width-10, 2);
    [self.view addSubview:sSeperatorLine];
    
    UIImageView* sMenstrualImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"red1"]];
    sMenstrualImage.frame = CGRectMake(sX, sY, sWidth, sHeight);
    [self.view addSubview:sMenstrualImage];
    
    sX += sWidth+5;
    UILabel* sMenstrualLabel = [[UILabel alloc] initWithFrame:CGRectMake(sX, sY-5, sWidth, sHeight+10)];
    sMenstrualLabel.text = NSLocalizedString(@"Menstrual Period", nil);
    sMenstrualLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:sMenstrualLabel];
    
    sX += sWidth+10;
    UIImageView* sOvulatoryImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"red3"]];
    sOvulatoryImage.frame = CGRectMake(sX, sY, sWidth, sHeight);
    [self.view addSubview:sOvulatoryImage];
    
    sX += sWidth+5;
    UILabel* sOvulatoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(sX, sY-5, sWidth, sHeight+10)];
    sOvulatoryLabel.text = NSLocalizedString(@"Ovulatory Period", nil);
    sOvulatoryLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:sOvulatoryLabel];
    
    sX += sWidth+10;
    UIImageView* sSafeImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"red7"]];
    sSafeImage.frame = CGRectMake(sX, sY, sWidth, sHeight);
    [self.view addSubview:sSafeImage];
    
    sX += sWidth+5;
    UILabel* sSafeLabel = [[UILabel alloc] initWithFrame:CGRectMake(sX, sY-5, sWidth, sHeight+10)];
    sSafeLabel.text = NSLocalizedString(@"Safe Period", nil);
    sSafeLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:sSafeLabel];


    //
    sX += sWidth;
    sY -= 10;
    UIButtonLarge* sRefBtn = [UIButtonLarge buttonWithType:UIButtonTypeCustom];
    [sRefBtn setImage:[UIImage imageNamed:@"questionmark16"] forState:UIControlStateNormal];
    sRefBtn.frame = CGRectMake(sX, sY, 16, 16);
    sRefBtn.mMarginInsets = UIEdgeInsetsMake(15, 15, 15, 15);
    [sRefBtn addTarget:self action:@selector(presentPeriodReferences) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:sRefBtn];
    
    [sSeperatorLine release];
    [sMenstrualImage release];
    [sMenstrualLabel release];
    [sOvulatoryImage release];
    [sOvulatoryLabel release];
    [sSafeImage release];
    [sSafeLabel release];
    
    
    [self.monthView selectDate:[NSDate date]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) presentPeriodReferences
{
    if (!self.mPeriodReferenceView)
    {
        self.mPeriodReferenceView = [PeriodReferenceView getInstanceWithFrame:CGRectMake(0, 0, 280, 200)];
    }
    
    KGModal* sKGModal = [KGModal sharedInstance];
    
    [sKGModal setMBackgroundColor:[UIColor whiteColor]];
    [sKGModal setMBorderWidth:1.0];
    [sKGModal setMBorderColor:MAIN_BGCOLOR];
    [sKGModal setMCornerRadius:8.0];
    
    [sKGModal showWithContentView:self.mPeriodReferenceView andAnimated:YES];
    
    return;
    
}


- (void) setPeriods
{
    if (!self.mPeriodSettingController)
    {
        Period* sPeriod = [[SharedStates getInstance] getPeriod];
        PeriodSettingViewController* sPeriodSettingViewController = [[PeriodSettingViewController alloc] initWithInitPeriod:sPeriod];
        sPeriodSettingViewController.mDelegate = self;
        CGFloat sYOffset = 150;
        CGRect sFrame = CGRectMake(0, sYOffset, self.view.bounds.size.width, self.view.bounds.size.height-sYOffset);
        sPeriodSettingViewController.view.frame = sFrame;
        
        self.mPeriodSettingController = sPeriodSettingViewController;
        [sPeriodSettingViewController release];
    }
    
    //
    if (self.mPeriodSettingController.view.superview == self.view)
    {
        CATransition *animation = [CATransition  animation];
        animation.delegate = self;
        animation.duration = 0.3;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.type = kCATransitionPush;
        animation.subtype = kCATransitionFromBottom;
        [self.mPeriodSettingController.view setAlpha:0.0f];
        [self.mPeriodSettingController.view.layer addAnimation:animation forKey:@"pushOut"];
        [self.mPeriodSettingController.view performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.3];
        self.monthView.userInteractionEnabled = YES;
        [self.navigationItem setHidesBackButton:NO animated:YES];
    }
    else
    {
        CATransition *animation = [CATransition  animation];
        animation.delegate = self;
        animation.duration = 0.3;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.type = kCATransitionMoveIn;
        animation.subtype = kCATransitionFromTop;
        [self.mPeriodSettingController.view setAlpha:1.0f];
        [self.mPeriodSettingController.view.layer addAnimation:animation forKey:@"pushIn"];
        [self.mPeriodSettingController resetPeriod: [[SharedStates getInstance] getPeriod]];
   
        [self.view addSubview:self.mPeriodSettingController.view];
        self.monthView.userInteractionEnabled = NO;
        [self.navigationItem setHidesBackButton:YES animated:YES];
    }
    
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
		ENUM_DAY_PERIOD_STATUS sDayStatus = [PeriodViewController getStatusForDate:sDate];
		switch (sDayStatus) {
            case ENUM_DAY_PERIOD_STATUS_MENSTRUAL:
            {
                sStyle = ENUM_DAY_STYLE_FIRST;
            }
                break;
            case ENUM_DAY_PERIOD_STATUS_OVULATORY:
            {
                sStyle = ENUM_DAY_STYLE_SECOND;
            }
                break;
            case ENUM_DAY_PERIOD_STATUS_SAFE:
            {
                sStyle = ENUM_DAY_STYLE_THIRD;
            }
                break;
            case ENUM_DAY_PERIOD_STATUS_UNKNOWN:
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
    NSString* sDateStr = [NSDateFormatter standardyyyyMMddFormatedString:date];
    if ([date isTodayWithTimeZone:[NSTimeZone localTimeZone]])
    {
        sDateStr = [sDateStr stringByAppendingFormat:@"(%@)", NSLocalizedString(@"Today", nil)];
    }
    
    NSString* sStatusStr = nil;
    ENUM_DAY_PERIOD_STATUS sStatus = [PeriodViewController getStatusForDate:date];
    switch (sStatus) {
        case ENUM_DAY_PERIOD_STATUS_MENSTRUAL:
        {
            sStatusStr = [NSString stringWithFormat:@"%@\t%@", NSLocalizedString(@"Menstrual Period", nil), @"建议不要同房"];;
        }
            break;
        case ENUM_DAY_PERIOD_STATUS_OVULATORY:
        {
            sStatusStr = [NSString stringWithFormat:@"%@\t%@", NSLocalizedString(@"Ovulatory Period", nil), @"建议采取必要避孕方法"];
        }
            break;
        case ENUM_DAY_PERIOD_STATUS_SAFE:
        {
            sStatusStr = [NSString stringWithFormat:@"%@\t%@", NSLocalizedString(@"Safe Period", nil), @""];;
        }
            break;
        case ENUM_DAY_PERIOD_STATUS_UNKNOWN:
        {
            
        }
            break;
        default:
            break;
    }
    
    NSString* sDetailsStr = sDateStr;
    if (sStatusStr)
    {
        sDetailsStr = [NSString stringWithFormat:@"• %@\t%@", sDetailsStr, sStatusStr];
    }
    else
    {
        sDetailsStr = [NSString stringWithFormat:@"• %@\t%@", sDetailsStr, NSLocalizedString(@"No status yet", nil)];
    }
    self.mDetailsLabel.text = sDetailsStr;

    
	NSLog(@"Date Selected: %@",date);
}

//- (void) calendarMonthView:(TKCalendarMonthView*)monthView monthWillChange:(NSDate*)month animated:(BOOL)animated
//{
//    NSLog(@"monthWillChange: %@",month);
//}
//
//- (void) calendarMonthView:(TKCalendarMonthView*)mv monthDidChange:(NSDate*)d animated:(BOOL)animated
//{
//    NSLog(@"monthDidChange: %@",d);
//}

+ (ENUM_DAY_PERIOD_STATUS) getStatusForDate:(NSDate*)aDate
{
    Period* sPeriod = [[SharedStates getInstance] getPeriod];
    if (!sPeriod)
    {
        return ENUM_DAY_PERIOD_STATUS_UNKNOWN;
    }
    else
    {
        NSInteger sDaysSincePeriodStartDay = [aDate ceilingDaysSinceStartingOfDate:sPeriod.mStartDate];
        if (sDaysSincePeriodStartDay < 1)
        {
            return ENUM_DAY_PERIOD_STATUS_UNKNOWN;
        }
        
        NSInteger sDaysSincePeriodStartDayAdjusted = sDaysSincePeriodStartDay%(sPeriod.mPeriodDays+1);
        
        if (sDaysSincePeriodStartDayAdjusted<=sPeriod.mDurationDays)
        {
            return ENUM_DAY_PERIOD_STATUS_MENSTRUAL;
        }
        else if (sDaysSincePeriodStartDayAdjusted >= sPeriod.mPeriodDays-18
                 && sDaysSincePeriodStartDayAdjusted <= sPeriod.mPeriodDays-9)
        {
            return ENUM_DAY_PERIOD_STATUS_OVULATORY;
        }
        else
        {
            return ENUM_DAY_PERIOD_STATUS_SAFE;
        }
        
    }    
}


#pragma mark - PeriodSettingDelegate
- (void) cancel
{
    [self setPeriods];
}

- (void) confirmWith:(Period*)aPeriod
{
    [[SharedStates getInstance] savePeriod:aPeriod];
    [self setPeriods];
    
    [self.monthView reloadData];
    [self.monthView selectDate:[NSDate date]];
    [self showNotice:NSLocalizedString(@"Modification Success", nil)];
    
    [MobClick event:@"UEID_PERIOD_SETTING"];

}

//
- (void) showNotice:(NSString*)aNotice
{
    ATMHud* sHudForSaveSuccess = [[[ATMHud alloc] initWithDelegate:self] autorelease];
    [sHudForSaveSuccess setAlpha:0.6];
    [sHudForSaveSuccess setDisappearScaleFactor:1];
    [sHudForSaveSuccess setShadowEnabled:YES];
    [self.view addSubview:sHudForSaveSuccess.view];
    
    [sHudForSaveSuccess setCaption:aNotice];
    [sHudForSaveSuccess show];
    [sHudForSaveSuccess hideAfter:1.2];
    
}

@end
