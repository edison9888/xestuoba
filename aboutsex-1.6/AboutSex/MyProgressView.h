//
//  MyProgressView.h
//  AboutSex
//
//  Created by Wen Shane on 13-6-25.
//
//

#import <UIKit/UIKit.h>

@interface MyProgressView : UIView

- (id)initWithFrame:(CGRect)frame andTrackColor:(UIColor*)aTrackColor ProgressColor:(UIColor*)aProgressColor;
- (void)setProgress:(CGFloat)precent;

@end
