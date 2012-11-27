//
//  ContentViewController.m
//  AboutSex
//
//  Created by Shane Wen on 12-6-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ContentViewController.h"
#import "SVSegmentedControl.h"
#import "CMPopTipView.h"

#define TAG_FOR_TITLE_BAR 100
#define TAG_FOR_RIGHT_COLLECTIN_BARBUTTON 101

@interface ContentViewController ()
{
    UIButton* mCollectionButton;
}

@property (nonatomic, retain) UIButton* mCollectionButton;

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

- (void) setTitle:(NSString*)aTitle AndContentLoc: (NSURL*)aLoc AndWithCollectionSupport: (BOOL) canCollect;
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
    
    self.mCollectionButton = nil;
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
    
    NSMutableArray* sRightBarButtonItems = [[NSMutableArray alloc] initWithCapacity:2];
    
    //Text size change button
    UIButton* sFontSizeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sFontSizeButton.frame = CGRectMake(0, 0, 24, 24);
    [sFontSizeButton setImage: [UIImage imageNamed:@"fontsize20.png"] forState:UIControlStateNormal];
    [sFontSizeButton addTarget:self action:@selector(fontSizeButtonPressed) forControlEvents:UIControlEventTouchDown];
    
    UIBarButtonItem* sFontSizeBarButton =  [[UIBarButtonItem alloc]initWithCustomView:sFontSizeButton];
    [sRightBarButtonItems addObject:sFontSizeBarButton];
    [sFontSizeBarButton release];

    
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

        UIBarButtonItem* sCollectionStatusBarButton =  [[UIBarButtonItem alloc]initWithCustomView:sCollectionButton];
        self.mCollectionButton = sCollectionButton;
        
        [sRightBarButtonItems addObject:sCollectionStatusBarButton];
        [sCollectionStatusBarButton release]; 
    }
    
    
    self.navigationItem.rightBarButtonItems = sRightBarButtonItems;
    [sRightBarButtonItems release];

    return;
}

- (void) constructSubviewsWithTitle:(NSString*)aTitle AndContentLoc:(NSURL*)aContentURL;
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
        NSURLRequest* sRequest = [NSURLRequest requestWithURL:aContentURL];
        [sWebView loadRequest:sRequest];
    }
    
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
  //  [ self.presentingViewController setColletedStatusOfCurrentMessageOnContentViewControllerDismissed:mIsCollected];
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void) collectionButtonPressed
{
    [self toggleCollectedStatus];
    return;
}

- (void) fontSizeButtonPressed
{

    
    
    SVSegmentedControl *sSegmentedControl = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:NSLocalizedString(@"small", nil), NSLocalizedString(@"medium", nil), NSLocalizedString(@"large", nil), nil]];
    //    [sSegmentedControl addTarget:self action:@selector(sexSegmentedControlChanged:) forControlEvents:UIControlEventValueChanged];
	sSegmentedControl.font = [UIFont boldSystemFontOfSize:19];
	sSegmentedControl.titleEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 25);
//    sSegmentedControl.center = CGPointMake(sX+sWidth/2, sY+sHeightInfoLine/2);
	sSegmentedControl.thumb.tintColor = MAIN_BGCOLOR_TRANSPARENT;
    sSegmentedControl.backgroundColor = [UIColor lightGrayColor];
    
    sSegmentedControl.selectedIndex = 1;
    


    CMPopTipView* sPopTipView = [[CMPopTipView alloc] initWithCustomView:sSegmentedControl];
    [sSegmentedControl release];

    sPopTipView.center = CGPointMake(sPopTipView.center.x+30, sPopTipView.center.y-30);
    sPopTipView.textColor = [UIColor grayColor];
    sPopTipView.backgroundColor = [UIColor lightGrayColor];
    sPopTipView.topMargin = 0;
    sPopTipView.sidePadding = 2;
    sPopTipView.cornerRadius = 2;
    sPopTipView.disableTapToDismiss = YES;
    sPopTipView.animation = CMPopTipAnimationPop;
    UIBarButtonItem* sRightBarButtonItem = (UIBarButtonItem*)[self.navigationItem.rightBarButtonItems objectAtIndex:0];

    [sPopTipView presentPointingAtView:sRightBarButtonItem.customView inView:self.view animated:YES];

    [sPopTipView release];
    
    return;
}

- (void) smallFontSelected
{
    
}

- (void) mediumFontSelected
{
    
}

- (void) largeFontSelected
{
    
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
