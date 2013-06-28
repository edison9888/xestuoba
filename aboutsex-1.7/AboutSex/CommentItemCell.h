//
//  CommentItemView.h
//  AboutSex
//
//  Created by Wen Shane on 13-2-8.
//
//

#import <UIKit/UIKit.h>
#import "CommentItem.h"
#import "CommentItemCellDelegate.h"

@class CommentItemCell;


@interface CommentItemCell : UITableViewCell
{
    UILabel* mContentLabel;
    UILabel* mCommentorLabel;
    UILabel* mDateLabel;
    UIView* mSeperatorLineView;
    UIButton* mDingButton;
    UIButton* mCaiButton;
    
    CGFloat mHeight;
    
    id<CommentItemCellDelegate> mDelegate;
}

@property(nonatomic, retain) UILabel* mContentLabel;
@property(nonatomic, retain) UILabel* mCommentorLabel;
@property(nonatomic, retain) UILabel* mDateLabel;
@property (nonatomic, retain) UIView* mSeperatorLineView;
@property(nonatomic, assign) CGFloat mHeight;
@property (nonatomic, assign)  id<CommentItemCellDelegate> mDelegate;
@property (nonatomic, retain)  UIButton* mDingButton;
@property (nonatomic, retain)  UIButton* mCaiButton;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withFrame:(CGRect)aFrame;

- (void) fillValueByComment:(CommentItem*)aComment;
+ (CGFloat) getCellHeightByComment:(CommentItem*)aComment;
@end
