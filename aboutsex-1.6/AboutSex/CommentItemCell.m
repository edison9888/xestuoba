//
//  CommentItemView.m
//  AboutSex
//
//  Created by Wen Shane on 13-2-8.
//
//

#import "CommentItemCell.h"
#import "NSDateFormatter+MyDateFormatter.h"
#import "SharedVariables.h"
#import "TaggedButton.h"
#import <QuartzCore/QuartzCore.h>

#define WIDTH_CONTENT_LABEL 305
#define HEIGHT_CONTENT_LABEL 300

#define TAG_DING_BUTTON 202
#define TAG_CAI_BUTTON  203

@implementation CommentItemCell
@synthesize mCommentorLabel;
@synthesize mContentLabel;
@synthesize mDateLabel;
@synthesize mSeperatorLineView;
@synthesize mHeight;
@synthesize mDelegate;
@synthesize mDingButton;
@synthesize mCaiButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withFrame:(CGRect)aFrame
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.frame = aFrame;
    if (self) {
        [self configSubviews];
    }
    return self;
}

- (void) dealloc
{
    self.mContentLabel = nil;
    self.mCommentorLabel = nil;
    self.mDateLabel = nil;
    self.mSeperatorLineView = nil;
    self.mDingButton = nil;
    self.mCaiButton = nil;
    
    [super dealloc];
}

- (void) configSubviews;
{
    CGFloat sX = 5;
    CGFloat sY = 3;
    CGFloat sWidth = 100;
    CGFloat sHeight = 18;
    self.mCommentorLabel = [[[UILabel alloc] initWithFrame:CGRectMake(sX, sY, sWidth, sHeight)] autorelease];
    self.mCommentorLabel.textColor = MAIN_BGCOLOR;
    self.mCommentorLabel.font = [UIFont boldSystemFontOfSize:12];
    self.mCommentorLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.mCommentorLabel];
  
    sX = 170;
    sWidth = 50;
    TaggedButton* sDingButton = [TaggedButton buttonWithType:UIButtonTypeCustom];
    sDingButton.frame = CGRectMake(sX, sY, sWidth, sHeight);
    sDingButton.titleLabel.font = [UIFont systemFontOfSize:12];
    sDingButton.mMarginInsets = UIEdgeInsetsMake(10, 50, 20, 0);
//    sDingButton.backgroundColor = [UIColor blackColor];
    [sDingButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [sDingButton setTitleColor:MAIN_BGCOLOR forState:UIControlStateSelected];
    sDingButton.tag = TAG_DING_BUTTON;
    [sDingButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    [sDingButton setTitle:NSLocalizedString(@"Ding", nil) forState:UIControlStateNormal];
    [self addSubview:sDingButton];
    self.mDingButton = sDingButton;
    
    sX += sWidth+30;
    TaggedButton* sCaiButton = [TaggedButton buttonWithType:UIButtonTypeCustom];
    sCaiButton.frame = CGRectMake(sX, sY, sWidth, sHeight);
    sCaiButton.titleLabel.font = [UIFont systemFontOfSize:12];
    sCaiButton.mMarginInsets = UIEdgeInsetsMake(10, 0, 20, 50);
//    sCaiButton.backgroundColor = [UIColor blackColor];
    [sCaiButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [sCaiButton setTitleColor:MAIN_BGCOLOR forState:UIControlStateSelected];
    sCaiButton.tag = TAG_CAI_BUTTON;

    [sCaiButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    [sCaiButton setTitle:NSLocalizedString(@"Cai", nil) forState:UIControlStateNormal];
    [self addSubview:sCaiButton];
    self.mCaiButton = sCaiButton;
    
    sX = 5;
    sY += sHeight;
    sWidth = 100;
    self.mDateLabel = [[[UILabel alloc] initWithFrame:CGRectMake(sX, sY, sWidth, sHeight)] autorelease];
    self.mDateLabel.textColor = [UIColor grayColor];
    self.mDateLabel.font = [UIFont systemFontOfSize:10];
    self.mDateLabel.textAlignment = UITextAlignmentLeft;
    self.mDateLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.mDateLabel];
    
    sY += sHeight;
    sWidth = WIDTH_CONTENT_LABEL;
    sHeight = HEIGHT_CONTENT_LABEL;
    self.mContentLabel = [[[UILabel alloc] initWithFrame:CGRectMake(sX, sY, sWidth, sHeight)] autorelease];
    self.mContentLabel.backgroundColor = [UIColor clearColor];
    self.mContentLabel.numberOfLines = 0;
    self.mContentLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.mContentLabel];
    
    sY += sHeight;
    UIView* sSeperatorLineView = [[UIView alloc] initWithFrame:CGRectMake(sX, sY, self.bounds.size.width, 1)];
    sSeperatorLineView.backgroundColor = RGBA_COLOR(222, 222, 222, 1);
    sSeperatorLineView.layer.shadowColor = [RGBA_COLOR(224, 224, 224, 1) CGColor];
    sSeperatorLineView.layer.shadowOffset = CGSizeMake(0, -10);
    sSeperatorLineView.layer.shadowOpacity = .5f;
    sSeperatorLineView.layer.shadowRadius = 2.0f;
    sSeperatorLineView.clipsToBounds = NO;
    sSeperatorLineView.layer.cornerRadius = 2;
    
    [self addSubview:sSeperatorLineView];
    
    self.mSeperatorLineView = sSeperatorLineView;
    [sSeperatorLineView release];
}

//- (void) fillValueByCommentor:(NSString*)aCommentor Date:(NSDate*)aDate Content:(NSString*)aContent
- (void) fillValueByComment:(CommentItem*)aComment
{
    self.mCommentorLabel.text = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"User", nil), aComment.mName];
    self.mDateLabel.text = [NSDateFormatter createTimeStringForCommentDate:aComment.mDate];
    
    [self.mDingButton setTitle:[NSString stringWithFormat:@"%d%@",  aComment.mDings, NSLocalizedString(@"Ding", nil)] forState:UIControlStateNormal];
    
    [self.mCaiButton setTitle:[NSString stringWithFormat:@"%d%@", aComment.mCais, NSLocalizedString(@"Cai", nil)] forState:UIControlStateNormal];
    
    if (aComment.mDidDing
        || aComment.mDidCai)
    {
        self.mDingButton.userInteractionEnabled = NO;
        self.mCaiButton.userInteractionEnabled = NO;

    }
    else
    {
        self.mDingButton.userInteractionEnabled = YES;
        self.mCaiButton.userInteractionEnabled = YES;
    }
    
    if (aComment.mDidDing)
    {
        self.mDingButton.selected = YES;
    }
    else
    {
        self.mDingButton.selected = NO;
    }
    
    if (aComment.mDidCai)
    {
        self.mCaiButton.selected = YES;
    }
    else
    {
        self.mCaiButton.selected = NO;
    }
    
    CGSize sContentSize;
    if (!aComment.mContent)
    {
        sContentSize = CGSizeZero;
    }
    else
    {
        CGSize sSize = CGSizeMake(WIDTH_CONTENT_LABEL, HEIGHT_CONTENT_LABEL);
        sContentSize = [aComment.mContent sizeWithFont:self.mContentLabel.font constrainedToSize:sSize];
        sContentSize.height += 8;
    }
    
    self.mContentLabel.frame = CGRectMake(self.mContentLabel.frame.origin.x, self.mContentLabel.frame.origin.y, sContentSize.width, sContentSize.height);
    
    self.mContentLabel.text = aComment.mContent;
   
    CGFloat sY = self.mContentLabel.frame.origin.y+self.mContentLabel.bounds.size.height;
    CGRect sFrame = self.mSeperatorLineView.frame;
    sFrame.origin.y = sY;
    self.mSeperatorLineView.frame = sFrame;    
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, sY+self.mSeperatorLineView.bounds.size.height);
}


- (void) buttonClicked:(UIButton*)aButton
{
    if (aButton.tag == TAG_DING_BUTTON)
    {
        if (!aButton.selected)
        {
            if ([self.mDelegate respondsToSelector:@selector(dingAt:)])
            {
                [self.mDelegate dingAt:self];
            }
        }
    }
    else if (aButton.tag == TAG_CAI_BUTTON)
    {
        if (!aButton.selected)
        {
            if ([self.mDelegate respondsToSelector:@selector(caiAt:)])
            {
                [self.mDelegate caiAt:self];
            }
        }
    }
    else
    {
        //
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
