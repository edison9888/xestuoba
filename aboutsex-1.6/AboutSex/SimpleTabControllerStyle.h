//
//  SimpleTabControllerStyle.h
//  BTT
//
//  Created by Wen Shane on 12-12-9.
//  Copyright (c) 2012年 Wen Shane. All rights reserved.
//

#import <Foundation/Foundation.h>

//often-used styles of  SimpleTabControllerStyleType
typedef enum{
    
    ENUM_SIMPLE_TAB_CONTROLLER_STYLE_DEFAULT,
    ENUM_SIMPLE_TAB_CONTROLLER_STYLE1,
    ENUM_SIMPLE_TAB_CONTROLLER_STYLE2,
    ENUM_SIMPLE_TAB_CONTROLLER_STYLE3,
    
}SimpleTabControllerStyleType;


//the type of back text
typedef enum{
    ENUM_BACK_TEXT_TYPE_ROOTNAV_TITLE,
    ENUM_BACK_TEXT_TYPE_FIRST_LEVEL_TABBARITEM_TITLE,
    ENUM_BACK_TEXT_TYPE_RETURN,
}EnumBackTextType;

//the style of SimpleTabControllerStyleType
@interface SimpleTabControllerStyle: NSObject
{
    UIColor* mTabBarColor;  //color of tab bar
    BOOL mTabBarColorWithGradient;  //
    BOOL mTabHaveSperator;  //whether there is a seperator line between bar items
    UIEdgeInsets mTabBarPadding;    //padding for tab bar
  
    UIColor* mItemTitleColor;   //title color of bar item
    UIColor* mItemSelectedTitleColor;   //title color of selected bar item
    
    UIColor* mItemBackGroundColor;  //bg color of item
    UIColor* mItemSelectedBackGroundColor;  //bg color for selected item.
    
    UIColor* mItemBackgroundColorGradientStart; //below 4 members are for item gradient coloring.
    UIColor* mItemBackgroundColorGradientEnd;
    UIColor* mItemSelectedBackgroundColorGradientStart;
    UIColor* mItemSelectedBackgroundColorGradientEnd;
    
    UIFont* mItemFont;  //font of item title
    
    BOOL mItemHaveUnderscore;   //whether there is a underscore
    BOOL mItemSwitchWithAnimation;  //whether there is a animition when being switched
    
    BOOL mItemBackgroundWithGradient; //whether there is a background gradient

    EnumBackTextType mBackTextType; //type of back text.
}
@property (nonatomic, retain) UIColor* mTabBarColor;
@property (nonatomic, assign) BOOL mTabHaveSperator;
@property (nonatomic, assign) BOOL mTabBarColorWithGradient;
@property (nonatomic, assign) UIEdgeInsets mTabBarPadding;

@property (nonatomic, retain) UIColor* mItemTitleColor;
@property (nonatomic, retain) UIColor* mItemSelectedTitleColor;

@property (nonatomic, retain) UIColor* mItemBackGroundColor;
@property (nonatomic, retain) UIColor* mItemSelectedBackGroundColor;

@property (nonatomic, retain) UIColor* mItemBackgroundColorGradientStart;
@property (nonatomic, retain) UIColor* mItemBackgroundColorGradientEnd;
@property (nonatomic, retain) UIColor* mItemSelectedBackgroundColorGradientStart;
@property (nonatomic, retain) UIColor* mItemSelectedBackgroundColorGradientEnd;

@property (nonatomic, retain) UIFont* mItemFont;
@property (nonatomic, assign) BOOL mItemHaveUnderscore;
@property (nonatomic, assign) BOOL mItemSwitchWithAnimation;
@property (nonatomic, assign) BOOL mItemBackgroundWithGradient;
@property (nonatomic, assign) EnumBackTextType mBackTextType;


//get style of simple tab bar with type
+ (SimpleTabControllerStyle*) getSimpleTabControllerStyleByType:(SimpleTabControllerStyleType)aType;

@end

