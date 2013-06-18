//
//  AdSpotManager.m
//  AboutSex
//
//  Created by Wen Shane on 13-5-11.
//
//

#import "AdSpotManager.h"
#import "WapsSpotAdapter.h"
#import "YoumiSpotAdapter.h"
#import "GmSpotAdapter.h"
#import "MobClick.h"

@implementation AdSpotManager

+ (SpotAdapter*) spotAdapter
{
    static SpotAdapter* sSpot = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        E_SPOT_AD_TYPE sType;
        sType = [self getADSpotType];
        //
        
        switch (sType)
        {
//            case E_SPOT_AD_TYPE_Waps:
//                sSpot = [[WapsSpotAdapter alloc] init];
//                break;
            case E_SPOT_AD_TYPE_Youmi:
                sSpot = [[YoumiSpotAdapter alloc] init];
                break;
            case E_SPOT_AD_TYPE_Guomob:
                sSpot = [[GmSpotAdapter alloc] init];
                break;
            default:
                sSpot = [[YoumiSpotAdapter alloc] init];
                break;
        }
    });
    
    return sSpot;
}


+ (E_SPOT_AD_TYPE) getADSpotType
{
    NSString* sAdName = [MobClick getConfigParams:@"UPID_AD_SPOT_TYPE"];
    
    E_SPOT_AD_TYPE sADType = E_SPOT_AD_TYPE_Youmi;
    if (sAdName.length > 0)
    {
        if ([sAdName caseInsensitiveCompare:@"Youmi"] == NSOrderedSame)
        {
            sADType = E_SPOT_AD_TYPE_Youmi;
        }
        else if ([sAdName caseInsensitiveCompare:@"Guomob"] == NSOrderedSame)
        {
            sADType = E_SPOT_AD_TYPE_Guomob;
        }
//        else if ([sAdName caseInsensitiveCompare:@"Waps"] == NSOrderedSame)
//        {
//            sADType = E_SPOT_AD_TYPE_Waps;
//        }
        else
        {
            sADType = E_SPOT_AD_TYPE_Youmi;
        }
    }
    
    return sADType;
}

@end
