//
//  UIControlLarge.m
//  AboutSex
//
//  Created by Wen Shane on 13-6-16.
//
//

#import "UIControlLarge.h"

@implementation UIControlLarge
@synthesize mMarginInsets;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        self.mMarginInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect largerFrame = CGRectMake(0 - self.mMarginInsets.left, 0 - self.mMarginInsets.top, self.frame.size.width + self.mMarginInsets.left+self.mMarginInsets.right, self.frame.size.height + self.mMarginInsets.top+self.mMarginInsets.bottom);
    if (CGRectContainsPoint(largerFrame, point) == 1)
    {
        return self;
    }
    else
    {
        return nil;
    }
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
