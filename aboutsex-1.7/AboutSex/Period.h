//
//  Period.h
//  AboutSex
//
//  Created by Wen Shane on 13-6-21.
//
//

#import <Foundation/Foundation.h>

@interface Period : NSObject<NSCoding>
{
    NSDate* mStartDate;
    NSInteger mDurationDays;
    NSInteger mPeriodDays;
}

@property (nonatomic, retain) NSDate* mStartDate;
@property (nonatomic, assign) NSInteger mDurationDays;
@property (nonatomic, assign) NSInteger mPeriodDays;


- (NSDate*) getEndDate;
- (BOOL) setEndDate:(NSDate*)aDate;

- (NSDate*) getMinEndDateOnStartDate;
- (NSDate*) getMaxEndDateOnStartDate;
- (NSDate*) getCommonEndDateOnStartDate;



+ (NSInteger) getMinPeriodDays;
+ (NSInteger) getMaxPeriodDays;
+ (NSInteger) getCommonDurationDays;
+ (NSInteger) getCommonPeriodDays;


@end
