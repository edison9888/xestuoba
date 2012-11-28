//
//  UserConfiger.m
//  AboutSex
//
//  Created by Wen Shane on 12-11-28.
//
//

#import "UserConfiger.h"


#define NIGHT_MODE_SETTING          @"night_mode_setting"
#define FONT_SIZE_SETTING           @"font_size_setting"

@implementation UserConfiger

+ (BOOL) isNightModeOn
{
    NSUserDefaults* sDefaults = [NSUserDefaults standardUserDefaults];
    
    BOOL sIsNightModeOn;
    if ([sDefaults objectForKey:NIGHT_MODE_SETTING])
    {
        sIsNightModeOn = [((NSNumber*)[sDefaults objectForKey:NIGHT_MODE_SETTING]) boolValue];
    }
    else
    {
        sIsNightModeOn = NO;
    }
    return sIsNightModeOn;
}

+ (void) setNightMode:(BOOL)aIsNightMode
{
    NSUserDefaults* sDefaults = [NSUserDefaults standardUserDefaults];
    [sDefaults setBool:aIsNightMode forKey:NIGHT_MODE_SETTING];
}

+ (ENUM_FONT_SIZE_TYPE) getFontSizeType
{
    NSUserDefaults* sDefaults = [NSUserDefaults standardUserDefaults];
    ENUM_FONT_SIZE_TYPE sFontSize;
    if ([sDefaults objectForKey:FONT_SIZE_SETTING])
    {
        sFontSize = [((NSNumber*)[sDefaults objectForKey:FONT_SIZE_SETTING]) integerValue]; 
    }
    else
    {
        sFontSize = ENUM_FONT_SIZE_NORMAL;
    }
    return sFontSize;
}

+ (void) setFontSizeType:(ENUM_FONT_SIZE_TYPE)aFontSizeType
{
    NSUserDefaults* sDefaults = [NSUserDefaults standardUserDefaults];
    [sDefaults setInteger:aFontSizeType forKey:FONT_SIZE_SETTING];
}


+ (NSInteger) getFontSizeScalePercentByFontSizeType:(ENUM_FONT_SIZE_TYPE)aFontSizeType
{
    NSInteger sFontSize;
    switch (aFontSizeType) {
        case ENUM_FONT_SIZE_SMALL:
        {
            sFontSize = 80; //70%
        }
            break;
        case ENUM_FONT_SIZE_NORMAL:
        {
            sFontSize = 100; //100%
        }
            break;
        case ENUM_FONT_SIZE_LARGE:
        {
            sFontSize = 120; //%150
        }
            break;
        default:
        {
            sFontSize = 100; //100%
        }
            break;
    }
    return sFontSize;
}


@end
