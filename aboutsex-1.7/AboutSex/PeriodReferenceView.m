//
//  BMIReference.m
//  FatCamp
//
//  Created by Wen Shane on 12-11-23.
//  Copyright (c) 2012年 Wen Shane. All rights reserved.
//

#import "PeriodReferenceView.h"

#define PATH_PERIOD_REFERENCE_FILE     @"PeriodReference.html"

@implementation PeriodReferenceView


+ (PeriodReferenceView*) getInstanceWithFrame:(CGRect)aFrame
{
    PeriodReferenceView* sInstance = [[[PeriodReferenceView alloc] initWithFrame:aFrame] autorelease];
    
    return sInstance;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        NSString* sBundlePath = [[NSBundle mainBundle] bundlePath];
        
        NSString* sLoc = [sBundlePath stringByAppendingPathComponent:PATH_PERIOD_REFERENCE_FILE];

        UIWebView* sWebView = [[UIWebView alloc]init];
        
        [sWebView setFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
                
        NSString* sHtmlString = [[NSString alloc]initWithContentsOfFile:sLoc usedEncoding:nil error:nil];
        
        if (nil == sHtmlString)
        {
            NSString* sErrPageHtml = @"<!DOCTYPE HTML><html><meta charset=\"utf-8\">      <head><title>出错页面</title><style type=\"text/css\">body{text-align:center;}</style> </head><body><p>无法为你成功加载页面，很抱歉！<br/>也许还需要点时间，请稍后尝试！</p></body></html>";
            sHtmlString = sErrPageHtml;
        }
        
        [sWebView loadHTMLString:sHtmlString baseURL:[NSURL fileURLWithPath:sLoc]];
        [sHtmlString release];
//        sWebView.delegate = self;
        [sWebView setOpaque:YES];
        [sWebView setBackgroundColor:[UIColor clearColor]];
        
        [self addSubview:sWebView];
        [sWebView release];
    
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
