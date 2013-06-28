//
//  SimpleTabBarItem.m
//  BTT
//
//  Created by Wen Shane on 12-12-8.
//  Copyright (c) 2012年 Wen Shane. All rights reserved.
//

#import "SimpleTabBarItem.h"
#import <QuartzCore/QuartzCore.h>

@interface SimpleTabBarItem ()
{
    
    BOOL mSelected;
    UILabel* mTitleLabel;
    
    NSString* mTitle;
    UIImage* mImage;
    UIImage* mSelectedImage;
    
    UIFont* mTitleFont;
    UIColor* mTitleColor;
    UIColor* mSelectedTitleColor;
    UIColor* mBackGroundColor;
    UIColor* mSelectedBackGroundColor;
    
    BOOL mBackgroundWithGradient;
    UIColor* mBackgroundColorGradientStart;
    UIColor* mBackgroundColorGradientEnd;
    UIColor* mSelectedBackgroundColorGradientStart;
    UIColor* mSelectedBackgroundColorGradientEnd;

    
    CAGradientLayer* mBackgroundGadientLayer;
}

@property (nonatomic, retain) UILabel* mTitleLabel;
@property (nonatomic, retain) CAGradientLayer* mBackgroundGadientLayer;

@end


@implementation SimpleTabBarItem

@synthesize mSelected;
@synthesize mTitleLabel;
@synthesize mImage;
@synthesize mSelectedImage;

@synthesize mTitleFont;
@synthesize mTitle;
@synthesize mTitleColor;
@synthesize mSelectedTitleColor;
@synthesize mBackGroundColor;
@synthesize mSelectedBackGroundColor;

@synthesize mBackgroundColorGradientStart;
@synthesize mBackgroundColorGradientEnd;
@synthesize mSelectedBackgroundColorGradientStart;
@synthesize mSelectedBackgroundColorGradientEnd;

@synthesize mBackgroundWithGradient;
@synthesize mBackgroundGadientLayer;

- (id)initWithFrame:(CGRect)frame WithTitle:(NSString *)title WithBackGroundColor:(UIColor*) aBackGroundColor
{
    return [self initWithFrame:frame WithTitle:title  Image:nil selectedImage:nil backGroundColor:aBackGroundColor];
}

- (id)initWithFrame:(CGRect)frame WithImage:(UIImage *)image selectedImage:(UIImage *)aSelectedImage WithBackGroundColor:(UIColor*) aBackGroundColor
{
    return [self initWithFrame:frame WithTitle:nil Image:image selectedImage:aSelectedImage  backGroundColor:aBackGroundColor];
}

- (id) initWithFrame:(CGRect)frame WithTitle:(NSString *)title  Image:(UIImage*) image selectedImage:(UIImage *)aSelectedImage backGroundColor:(UIColor *)aBackGroundColor
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.mTitle = title;
        self.mImage = image;
        self.mSelectedImage = aSelectedImage;
        self.mBackGroundColor = aBackGroundColor;
        
        self.mSelected = NO;
        self.mTitleColor = [UIColor blackColor];
        self.mSelectedTitleColor = [UIColor redColor];
        
        UILabel* sLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        sLabel.backgroundColor = [UIColor clearColor];
        sLabel.textAlignment = UITextAlignmentCenter;
//        sLabel.textColor = kNGDefaultTitleColor;
        [self addSubview:sLabel];
        self.mTitleLabel = sLabel;
        [sLabel release];
    }
    return self;
}

- (void) dealloc
{
    self.mTitle = nil;
    self.mImage = nil;
    self.mSelectedImage = nil;
    self.mTitleLabel = nil;

    self.mTitleFont = nil;
    self.mTitleColor = nil;
    self.mSelectedTitleColor = nil;
    self.mBackGroundColor = nil;
    
    self.mBackgroundColorGradientStart = nil;
    self.mBackgroundColorGradientEnd = nil;
    self.mSelectedBackgroundColorGradientStart = nil;
    self.mSelectedBackgroundColorGradientEnd = nil;
    
    self.mSelectedBackGroundColor = nil;
    self.mBackgroundGadientLayer = nil;
    
    [super dealloc];
}

- (void) setMTitleFont:(UIFont *)aTitleFont
{
    [mTitleFont release];
    mTitleFont = [aTitleFont retain];
    [self refreshBarItemStyle];
}

- (void) setMTitleColor:(UIColor *)aTitleColor
{
    [mTitleColor release];
    mTitleColor = [aTitleColor retain];
    if (!self.mSelected) {
        [self refreshBarItemStyle];
    }
}

- (void) setMSelectedTitleColor:(UIColor *)aSelectedTitleColor
{
    [mSelectedTitleColor release];
    mSelectedTitleColor = [aSelectedTitleColor retain];
    if (self.mSelected)
    {
        [self refreshBarItemStyle];
    }
}

- (void) setMBackGroundColor:(UIColor *)aBackGroundColor
{
    [mBackGroundColor release];
    mBackGroundColor = [aBackGroundColor retain];
    if (!self.mSelected)
    {
        [self refreshBarItemStyle];
    }
}

- (void) setMSelectedBackGroundColor:(UIColor *)aSelectedBackGroundColor
{
    [mSelectedBackGroundColor release];
    mSelectedBackGroundColor = [aSelectedBackGroundColor retain];
    if (self.mSelected)
    {
        [self refreshBarItemStyle];
    }
}

- (void) setMSelected:(BOOL)aSelected
{
    if (self.mSelected == aSelected)
    {
        return;
    }
    
    mSelected = aSelected;
    
    [self refreshBarItemStyle];
}

- (void) refreshBarItemStyle
{
    self.mTitleLabel.font = self.mTitleFont;
    
    if (!self.mSelected)
    {
        self.mTitleLabel.textColor = self.mTitleColor;
        if (!self.mBackgroundWithGradient)
        {
            self.backgroundColor = self.mBackGroundColor;
        }
        else
        {
            if (!self.mBackgroundGadientLayer)
            {
                [self constructBackgroundGradientLayer];
            }
            self.backgroundColor = [UIColor clearColor];
            [self.mBackgroundGadientLayer setColors:[NSArray arrayWithObjects:(id)self.mBackgroundColorGradientStart.CGColor,(id)self.mBackgroundColorGradientEnd.CGColor,nil]];
        }
    }
    else
    {
        self.mTitleLabel.textColor = self.mSelectedTitleColor;
        if (!self.mBackgroundWithGradient)
        {
            self.mBackGroundColor = self.mSelectedBackGroundColor;
        }
        else
        {
            if (!self.mBackgroundGadientLayer)
            {
                [self constructBackgroundGradientLayer];
            }
            self.backgroundColor = [UIColor clearColor];
            [self.mBackgroundGadientLayer setColors:[NSArray arrayWithObjects:(id)self.mSelectedBackgroundColorGradientStart.CGColor,(id)self.mSelectedBackgroundColorGradientEnd.CGColor,nil]];
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.mTitle)
    {
        self.mTitleLabel.text = self.mTitle;
        [self.mTitleLabel setFrame:self.bounds];
    }
    
    [self constructBackgroundGradientLayer];
    
    [self refreshBarItemStyle];
}

- (void) constructBackgroundGradientLayer
{
    if (self.mBackgroundGadientLayer)
    {
        [self.mBackgroundGadientLayer removeFromSuperlayer];
        self.mBackgroundGadientLayer = nil;
    }
    CAGradientLayer* sBackgroundGadientLayer =[[CAGradientLayer alloc] init];
    [sBackgroundGadientLayer setBounds:self.bounds];
    [sBackgroundGadientLayer setPosition:CGPointMake([self bounds].size.width/2,[self bounds].size.height/2)];
    [self.layer insertSublayer:sBackgroundGadientLayer atIndex:0];
    
    self.mBackgroundGadientLayer = sBackgroundGadientLayer;
    [sBackgroundGadientLayer release];
}

+ (SimpleTabBarItem *)itemWithTitle:(NSString *)title
{
    return [self itemWithTitle:title andBackgroundColor:[UIColor whiteColor]];
}

+ (SimpleTabBarItem *)itemWithTitle:(NSString *)title andBackgroundColor:(UIColor*)aBackgroundColor
{
    SimpleTabBarItem* sItem = [[[SimpleTabBarItem alloc] initWithFrame:CGRectZero WithTitle:title WithBackGroundColor:aBackgroundColor] autorelease];
    return sItem;

}

+ (SimpleTabBarItem *)itemWithImage:(UIImage *)aImage AndSelectedImage:(UIImage *)aSelectedImage
{
    SimpleTabBarItem* sItem = [[[SimpleTabBarItem alloc] initWithFrame:CGRectZero WithImage:aImage selectedImage:aSelectedImage WithBackGroundColor:[UIColor whiteColor]] autorelease];

    return sItem;
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
