//
//  FavoriteViewController.h
//  AboutSex
//
//  Created by Shane Wen on 12-6-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonTableViewController.h"

@interface FavoriteViewController: CommonTableViewController{
    NSMutableArray* mFavorites;
    UIView* mEmptyView;
    UIBarButtonItem* mEditBarButtonItem;
}


- (id) initWithTitle:(NSString*)aTitle;

@property (nonatomic, retain) NSMutableArray* mFavorites;
@property (nonatomic, retain) UIView* mEmptyView;
@property (nonatomic, retain) UIBarButtonItem* mEditBarButtonItem;
@end
