//
//  SimpleTabControllerStyle.m
//  BTT
//
//  Created by Wen Shane on 12-12-9.
//  Copyright (c) 2012年 Wen Shane. All rights reserved.
//

#import "SimpleTabControllerStyle.h"
#import "SharedVariables.h"

@implementation SimpleTabControllerStyle

@synthesize mTabBarColor;
@synthesize mTabBarColorWithGradient;
@synthesize mTabHaveSperator;
@synthesize mTabBarPadding;

@synthesize mItemTitleColor;
@synthesize mItemSelectedTitleColor;

@synthesize mItemBackGroundColor;
@synthesize mItemSelectedBackGroundColor;

@synthesize mItemBackgroundColorGradientStart;
@synthesize mItemBackgroundColorGradientEnd;
@synthesize mItemSelectedBackgroundColorGradientStart;
@synthesize mItemSelectedBackgroundColorGradientEnd;

@synthesize mItemFont;
@synthesize mItemHaveUnderscore;
@synthesize mItemSwitchWithAnimation;
@synthesize mItemBackgroundWithGradient;
@synthesize mBackTextType;

- (id) init
{
    self = [super init];
    if (self)
    {
        self.mTabBarColor = [UIColor clearColor];
        self.mTabBarColorWithGradient = NO;
        self.mTabHaveSperator = YES;
        self.mTabBarPadding = UIEdgeInsetsMake(10, 0, 5, 0);
        
        self.mItemTitleColor = [UIColor blackColor];
        self.mItemSelectedTitleColor = [UIColor redColor];
        self.mItemBackGroundColor = [UIColor whiteColor];
        self.mItemSelectedBackGroundColor = [UIColor whiteColor];
        self.mItemFont = [UIFont systemFontOfSize:16];
        self.mItemHaveUnderscore = YES;
        self.mItemSwitchWithAnimation = YES;
        
        self.mItemBackgroundWithGradient = NO;
        self.mBackTextType = ENUM_BACK_TEXT_TYPE_ROOTNAV_TITLE;
    }
    return self;
}
- (void) dealloc
{
    self.mTabBarColor = nil;
    
    self.mItemTitleColor = nil;
    self.mItemSelectedTitleColor = nil;
    
    self.mItemBackGroundColor = nil;
    self.mItemSelectedBackGroundColor = nil;

    self.mItemBackgroundColorGradientStart = nil;
    self.mItemBackgroundColorGradientEnd = nil;
    self.mItemSelectedBackgroundColorGradientStart = nil;
    self.mItemSelectedBackgroundColorGradientEnd = nil;
    
    self.mItemFont = nil;
    
    [super dealloc];
}

+ (SimpleTabControllerStyle*) getSimpleTabControllerStyleByType:(SimpleTabControllerStyleType)aType
{
    switch (aType) {
        case ENUM_SIMPLE_TAB_CONTROLLER_STYLE_DEFAULT:
        {
            return [self getDefaultSimpleTabControllerStyle];
        }
            break;
        case ENUM_SIMPLE_TAB_CONTROLLER_STYLE1:
        {
            return [self getSimpleTabControllerStyle1];
        }
            break;
        case ENUM_SIMPLE_TAB_CONTROLLER_STYLE2:
        {
            return [self getSimpleTabControllerStyle2];
        }
            break;
        case ENUM_SIMPLE_TAB_CONTROLLER_STYLE3:
        {
            return [self getSimpleTabControllerStyle3];
        }
            break;
        default:
        {
            return [self getDefaultSimpleTabControllerStyle];         
        }
            break;
    }
}

+ (SimpleTabControllerStyle*) getDefaultSimpleTabControllerStyle
{
    return [self getSimpleTabControllerStyle1];
}

+ (SimpleTabControllerStyle*) getSimpleTabControllerStyle1
{
    SimpleTabControllerStyle* sStyle = [[[SimpleTabControllerStyle alloc] init] autorelease];
    
    sStyle.mTabBarColor = RGBA_COLOR(235, 235, 235, 1);
    sStyle.mItemTitleColor = [UIColor blackColor];
    sStyle.mItemSelectedTitleColor = RGBA_COLOR(243, 129, 44, 1);
    sStyle.mItemBackGroundColor = [UIColor clearColor];
    sStyle.mItemSelectedBackGroundColor = [UIColor clearColor];
    sStyle.mItemFont = [UIFont systemFontOfSize:16];
    sStyle.mItemHaveUnderscore = YES;
    sStyle.mItemSwitchWithAnimation = YES;
    sStyle.mTabHaveSperator = YES;
    sStyle.mBackTextType = ENUM_BACK_TEXT_TYPE_RETURN;
    
    return sStyle;
}

+ (SimpleTabControllerStyle*) getSimpleTabControllerStyle2
{
    SimpleTabControllerStyle* sStyle = [[[SimpleTabControllerStyle alloc] init] autorelease];
    
    sStyle.mTabBarColor =  RGBA_COLOR(222, 222, 222, 1);
    sStyle.mTabHaveSperator = NO;

    
    sStyle.mItemTitleColor = [UIColor blackColor];
    sStyle.mItemSelectedTitleColor = [UIColor blackColor];
    sStyle.mItemBackGroundColor = RGBA_COLOR(222, 222, 222, 1);
    sStyle.mItemSelectedBackGroundColor = RGBA_COLOR(202, 202, 202, 1);
    sStyle.mItemFont = [UIFont systemFontOfSize:14];
    sStyle.mItemHaveUnderscore = NO;
    sStyle.mItemSwitchWithAnimation = NO;
    
    sStyle.mItemBackgroundWithGradient = YES;
    sStyle.mItemBackgroundColorGradientStart = RGBA_COLOR(253, 253, 253, 1);
    sStyle.mItemBackgroundColorGradientEnd = RGBA_COLOR(206, 206, 206, 1);
    sStyle.mItemSelectedBackgroundColorGradientStart = RGBA_COLOR(173, 173, 173, 1);
    sStyle.mItemSelectedBackgroundColorGradientEnd = RGBA_COLOR(223, 223, 223, 1);
    
    
    return sStyle;

}

+ (SimpleTabControllerStyle*) getSimpleTabControllerStyle3
{
    SimpleTabControllerStyle* sStyle = [[[SimpleTabControllerStyle alloc] init] autorelease];
    
    sStyle.mTabBarColor = RGBA_COLOR(163, 163, 163, 1);
    sStyle.mItemTitleColor = [UIColor blackColor];
    sStyle.mItemSelectedTitleColor = RGBA_COLOR(255, 0, 23, 1);
    sStyle.mItemBackGroundColor = RGBA_COLOR(163, 163, 163, 1);
    sStyle.mItemSelectedBackGroundColor = RGBA_COLOR(216, 216, 216, 1);
    sStyle.mItemFont = [UIFont systemFontOfSize:13];
    sStyle.mItemHaveUnderscore = NO;
    sStyle.mItemSwitchWithAnimation = NO;
    sStyle.mTabHaveSperator = NO;
    return sStyle;

}





@end
