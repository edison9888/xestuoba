//
//  AdSpotManager.h
//  AboutSex
//
//  Created by Wen Shane on 13-5-11.
//
//

#import <Foundation/Foundation.h>
#import "SpotAdapter.h"

typedef enum _E_SPOT_AD_TYPE
{
    E_SPOT_AD_TYPE_Youmi,
    E_SPOT_AD_TYPE_Guomob,
//    E_SPOT_AD_TYPE_Waps,
    
}E_SPOT_AD_TYPE;


@interface AdSpotManager : NSObject

+ (SpotAdapter*) spotAdapter;


@end
