//
//  Period.m
//  AboutSex
//
//  Created by Wen Shane on 13-6-21.
//
//

#import "Period.h"
#import "NSDate+MyDate.h"


#define MIN_DURATION_DAYS   3
#define MAX_DURATION_DAYS   9
#define COMMON_DURATION_DAYS 6
#define COMMON_PERIOD_DAYS 28
#define MIN_PERIOD_DAYS 25
#define MAX_PERIOD_DAYS 31

@implementation Period
@synthesize mStartDate;
@synthesize mDurationDays;
@synthesize mPeriodDays;

- (id) initWithCoder:(NSCoder *)aCoder
{
    self.mStartDate = [aCoder decodeObjectForKey:@"startDate"];
    self.mDurationDays = ((NSNumber*)[aCoder decodeObjectForKey:@"duationDays"]).integerValue;
    self.mPeriodDays = ((NSNumber*)[aCoder decodeObjectForKey:@"periodDays"]).integerValue;
    
    return self;
}

- (void) dealloc
{
    self.mStartDate = nil;
    
    [super dealloc];
}

- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.mStartDate forKey:@"startDate"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.mDurationDays] forKey:@"duationDays"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.mPeriodDays] forKey:@"periodDays"];
}

- (NSDate*) getEndDate
{
    NSDate* sDate = [self.mStartDate dateByAddingTimeInterval:(self.mDurationDays-1)*SECONDS_FOR_ONE_DAY];
    return sDate;
}

- (BOOL) setEndDate:(NSDate*)aDate
{
    if (!aDate)
    {
        return NO;
    }
    
    NSInteger sDurationDays = [aDate ceilingDaysSinceStartingOfDate:self.mStartDate];
    if (sDurationDays < MIN_DURATION_DAYS
        || sDurationDays > MAX_DURATION_DAYS)
    {
        return NO;
    }
    self.mDurationDays = sDurationDays;
    return YES;
}

- (NSDate*) getMinEndDateOnStartDate
{
    NSDate* sDate = [self.mStartDate dateByAddingTimeInterval:(MIN_DURATION_DAYS-1)*SECONDS_FOR_ONE_DAY];
    return sDate;
}

- (NSDate*) getMaxEndDateOnStartDate
{
    NSDate* sDate = [self.mStartDate dateByAddingTimeInterval:(MAX_DURATION_DAYS-1)*SECONDS_FOR_ONE_DAY];
    return sDate;
}

- (NSDate*) getCommonEndDateOnStartDate
{
    NSDate* sDate = [self.mStartDate dateByAddingTimeInterval:(COMMON_DURATION_DAYS-1)*SECONDS_FOR_ONE_DAY];
    return sDate;
}

+ (NSInteger) getMinPeriodDays
{
    return MIN_PERIOD_DAYS;
}

+ (NSInteger) getMaxPeriodDays
{
    return MAX_PERIOD_DAYS;
}

+ (NSInteger) getCommonDurationDays
{
    return COMMON_DURATION_DAYS;
}

+ (NSInteger) getCommonPeriodDays
{
    return COMMON_PERIOD_DAYS;
}


@end
