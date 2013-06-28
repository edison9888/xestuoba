//
//  UserConfiger.h
//  AboutSex
//
//  Created by Wen Shane on 12-11-28.
//
//

#import <Foundation/Foundation.h>

typedef enum _ENUM_FONT_SIZE_TYPE
{
    ENUM_FONT_SIZE_SMALL,
    ENUM_FONT_SIZE_NORMAL,
    ENUM_FONT_SIZE_LARGE,
}ENUM_FONT_SIZE_TYPE;


@interface UserConfiger : NSObject

+ (BOOL) isNightModeOn;
+ (void) setNightMode:(BOOL)aIsNightMode;

+ (void) setFontSizeType:(ENUM_FONT_SIZE_TYPE)aFontSizeType;
+ (ENUM_FONT_SIZE_TYPE) getFontSizeType;

+ (NSInteger) getFontSizeScalePercentByFontSizeType:(ENUM_FONT_SIZE_TYPE)aFontSizeType;

@end
