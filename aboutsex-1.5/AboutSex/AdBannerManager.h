//
//  AdBannerManager.h
//  AboutSex
//
//  Created by Wen Shane on 13-5-9.
//
//

#import <Foundation/Foundation.h>
#import "BannerAdapter.h"


typedef enum _E_BANNER_AD_PLACE_TYPE
{
    E_BANNER_AD_PLACE_TYPE_PAGE,
    E_BANNER_AD_PLACE_TYPE_LIBRARY,
        
}E_BANNER_AD_PLACE_TYPE;


typedef enum _E_BANNER_AD_TYPE
{
    E_BANNER_AD_TYPE_Youmi,
    E_BANNER_AD_TYPE_Guomob,
    E_BANNER_AD_TYPE_Miidi,
    E_BANNER_AD_TYPE_Dianru,
    E_BANNER_AD_TYPE_Baidu,
    E_BANNER_AD_TYPE_Ader,
    E_BANNER_AD_TYPE_Disable,
    
}E_BANNER_AD_TYPE;


@interface AdBannerManager : NSObject

//return nil if ad is disabled for this ad place type.
+ (BannerAdapter*) adBannerWithPlaceType:(E_BANNER_AD_PLACE_TYPE)aType;


@end
