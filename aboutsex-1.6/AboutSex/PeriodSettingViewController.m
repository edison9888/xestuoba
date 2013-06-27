//
//  PeriodSettingViewController.m
//  AboutSex
//
//  Created by Wen Shane on 13-6-7.
//
//

#import "PeriodSettingViewController.h"
#import "SharedVariables.h"
#import "CustomCellBackgroundView.h"
#import "NSDateFormatter+MyDateFormatter.h"
#import "NSDate+MyDate.h"
#import <QuartzCore/QuartzCore.h>


#define MIN_DATE_START_DATE   ([NSDate dateWithTimeIntervalSinceNow:-30*SECONDS_FOR_ONE_DAY])
#define MAX_DATE_START_DATE   ([NSDate date])
#define TAG_START_DATE_SELECTION_VIEW   101
#define TAG_END_DATE_SELECTION_VIEW     102

@interface PeriodSettingViewController ()
{
    Period* mInitPeriod;
    Period* mCurPeriod;
    
    UITableView* mTableView;
    DateSelectionView* mDateSelectionView;
    NumberSelectionView* mDaysSelectionView;
}

@property (nonatomic, retain) Period* mInitPeriod;
@property (nonatomic, retain) Period* mCurPeriod;
@property (nonatomic, retain) UITableView* mTableView;
@property (nonatomic, retain) DateSelectionView* mDateSelectionView;
@property (nonatomic, retain) NumberSelectionView* mDaysSelectionView;
@end

@implementation PeriodSettingViewController
@synthesize mDelegate;
@synthesize mInitPeriod;
@synthesize mCurPeriod;
@synthesize mTableView;
@synthesize mDateSelectionView;
@synthesize mDaysSelectionView;

- (id) initWithInitPeriod:(Period*)aPeriod
{
    self = [super init];
    if (self) {
        self.mInitPeriod = aPeriod;
        self.mCurPeriod = aPeriod;
        if (!self.mCurPeriod)
        {
            Period* sPeriod = [[Period alloc] init];
            sPeriod.mStartDate = [NSDate date];
            sPeriod.mDurationDays = [Period getCommonDurationDays];
            sPeriod.mPeriodDays = [Period getCommonPeriodDays];
                
            self.mCurPeriod = sPeriod;
            [sPeriod release];
        }
    }
    return self;
}

- (void) dealloc
{
    self.mInitPeriod = nil;
    self.mCurPeriod = nil;
    self.mTableView = nil;
    self.mDateSelectionView = nil;
    self.mDaysSelectionView = nil;
    
    [super dealloc];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat sHeightOfBtnBar = 44;
    CGFloat sX = 0;
    CGFloat sY = 0;
    CGFloat sWidth = 320;
    CGFloat sHeight = sHeightOfBtnBar;

    UINavigationBar* sBtnBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    sBtnBar.barStyle = UIBarStyleDefault;
//    [sBtnBar setTintColor:MAIN_BGCOLOR];
    
    UINavigationItem* sNavItem = [[[UINavigationItem alloc] initWithTitle:NSLocalizedString(@"Set Period", nil) ] autorelease];
    
    sNavItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Ok", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(confirmBtnPressed)] autorelease];
    sNavItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(cancelBtnPressed)] autorelease];
    
    [sBtnBar pushNavigationItem:sNavItem animated:NO];
    
    [self.view addSubview:sBtnBar];
    [sBtnBar release];
    
    sY += sHeight+20;
    sHeight = self.view.bounds.size.height-sY;
    
    UITableView* sTableView = [[UITableView alloc] initWithFrame:CGRectMake(sX, sY, sWidth, sHeight) style:UITableViewStyleGrouped];
    sTableView.dataSource = self;
    sTableView.delegate = self;
    sTableView.autoresizesSubviews = YES;
    sTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    sTableView.backgroundColor = [UIColor whiteColor];
    sTableView.scrollEnabled = NO;
    [sTableView setBackgroundView:nil];
    [sTableView setBackgroundColor:[UIColor clearColor]];
    
    
    
    [self.view addSubview:sTableView];
    
    self.mTableView = sTableView;
    [sTableView release];

}

- (void) resetPeriod:(Period*)aPeriod
{
    if (aPeriod)
    {
        self.mInitPeriod = aPeriod;
        self.mCurPeriod = aPeriod;
        
        [self.mTableView reloadData];
    }
}

- (void) cancelBtnPressed
{
    if ([self.mDelegate respondsToSelector:@selector(cancel)])
    {
        [self.mDelegate cancel];
    }
}

- (void) confirmBtnPressed
{
    if ([self.mDelegate respondsToSelector:@selector(confirmWith:)])
    {
        [self.mDelegate confirmWith:self.mCurPeriod];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        
        CustomCellBackgroundView* sBGView = [CustomCellBackgroundView backgroundCellViewWithFrame:cell.frame Row:[indexPath row] totalRow:[tableView numberOfRowsInSection:[indexPath section]] borderColor:SELECTED_CELL_COLOR fillColor:SELECTED_CELL_COLOR tableViewStyle:tableView.style];
        cell.selectedBackgroundView = sBGView;

    }

    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = NSLocalizedString(@"Menstrual Starting", nil);
            if (self.mCurPeriod)
            {
                cell.detailTextLabel.text = [NSDateFormatter standardyyyyMMddFormatedString:self.mCurPeriod.mStartDate];
            }
            else
            {
                cell.detailTextLabel.text = NSLocalizedString(@"No records", nil);
            }
        }
            break;
        case 1:
        {
            cell.textLabel.text = NSLocalizedString(@"Menstrual Ending", nil);
            if (self.mCurPeriod)
            {
                cell.detailTextLabel.text = [NSDateFormatter standardyyyyMMddFormatedString:[self.mCurPeriod getEndDate]];
            }
            else
            {
                cell.detailTextLabel.text = NSLocalizedString(@"No records", nil);
            }
        }
            break;
        case 2:
        {
            cell.textLabel.text = NSLocalizedString(@"Period Length", nil);
            if (self.mCurPeriod)
            {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%d%@", self.mCurPeriod.mPeriodDays, NSLocalizedString(@"day(s)", nil)];
            }
            else
            {
                cell.detailTextLabel.text = NSLocalizedString(@"No records", nil);
            }
        }
            break;
            
        default:
            break;
    }
        
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger sRow = indexPath.row;
    
    if (0 == sRow
        || 1 == sRow)
    {
        if (!self.mDateSelectionView)
        {
            DateSelectionView* sDateSelectionView = [[DateSelectionView alloc] initWithFrame:self.view.bounds Title:NSLocalizedString(@"Set Menstrual Starting Date", nil) InitDate:self.mCurPeriod.mStartDate MinDate:MIN_DATE_START_DATE MaxDate:MAX_DATE_START_DATE];
            sDateSelectionView.mDelegate = self;
            self.mDateSelectionView = sDateSelectionView;
            [sDateSelectionView release];
        }

        if (0 == sRow)
        {
            self.mDateSelectionView.tag = TAG_START_DATE_SELECTION_VIEW;
            [self.mDateSelectionView resetInitDate:self.mCurPeriod.mStartDate];
            [self.mDateSelectionView resetMinDate:MIN_DATE_START_DATE MaxDate:MAX_DATE_START_DATE];
            [self.mDateSelectionView resetTitle:NSLocalizedString(@"Set Menstrual Starting Date", nil)];
            [self pushPopView:self.mDateSelectionView];
        }
        else if (1 == sRow)
        {
            self.mDateSelectionView.tag = TAG_END_DATE_SELECTION_VIEW;
            [self.mDateSelectionView resetInitDate:[self.mCurPeriod getEndDate]];
            [self.mDateSelectionView resetMinDate:[self.mCurPeriod getMinEndDateOnStartDate] MaxDate:[self.mCurPeriod getMaxEndDateOnStartDate]];
            [self.mDateSelectionView resetTitle:NSLocalizedString(@"Set Menstrual Ending Date", nil)];
            [self pushPopView:self.mDateSelectionView];
        }
    }
    else if (2 == sRow)
    {
        if (!self.mDaysSelectionView)
        {
            NumberSelectionView* sPeriodDaysSelectionView = [[NumberSelectionView alloc] initWithFrame:self.view.bounds Title:NSLocalizedString(@"Set Period Length", nil) InitDigit:self.mCurPeriod.mPeriodDays MinDigit:[Period getMinPeriodDays] MaxDigit:[Period getMaxPeriodDays]];
            sPeriodDaysSelectionView.mDelegate = self;
            self.mDaysSelectionView = sPeriodDaysSelectionView;
            [sPeriodDaysSelectionView release];
        }
        
        [self.mDaysSelectionView resetInitDigit:self.mCurPeriod.mPeriodDays];
        [self pushPopView:self.mDaysSelectionView];

    }
    else
    {
        //nothing
    }
}

- (void) pushPopView:(UIView*)aView
{
    if (aView.superview == self.view)
    {
        CATransition *animation = [CATransition  animation];
        animation.delegate = self;
        animation.duration = 0.3;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.type = kCATransitionPush;
        animation.subtype = kCATransitionFromLeft;
        [aView setAlpha:0.0f];
        [aView.layer addAnimation:animation forKey:@"pushOut"];
        [aView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.3];
    }
    else
    {
        CATransition *animation = [CATransition  animation];
        animation.delegate = self;
        animation.duration = 0.3;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.type = kCATransitionPush;
        animation.subtype = kCATransitionFromRight;
        [aView setAlpha:1.0f];
        [aView.layer addAnimation:animation forKey:@"pushIn"];
    
        [self.view addSubview:aView];
    }
}

#pragma mark -  DateSelectionDelegate
- (void) dateSelectionView:(UIView*)aDateSelectionView doneWithDate:(NSDate*)aDateSelected aIsDiffFromInitDate:(BOOL)aDateIsNew
{
    if (aDateIsNew)
    {
        if (aDateSelectionView.tag == TAG_START_DATE_SELECTION_VIEW)
        {
            self.mCurPeriod.mStartDate = aDateSelected;
            [self.mCurPeriod setEndDate:[self.mCurPeriod getCommonEndDateOnStartDate]];
        }
        else if (aDateSelectionView.tag == TAG_END_DATE_SELECTION_VIEW)
        {
            if (![self.mCurPeriod setEndDate:aDateSelected])
            {
                //invalid setting
            }
        }
    }
    [self.mTableView reloadData];
    [self pushPopView:aDateSelectionView];
    
}

#pragma mark - NumberSelectionDelegate
- (void) numberDigitView:(UIView*)aDigitSelectionView doneWithDigit:(NSInteger)aDigitSelected aIsDiffFromInitDigit:(BOOL)aDigitIsNew
{
    if (aDigitIsNew)
    {
        self.mCurPeriod.mPeriodDays = aDigitSelected;
    }
    [self.mTableView reloadData];
    [self pushPopView:aDigitSelectionView];
}

@end
