//
//  UserConfiger.m
//  AboutSex
//
//  Created by Wen Shane on 12-11-28.
//
//

#import "UserConfiger.h"
#import "SharedVariables.h"


#define NIGHT_MODE_SETTING          @"night_mode_setting"
#define FONT_SIZE_SETTING           @"font_size_setting"

static UIView* sBackgroundView = nil;

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

+ (void) constructAndAddNightModeViewIfNeeded
{
    if (!sBackgroundView)
    {
        CGRect sScreenBounds = [[UIScreen mainScreen] bounds];
        sBackgroundView = [[UIView alloc] initWithFrame:sScreenBounds];
        sBackgroundView.backgroundColor = [UIColor blackColor];
        sBackgroundView.userInteractionEnabled = NO;
        sBackgroundView.alpha = 0.0;
        [[[UIApplication sharedApplication] keyWindow] addSubview:sBackgroundView];
    }
    [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:sBackgroundView];
}

+ (void) setNightMode:(BOOL)aIsNightMode
{
    NSUserDefaults* sDefaults = [NSUserDefaults standardUserDefaults];
    [sDefaults setBool:aIsNightMode forKey:NIGHT_MODE_SETTING];
    
    NSTimeInterval sAnimDuration = 0.2;
    //disable animation for the first time night mode setting(the time when the app launches).
    if (!sBackgroundView)
    {
        sAnimDuration = 0;
    }
    [self constructAndAddNightModeViewIfNeeded];

    if (aIsNightMode)
    {
        [UIView animateWithDuration:sAnimDuration   animations:^{
            sBackgroundView.alpha = 0.7;
        } completion:^(BOOL finished){
            NSLog(@"done making it dark"); }];
    }
    else
    {
        [UIView animateWithDuration:sAnimDuration   animations:^{
            sBackgroundView.alpha = 0.0;
        } completion:^(BOOL finished){
            NSLog(@"done making it bright"); }];
    }
//    [[UIApplication sharedApplication] setStatusBarHidden:aIsNightMode withAnimation:UIStatusBarAnimationFade];
//    [[[[UIApplication sharedApplication] keyWindow] rootViewController]view] .frame= [[UIScreen mainScreen] applicationFrame];

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
