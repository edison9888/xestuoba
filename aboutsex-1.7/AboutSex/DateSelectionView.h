//
//  DateSelectionView.h
//  AboutSex
//
//  Created by Wen Shane on 13-6-23.
//
//

#import <UIKit/UIKit.h>

@protocol DateSelectionDelegate <NSObject>

@optional
- (void) dateSelectionView:(UIView*)aDateSelectionView doneWithDate:(NSDate*)aDateSelected aIsDiffFromInitDate:(BOOL)aDateIsNew;

@end

@interface DateSelectionView : UIView
{
    id<DateSelectionDelegate> mDelegate;
}


@property (nonatomic, assign) id<DateSelectionDelegate> mDelegate;

- (id)initWithFrame:(CGRect)frame Title:(NSString*)aTitle InitDate:(NSDate*)aInitDate MinDate:(NSDate*)aMinDate MaxDate:(NSDate*)aMaxDate;
- (void) resetInitDate:(NSDate*)aInitDate;
- (void) resetMinDate:(NSDate*)aMinDate MaxDate:(NSDate*)aMaxDate;
- (void) resetTitle:(NSString*)aTitle;

@end
