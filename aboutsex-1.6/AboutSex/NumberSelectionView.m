//
//  NumberSelectionView.m
//  AboutSex
//
//  Created by Wen Shane on 13-6-23.
//
//

#import "NumberSelectionView.h"

@interface NumberSelectionView()
{
    NSInteger mInitDigit;
    NSInteger mMinDitit;
    NSInteger mMaxDitit;
    UINavigationBar* mNavBar;
    UIPickerView* mDatePicker;
    
    
}

@property (nonatomic, assign)  NSInteger mInitDigit;
@property (nonatomic, assign)   NSInteger mMinDitit;
@property (nonatomic, assign)   NSInteger mMaxDitit;
@property (nonatomic, retain)  UINavigationBar* mNavBar;
@property (nonatomic, retain)  UIPickerView* mDatePicker;

@end

@implementation NumberSelectionView
@synthesize mDelegate;
@synthesize mInitDigit;
@synthesize mMinDitit;
@synthesize mMaxDitit;
@synthesize mNavBar;
@synthesize mDatePicker;

- (id)initWithFrame:(CGRect)frame Title:(NSString*)aTitle InitDigit:(NSInteger)aInitDigit MinDigit:(NSInteger)aMinDigit MaxDigit:(NSInteger)aMaxDigit
{
    self = [super initWithFrame:frame];
    if (self) {
        self.mInitDigit = aInitDigit;
        self.mMinDitit = aMinDigit;
        self.mMaxDitit = aMaxDigit;
        [self preparePickerViewWithTitle:aTitle];
    }
    return self;
}

- (void) dealloc
{
    self.mNavBar = nil;
    self.mDatePicker = nil;
    
    [super dealloc];
}

- (void) preparePickerViewWithTitle:(NSString*)aTitle
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
    
    UINavigationItem* sNavItem = [[[UINavigationItem alloc] initWithTitle:aTitle] autorelease];
    sNavItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Ok", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(cfmBtnPressed)] autorelease];
    sNavItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(cancelBtnPressed)] autorelease];
    
    
    [self.mNavBar pushNavigationItem:sNavItem animated:NO];
    [self addSubview:self.mNavBar];
    
    sY += sHeight;
    sHeight = sHeightOfDatePicker;
    
    //2. datepicker
    self.mDatePicker = [[[UIPickerView alloc] initWithFrame:CGRectMake(0, sY, self.bounds.size.width, sHeight)] autorelease];
    self.mDatePicker.dataSource = self;
    self.mDatePicker.delegate = self;
    self.mDatePicker.showsSelectionIndicator = YES;
    
    CGFloat sSystemHeightOfPicker = self.mDatePicker.bounds.size.height;
    if (sSystemHeightOfPicker != sHeightOfDatePicker)
    {
        CGAffineTransform sTransform = CGAffineTransformMakeScale(1, sHeightOfDatePicker/sSystemHeightOfPicker);
        self.mDatePicker.transform = sTransform;
        self.mDatePicker.center = CGPointMake(self.mDatePicker.center.x, sY+sHeightOfDatePicker/2);
    }
    
    [self addSubview:self.mDatePicker];
    
    //3. init
    [self setMInitDigit:self.mInitDigit];
}

- (void) resetInitDigit:(NSInteger)aInitDigit
{
    self.mInitDigit = aInitDigit;
}

- (void) setMInitDigit:(NSInteger)aInitDigit
{
    mInitDigit = aInitDigit;
    NSInteger sRow = [self rowForValue:mInitDigit];
    if (sRow >= 0)
    {
        [self.mDatePicker selectRow:sRow inComponent:0 animated:NO];
    }
}

- (void) cfmBtnPressed
{
    if ([self.mDelegate respondsToSelector:@selector(numberDigitView:doneWithDigit:aIsDiffFromInitDigit:)])
    {
        NSInteger sNewValue = [self valueForSelectedRow];
        [self.mDelegate numberDigitView:self doneWithDigit:sNewValue aIsDiffFromInitDigit:sNewValue!=self.mInitDigit];
    }
}

- (void) cancelBtnPressed
{
    if ([self.mDelegate respondsToSelector:@selector(numberDigitView:doneWithDigit:aIsDiffFromInitDigit:)])
    {
        [self.mDelegate numberDigitView:self doneWithDigit:[self valueForSelectedRow] aIsDiffFromInitDigit:NO];
    }
}

- (NSInteger) valueForRow:(NSInteger)aRow
{
    return self.mMinDitit+aRow;
}

- (NSInteger) rowForValue:(NSInteger)aValue
{
    NSInteger sRow = aValue-self.mMinDitit;
    if (sRow >= 0)
    {
        return sRow;
    }
    else
    {
        return -1;
    }
}

- (NSInteger) valueForSelectedRow
{
    return [self valueForRow:[self.mDatePicker selectedRowInComponent:0]];
}

#pragma mark -
#pragma mark UIPickerViewDataSource methods for UIPickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.mMaxDitit-self.mMinDitit+1;
}

#pragma mark -
#pragma mark UIPickerViewDelegate methods for UIPickerView
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0)
    {
        return [NSString stringWithFormat:@"%d", [self valueForRow:row]];
    }
    else
    {
        return nil;
    }
}


@end
