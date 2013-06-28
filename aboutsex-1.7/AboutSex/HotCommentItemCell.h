//
//  HotCommentItemCell.h
//  AboutSex
//
//  Created by Wen Shane on 13-6-13.
//
//

#import <UIKit/UIKit.h>
#import "CommentItem.h"
#import "CommentItemCellDelegate.h"



@interface HotCommentItemCell : UITableViewCell<CommentItemCellDelegate>
{
    UILabel* mContentLabel;
    UILabel* mUserLabel;
    UILabel* mRefTitleLabel;
    
    
    UIButton* mDingBtn;
    id<CommentItemCellDelegate> mDelegate;
}

@property (nonatomic, retain)   UILabel* mContentLabel;
@property (nonatomic, retain)   UILabel* mUserLabel;
@property (nonatomic, retain)   UILabel* mRefTitleLabel;
@property (nonatomic, retain)   UIButton* mDingBtn;
@property (nonatomic, assign)   id<CommentItemCellDelegate> mDelegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (void) fillValueByComment:(CommentItem*)aComment;

+ (CGFloat) getCellHeightByComment:(CommentItem*)aComment;
@end
