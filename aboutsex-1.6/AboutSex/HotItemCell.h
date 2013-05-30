//
//  HotItemCell.h
//  AboutSex
//
//  Created by Wen Shane on 13-3-7.
//
//

#import <UIKit/UIKit.h>
#import "StreamItem.h"

@interface HotItemCell : UITableViewCell
{
    UILabel* mRankLabel;
    UILabel* mTitleLabel;
    UILabel* mSummaryLabel;
    UILabel* mDateLabel;
    UILabel* mLikesLabel;
    UILabel* mCollectsLabel;
    UILabel* mCommentsLabel;
}

@property (nonatomic, retain)     UILabel* mRankLabel;
@property (nonatomic, retain)     UILabel* mTitleLabel;
@property (nonatomic, retain)     UILabel* mSummaryLabel;
@property (nonatomic, retain)     UILabel* mDateLabel;
@property (nonatomic, retain)     UILabel* mLikesLabel;
@property (nonatomic, retain)     UILabel* mCollectsLabel;
@property (nonatomic, retain)     UILabel* mCommentsLabel;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withFrame:(CGRect)aFame;
- (void) fillValueByItem:(StreamItem*)aItem withRank:(NSInteger)aRank;

@end
