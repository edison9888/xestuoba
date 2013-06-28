//
//  ContentViewController.m
//  AboutSex
//
//  Created by Shane Wen on 12-6-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ContentViewController.h"
//#import "SVSegmentedControl.h"
//#import "CMPopTipView.h"
#import "UIWebView+Clean.h"

#import "UserConfiger.h"
#import "AdBannerManager.h"

#define TAG_FOR_TITLE_BAR 100
#define TAG_FOR_RIGHT_COLLECTIN_BARBUTTON 101

#define TIME_FOR_JS_EXECUTATION     0.1

@interface ContentViewController ()
{
    UIButton* mCollectionButton;
    NSTimer* mJSExecutationTimer;
    BOOL mIsDisappearing;
    UIScrollView* mScrollView;
    
    NSString* mTitle;
    BOOL mCanCollect;
    NSURL* mContentURL;
}

@property (nonatomic, retain) UIButton* mCollectionButton;
@property (nonatomic, retain) NSTimer* mJSExecutationTimer;
@property (nonatomic, assign) BOOL mIsDisappearing;
@property (nonatomic, retain) UIScrollView* mScrollView;

@property (nonatomic, copy)         NSString* mTitle;
@property (nonatomic, assign)       BOOL mCanCollect;
@property (nonatomic, copy)         NSURL* mContentURL;


- (void) configureNaviBar: (NSString*) aTitle WithCollectionSupport:(BOOL)canCollect;
- (void) constructSubviewsWithTitle:(NSString*)aTitle AndContentLoc:(NSURL*)aContentURL;
- (void) leftButtonPressed:(id)aButton;
- (void) collectionButtonPressed;
- (BOOL) toggleCollectedStatus;



@end

@implementation ContentViewController

@synthesize mItemListViewController;
@synthesize mWebView;
@synthesize mPageLoadingIndicator;

@synthesize mCollectionButton;

@synthesize mJSExecutationTimer;
@synthesize mIsDisappearing;
@synthesize mScrollView;

@synthesize mCanCollect;
@synthesize mContentURL;
@synthesize mTitle;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.mIsDisappearing = NO;
    }
    return self;
}


- (void) setTitle:(NSString*)aTitle AndContentLoc: (NSURL*)aLoc AndWithCollectionSupport: (BOOL) canCollect;
{
    self.mTitle = aTitle;
    self.mContentURL = aLoc;
    self.mCanCollect = canCollect;
    return;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self configureNaviBar:self.mTitle WithCollectionSupport:self.mCanCollect];
    [self constructSubviewsWithTitle: self.mTitle AndContentLoc: self.mContentURL];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.view.backgroundColor = [UIColor whiteColor];

}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.mWebView stopLoading];
    self.mIsDisappearing = YES;
    
}

- (void) dealloc
{
    [self.mWebView cleanForDealloc];
    self.mWebView = nil;
    self.mPageLoadingIndicator = nil;
    
    self.mCollectionButton = nil;
    self.mJSExecutationTimer = nil;
    
    self.mScrollView = nil;
    
    self.mTitle = nil;
    self.mContentURL = nil;
    [super dealloc];
}

- (void) configureNaviBar: (NSString*) aTitle WithCollectionSupport:(BOOL)canCollect;
{
    // config the title view for navi bar.
    UIButton* sTitleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sTitleButton.userInteractionEnabled = NO;
    UIFont* sFont = [UIFont fontWithName:@"Arial" size:15];
    sTitleButton.titleLabel.font = sFont;
    sTitleButton.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;        
    [sTitleButton setFrame:CGRectMake(0, 0, 150, self.navigationController.navigationBar.frame.size.height)];
    [sTitleButton setTitle:aTitle forState:UIControlStateNormal];
    [self.navigationItem setTitleView:sTitleButton];
    
    //config the collection status for navi bar.
    if (canCollect)
    {
        UIButton* sCollectionButton = [UIButton buttonWithType:UIButtonTypeCustom];

        if ([self.mItemListViewController getCollectionStatuForSelectedRow])
        {
            [sCollectionButton setImage:[UIImage imageNamed:@"favorite20.png"] forState:UIControlStateNormal];
        }
        else 
        {
            [sCollectionButton setImage:[UIImage imageNamed:@"favorite_inactive20.png"] forState:UIControlStateNormal];
        }
        sCollectionButton.frame = CGRectMake(0, 0, 20, 20);
        [sCollectionButton addTarget:self action:@selector(collectionButtonPressed) forControlEvents:UIControlEventTouchDown];

        UIBarButtonItem* sCollectionStatusBarButtonItem =  [[UIBarButtonItem alloc]initWithCustomView:sCollectionButton];
        self.mCollectionButton = sCollectionButton;
        
        self.navigationItem.rightBarButtonItem = sCollectionStatusBarButtonItem;
        [sCollectionStatusBarButtonItem release]; 
    }
    

    return;
}

- (void) constructSubviewsWithTitle:(NSString*)aTitle AndContentLoc:(NSURL*)aContentURL;
{    
    //UIWebView
    UIWebView* sWebView = [[UIWebView alloc]init];
    self.mWebView = sWebView;

    CGFloat sX;
    CGFloat sY;
    CGFloat sWidth;
    CGFloat sHeight;
    sX = 0;
    sY = 0;
    sWidth = [UIScreen mainScreen].applicationFrame.size.width;
    sHeight = [UIScreen mainScreen].applicationFrame.size.height-self.navigationController.navigationBar.bounds.size.height;
    [sWebView setFrame:CGRectMake(sX, sY, sWidth, sHeight)];
    
    if ([aContentURL isFileURL])
    {
        NSString* sHtmlString = [[NSString alloc]initWithContentsOfURL:aContentURL usedEncoding:nil error:nil];
        
        if (nil == sHtmlString)
        {
            NSString* sErrPageHtml = @"<!DOCTYPE HTML><html><meta charset=\"utf-8\">      <head><title>出错页面</title><style type=\"text/css\">body{text-align:center;}</style> </head><body><p>无法为你成功加载页面，很抱歉！<br/>也许还需要点时间，请稍后尝试！</p></body></html>";
            sHtmlString = sErrPageHtml;
        }
        
        [sWebView loadHTMLString:sHtmlString baseURL:aContentURL];
        [sHtmlString release];
    }
    else 
    {
        //
        NSURLRequest* sRequest = [NSURLRequest requestWithURL:aContentURL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:20];
        [sWebView loadRequest:sRequest];
    }
    
    sWebView.delegate = self;
    [sWebView setOpaque:YES];
    [sWebView setBackgroundColor:[UIColor clearColor]];
    
//    [self.view addSubview:sWebView];
    
    if ([UserConfiger getFontSizeType] != ENUM_FONT_SIZE_NORMAL)
    {
        NSTimer* sTimer = [[NSTimer alloc]initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:TIME_FOR_JS_EXECUTATION]  interval:TIME_FOR_JS_EXECUTATION target:self selector:@selector(setFontSizeForWebViewIfNecessary) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:sTimer forMode:NSDefaultRunLoopMode];
        
        self.mJSExecutationTimer = sTimer;
        
        [sTimer release];

    }
    

    [sWebView release];

    
    
    //disable webview scrolling capability
    UIScrollView* sScrollViewOfWebView = nil;
    if ([self.mWebView respondsToSelector:@selector(scrollView)])
    {
        sScrollViewOfWebView = self.mWebView.scrollView;
    }
    else
    {
        NSArray *arr = [self.mWebView subviews];
        sScrollViewOfWebView = [arr objectAtIndex:0];
    }
    sScrollViewOfWebView.scrollEnabled = NO;
    [sWebView.scrollView setShowsHorizontalScrollIndicator:NO];

    //
    UIScrollView* sScrollView = [[UIScrollView alloc] initWithFrame:sWebView.frame];
    sScrollView.scrollEnabled = YES;
    sScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:sScrollView];
    self.mScrollView = sScrollView;
    [sScrollView release];
    
    //
    [self.mScrollView addSubview:self.mWebView];

    //
    UIActivityIndicatorView* sPageLoadingIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    [sPageLoadingIndicator setCenter:self.view.center];
    sPageLoadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    
    [self.view addSubview: sPageLoadingIndicator];
    self.mPageLoadingIndicator = sPageLoadingIndicator;
    [sPageLoadingIndicator release];

    
    return;
}

- (void) setFontSizeForWebViewIfNecessary
{
    ENUM_FONT_SIZE_TYPE sFontSizeType = [UserConfiger getFontSizeType];
    if (sFontSizeType != ENUM_FONT_SIZE_NORMAL)
    {
        NSInteger sFontSizeScale = [UserConfiger getFontSizeScalePercentByFontSizeType:sFontSizeType];
        
        NSString* sJSTempStr = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'";
        
        NSString* sJSStr = [NSString stringWithFormat:sJSTempStr, sFontSizeScale];
        
        [self.mWebView stringByEvaluatingJavaScriptFromString:sJSStr];

    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) leftButtonPressed:(id)aButton
{
  //  [ self.presentingViewController setColletedStatusOfCurrentMessageOnContentViewControllerDismissed:mIsCollected];
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void) collectionButtonPressed
{
    [self toggleCollectedStatus];
    return;
}

- (BOOL) toggleCollectedStatus
{
    
    //refresh title bar's collected status    
//    UIButton* sCollectionButton = (UIButton*)self.navigationItem.rightBarButtonItem.customView;
    if ([self.mItemListViewController getCollectionStatuForSelectedRow])
    {
        [self.mCollectionButton setImage:[UIImage imageNamed:@"favorite_inactive20.png"] forState:UIControlStateNormal];
    }
    else {
        [self.mCollectionButton setImage:[UIImage imageNamed:@"favorite20.png"] forState:UIControlStateNormal];
    }


    //tell the presenting view controller the changing of collected status, which will then write it back to .json file. 
   return [self.mItemListViewController toggleColletedStatusOfSelectedRow];
    
}


#pragma mark UIWebView delegate methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if (self.mPageLoadingIndicator)
    {
        [self.mPageLoadingIndicator startAnimating];
    }

}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    [self setFontSizeForWebViewIfNecessary];
    
    if (self.mJSExecutationTimer)
    {
        [self.mJSExecutationTimer invalidate];
    }
    
    if (self.mPageLoadingIndicator)
    {
        [self.mPageLoadingIndicator stopAnimating];
    }
    
    [self setFontSizeForWebViewIfNecessary];
//    [self.mWebView stringByEvaluatingJavaScriptFromString:@"document.body.style.backgroundColor = '#000099';"];
    
    
    //
    NSString *heightString = [self.mWebView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"];
    CGFloat sHeight = [heightString floatValue];
    [self.mWebView setFrame:CGRectMake(0, 0, self.mWebView.bounds.size.width, sHeight)];    
    [self.mScrollView setContentSize:CGSizeMake(self.mScrollView.contentSize.width, sHeight+20)];
    
    UIView* sAdView = [[[UIView alloc] initWithFrame:CGRectMake(0, sHeight-30, 320, 50)] autorelease];
    [self.mScrollView addSubview:sAdView];

    BannerAdapter* sBanner = [AdBannerManager adBannerWithPlaceType:E_BANNER_AD_PLACE_TYPE_PAGE];
    if (sBanner)
    {
        sBanner.frame = CGRectMake(0, 0, sBanner.bounds.size.width, sBanner.bounds.size.height);
        [sAdView addSubview:sBanner];
    }

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //ensure that alert view pops only when the this controller still exists.
    if (self.mWebView
        && !self.mIsDisappearing)
    {
        UIAlertView *alterview = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"fail to load page, please retry later", nil)  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alterview show];
        [alterview release];
    }
}


@end
