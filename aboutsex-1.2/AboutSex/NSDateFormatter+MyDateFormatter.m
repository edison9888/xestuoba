//
//  NSDateFormatter+MyDateFormatter.m
//  AboutSex
//
//  Created by Shane Wen on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSDateFormatter+MyDateFormatter.h"
#import "NSDate+MyDate.h"




@implementation NSDateFormatter (MyDateFormatter)

- (NSString*) stringFromDateForStreams: (NSDate*)aDate
{
    NSString* sDateStr;
    
    NSTimeZone* localzone = [NSTimeZone localTimeZone];  
    [self setTimeZone:localzone];  

    
    NSDate* sNowDate = [NSDate date];
    NSTimeInterval sTimeIntervalBeforeNow = -[aDate timeIntervalSinceDate:sNowDate];
    if  ([aDate isSameDayWith:sNowDate])
    {
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
    else 
    {
        [self setDateFormat:@"M月d日"];
        sDateStr = [self stringFromDate:aDate];
    }
    
    return sDateStr;
    
}


@end
