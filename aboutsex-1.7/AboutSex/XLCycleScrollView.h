//
//  XLCycleScrollView.h
//  CycleScrollViewDemo
//
//  Created by xie liang on 9/14/12.
//  Copyright (c) 2012 xie liang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageControlEx.h"

@protocol XLCycleScrollViewDelegate;
@protocol XLCycleScrollViewDatasource;

@interface XLCycleScrollView : UIView<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    PageControlEx *_pageControl;
    
    id<XLCycleScrollViewDelegate> _delegate;
    id<XLCycleScrollViewDatasource> _datasource;
    
    NSInteger _totalPages;
    NSInteger _curPage;
    
    NSMutableArray *_curViews;
   
    BOOL mNeedPageControl;
    
    BOOL mIsRepeating;//note that when mIsRepeating is YES, the num of views you add should larger than 2, cos there are 3 subviews(pre, cur, next) in _scrollView, one of the two views you add will be refered twice, and its offset in _scrollviews will not work as expected(for instance, when you scroll in the right direction, the pre view will appear abruptly, not gradually)
    
    //used for non-repeating scrolling
    CGFloat mPreViewWidth;
    CGFloat mCurViewWidth;
    CGFloat mNextViewWidth;
}

@property (nonatomic,readonly) UIScrollView *scrollView;
@property (nonatomic,readonly) PageControlEx *pageControl;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,assign,setter = setDataource:) id<XLCycleScrollViewDatasource> datasource;
@property (nonatomic,assign,setter = setDelegate:) id<XLCycleScrollViewDelegate> delegate;

@property (nonatomic, assign) BOOL mNeedPageControl;
@property (nonatomic, assign) BOOL mIsRepeating;
@property (nonatomic, assign) CGFloat mPreViewWidth;
@property (nonatomic, assign) CGFloat mCurViewWidth;
@property (nonatomic, assign) CGFloat mNextViewWidth;
- (id)initWithFrame:(CGRect)frame IsRepeating:(BOOL)aIsRepeating NeedPageControl:(BOOL)NeedPageControl;

- (void)reloadData;
- (void)setViewContent:(UIView *)view atIndex:(NSInteger)index;

@end

@protocol XLCycleScrollViewDelegate <NSObject>

@optional
- (void)didClickPage:(XLCycleScrollView *)csView atIndex:(NSInteger)index;

@end

@protocol XLCycleScrollViewDatasource <NSObject>

@required
- (NSInteger)numberOfPages;
//- (UIView *)pageAtIndex:(NSInteger)index;
- (UIView *)pageAtIndex:(NSInteger)index aIsCurPage:(BOOL)aIsCurPage;


@end
