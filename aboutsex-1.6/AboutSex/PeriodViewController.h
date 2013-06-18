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


typedef enum _ENUM_DAY_PERIOD_STATUS{
    ENUM_DAY_PERIOD_STATUS_EMMENIA,
    ENUM_DAY_PERIOD_STATUS_OVULATION,
    ENUM_DAY_PERIOD_STATUS_SAFE,
    
}ENUM_DAY_PERIOD_STATUS;

@interface PeriodViewController : TKCalendarMonthViewController<UIActionSheetDelegate, DMCustomViewControllerDelegate>

@end
