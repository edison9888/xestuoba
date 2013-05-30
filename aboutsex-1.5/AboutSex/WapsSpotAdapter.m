//
//  WapsSpotAdapter.m
//  AboutSex
//
//  Created by Wen Shane on 13-5-11.
//
//

#import "WapsSpotAdapter.h"
#import "WapsOffer/AppConnect.h"

@implementation WapsSpotAdapter


- (void) showSpot
{
    [AppConnect showPopAd:[UIApplication sharedApplication].keyWindow.rootViewController];
}

@end
