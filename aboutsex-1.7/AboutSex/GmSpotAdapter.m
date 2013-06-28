//
//  GmSpotAdapter.m
//  AboutSex
//
//  Created by Wen Shane on 13-5-13.
//
//

#import "GmSpotAdapter.h"
#import "SharedVariables.h"

@interface GmSpotAdapter()
{
    GMInterstitialAD* mSpotAd;
}

@property (nonatomic, retain) GMInterstitialAD* mSpotAd;
@end


@implementation GmSpotAdapter
@synthesize mSpotAd;


- (id) init
{
    self = [super init];
    if (self)
    {
        GMInterstitialAD* sSpotAD = [[GMInterstitialAD alloc] initWithId:SECRET_KEY_GUOMENG];
        sSpotAD.delegate = self;
        [sSpotAD loadInterstitialAd:NO];
        
        
        self.mSpotAd = sSpotAD;
        [sSpotAD release];
    }
    return self;
}

- (void) dealloc
{
    self.mSpotAd.delegate = nil;
    [self.mSpotAd removeFromSuperview];
    self.mSpotAd = nil;
    
    [super dealloc];
}

- (void) showSpot
{
    [self.mSpotAd loadInterstitialAd:NO];
    if([self.mSpotAd superview])
    {
        [self.mSpotAd removeFromSuperview];
    }
    
    UIView* sContainerView = [[UIApplication sharedApplication] keyWindow].rootViewController.view;
    
    [sContainerView addSubview:self.mSpotAd];
}

#pragma mark - GMInterstitialDelegate
- (void)loadInterstitialAdSuccess:(BOOL)success
{
    return;
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:viewControllerToPresent animated:flag completion:completion];
    return;
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] dismissViewControllerAnimated:flag completion:completion];
}



@end
