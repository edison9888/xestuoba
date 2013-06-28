//
//  AdBannerManager.m
//  AboutSex
//
//  Created by Wen Shane on 13-5-9.
//
//

#import "AdBannerManager.h"
#import "GmBannerAdapter.h"
#import "YoumiBannerAdapter.h"
#import "MobClick.h"


@implementation AdBannerManager


+ (BannerAdapter*) adBannerWithPlaceType:(E_BANNER_AD_PLACE_TYPE)aPlaceType
{
    E_BANNER_AD_TYPE sType = [self getAdTypeByPlaceType:aPlaceType];
    if (sType == E_BANNER_AD_TYPE_Disable)
    {
        return nil;
    }
    
    return [self adBannerWithAdType:sType];
}


+ (BannerAdapter*) adBannerWithAdType:(E_BANNER_AD_TYPE)aType
{
    BannerAdapter* sBanner = nil;
    CGRect sFrame = CGRectMake(0, 0, 320, 50);
    switch (aType)
    {
        case E_BANNER_AD_TYPE_Youmi:
            sBanner = [[[YoumiBannerAdapter alloc] initWithFrame:sFrame] autorelease];
            break;
        case E_BANNER_AD_TYPE_Guomob:
            sBanner = [[[GmBannerAdapter alloc] initWithFrame:sFrame] autorelease];
            break;
        default:
            sBanner = [[[GmBannerAdapter alloc] initWithFrame:sFrame] autorelease];
            break;
    }
    
    return sBanner;
}

+ (E_BANNER_AD_TYPE) getAdTypeByPlaceType:(E_BANNER_AD_PLACE_TYPE)aPlaceType
{
    NSString* sPlaceTypeKey = nil;
    switch (aPlaceType)
    {
        case E_BANNER_AD_PLACE_TYPE_PAGE:
            sPlaceTypeKey = @"UPID_AD_BANNER_TYPE_PAGE";
            break;
        case E_BANNER_AD_PLACE_TYPE_LIBRARY:
            sPlaceTypeKey = @"UPID_AD_BANNER_TYPE_LIB";
            break;
        default:
            break;
    }
    
    E_BANNER_AD_TYPE sADType;
    if (sPlaceTypeKey.length > 0)
    {
        NSString* sAdName = [MobClick getConfigParams:sPlaceTypeKey];
        if (sAdName.length > 0)
        {
            if ([sAdName caseInsensitiveCompare:@"Youmi"] == NSOrderedSame)
            {
                sADType = E_BANNER_AD_TYPE_Youmi;
            }
            else if ([sAdName caseInsensitiveCompare:@"Guomob"] == NSOrderedSame)
            {
                sADType = E_BANNER_AD_TYPE_Guomob;
            }
            else if ([sAdName caseInsensitiveCompare:@"Miidi"] == NSOrderedSame)
            {
                sADType = E_BANNER_AD_TYPE_Miidi;
            }
            else if ([sAdName caseInsensitiveCompare:@"Disable"] == NSOrderedSame)
            {
                sADType = E_BANNER_AD_TYPE_Disable;
            }
            else
            {
                sADType = E_BANNER_AD_TYPE_Disable;
            }
        }
        else
        {
            sADType = E_BANNER_AD_TYPE_Disable;
        }
    }
    else
    {
        sADType = E_BANNER_AD_TYPE_Disable;      
    }
    
    return sADType;
}


@end
