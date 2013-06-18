//
//  NSDateFormatter+MyDateFormatter.m
//  AboutSex
//
//  Created by Shane Wen on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSDateFormatter+MyDateFormatter.h"
#import "NSDate+MyDate.h"
#import "NSDate-Utilities.h"


static NSDateFormatter* SDateFormatter = nil;


@implementation NSDateFormatter (MyDateFormatter)

+ (NSDateFormatter*) getDateFormatter
{
    if (!SDateFormatter)
    {
        SDateFormatter = [[NSDateFormatter alloc]init];
    }
    return SDateFormatter;
}


- (void) setLocaleTimeZone
{
    [self setTimeZone:[NSTimeZone localTimeZone]];
}

- (NSString*) stringFromDateForStreams: (NSDate*)aDate ForLastUpdateTime:(BOOL)aNeedPastTime
{
    NSString* sDateStr;
    
    NSTimeZone* localzone = [NSTimeZone localTimeZone];  
    [self setTimeZone:localzone];  

    
    if  ([aDate isToday])
    {
        NSDate* sNowDate = [NSDate date];
        NSTimeInterval sTimeIntervalBeforeNow = -[aDate timeIntervalSinceDate:sNowDate];

        if (sTimeIntervalBeforeNow < 5*SECONDS_FOR_ONE_HOUR)
        {
            if (sTimeIntervalBeforeNow < 1*SECONDS_FOR_ONE_HOUR)
            {
                if (sTimeIntervalBeforeNow < SECONDS_FOR_ONE_MINUTE)
                {
                    sDateStr = [NSString stringWithFormat:@"%d秒钟前", (NSInteger)(sTimeIntervalBeforeNow)];
                }
                else 
                {    
                    sDateStr = [NSString stringWithFormat:@"%d分钟前", (NSInteger)(sTimeIntervalBeforeNow/60)];
                }
            }
            else 
            {
                sDateStr = [NSString stringWithFormat:@"%d小时前", (NSInteger)(sTimeIntervalBeforeNow/(60*60))];
            }
        }
        else
        {
            [self setDateFormat:@"HH:mm"];       
            sDateStr = [self stringFromDate:aDate];
        }

    }
    else if ([aDate isYesterday])
    {
        [self setDateFormat:@"HH:mm"];
        sDateStr = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Yesterday", nil), [self stringFromDate:aDate]];
    }
    else
    {
        if (aNeedPastTime)
        {
            [self setDateFormat:@"M月d日 HH:mm"];
        }
        else
        {
            [self setDateFormat:@"M月d日"];
        }
        sDateStr = [self stringFromDate:aDate];
    }
    
    return sDateStr;
    
}

+ (NSString*) createTimeStringForCommentDate:(NSDate*)aDate
{
    NSDateFormatter* sDF = [self getDateFormatter];
    
    [sDF setLocaleTimeZone];
    
    return [sDF stringFromDateForStreams: aDate ForLastUpdateTime:YES];
}

+ (NSString*) lastUpdateTimeStringForDate:(NSDate*)aDate
{
    NSDateFormatter* sDF = [self getDateFormatter];
    
    [sDF setLocaleTimeZone];

    return [sDF stringFromDateForStreams:aDate ForLastUpdateTime:NO];
    
}

+ (NSString*) standardyyyyMMddFormatedString: (NSDate*)aDate
{
    NSDateFormatter* sDF = [self getDateFormatter];
    
    [sDF setLocaleTimeZone];
    
    NSString* sDateStr;
    
    [sDF setDateFormat:@"yyyy-MM-dd"];
    sDateStr = [sDF stringFromDate:aDate];
    
    return sDateStr;
}

+ (NSString*) standardyyyyMMddHHmmFormatedString: (NSDate*)aDate
{
    NSDateFormatter* sDF = [self getDateFormatter];
    
    [sDF setLocaleTimeZone];
    
    NSString* sDateStr;
    
    [sDF setDateFormat:@"yyyy-MM-dd HH:mm"];
    sDateStr = [sDF stringFromDate:aDate];
    
    return sDateStr;
}

+ (NSString*) standardYMDFormatedStringLeadigZero: (NSDate*)aDate
{
    NSDateFormatter* sDF = [self getDateFormatter];
    
    [sDF setLocaleTimeZone];
    
    NSString* sDateStr;
    
    [sDF setDateFormat:@"yyyy-MM-dd"];
    sDateStr = [sDF stringFromDate:aDate];
    
    return sDateStr;
}

+ (NSString*) standardMDFormatedStringCN: (NSDate*)aDate
{
    NSDateFormatter* sDF = [self getDateFormatter];
    
    [sDF setLocaleTimeZone];
    
    NSString* sDateStr;
    
    NSString* sFormatStr = [NSString stringWithFormat:@"M%@d%@", NSLocalizedString(@"month", nil), NSLocalizedString(@"day", nil)];
    [sDF setDateFormat:sFormatStr];
    sDateStr = [sDF stringFromDate:aDate];
    
    return sDateStr;
}

+ (NSString*) standardYMDFormatedStringLeadigZeroCN: (NSDate*)aDate
{
    NSDateFormatter* sDF = [self getDateFormatter];
    
    [sDF setLocaleTimeZone];
    
    NSString* sDateStr;
    
    NSString* sFormatStr = [NSString stringWithFormat:@"yyyy%@M%@d%@", NSLocalizedString(@"year", nil), NSLocalizedString(@"month", nil), NSLocalizedString(@"day", nil)];
    [sDF setDateFormat:sFormatStr];
    sDateStr = [sDF stringFromDate:aDate];
    
    return sDateStr;
}


+ (NSString*) mmssFromSeconds:(NSTimeInterval)aSeconds
{
    return [NSString stringWithFormat:@"%02d:%02d", (int)aSeconds/60, (int)aSeconds % 60, nil];
}

+ (NSString*) weekDay:(NSDate*)aDate
{
    NSDateFormatter* sDF = [self getDateFormatter];
    
    [sDF setLocaleTimeZone];
    
    NSString* sDateStr;
    
    NSString* sFormatStr = @"eee";
    [sDF setDateFormat:sFormatStr];
    sDateStr = [sDF stringFromDate:aDate];
    
    return sDateStr;
}

@end
