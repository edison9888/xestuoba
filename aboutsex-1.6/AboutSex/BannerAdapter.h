//
//  AdBanner.h
//  AboutSex
//
//  Created by Wen Shane on 13-5-9.
//
//

#import <UIKit/UIKit.h>
#import "SharedVariables.h"


@protocol AdBannerDelegate <NSObject>

@optional
- (void) didGetAd:(BOOL)aSuccess;

@end


@interface BannerAdapter : UIView
{
}
@property (nonatomic, assign) id<AdBannerDelegate> mDelegate;

@end
