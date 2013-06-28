//
//  SimpleTabBar.m
//  BTT
//
//  Created by Wen Shane on 12-12-8.
//  Copyright (c) 2012年 Wen Shane. All rights reserved.
//

#import "SimpleTabBar.h"
#import "SimpleTabBarItem.h"


//#define BAR_EDGE_INSETS         UIEdgeInsetsMake(0, 0, 0, 0)
#define SPERATOR_LINE_WIDTH     1.2f
#define INVALID_SELECTED_INDEX -1

@interface SimpleTabBar()
{
    NSArray* mBarItems;
    NSInteger mSelectedIndex;
    UILabel* mUnderScoreLabel;
    
    CGFloat mSperatorLineWidth;
}

@property (nonatomic, assign)  NSInteger mSelectedIndex;
@property (nonatomic, retain)  UILabel* mUnderScoreLabel;
@property (nonatomic, assign)  CGFloat mSperatorLineWidth;


@end

@implementation SimpleTabBar

@synthesize mBarItems;
@synthesize mSelectedIndex;
@synthesize mUnderScoreLabel;
@synthesize mDelegate;
@synthesize mSperatorLineWidth;

- (id)initWithFrame:(CGRect)frame BarItems:(NSArray*)aBarItems Delegate:(id<SimpleTabBarDelegate>)aDelegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.mBarItems = aBarItems;
        self.mSelectedIndex = INVALID_SELECTED_INDEX;
        self.mDelegate = aDelegate;
        //test-
        self.backgroundColor = [UIColor clearColor];
        //-test
        
        if ([self.mDelegate getStyleOfCorrespondingController].mTabHaveSperator)
        {
            self.mSperatorLineWidth = SPERATOR_LINE_WIDTH;
        }
        else
        {
            self.mSperatorLineWidth = 0;
        }
        
        [self layoutBarItemView];
    }
    return self;
}

- (void) dealloc
{
    self.mBarItems = nil;
    self.mUnderScoreLabel = nil;
    
    [super dealloc];
    
}

- (CGFloat) getWidhtOfBarItemView
{
    CGFloat sTotalWidthOfSperator = (self.mBarItems.count-1)*self.mSperatorLineWidth;
    CGFloat sTotalHorizontalPadding = [self.mDelegate getStyleOfCorrespondingController].mTabBarPadding.left+[self.mDelegate getStyleOfCorrespondingController].mTabBarPadding.right;
    
    CGFloat sTotalWidhtOfBarItemViews = self.bounds.size.width-sTotalWidthOfSperator-sTotalHorizontalPadding;
    CGFloat sWidthOfBarItemView = sTotalWidhtOfBarItemViews/self.mBarItems.count;
    return sWidthOfBarItemView;
}

- (void) layoutBarItemView
{
    
    CGFloat sWidthOfBarItemView = [self getWidhtOfBarItemView];
    CGFloat sHeightOfBarItemView = self.bounds.size.height;
    
    CGFloat sX = [self.mDelegate getStyleOfCorrespondingController].mTabBarPadding.left;
    CGFloat sY = 0;
    CGFloat sWidth = sWidthOfBarItemView;
    CGFloat sHeight = sHeightOfBarItemView;
    
    for (int i=0; i<self.mBarItems.count; i++)
    {
        SimpleTabBarItem* sBarItemView = [self.mBarItems objectAtIndex:i];
        [self configureBarItem:sBarItemView];
        
        [sBarItemView setFrame:CGRectMake(sX, sY, sWidth, sHeight)];
        sBarItemView.mMarginInsets = UIEdgeInsetsMake(20, 0, 50, 0);
        
        [self addSubview:sBarItemView];
        
        if (i != self.mBarItems.count-1)
        {
            CGFloat sSHeight = (2*self.bounds.size.height)/3.0f;
            CGFloat sSWidth = self.mSperatorLineWidth;
            CGFloat sSX = sX+sWidth;
            CGFloat sSY = (self.bounds.size.height-sSHeight)/2.0f;
            UILabel* sSperatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(sSX, sSY, sSWidth, sSHeight)];
            sSperatorLabel.backgroundColor = [UIColor lightGrayColor];
            [self addSubview:sSperatorLabel];
            [sSperatorLabel release];
        }
        
        sX += sWidth+self.mSperatorLineWidth;
    }

    if ([self.mDelegate getStyleOfCorrespondingController].mItemHaveUnderscore)
    {
        sHeight = 1;
        sWidth = sWidth;
        sX = [self.mDelegate getStyleOfCorrespondingController].mTabBarPadding.left;
        sY = self.bounds.size.height-sHeight;
        UILabel* sUnderScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(sX, sY, sWidth, sHeight)];
        sUnderScoreLabel.backgroundColor = [self.mDelegate getStyleOfCorrespondingController].mItemSelectedTitleColor;
        [self addSubview:sUnderScoreLabel];
        self.mUnderScoreLabel = sUnderScoreLabel;
        [sUnderScoreLabel release];
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

- (void) moveTo:(NSInteger)aIndex
{
    if (aIndex < 0
        || aIndex >= self.mBarItems.count
        || aIndex == self.mSelectedIndex)
    {
        return;
    }
    
    CGFloat sX = [self.mDelegate getStyleOfCorrespondingController].mTabBarPadding.left + aIndex * ([self getWidhtOfBarItemView]+self.mSperatorLineWidth);
    
    NSTimeInterval sDurationTimeInterval = 0.0;
    if ([self.mDelegate getStyleOfCorrespondingController].mItemSwitchWithAnimation)
    {
        sDurationTimeInterval = 0.2;
    }
    [UIView animateWithDuration:sDurationTimeInterval animations:^{
        if(self.mUnderScoreLabel)
        {
            self.mUnderScoreLabel.frame = CGRectOffset(self.mUnderScoreLabel.frame, sX-self.mUnderScoreLabel.frame.origin.x, 0);
        }
        if (self.mSelectedIndex != INVALID_SELECTED_INDEX)
        {
            SimpleTabBarItem* sOldSelectedTabBarItem = [self.mBarItems objectAtIndex:self.mSelectedIndex];
            [sOldSelectedTabBarItem setMSelected:NO];
        }
        
        SimpleTabBarItem* sNewSelectedTabBarItem = [self.mBarItems objectAtIndex:aIndex];
        [sNewSelectedTabBarItem setMSelected:YES];
        self.mSelectedIndex = aIndex;
    }completion:^(BOOL finished) {
        //        self.mSelectedIndex = aIndex;
    }];
}

- (void) configureBarItem:(SimpleTabBarItem*)aBarItem
{
    if (aBarItem)
    {
        SimpleTabControllerStyle* sControllerStyle = [self.mDelegate getStyleOfCorrespondingController];
        aBarItem.mTitleColor = sControllerStyle.mItemTitleColor;
        aBarItem.mSelectedTitleColor = sControllerStyle.mItemSelectedTitleColor;
        aBarItem.mBackGroundColor = sControllerStyle.mItemBackGroundColor;
        aBarItem.mSelectedBackGroundColor = sControllerStyle.mItemSelectedBackGroundColor;
        aBarItem.mTitleFont = sControllerStyle.mItemFont;
        aBarItem.mBackgroundWithGradient = sControllerStyle.mItemBackgroundWithGradient;
        if (aBarItem.mBackgroundWithGradient)
        {
            aBarItem.mBackgroundColorGradientStart = sControllerStyle.mItemBackgroundColorGradientStart;
            aBarItem.mBackgroundColorGradientEnd =  sControllerStyle.mItemBackgroundColorGradientEnd;
            aBarItem.mSelectedBackgroundColorGradientStart = sControllerStyle.mItemSelectedBackgroundColorGradientStart;
            aBarItem.mSelectedBackgroundColorGradientEnd = sControllerStyle.mItemSelectedBackgroundColorGradientEnd;
        }
    }
}

@end
