//
//  PeriodSettingViewController.h
//  AboutSex
//
//  Created by Wen Shane on 13-6-7.
//
//

#import <UIKit/UIKit.h>
#import "Period.h"
#import "DateSelectionView.h"
#import "NumberSelectionView.h"


@protocol PeriodSettingDelegate <NSObject>

- (void) cancel;
- (void) confirmWith:(Period*)aPeriod;

@end


@interface PeriodSettingViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, DateSelectionDelegate, NumberSelectionDelegate>
{
    id<PeriodSettingDelegate> mDelegate;
}
@property (nonatomic, assign) id<PeriodSettingDelegate> mDelegate;

- (id) initWithInitPeriod:(Period*)aPeriod;

- (void) resetPeriod:(Period*)aPeriod;
@end
