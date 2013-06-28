//
//  HotCommentsViewController.h
//  AboutSex
//
//  Created by Wen Shane on 13-6-7.
//
//

#import <UIKit/UIKit.h>
#import "SimplePageViewController.h"
#import "AffectionViewController.h"
#import "CommentItemCellDelegate.h"


@interface HotCommentsViewController : SimplePageViewController<CommentItemCellDelegate>
{
    id<AffectionViewControllerDelegate> mDelegate;
}

@property (nonatomic, assign) id<AffectionViewControllerDelegate> mDelegate;
+ (HotCommentsViewController*) shared;

@end
