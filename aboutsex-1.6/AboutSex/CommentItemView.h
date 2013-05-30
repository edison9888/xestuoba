//
//  CommentItemView.h
//  AboutSex
//
//  Created by Wen Shane on 13-2-8.
//
//

#import <UIKit/UIKit.h>

@interface CommentItemView : UITableViewCell
{
    UILabel* mContentLabel;
    UILabel* mCommentorLabel;
    UILabel* mDateLabel;
    UIView* mSeperatorLineView;
    
    CGFloat mHeight;
}

@property(nonatomic, retain) UILabel* mContentLabel;
@property(nonatomic, retain) UILabel* mCommentorLabel;
@property(nonatomic, retain) UILabel* mDateLabel;
@property (nonatomic, retain) UIView* mSeperatorLineView;
@property(nonatomic, assign) CGFloat mHeight;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withFrame:(CGRect)aFrame;

- (void) fillValueByCommentor:(NSString*)mCommentor Date:(NSDate*)aDate Content:(NSString*)aContent;

@end
