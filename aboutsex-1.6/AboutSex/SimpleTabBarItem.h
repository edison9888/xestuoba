//
//  SimpleTabBarItem.h
//  BTT
//
//  Created by Wen Shane on 12-12-8.
//  Copyright (c) 2012年 Wen Shane. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIControlLarge.h"

//the data utility for simple tab bar
@interface SimpleTabBarItem : UIControlLarge

@property (nonatomic, assign) BOOL mSelected;
@property (nonatomic, copy) NSString * mTitle;
@property (nonatomic, retain) UIImage* mImage;
@property (nonatomic, retain) UIImage* mSelectedImage;


@property (nonatomic, retain) UIColor* mTitleColor;
@property (nonatomic, retain) UIFont* mTitleFont;
@property (nonatomic, retain) UIColor* mSelectedTitleColor;

@property (nonatomic, retain) UIColor* mBackGroundColor;
@property (nonatomic, retain) UIColor* mSelectedBackGroundColor;

@property (nonatomic, retain) UIColor* mBackgroundColorGradientStart;
@property (nonatomic, retain) UIColor* mBackgroundColorGradientEnd;
@property (nonatomic, retain) UIColor* mSelectedBackgroundColorGradientStart;
@property (nonatomic, retain) UIColor* mSelectedBackgroundColorGradientEnd;


@property (nonatomic, assign) BOOL mBackgroundWithGradient;

+ (SimpleTabBarItem *)itemWithTitle:(NSString *)title;

//+ (SimpleTabBarItem *)itemWithTitle:(NSString *)title andBackgroundColor:(UIColor*)aBackgroundColor;
//
//
//+ (SimpleTabBarItem *)itemWithImage:(UIImage *)aImage AndSelectedImage:(UIImage *)aSelectedImage;


@end
