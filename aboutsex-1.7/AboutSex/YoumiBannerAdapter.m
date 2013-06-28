//
//  YoumiBannerAdapter.m
//  AboutSex
//
//  Created by Wen Shane on 13-5-9.
//
//

#import "YoumiBannerAdapter.h"
#import "YouMiView.h"

@implementation YoumiBannerAdapter

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        YouMiView *sAdBanner=[[YouMiView alloc] initWithContentSizeIdentifier:YouMiBannerContentSizeIdentifier320x50 delegate:self];
        sAdBanner.frame = CGRectMake(0, 0, CGRectGetWidth(sAdBanner.bounds), CGRectGetHeight(sAdBanner.bounds));
        sAdBanner.indicateBackgroundColor = [UIColor clearColor];
        sAdBanner.textColor = MAIN_BGCOLOR;
        sAdBanner.subTextColor = MAIN_BGCOLOR;
        sAdBanner.indicateTranslucency = YES;
        sAdBanner.indicateRounded = YES;
        sAdBanner.indicateBorder = NO;
        [sAdBanner start];
        [self addSubview:sAdBanner];
        [sAdBanner release];
    }
    return self;
}

#pragma mark - YouMiDelegate
- (void)didReceiveAd:(YouMiView *)adView
{
    if ([self.mDelegate respondsToSelector:@selector(didGetAd:)])
    {
        [self.mDelegate didGetAd:YES];
    }
}

- (void)didFailToReceiveAd:(YouMiView *)adView  error:(NSError *)error
{
    if ([self.mDelegate respondsToSelector:@selector(didGetAd:)])
    {
        [self.mDelegate didGetAd:NO];
    }
}
@end
