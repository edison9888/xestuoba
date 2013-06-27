//
//  NumberSelectionView.h
//  AboutSex
//
//  Created by Wen Shane on 13-6-23.
//
//

#import <UIKit/UIKit.h>

@protocol NumberSelectionDelegate <NSObject>

@optional
- (void) numberDigitView:(UIView*)aDigitSelectionView doneWithDigit:(NSInteger)aDigitSelected aIsDiffFromInitDigit:(BOOL)aDigitIsNew;

@end


@interface NumberSelectionView : UIView<UIPickerViewDataSource, UIPickerViewDelegate>
{
    id<NumberSelectionDelegate> mDelegate;
}

@property (nonatomic, assign)    id<NumberSelectionDelegate> mDelegate;
- (id)initWithFrame:(CGRect)frame Title:(NSString*)aTitle InitDigit:(NSInteger)aInitDigit MinDigit:(NSInteger)aMinDigit MaxDigit:(NSInteger)aMaxDigit;
- (void) resetInitDigit:(NSInteger)aInitDigit;

@end
