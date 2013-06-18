//
//  NSDateFormatter+MyDateFormatter.h
//  AboutSex
//
//  Created by Shane Wen on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (MyDateFormatter)

- (NSString*) stringFromDateForStreams: (NSDate*)aDate ForLastUpdateTime:(BOOL)aNeedPastTime;
+ (NSString*) createTimeStringForCommentDate:(NSDate*)aDate;
+ (NSString*) lastUpdateTimeStringForDate:(NSDate*)aDate;
+ (NSString*) standardyyyyMMddHHmmFormatedString: (NSDate*)aDate;
+ (NSString*) standardyyyyMMddFormatedString: (NSDate*)aDate;
+ (NSString*) standardYMDFormatedStringLeadigZero: (NSDate*)aDate;


+ (NSString*) standardMDFormatedStringCN: (NSDate*)aDate;
+ (NSString*) standardYMDFormatedStringLeadigZeroCN: (NSDate*)aDate;

+ (NSString*) weekDay:(NSDate*)aDate;

+ (NSString*) mmssFromSeconds:(NSTimeInterval)aSeconds;
@end
