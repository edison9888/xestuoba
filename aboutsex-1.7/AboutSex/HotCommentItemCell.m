//
//  HotCommentItemCell.m
//  AboutSex
//
//  Created by Wen Shane on 13-6-13.
//
//

#import "HotCommentItemCell.h"
#import "SharedVariables.h"
#import "InsetLabel.h"
#import "TaggedButton.h"
#import <QuartzCore/QuartzCore.h>

#define WIDTH_CONTENT_LABEL 280
#define HEIGHT_CONTENT_LABEL 300
#define CONTENT_FONT    [UIFont systemFontOfSize:15]

#define TAG_DING_BUTTON 202
#define TAG_CAI_BUTTON  203

@implementation HotCommentItemCell
@synthesize mContentLabel;
@synthesize mUserLabel;
@synthesize mRefTitleLabel;
@synthesize mDingBtn;
@synthesize mDelegate;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configSubviews];
    }
    return self;
}

- (void) dealloc
{
    self.mContentLabel = nil;
    self.mUserLabel = nil;
//    self.mUpBtn = nil;
//    self.mDownBtn = nil;
    self.mRefTitleLabel = nil;
    
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    if (selected)
    {
        self.mRefTitleLabel.textColor = [UIColor blackColor];
    }
    else
    {
        self.mRefTitleLabel.textColor = [UIColor grayColor];
    }
    // Configure the view for the selected state
}

- (void) configSubviews;
{
    UIEdgeInsets sInsets = UIEdgeInsetsMake(10, 10, 0, 10);
    CGFloat sX = 10;
    CGFloat sY = 10;
    CGFloat sWidth = WIDTH_CONTENT_LABEL+ sInsets.left+sInsets.right;
    CGFloat sHeight = 25;
    
    InsetLabel* sContentLabel = [[InsetLabel alloc] initWithFrame:CGRectMake(sX, sY, sWidth, sHeight) andInsets:sInsets];
    sContentLabel.numberOfLines = 0;
    sContentLabel.font = CONTENT_FONT;
    sContentLabel.layer.cornerRadius = 1;
    sContentLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    sContentLabel.layer.shadowOffset = CGSizeMake(0, 5);
    sContentLabel.layer.borderColor = [UIColor blackColor].CGColor;
    sContentLabel.backgroundColor = RGBA_COLOR(244, 242, 228, 1);
    [self addSubview:sContentLabel];
    self.mContentLabel = sContentLabel;
    [sContentLabel release];
    
    sInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    sY += sHeight;
    InsetLabel* sUserLabel = [[InsetLabel alloc] initWithFrame:CGRectMake(sX, sY, sWidth, sHeight) andInsets:sInsets];
    sUserLabel.textAlignment = UITextAlignmentRight;
//    sUserLabel.backgroundColor = RGBA_COLOR(230, 228, 217, 1);
    sUserLabel.backgroundColor = RGBA_COLOR(244, 242, 228, 1);
    sUserLabel.font = [UIFont systemFontOfSize:12];
    sUserLabel.textColor = [UIColor grayColor];
       
    sY += sHeight;
    CGFloat sWidthOfUpButton = 50;
    TaggedButton* sDingBtn = [TaggedButton buttonWithType:UIButtonTypeCustom];
    [sDingBtn setImage:[UIImage imageNamed:@"like_inactive_12"] forState:UIControlStateNormal];
//    [sDingBtn setImage:[UIImage imageNamed:@"like_active_12"] forState:UIControlStateDisabled];
    [sDingBtn.titleLabel setFont:[UIFont systemFontOfSize:11]];
    [sDingBtn setTitleEdgeInsets:UIEdgeInsetsMake(3, 5, 0, 0)];
    [sDingBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [sDingBtn setTitleColor:MAIN_BGCOLOR forState:UIControlStateDisabled];
    [sDingBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    sDingBtn.tag = TAG_DING_BUTTON;
    sDingBtn.frame = CGRectMake(sX, sY+5, sWidthOfUpButton, 12);
    sDingBtn.mMarginInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [self addSubview:sDingBtn];
    self.mDingBtn = sDingBtn;

    UILabel* sRefTitleLabel = [[InsetLabel alloc] initWithFrame:CGRectMake(sX+sWidthOfUpButton, sY, sWidth-sWidthOfUpButton, sHeight) andInsets:sInsets];
    sRefTitleLabel.textAlignment = UITextAlignmentRight;
    sRefTitleLabel.textColor = [UIColor grayColor];
    sRefTitleLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:sRefTitleLabel];
    self.mRefTitleLabel = sRefTitleLabel;
    [sRefTitleLabel release];

    
    [self addSubview:sUserLabel];
    self.mUserLabel = sUserLabel;
    [sUserLabel release];
}

- (void) fillValueByComment:(CommentItem*)aComment
{
    CGSize sContentSize;
    if (!aComment.mContent)
    {
        sContentSize = CGSizeZero;
    }
    else
    {
        CGSize sSize = CGSizeMake(WIDTH_CONTENT_LABEL, HEIGHT_CONTENT_LABEL);
        sContentSize = [aComment.mContent sizeWithFont:self.mContentLabel.font constrainedToSize:sSize lineBreakMode:UILineBreakModeTailTruncation];
        sContentSize.height += 10;
    }
    
    self.mContentLabel.frame = CGRectMake(self.mContentLabel.frame.origin.x, self.mContentLabel.frame.origin.y, self.mContentLabel.frame.size.width, sContentSize.height);
    
    CGFloat sY = self.mContentLabel.frame.origin.y+self.mContentLabel.bounds.size.height;
    
    CGRect sFrame;
    
    sFrame = self.mUserLabel.frame;
    sFrame.origin.y = sY;
    self.mUserLabel.frame = sFrame;

    sY += sFrame.size.height;
    
    sFrame = self.mDingBtn.frame;
    sFrame.origin.y = sY+5;
    self.mDingBtn.frame = sFrame;

    sFrame = self.mRefTitleLabel.frame;
    sFrame.origin.y = sY;
    self.mRefTitleLabel.frame = sFrame;

    //
    self.mContentLabel.text = aComment.mContent;
    self.mUserLabel.text = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"User", nil), aComment.mName];
    self.mRefTitleLabel.text = aComment.mItem.mName;
    [self.mDingBtn setTitle:[NSString stringWithFormat:@"%d", aComment.mDings] forState:UIControlStateNormal];
//    [self.mUpBtn setTitle:[NSString stringWithFormat:@"%d%@",  aComment.mDings, NSLocalizedString(@"Ding", nil)] forState:UIControlStateNormal];

    
    if (aComment.mDidDing)
    {
        [self.mDingBtn setEnabled:NO];
    }

    return;
}

+ (CGFloat) getCellHeightByComment:(CommentItem*)aComment
{
    CGSize sContentSize;
    if (!aComment.mContent)
    {
        sContentSize = CGSizeZero;
    }
    else
    {
        CGSize sSize = CGSizeMake(WIDTH_CONTENT_LABEL, HEIGHT_CONTENT_LABEL);
        sContentSize = [aComment.mContent sizeWithFont:CONTENT_FONT constrainedToSize:sSize lineBreakMode:UILineBreakModeTailTruncation];
        sContentSize.height += 8;
    }

    return sContentSize.height+65;
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


@end
