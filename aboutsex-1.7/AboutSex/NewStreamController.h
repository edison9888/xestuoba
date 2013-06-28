//
//  PullRefreshTableViewController.h
//  Plancast
//
//  Created by Leah Culver on 7/2/10.
//  Copyright (c) 2010 Leah Culver
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import <UIKit/UIKit.h>
#import "CommonTableViewController2.h"
//#import "MyURLConnection.h"

#import "StreamItem.h"
#import "NewStreamSniffer.h"

#import "MKInfoPanel.h"
#import "StreamViewController.h"


@interface NewStreamController: CommonTableViewController2<NewStreamSnifferDelegate>
{
    UIView *refreshHeaderView;
    UILabel *refreshNoticeLabel;
    UILabel* mLastUpdateTimeLabel;
    UIImageView *refreshArrow;
    UIActivityIndicatorView *refreshSpinner;
    BOOL isDragging;
    BOOL isLoading;
    NSString *textPull;
    NSString *textRelease;
    NSString *textLoading;
    
    NSMutableArray* mStreamItems;
    BOOL mHasMore;
    UIActivityIndicatorView* mLoadingMoreActivityIndicator;
 
//    UITableView* mTableView;
}

@property (nonatomic, retain) UIView *refreshHeaderView;
@property (nonatomic, retain) UILabel *refreshNoticeLabel;
@property (nonatomic, retain) UILabel* mLastUpdateTimeLabel;
@property (nonatomic, retain) UIImageView *refreshArrow;
@property (nonatomic, retain) UIActivityIndicatorView *refreshSpinner;
@property (nonatomic, copy) NSString *textPull;
@property (nonatomic, copy) NSString *textRelease;
@property (nonatomic, copy) NSString *textLoading;
@property (nonatomic, assign) BOOL isLoading;

@property (nonatomic, retain) NSMutableArray* mStreamItems;
@property (nonatomic, assign) BOOL mHasMore;
@property (nonatomic, retain) UIActivityIndicatorView* mLoadingMoreActivityIndicator;


+ (NewStreamController*) shared;
- (void) refreshFromOutside;
- (void) refreshViaButton;
//- (void)setupStrings;
//- (void)addPullToRefreshHeader;
//- (void)startLoading;
//- (void)stopLoading;
//- (void)refresh;

@end
