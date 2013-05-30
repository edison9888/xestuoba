//
//  AdBanner.m
//  AboutSex
//
//  Created by Wen Shane on 13-5-9.
//
//

#import "BannerAdapter.h"

@interface BannerAdapter()
{
    id<AdBannerDelegate> mDelegate;
}


@end


@implementation BannerAdapter
@synthesize mDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void) dealloc
{
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
