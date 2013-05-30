//
//  YoumiSpotAdapter.m
//  AboutSex
//
//  Created by Wen Shane on 13-5-12.
//
//

#import "YoumiSpotAdapter.h"
#import "YouMiSpot.h"


@implementation YoumiSpotAdapter

- (id) init
{
    self = [super init];
    if (self)
    {
        [YouMiSpot requestSpotADs]; // you must requst spot ad much ealier before showing it.
    }
    return self;
}


- (void) showSpot
{
    [YouMiSpot showSpotDismiss:^{
        
    }];
}

@end
