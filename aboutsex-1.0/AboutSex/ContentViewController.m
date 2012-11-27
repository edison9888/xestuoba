//
//  ContentViewController.m
//  AboutSex
//
//  Created by Shane Wen on 12-6-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ContentViewController.h"

#define TAG_FOR_TITLE_BAR 100
#define TAG_FOR_RIGHT_COLLECTIN_BARBUTTON 101

@interface ContentViewController ()

- (void) configureNaviBar: (NSString*) aTitle WithCollectionSupport:(BOOL)canCollect;
- (void) constructSubviewsWithTitle:(NSString*)aTitle AndContentLoc:(NSString*)aLoc;
- (void) leftButtonPressed:(id)aButton;
- (void) rightButtonPressed:(id)aButton;
- (BOOL) toggleCollectedStatus;



@end

@implementation ContentViewController

@synthesize mItemListViewController;
@synthesize mWebView;
@synthesize mPageLoadingIndicator;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


//- (id) initWithTitle:(NSString*)aTitle AndContentLoc: (NSString*)aLoc;
//{
//    self = [super init];
//    if (self)
//    {
//
//        [self configureNaviBar:aTitle];
//
//        
//        [self constructSubviewsWithTitle: aTitle AndContentLoc: aLoc];
//    }
//    return self;
//}

- (void) setTitle:(NSString*)aTitle AndContentLoc: (NSString*)aLoc AndWithCollectionSupport: (BOOL) canCollect;
{
    [self configureNaviBar:aTitle WithCollectionSupport:canCollect];    
    [self constructSubviewsWithTitle: aTitle AndContentLoc: aLoc];

    return;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void) dealloc
{
    self.mWebView = nil;
    self.mPageLoadingIndicator = nil;
    
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
    [sTitleButton setFrame:CGRectMake(0, 0, 200, self.navigationController.navigationBar.frame.size.height)];
    [sTitleButton setTitle:aTitle forState:UIControlStateNormal];
    [self.navigationItem setTitleView:sTitleButton];
    
    
    //config the collection status for navi bar.
    if (canCollect)
    {
        UIBarButtonItem* sCollectionStatusBarButton;
        if ([self.mItemListViewController getCollectionStatuForSelectedRow])
        {
            sCollectionStatusBarButton =  [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"favorite24.png"] style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonPressed:)];
        }
        else {
            sCollectionStatusBarButton =  [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"favorite24_bw.png"] style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonPressed:)];
        }
        
        sCollectionStatusBarButton.tag = TAG_FOR_RIGHT_COLLECTIN_BARBUTTON;
        
        [self.navigationItem setRightBarButtonItem:sCollectionStatusBarButton];
        [sCollectionStatusBarButton release]; 
    }
        
    return;
}

- (void) constructSubviewsWithTitle:(NSString*)aTitle AndContentLoc:(NSString*)aLoc;
{    
    
    [self.view setBackgroundColor:TAB_PAGE_BGCOLOR];
    
    //UIWebView
    UIWebView* sWebView = [[UIWebView alloc]init];
    
    CGFloat sX;
    CGFloat sY;
    CGFloat sWidth;
    CGFloat sHeight;
    sX = 0;
    sY = 0;
    sWidth = [UIScreen mainScreen].applicationFrame.size.width;
    sHeight = [UIScreen mainScreen].applicationFrame.size.height-sY;
    [sWebView setFrame:CGRectMake(sX, sY, sWidth, sHeight)];
    
//    NSString* sPath = [[NSBundle mainBundle]pathForResource:@"1" ofType:@"html"];
//    NSFileHandle *sFileHandle = [NSFileHandle fileHandleForReadingAtPath:sPath];
//    
//    NSString *sHtmlString = [[NSString alloc] initWithData: 
//                            [sFileHandle readDataToEndOfFile] encoding:NSUTF8StringEncoding];
    
    NSString* sHtmlString = [[NSString alloc]initWithContentsOfFile:aLoc usedEncoding:nil error:nil];
  
    if (nil == sHtmlString)
    {
        NSString* sErrPageHtml = @"<!DOCTYPE HTML><html><meta charset=\"utf-8\">      <head><title>出错页面</title><style type=\"text/css\">body{text-align:center;}</style> </head><body><p>无法为你成功加载页面，很抱歉！<br/>也许还需要点时间，请稍后尝试！</p></body></html>";
        sHtmlString = sErrPageHtml;
    }
    [sWebView loadHTMLString:sHtmlString baseURL:[NSURL fileURLWithPath:aLoc]];
    [sHtmlString release];
    sWebView.delegate = self;
    [sWebView setOpaque:NO];
    [sWebView setBackgroundColor:[UIColor clearColor]];
    
    [self.view addSubview:sWebView];
    self.mWebView = sWebView;
    [sWebView release];

    UIActivityIndicatorView* sPageLoadingIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    [sPageLoadingIndicator setCenter:self.view.center];
    sPageLoadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    
    [self.view addSubview: sPageLoadingIndicator];
    self.mPageLoadingIndicator = sPageLoadingIndicator;
    [sPageLoadingIndicator release];
    
    return;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) leftButtonPressed:(id)aButton
{
//    void(^ContentViewDismissedFunc)(void) = NULL;
//    ContentViewDismissedFunc = ^(void) {
//        [ self.presentingViewController setColletedStatusOfCurrentMessageOnContentViewControllerDismissed:mIsCollected];
//        int i =0;
//    };
//    Class* s = [self.presentingViewController class];
//    NSLog(@"b:the class name of the presenting vc of contentvc: %@", NSStringFromClass(s));
//    
//    Class* s1 = [self.parentViewController class];
//    NSLog(@"b2:the class name of the parent vc of contentvc: %@", NSStringFromClass(s1));
//    

  //  [ self.presentingViewController setColletedStatusOfCurrentMessageOnContentViewControllerDismissed:mIsCollected];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) rightButtonPressed:(id)aButton
{
    [self toggleCollectedStatus];
    return;
}

- (BOOL) toggleCollectedStatus
{
    
    //refresh title bar's collected status
    UIBarButtonItem* sCollectionStatusBarButton = self.navigationItem.rightBarButtonItem;
    if ([self.mItemListViewController getCollectionStatuForSelectedRow])
    {
        sCollectionStatusBarButton.image = [UIImage imageNamed:@"favorite24_bw.png"];
    }
    else {
        sCollectionStatusBarButton.image = [UIImage imageNamed:@"favorite24.png"];
    }

    //tell the presenting view controller the changing of collected status, which will then write it back to .json file. 
   return [self.mItemListViewController toggleColletedStatusOfSelectedRow];
    
}


#pragma mark UIWebView delegate methods

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.mPageLoadingIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.mPageLoadingIndicator stopAnimating];
//    [self.mWebView stringByEvaluatingJavaScriptFromString:@"document.body.style.backgroundColor = '#000099';"];

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
    UIAlertView *alterview = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"fail to load page, please retry later", nil)  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alterview show];
    [alterview release];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

@end
