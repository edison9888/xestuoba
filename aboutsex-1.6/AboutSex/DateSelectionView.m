//
//  DateSelectionView.m
//  AboutSex
//
//  Created by Wen Shane on 13-6-23.
//
//

#import "DateSelectionView.h"

#import "DateSelectionView.h"
#import "NSDate+MyDate.h"
#import "NSDateFormatter+MyDateFormatter.h"

#import "SharedVariables.h"

@interface DateSelectionView()
{
    UINavigationBar* mNavBar;
    UIDatePicker* mDatePicker;
    NSDate* mDateSelected;
    NSDate* mInitDate;
}

@property (nonatomic, retain) UINavigationBar* mNavBar;
@property (nonatomic, retain) UIDatePicker* mDatePicker;
@property (nonatomic, retain) NSDate* mDateSelected;
@property (nonatomic, retain) NSDate* mInitDate;

@end


@implementation DateSelectionView

@synthesize mNavBar;
@synthesize mDatePicker;
@synthesize mInitDate;
@synthesize mDateSelected;
@synthesize mDelegate;

- (id)initWithFrame:(CGRect)frame Title:(NSString*)aTitle InitDate:(NSDate*)aInitDate MinDate:(NSDate*)aMinDate MaxDate:(NSDate*)aMaxDate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.mInitDate = aInitDate;
        [self prepareDatePickerWithInitDate:aInitDate Title:aTitle MinDate:aMinDate MaxDate:aMaxDate];
    }
    return self;
}

- (void) dealloc
{
    self.mNavBar = nil;
    self.mDatePicker = nil;
    self.mDateSelected = nil;
    self.mInitDate = nil;
    
    [super dealloc];
}

- (void) resetInitDate:(NSDate*)aInitDate;
{
    self.mInitDate = aInitDate;
    if (self.mInitDate)
    {
        self.mDateSelected = self.mInitDate;
    }
    else
    {
        self.mDateSelected = [NSDate date];
    }
    
    [self.mDatePicker setDate:self.mDateSelected animated:NO];
    [self refreshNavBar];
}

- (void) resetMinDate:(NSDate*)aMinDate MaxDate:(NSDate*)aMaxDate
{
    if (aMinDate)
    {
        self.mDatePicker.minimumDate = aMinDate;
    }
    if (aMaxDate)
    {
        self.mDatePicker.maximumDate = aMaxDate;      
    }
}

- (void) resetTitle:(NSString*)aTitle
{
    self.mNavBar.topItem.title = aTitle;
}

- (void) prepareDatePickerWithInitDate:(NSDate*)aInitDate Title:(NSString*)aTitle MinDate:(NSDate*)aMinDate MaxDate:(NSDate*)aMaxDate
{
    //    CGFloat sHeightOfDatePicker = 216;
    
    //1. button bar
    CGFloat sHeightOfNavBar = 44;
    CGFloat sHeightOfDatePicker = self.bounds.size.height - sHeightOfNavBar;
    CGFloat sX = 0;
    CGFloat sY = 0;
    CGFloat sWidth = self.bounds.size.width;
    CGFloat sHeight = sHeightOfNavBar;
    self.mNavBar = [[[UINavigationBar alloc] initWithFrame:CGRectMake(sX, sY, sWidth, sHeight)] autorelease];
    self.mNavBar.barStyle = UIBarStyleDefault;
    
    UINavigationItem* sNavItem = [[[UINavigationItem alloc] initWithTitle: [NSDateFormatter standardYMDFormatedStringLeadigZero:self.mInitDate] ] autorelease];
    sNavItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(cfmBtnPressed)] autorelease];
    sNavItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(cancelBtnPressed)] autorelease];
    sNavItem.title = aTitle;
    
    [self.mNavBar pushNavigationItem:sNavItem animated:NO];
    [self addSubview:self.mNavBar];
    
    sY += sHeight;
    sHeight = sHeightOfDatePicker;
    
    //2. datepicker
    self.mDatePicker = [[[UIDatePicker alloc] initWithFrame:CGRectMake(0, sY, 100, sHeight)] autorelease];
    self.mDatePicker.timeZone = [NSTimeZone localTimeZone];
    self.mDatePicker.datePickerMode = UIDatePickerModeDate;
    self.mDatePicker.minimumDate = aMinDate;
    self.mDatePicker.maximumDate = aMaxDate;
    [self.mDatePicker setDate: self.mInitDate animated:NO];
    [self.mDatePicker addTarget:self action:@selector(datePickerValueChange) forControlEvents:UIControlEventValueChanged];
    
    
    CGFloat sSystemHeightOfPicker = self.mDatePicker.bounds.size.height;
    if (sSystemHeightOfPicker != sHeightOfDatePicker)
    {
        CGAffineTransform sTransform = CGAffineTransformMakeScale(1, sHeightOfDatePicker/sSystemHeightOfPicker);
        self.mDatePicker.transform = sTransform;
        self.mDatePicker.center = CGPointMake(self.mDatePicker.center.x, sY+sHeightOfDatePicker/2);
    }
    
    [self addSubview:self.mDatePicker];
}

- (void) datePickerValueChange
{
    self.mDateSelected = [self.mDatePicker date];
    [self refreshNavBar];
}

- (void) refreshNavBar
{
//    self.mNavBar.topItem.title = [NSDateFormatter standardYMDFormatedStringLeadigZero:self.mDateSelected];
    
}

- (void) cfmBtnPressed
{
    if (self.mInitDate
        && [self.mDateSelected isSameDayWith:self.mInitDate])
    {
        if ([self.mDelegate respondsToSelector:@selector(dateSelectionView:doneWithDate:aIsDiffFromInitDate:)])
        {
            [self.mDelegate dateSelectionView:self doneWithDate:self.mInitDate aIsDiffFromInitDate:NO];          
        }
    }
    else
    {
        if ([self.mDelegate respondsToSelector:@selector(dateSelectionView:doneWithDate:aIsDiffFromInitDate:)])
        {
            [self.mDelegate dateSelectionView:self doneWithDate:self.mDateSelected aIsDiffFromInitDate:YES]; 
        }
    }
}

- (void) cancelBtnPressed
{
    [self.mDelegate dateSelectionView:self doneWithDate:self.mInitDate aIsDiffFromInitDate:NO];
}

@end
