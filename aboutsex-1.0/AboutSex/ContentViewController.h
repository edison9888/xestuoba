//
//  ContentViewController.h
//  AboutSex
//
//  Created by Shane Wen on 12-6-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonTableViewController.h"

@interface ContentViewController : UIViewController<UIWebViewDelegate>
{
    CommonTableViewController* mItemListViewController;
    UIWebView* mWebView;
    UIActivityIndicatorView* mPageLoadingIndicator;
    
}

@property (nonatomic, retain) CommonTableViewController* mItemListViewController;
@property (nonatomic, retain) UIWebView* mWebView;
@property (nonatomic, retain) UIActivityIndicatorView* mPageLoadingIndicator;

//- (id) initWithTitle:(NSString*)aTitle AndContentLoc: (NSString*)aLoc;
- (void) setTitle:(NSString*)aTitle AndContentLoc: (NSString*)aLoc AndWithCollectionSupport: (BOOL) canCollect;
@end
