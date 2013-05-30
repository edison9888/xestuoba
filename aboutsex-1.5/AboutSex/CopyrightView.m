//
//  CopyrightView.m
//  FatCamp
//
//  Created by Wen Shane on 12-11-24.
//  Copyright (c) 2012年 Wen Shane. All rights reserved.
//

#import "CopyrightView.h"

@implementation CopyrightView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel* sCoporationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
//        sCoporationLabel.center = CGPointMake(frame.size.width/2, sCoporationLabel.center.y);
        sCoporationLabel.backgroundColor = [UIColor clearColor];
        sCoporationLabel.textColor = [UIColor lightGrayColor];
        sCoporationLabel.textAlignment = UITextAlignmentCenter;
        sCoporationLabel.font = [UIFont italicSystemFontOfSize:10];
//        sCoporationLabel.text = [NSString stringWithFormat:@"%@ %@", @"©2012", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]];
        sCoporationLabel.text = [NSString stringWithFormat:@"%@ %@", @"©2013", @"Tinyapps.cn"];

        
        [self addSubview:sCoporationLabel];
        [sCoporationLabel release];
    }
    return self;
}


+ (CopyrightView*) getView
{
    CGRect sRect = CGRectMake(0, 0, 320, 30);
    CopyrightView* sView = [[[CopyrightView alloc] initWithFrame:sRect] autorelease];
    
    return sView;
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
