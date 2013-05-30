//
//  ContentViewController.h
//  AboutSex
//
//  Created by Shane Wen on 12-6-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonTableViewController2.h"
#import "HPGrowingTextView.h"
#import "StreamItem.h"

@interface ContentViewController2 : UIViewController<UIWebViewDelegate,UIScrollViewDelegate, HPGrowingTextViewDelegate>
{
    StreamItem* mItem;

    CommonTableViewController2* mItemListViewController;
    
    UIScrollView* mBodyView;
    UIWebView* mWebView;    
    
    UIView* containerView;
    HPGrowingTextView *mTextView;

    UIActivityIndicatorView* mPageLoadingIndicator;
    NSMutableURLRequest* mRequest;
}

@property (nonatomic, assign) CommonTableViewController2* mItemListViewController;
@property (nonatomic, retain) UIScrollView* mBodyView;
@property (nonatomic, retain) UIWebView* mWebView;
@property (nonatomic, retain) UIView* containerView;
@property (nonatomic, retain) HPGrowingTextView *mTextView;
@property (nonatomic, retain) UIActivityIndicatorView* mPageLoadingIndicator;
@property (nonatomic, retain) StreamItem* mItem;
@property (nonatomic, retain) NSMutableURLRequest* mRequest;

- (void) setItem:(StreamItem*)aItem AndWithCollectionSupport: (BOOL) canCollect;
- (BOOL) canCollect;
@end
