//
//  CommentItemView.m
//  AboutSex
//
//  Created by Wen Shane on 13-2-8.
//
//

#import "CommentItemView.h"
#import "NSDateFormatter+MyDateFormatter.h"
#import "SharedVariables.h"
#import <QuartzCore/QuartzCore.h>

#define WIDTH_CONTENT_LABEL 305
#define HEIGHT_CONTENT_LABEL 200

@implementation CommentItemView
@synthesize mCommentorLabel;
@synthesize mContentLabel;
@synthesize mDateLabel;
@synthesize mSeperatorLineView;
@synthesize mHeight;


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
    
    [super dealloc];
}

- (void) configSubviews;
{
    CGFloat sX = 5;
    CGFloat sY = 3;
    CGFloat sWidth = 200;
    CGFloat sHeight = 18;
    self.mCommentorLabel = [[[UILabel alloc] initWithFrame:CGRectMake(sX, sY, sWidth, sHeight)] autorelease];
    self.mCommentorLabel.textColor = MAIN_BGCOLOR;
    self.mCommentorLabel.font = [UIFont boldSystemFontOfSize:12];
    self.mCommentorLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.mCommentorLabel];
    
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

- (void) fillValueByCommentor:(NSString*)aCommentor Date:(NSDate*)aDate Content:(NSString*)aContent
{
    self.mCommentorLabel.text = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"User", nil), aCommentor];
    self.mDateLabel.text = [NSDateFormatter createTimeStringForCommentDate:aDate];
    
    CGSize sContentSize;
    if (!aContent)
    {
        sContentSize = CGSizeZero;
    }
    else
    {
        CGSize sSize = CGSizeMake(WIDTH_CONTENT_LABEL, HEIGHT_CONTENT_LABEL);
        sContentSize = [aContent sizeWithFont:self.mContentLabel.font constrainedToSize:sSize];
        sContentSize.height += 8;
    }
    
    self.mContentLabel.frame = CGRectMake(self.mContentLabel.frame.origin.x, self.mContentLabel.frame.origin.y, sContentSize.width, sContentSize.height);
    
    self.mContentLabel.text = aContent;
   
    CGFloat sY = self.mContentLabel.frame.origin.y+self.mContentLabel.bounds.size.height;
    CGRect sFrame = self.mSeperatorLineView.frame;
    sFrame.origin.y = sY;
    self.mSeperatorLineView.frame = sFrame;    
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, sY+self.mSeperatorLineView.bounds.size.height);
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
