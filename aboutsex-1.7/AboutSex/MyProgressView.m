//
//  MyProgressView.m
//  AboutSex
//
//  Created by Wen Shane on 13-6-25.
//
//

#import "MyProgressView.h"

@interface MyProgressView()
{
    UILabel* mProgressLabel;
}

@property (nonatomic, retain)  UILabel* mProgressLabel;
@end

@implementation MyProgressView
@synthesize mProgressLabel;

- (id)initWithFrame:(CGRect)frame andTrackColor:(UIColor*)aTrackColor ProgressColor:(UIColor*)aProgressColor
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UILabel* sTrackLabel = [[UILabel alloc] initWithFrame:self.bounds];
        sTrackLabel.backgroundColor = aTrackColor;
        [self addSubview:sTrackLabel];
        [sTrackLabel release];
        
        UILabel* sProgressLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        sProgressLabel.backgroundColor = aProgressColor;
        [self addSubview:sProgressLabel];
        self.mProgressLabel = sProgressLabel;
        [sProgressLabel release];

    }
    return self;
}

- (void) dealloc
{
    self.mProgressLabel = nil;
    [super dealloc];
}

- (void)setProgress:(CGFloat)precent
{
    CGFloat sWidth = self.frame.size.width * precent;
    [self.mProgressLabel setFrame:CGRectMake(0, 0, sWidth,self.frame.size.height)];
}

@end
