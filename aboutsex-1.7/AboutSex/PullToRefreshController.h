//
//  PullToRefreshController.h
//  BTT
//
//  Created by Wen Shane on 12-12-19.
//  Copyright (c) 2012年 Wen Shane. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PullToRefreshController : UITableViewController
{
    UIView *mRefreshHeaderView;
    UILabel *mRefreshNoticeLabel;
    UILabel* mLastUpdateTimeLabel;
    UIImageView *mRefreshArrow;
    UIActivityIndicatorView *mRefreshSpinner;
    BOOL mIsDragging;
    BOOL mIsLoading;
    NSString *mTextPull;
    NSString *mTextRelease;
    NSString *mTextLoading;
    
    BOOL mIsAutoRefresh;
    
    BOOL mNeedShowNetworkErrorStatus;
    NSDate* mLastUpdateTime;

}

@property (nonatomic, retain) UIView *mRefreshHeaderView;
@property (nonatomic, retain) UILabel *mRefreshNoticeLabel;
@property (nonatomic, retain) UILabel* mLastUpdateTimeLabel;
@property (nonatomic, retain) UIImageView *mRefreshArrow;
@property (nonatomic, retain) UIActivityIndicatorView *mRefreshSpinner;
@property (nonatomic, copy) NSString *mTextPull;
@property (nonatomic, copy) NSString *mTextRelease;
@property (nonatomic, copy) NSString *mTextLoading;
@property (nonatomic, assign) BOOL mIsDragging;
@property (nonatomic, assign) BOOL mIsLoading;

@property (nonatomic, assign) BOOL mIsAutoRefresh;
@property (nonatomic, assign) BOOL mNeedShowNetworkErrorStatus;
@property (nonatomic, retain) NSDate* mLastUpdateTime;


- (void) refresh; //called on refreshing action starts.
- (void) refreshDone:(BOOL)aSuccess;   //called on refreshing is completed.
- (void) autoRefresh; 


@end
