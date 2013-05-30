//
//  HotItemCell.m
//  AboutSex
//
//  Created by Wen Shane on 13-3-7.
//
//

#import "HotItemCell.h"
#import "SharedVariables.h"
#import "NSDateFormatter+MyDateFormatter.h"
#import "RatingView.h"
#import <QuartzCore/QuartzCore.h>

@implementation HotItemCell
@synthesize mRankLabel;
@synthesize mTitleLabel;
@synthesize mLikesLabel;
@synthesize mCollectsLabel;
@synthesize mCommentsLabel;
@synthesize mSummaryLabel;
@synthesize mDateLabel;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withFrame:(CGRect)aFame
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = aFame;
        [self setupViews];
    }
    return self;
}

- (void) dealloc
{
    self.mRankLabel = nil;
    self.mTitleLabel = nil;
    self.mSummaryLabel = nil;
    self.mDateLabel = nil;
    self.mLikesLabel = nil;
    self.mCollectsLabel = nil;
    self.mCommentsLabel = nil;
    
    [super dealloc];
}

- (void) setupViews
{
    CGFloat sX = 0;
    CGFloat sY = 0;
    CGFloat sWidth = 40;
    CGFloat sHeight = self.bounds.size.height;
    
    UIView* sView = [[[UIView alloc] initWithFrame:CGRectMake(sX, sY, sWidth, sHeight)] autorelease];
//    sView.backgroundColor = RGBA_COLOR(242, 242, 234, 1);
    sView.backgroundColor = [UIColor clearColor];

    
    [self addSubview:sView];

    
    self.mRankLabel = [self labelWithFrame:CGRectMake(0, 0, 24, 24) withBGColor:[UIColor clearColor] textAlignment:UITextAlignmentCenter forSuperView:sView];
    [self.mRankLabel setCenter:sView.center];
    self.mRankLabel.font = [UIFont systemFontOfSize:20];
//[UIFont fontWithName:@"Helvetica-Bold" size:28];
    self.mRankLabel.textColor = [UIColor grayColor];
    self.mRankLabel.backgroundColor = [UIColor clearColor];
    self.mRankLabel.layer.cornerRadius = 0.0f;
    self.mRankLabel.shadowOffset = CGSizeMake(-0.5, 0);
    self.mRankLabel.shadowColor = MAIN_BGCOLOR;

    UIView* sSeperatorView = [[UIView alloc] initWithFrame:CGRectMake(sView.bounds.size.width-2, 5, 1, sView.bounds.size.height-10)];
    sSeperatorView.backgroundColor = RGBA_COLOR(222, 222, 222, 1);
    sSeperatorView.layer.shadowColor = [RGBA_COLOR(224, 224, 224, 1) CGColor];
    sSeperatorView.layer.shadowOffset = CGSizeMake(0, 0);
    sSeperatorView.layer.shadowOpacity = .5f;
    sSeperatorView.layer.shadowRadius = 20.0f;
    sSeperatorView.clipsToBounds = NO;
    sSeperatorView.layer.cornerRadius = 5;
    
    [sView addSubview:sSeperatorView];
    [sSeperatorView release];


    sX += sWidth+5;
    sY = 7;
    sWidth = self.bounds.size.width-sX-70;
    sHeight = 15;
    
    self.mTitleLabel = [self labelWithFrame:CGRectMake(sX, sY, sWidth, sHeight) withBGColor:[UIColor clearColor]  textAlignment:UITextAlignmentLeft forSuperView:self];
    
    self.mDateLabel = [self labelWithFrame:CGRectMake(sX+sWidth, sY, self.bounds.size.width-sX-sWidth-10, sHeight) withBGColor:[UIColor clearColor]  textAlignment:UITextAlignmentRight forSuperView:self];
    self.mDateLabel.font = [UIFont systemFontOfSize:10];
    self.mDateLabel.textColor = [UIColor lightGrayColor];
    
    sY += sHeight;
    sWidth = self.bounds.size.width-sX-10;
    sHeight = 40;
    self.mSummaryLabel = [self labelWithFrame:CGRectMake(sX, sY, sWidth, sHeight) withBGColor:[UIColor clearColor]  textAlignment:UITextAlignmentLeft forSuperView:self];
    self.mSummaryLabel.textColor = [UIColor grayColor];
    self.mSummaryLabel.font = [UIFont systemFontOfSize:13];
    self.mSummaryLabel.numberOfLines = 0;
//    sY += sHeight;
    
    
    CGFloat sWidthOfImage = 10;
    CGFloat sWidthOfNumLabel = 40;
    sX += 5;
    sY += sHeight;
    sWidth = sWidthOfImage;
    sHeight = sWidthOfImage;
    UIImageView* sLikeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"like10"]];
    sLikeImageView.frame = CGRectMake(sX, sY-1, sWidth, sHeight);
    [self addSubview:sLikeImageView];
    [sLikeImageView release];

    sX += sWidth+5;
    sWidth = sWidthOfNumLabel;
    self.mLikesLabel = [self labelWithFrame:CGRectMake(sX, sY, sWidth, sHeight) withBGColor:[UIColor clearColor]  textAlignment:UITextAlignmentLeft forSuperView:self];
    self.mLikesLabel.font = [UIFont systemFontOfSize:12];
    self.mLikesLabel.textColor = [UIColor grayColor];
    self.mLikesLabel.backgroundColor = [UIColor clearColor];
    
    sX += sWidth+5;
    sWidth = sWidthOfImage;
    UIImageView* sColletImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"heart10"]];
    sColletImageView.frame = CGRectMake(sX, sY-1, sWidth, sHeight);
    [self addSubview:sColletImageView];
    [sColletImageView release];

    sX += sWidth+5;
    sWidth = sWidthOfNumLabel;
    self.mCollectsLabel = [self labelWithFrame:CGRectMake(sX, sY, sWidth, sHeight) withBGColor:[UIColor clearColor]  textAlignment:UITextAlignmentLeft forSuperView:self];
    self.mCollectsLabel.font = [UIFont systemFontOfSize:12];
    self.mCollectsLabel.textColor = [UIColor grayColor];
    self.mCollectsLabel.backgroundColor = [UIColor clearColor];
    
    sX += sWidth+5;
    sWidth = sWidthOfImage;
    UIImageView* sCommentsImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat10"]];
    sCommentsImageView.frame = CGRectMake(sX, sY, sWidth, sHeight);
    [self addSubview:sCommentsImageView];
    [sCommentsImageView release];
    
    sX += sWidth+5;
    sWidth = sWidthOfNumLabel;
    self.mCommentsLabel = [self labelWithFrame:CGRectMake(sX, sY, sWidth, sHeight) withBGColor:[UIColor clearColor]  textAlignment:UITextAlignmentLeft forSuperView:self];
    self.mCommentsLabel.font = [UIFont systemFontOfSize:12];
    self.mCommentsLabel.textColor = [UIColor grayColor];
    self.mCollectsLabel.backgroundColor = [UIColor clearColor];
    
}

- (UILabel*) labelWithFrame:(CGRect)aFrame withBGColor:(UIColor*)aBGColor textAlignment:(UITextAlignment)aAlign forSuperView:(UIView*)aSuperView
{
    UILabel* sLabel = [[[UILabel alloc] initWithFrame:aFrame] autorelease];
    sLabel.textAlignment = aAlign;
    sLabel.backgroundColor = aBGColor;
    
    [aSuperView addSubview:sLabel];
    return sLabel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) fillValueByItem:(StreamItem*)aItem withRank:(NSInteger)aRank
{
    self.mRankLabel.text = [NSString stringWithFormat:@"%d", aRank];
    self.mTitleLabel.text = aItem.mName;
    self.mSummaryLabel.text = aItem.mSummary;
    self.mDateLabel.text = [NSDateFormatter lastUpdateTimeStringForDate: aItem.mReleasedTime];
    self.mLikesLabel.text = [NSString stringWithFormat:@"%d", aItem.mNumLikes];
    self.mCollectsLabel.text = [NSString stringWithFormat:@"%d", aItem.mNumCollects];
    self.mCommentsLabel.text = [NSString stringWithFormat:@"%d", aItem.mNumComments];

    if (aItem.mIsRead)
    {
        self.mTitleLabel.textColor = [UIColor grayColor];
    }
    else
    {
        self.mTitleLabel.textColor = MAIN_BGCOLOR;
    }
}

@end
