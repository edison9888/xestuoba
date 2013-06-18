//
//  CommentItemCellDelegate.h
//  AboutSex
//
//  Created by Wen Shane on 13-6-17.
//
//

#import <Foundation/Foundation.h>

@protocol CommentItemCellDelegate <NSObject>

@optional
- (void) dingAt:(UITableViewCell*)aCommentItemView;
- (void) caiAt:(UITableViewCell*)aCommentItemView;

@end
