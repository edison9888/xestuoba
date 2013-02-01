
//
//  XLCycleScrollView.m
//  CycleScrollViewDemo
//
//  Created by xie liang on 9/14/12.
//  Copyright (c) 2012 xie liang. All rights reserved.
//

#import "XLCycleScrollView.h"
#import "SharedVariables.h"
#import <QuartzCore/QuartzCore.h>


@implementation XLCycleScrollView

@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;
@synthesize currentPage = _curPage;
@synthesize datasource = _datasource;
@synthesize delegate = _delegate;

@synthesize mNeedPageControl;
@synthesize mIsRepeating;
@synthesize mPreViewWidth;
@synthesize mCurViewWidth;
@synthesize mNextViewWidth;

- (void)dealloc
{
    [_scrollView release];
    [_pageControl release];
    [_curViews release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame IsRepeating:(BOOL)aIsRepeating NeedPageControl:(BOOL)NeedPageControl;
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.mIsRepeating = aIsRepeating;
        self.mNeedPageControl = NeedPageControl;
        
        // Initialization code
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(self.bounds.size.width * 3, self.bounds.size.height);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = YES;
        [self addSubview:_scrollView];
        
        if (self.mNeedPageControl)
        {
            CGRect rect = self.bounds;
            rect.size.height = 20;
            rect.size.width = 50;
            rect.origin.y = self.bounds.size.height-rect.size.height-50;
            
            _pageControl = [[[PageControlEx alloc] initWithFrame:rect] autorelease];
            [_pageControl setCenter:CGPointMake(self.center.x, _pageControl.center.y)];
            _pageControl.userInteractionEnabled = NO;
//            _pageControl.dotColorCurrentPage = MAIN_BGCOLOR_SHALLOW;
//            _pageControl.backgroundColor = MAIN_BGCOLOR_TRANSPARENT;
//            _pageControl.layer.cornerRadius = 8.0;
            
//            
            [self addSubview:_pageControl];
            
        }
        
        
        _curPage = 0;

    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame IsRepeating:YES NeedPageControl:YES];
}

- (void)setDataource:(id<XLCycleScrollViewDatasource>)datasource
{
    _datasource = datasource;
    [self reloadData];
}

- (void)reloadData
{
    _totalPages = [_datasource numberOfPages];
    if (_totalPages == 0) {
        return;
    }
    if (_pageControl)
    {
       _pageControl.numberOfPages = _totalPages;
    }

    [self loadData];
}

//- (void)loadData
//{
//    
//    _pageControl.currentPage = _curPage;
//    
//    //从scrollView上移除所有的subview。
//    NSArray *subViews = [_scrollView subviews];
//    if([subViews count] != 0) {
//        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    }
//    
//    [self getDisplayImagesWithCurpage:_curPage];
//    
//    for (int i = 0; i < 3; i++) {
//        UIView *v = [_curViews objectAtIndex:i];
//        v.userInteractionEnabled = YES;
//        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
//                                                                                    action:@selector(handleTap:)];
//        [v addGestureRecognizer:singleTap];
//        [singleTap release];
//        v.frame = CGRectOffset(v.frame, v.frame.size.width * i, 0);
//        [_scrollView addSubview:v];
//    }
//    
//    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
//}

//- (void)getDisplayImagesWithCurpage:(int)page {
//    
//    int pre = [self validPageValue:_curPage-1];
//    int last = [self validPageValue:_curPage+1];
//    
//    if (!_curViews) {
//        _curViews = [[NSMutableArray alloc] init];
//    }
//    
//    [_curViews removeAllObjects];
//    
//    [_curViews addObject:[_datasource pageAtIndex:pre]];
//    [_curViews addObject:[_datasource pageAtIndex:page]];
//    [_curViews addObject:[_datasource pageAtIndex:last]];
//}

- (void)loadData
{
   
    if (_pageControl)
    {
        _pageControl.currentPage = _curPage;
    }
    
    //从scrollView上移除所有的subview。
    NSArray *subViews = [_scrollView subviews];
    if([subViews count] != 0) {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    [self getDisplayImagesWithCurpage:_curPage];
    
    CGFloat sDrift = 0;
    for (int i = 0; i < 3; i++) {
        UIView *v = [_curViews objectAtIndex:i];
        v.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(handleTap:)];
        [v addGestureRecognizer:singleTap];
        [singleTap release];
        v.frame = CGRectOffset(v.frame, sDrift, 0);
        [_scrollView addSubview:v];
        
        sDrift += v.frame.size.width;
    }
    _scrollView.contentSize  = CGSizeMake(self.mPreViewWidth+self.mCurViewWidth+self.mNextViewWidth, _scrollView.contentSize.height);
    [_scrollView setContentOffset:CGPointMake(self.mPreViewWidth, 0)];
    
}

- (void)getDisplayImagesWithCurpage:(int)page {

    if (!_curViews) {
        _curViews = [[NSMutableArray alloc] init];
    }
    [_curViews removeAllObjects];

   if (self.mIsRepeating)
   {
       int pre = [self validPageValue:_curPage-1];
       int last = [self validPageValue:_curPage+1];
       
       [_curViews addObject:[_datasource pageAtIndex:pre aIsCurPage:NO]];
       [_curViews addObject:[_datasource pageAtIndex:page aIsCurPage:YES]];
       [_curViews addObject:[_datasource pageAtIndex:last aIsCurPage:NO]];
   }
   else
   {
       int pre = _curPage-1;
       int last = _curPage+1;
              
       if (pre>=0)
       {
           [_curViews addObject:[_datasource pageAtIndex:pre aIsCurPage:NO]];
           
       }
       else//add a header view with no size.
       {
           UIView* sView = [[[UIView alloc]initWithFrame:CGRectZero] autorelease];
           [_curViews addObject:sView];
       }
       
       [_curViews addObject:[_datasource pageAtIndex:page aIsCurPage:YES]];
       
       if (last <= _totalPages-1)
       {
           [_curViews addObject:[_datasource pageAtIndex:last aIsCurPage:NO]];
       }
       else//add a tail view with no size.
       {
           UIView* sView = [[[UIView alloc]initWithFrame:CGRectZero] autorelease];
           [_curViews addObject:sView];
       }       
   }
    
    
    self.mPreViewWidth = ((UIView*) [_curViews objectAtIndex:0]).frame.size.width;
    self.mCurViewWidth = ((UIView*) [_curViews objectAtIndex:1]).frame.size.width;
    self.mNextViewWidth = ((UIView*) [_curViews objectAtIndex:2]).frame.size.width;

}

- (int)validPageValue:(NSInteger)value {
    
    if(value == -1) value = _totalPages - 1;
    if(value == _totalPages) value = 0;
    
    return value;
    
}

- (void)handleTap:(UITapGestureRecognizer *)tap {
    
    if ([_delegate respondsToSelector:@selector(didClickPage:atIndex:)]) {
        [_delegate didClickPage:self atIndex:_curPage];
    }
    
}

//- (void)setViewContent:(UIView *)view atIndex:(NSInteger)index
//{
//    if (index == _curPage) {
//        [_curViews replaceObjectAtIndex:1 withObject:view];
//        for (int i = 0; i < 3; i++) {
//            UIView *v = [_curViews objectAtIndex:i];
//            v.userInteractionEnabled = YES;
//            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
//                                                                                        action:@selector(handleTap:)];
//            [v addGestureRecognizer:singleTap];
//            [singleTap release];
//            v.frame = CGRectOffset(v.frame, v.frame.size.width * i, 0);
//            [_scrollView addSubview:v];
//        }
//    }
//}

- (void)setViewContent:(UIView *)view atIndex:(NSInteger)index
{
    if (index == _curPage) {
        [_curViews replaceObjectAtIndex:1 withObject:view];
        CGFloat sDrift = 0;
        for (int i = 0; i < 3; i++) {
            UIView *v = [_curViews objectAtIndex:i];
            v.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(handleTap:)];
            [v addGestureRecognizer:singleTap];
            [singleTap release];
            v.frame = CGRectOffset(v.frame, sDrift, 0);
            [_scrollView addSubview:v];
            
            sDrift += v.frame.size.width;
        }
    }
}

#pragma mark - UIScrollViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
//    int x = aScrollView.contentOffset.x;
//    
//    //往下翻一张
//    if(x >= (2*self.frame.size.width)) {
//        _curPage = [self validPageValue:_curPage+1];
//        [self loadData];
//    }
//    
//    //往上翻
//    if(x <= 0) {
//        _curPage = [self validPageValue:_curPage-1];
//        [self loadData];
//    }
//}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    int x = aScrollView.contentOffset.x;
    
    //往下翻一张
    if(x >= (self.mPreViewWidth+self.mCurViewWidth)) {
        if (self.mIsRepeating)
        {
            _curPage = [self validPageValue:_curPage+1];
            [self loadData];            
        }
        else
        {
            if (_curPage+1<_totalPages)
            {
                _curPage += 1;
                [self loadData];
                
            }
            
        }
    }
    
    //往上翻
    if(x <= 0) {
        if(self.mIsRepeating)
        {
            _curPage = [self validPageValue:_curPage-1];
            [self loadData];
        }
        else
        {
            if (_curPage-1>=0)
            {
                _curPage -= 1;
                [self loadData];
            } 
        }
    }
}


//- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView {
//    
//    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0) animated:YES];
//    
//}
    
- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView {
    
    [_scrollView setContentOffset:CGPointMake(self.mPreViewWidth, 0) animated:YES];
    
}


@end
