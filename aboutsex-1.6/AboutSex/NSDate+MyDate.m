//
//  NSDate+MyDate.m
//  AboutSex
//
//  Created by Shane Wen on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSDate+MyDate.h"

@implementation NSDate (MyDate)

- (BOOL) isSameDayWith:(NSDate*)aDate
{
    
    NSCalendar *sCalendar = [NSCalendar currentCalendar];
    
    NSTimeZone* localzone = [NSTimeZone localTimeZone];  
    [sCalendar setTimeZone:localzone];  
    
    int unit =NSMonthCalendarUnit |NSYearCalendarUnit |NSDayCalendarUnit;
    NSDateComponents *fistComponets = [sCalendar components: unit fromDate: self];
    NSDateComponents *secondComponets = [sCalendar components: unit fromDate: aDate];
    if ([fistComponets day] == [secondComponets day]
        && [fistComponets month] == [secondComponets month]
        && [fistComponets year] == [secondComponets year])
    {
        return YES;
    }
    return NO;
}

- (BOOL) isSameMonth:(NSDate*)aDate
{
    NSCalendar *sCalendar = [NSCalendar currentCalendar];
    NSTimeZone* localzone = [NSTimeZone localTimeZone];  
    [sCalendar setTimeZone:localzone];  
    
    int unit =NSMonthCalendarUnit |NSYearCalendarUnit;
    NSDateComponents *fistComponets = [sCalendar components: unit fromDate: self];
    NSDateComponents *secondComponets = [sCalendar components: unit fromDate: aDate];
    if ([fistComponets month] == [secondComponets month]
        && [fistComponets year] == [secondComponets year])
    {
        return YES;
    }
    return NO;
}


- (BOOL) isInRecentDaysBefore: (NSDate*)sDate NumberOfDays:(NSInteger)aNumberOfDays
{
    NSTimeInterval sTimeIntervalForStartDateOfTheDay = [[sDate startDateOfTheDayinLocalTimezone] timeIntervalSince1970];
    
    
    NSTimeInterval sTimeIntervalForStartDay = sTimeIntervalForStartDateOfTheDay-(aNumberOfDays-1)*SECONDS_FOR_ONE_DAY;
    NSTimeInterval sTimeIntervalForEndDay = sTimeIntervalForStartDateOfTheDay+SECONDS_FOR_ONE_DAY; 
    
    if ([self timeIntervalSince1970] >= sTimeIntervalForStartDay
        && [self timeIntervalSince1970] <= sTimeIntervalForEndDay)
    {
        return YES;
    }
    else {
        return NO;
    }
    
}

- (NSDate*) startDateOfTheDayinLocalTimezone
{
    
    NSTimeInterval sTimeInterval = [self timeIntervalSince1970]; 
    NSInteger secondsFromGMT = [[NSTimeZone localTimeZone]secondsFromGMT];
    NSTimeInterval sRemainder = ((NSUInteger)(sTimeInterval+secondsFromGMT))%((NSUInteger)SECONDS_FOR_ONE_DAY);
    NSTimeInterval sStartTimeIntervalOfTheDay = sTimeInterval - sRemainder;
    NSDate* sDate = [NSDate dateWithTimeIntervalSince1970:sStartTimeIntervalOfTheDay];

    return sDate;
}

- (NSDate*) midDayOftheDayInLocalTimezone
{
    NSDate* sDateForStartDay = [self startDateOfTheDayinLocalTimezone];
    NSDate* sDateForMidDay = [sDateForStartDay dateByAddingTimeInterval:SECONDS_FOR_ONE_DAY/2];
    return sDateForMidDay;
}

- (NSDate*) endDateOfTheDayinLocalTimezone
{
    NSDate* sStartDateofTheDayInLocalTimeZone = [self startDateOfTheDayinLocalTimezone];
    NSDate* sDate = [sStartDateofTheDayInLocalTimeZone dateByAddingTimeInterval:SECONDS_FOR_ONE_DAY-1];
    
    return sDate;
}

- (NSInteger) ceilingDaysSinceStartingOfDate:(NSDate*)aDate
{
    NSDate* sStartingOfDate = [aDate startDateOfTheDayinLocalTimezone];
    NSDate* sEndOfDate = [self endDateOfTheDayinLocalTimezone];
    NSTimeInterval sTimeInterval = [sEndOfDate timeIntervalSinceDate:sStartingOfDate];
    
    NSInteger sDays = ceil(sTimeInterval/((CGFloat)(SECONDS_FOR_ONE_DAY)));
    return sDays;
}


@end
