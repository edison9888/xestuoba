//
//  PeriodViewController.h
//  AboutSex
//
//  Created by Wen Shane on 13-5-25.
//
//

#import <UIKit/UIKit.h>
#import "TapkuLibrary.h"
#import "DMCustomModalViewController.h"
#import "PeriodSettingViewController.h"


typedef enum _ENUM_DAY_PERIOD_STATUS{
    ENUM_DAY_PERIOD_STATUS_UNKNOWN,
    ENUM_DAY_PERIOD_STATUS_MENSTRUAL,
    ENUM_DAY_PERIOD_STATUS_OVULATORY,
    ENUM_DAY_PERIOD_STATUS_SAFE,
    
}ENUM_DAY_PERIOD_STATUS;

@interface PeriodViewController : TKCalendarMonthViewController<PeriodSettingDelegate>

+ (ENUM_DAY_PERIOD_STATUS) getStatusForDate:(NSDate*)aDate;

@end
