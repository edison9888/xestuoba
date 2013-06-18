//
//  InsetLabel.h
//  AboutSex
//
//  Created by Wen Shane on 13-6-14.
//
//

#import <UIKit/UIKit.h>

@interface InsetLabel : UILabel

@property(nonatomic) UIEdgeInsets insets;
-(id) initWithFrame:(CGRect)frame andInsets: (UIEdgeInsets) insets;
-(id) initWithInsets: (UIEdgeInsets) insets;

@end
