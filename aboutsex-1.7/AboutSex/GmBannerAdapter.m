//
//  GmBannerAdapter.m
//  AboutSex
//
//  Created by Wen Shane on 13-5-9.
//
//

#import "GmBannerAdapter.h"
#import "GuomobAdSDK.h"
#import "SharedVariables.h"

@interface GmBannerAdapter()
{
    GuomobAdSDK* mBannerAD;
}
@property (nonatomic, retain) GuomobAdSDK* mBannerAD;

@end

@implementation GmBannerAdapter
@synthesize mBannerAD;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        GuomobAdSDK* sBannerAD=[GuomobAdSDK initWithAppId:SECRET_KEY_GUOMENG delegate:self];
        sBannerAD.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width);
        [self addSubview:sBannerAD];
        
        [sBannerAD loadAd];
        
        self.mBannerAD = sBannerAD;
    }
    
    return self;
}

- (void) dealloc
{
    self.mBannerAD.delegate = nil;
    self.mBannerAD = nil;
    
    [super dealloc];
}


#pragma mark - GuomobAdSDKDelegate
- (void)loadBannerAdSuccess:(BOOL)success
{
    if ([self.mDelegate respondsToSelector:@selector(didGetAd:)])
    {
        [self.mDelegate didGetAd:success];
    }
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
