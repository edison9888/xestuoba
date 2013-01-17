//
//  BaiduWrapper.m
//  AboutSex
//
//  Created by Shane Wen on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaiduWrapperViewController.h"
#import "SharedVariables.h"
#import "SharedStates.h"
#import "UIWebView+Clean.h"


//#define URL_ZHIDAO_SEX_COMPLETE    @"http://wapiknow.baidu.com/browse/174/?ssid=0&from=844b&bd_page_type=1&uid=wiaui_1340783265_7490&pu=sz%401320_2001&st=3&font=0&step=6&lm=0"
//
//#define URL_ZHIDAO_SEX_UNCOMPLETE @"http://wapiknow.baidu.com/browse/174/?ssid=0&from=844b&bd_page_type=1&uid=wiaui_1340783265_7490&pu=sz%401320_2001&st=3&font=0&step=9&lm=2"
//
//#define URL_ZHIDAO_SEX_HIGHREWARD @"http://wapiknow.baidu.com/browse/174/?ssid=0&from=844b&bd_page_type=1&uid=wiaui_1340783265_7490&pu=sz%401320_2001&st=3&font=0&step=11&lm=4"

//#define  URL_ZHIDAO_SEX_COMPLETE @"http://wenda.qihoo.com/c/136"


#define  URL_DEFAULT_ASK_URL @"http://wenwen.wap.soso.com/cat.jsp?sid=AfZV6GBmmO9_4t0RkKGfPmF_&sid=AfZV6GBmmO9_4t0RkKGfPmF_&catid=1192689664&state=4"

#define HEIGHT_SEARCH1_BAR  50


@interface BaiduWrapperViewController ()
{
    UIWebView* mWebView;
    UIActivityIndicatorView* mActivityIndicatoView;
    UIButton* mBackButton;
    UIButton* mStopOrRefreshButton;
    UIAlertView* mLoadingErrAlertView;
    BOOL mIsDisappearing;
}

@property (nonatomic, retain) UIActivityIndicatorView* mActivityIndicatorView;
@property (nonatomic, retain) UIWebView* mWebView;
@property (nonatomic, retain) UIButton* mBackButton;
@property (nonatomic, retain) UIButton* mStopOrRefreshButton;
@property (nonatomic, retain) UIAlertView* mLoadingErrAlertView;
@property (nonatomic, assign) BOOL mIsDisappearing;

- (void) startLoad;
//- (void) hideBaiduBarByExecutingJS;
- (void) hideWebView;
- (void) showWebView;
- (void) reShowWebView;

- (void) goBack: (id) aButton;
- (void) stopOrRefreshPage: (id) aButton;

- (void) refreshBackButton;
- (void) refreshStopOrRefreshButton;

- (void) handleLoadFailure;
- (void) dismissLoadingErrAlert:(NSTimer*)aTimer;

@end

@implementation BaiduWrapperViewController


@synthesize mActivityIndicatorView;
@synthesize mWebView;
@synthesize mBackButton;
@synthesize mStopOrRefreshButton;
@synthesize mLoadingErrAlertView;
@synthesize mIsDisappearing;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithTitle:(NSString*) aTitle
{
    self = [super init];
    if (self)
    {
        self.navigationItem.title = aTitle;
        self.mIsDisappearing = NO;
    }
    return self;
}

- (void) loadView
{
    CGRect sAppRect = [[UIScreen mainScreen] applicationFrame];
    sAppRect.origin.x = 0;
    sAppRect.origin.y = self.navigationController.navigationBar.bounds.size.height;
    sAppRect.size.height -= sAppRect.origin.y;
    UIView* sView = [[UIView alloc]initWithFrame:sAppRect];
    [sView setBackgroundColor:TAB_PAGE_BGCOLOR];
    self.view = sView;
    [sView release];
    
    //1. UIWebView
    UIWebView* sWebView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    sWebView.delegate = self;
    //code below does not work, STRANGELY.
//    [[sWebView scrollView] setContentInset:UIEdgeInsetsMake(10, 0, 100.0, 0)];
//    [sWebView setOpaque:NO];
//    [sWebView setBackgroundColor:[UIColor clearColor]];
    self.mWebView = sWebView;
    [self.view  addSubview:sWebView];
    [sWebView release];
    
    //2. UIActivityIndicatorView
     UIActivityIndicatorView* sActivityIndicatorView = [[UIActivityIndicatorView alloc] 
                                   initWithFrame : CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    [sActivityIndicatorView setCenter: self.view.center] ;
    sActivityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview : sActivityIndicatorView];
    self.mActivityIndicatorView = sActivityIndicatorView;
    [sActivityIndicatorView release];
    
    //3. back button and refresh button
    CGFloat sButtonWidth = 48;
    CGFloat sButtonHeight = 48;
    CGFloat sButtonPosY =  self.view.bounds.size.height-sButtonHeight;

    UIButton* sBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sBackButton setFrame:CGRectMake(2, sButtonPosY, sButtonWidth, sButtonHeight)];
    [sBackButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchDown];
    [sBackButton setImage:[UIImage imageNamed:@"back48.png"] forState:UIControlStateNormal];
    [sBackButton setHidden:YES];
    [self.view insertSubview:sBackButton aboveSubview:self.mWebView];
    self.mBackButton = sBackButton;
    
    
    UIButton* sStopOrRefreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sStopOrRefreshButton setFrame:CGRectMake(self.view.bounds.size.width-sButtonWidth-2, sButtonPosY, sButtonWidth, sButtonHeight)];
//    [sStopOrRefreshButton setImage:[UIImage imageNamed:@"refresh48.png"] forState:UIControlStateNormal];
    [sStopOrRefreshButton addTarget:self action:@selector(stopOrRefreshPage:) forControlEvents:UIControlEventTouchDown];
    [self.view insertSubview:sStopOrRefreshButton aboveSubview:self.mWebView];
    self.mStopOrRefreshButton = sStopOrRefreshButton;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self startLoad];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.mWebView = nil;
    self.mActivityIndicatorView = nil;
    self.mStopOrRefreshButton = nil;
    self.mBackButton = nil;
    self.mLoadingErrAlertView = nil;
}

- (void) dealloc
{
    [self.mWebView cleanForDealloc];
    self.mWebView = nil;
    self.mActivityIndicatorView = nil;
    self.mLoadingErrAlertView = nil;
    self.mStopOrRefreshButton = nil;
    self.mBackButton = nil;
    
    [super dealloc];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    NSHTTPCookie *cookie;
//    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    for (cookie in [storage cookies]) {
//        [storage deleteCookie:cookie];
//    }
//    
    return;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ( [[SharedStates getInstance] needShowNoticeForAsKAndAnswer])
    {
        [self presentNotice];
        [[SharedStates getInstance] closeShowAskAndAnswerNotice];
    }    
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.mWebView stopLoading];
    self.mIsDisappearing = YES;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) presentNotice
{
    NSString* sProvider = [[SharedStates getInstance] getAskProvider];
    if (!sProvider
        || sProvider.length <= 0)
    {
        sProvider = NSLocalizedString(@"third party", nil);
    }
    
    NSString* sNotcice = [NSString stringWithFormat:NSLocalizedString(@"Content of this section is provided by %@.", nil), sProvider];
    UIAlertView* sAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Notice", nil) message:sNotcice  delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Ok", nil), nil];
    sAlertView.delegate = self;
    
    [sAlertView show];
    [sAlertView release];

}


- (void) startLoad
{
    NSString* sURLStr = [[SharedStates getInstance] getAskURL];
    if (!sURLStr
        || sURLStr.length <= 4)
    {
        [self webView:self.mWebView didFailLoadWithError:nil];
    }
    else
    {
        NSURLRequest* sRequest  = [NSURLRequest requestWithURL:[NSURL URLWithString: sURLStr]];
        
        [self.mWebView loadRequest:sRequest];
    }
    
}


//- (void) hideBaiduBarByExecutingJS
//{
////    static NSString* sSetDisplayStatusByTag = @"function setDisplayStatusByTag(aTag, aDisplayStatus)"
////    "{"
////        "var elems = document.getElementsByTagName(aTag);"
////        "for (i=0; i<elems.length; i++)"
////        "{ elems[i].style.display=aDisplayStatus; }"
////    "};";
//    
//    static NSString* sSetDisplayStatusByID = @"function SetDisplayStatusByID(aID, aStatus)"
//    "{"
//    "var targetNode = document.getElementById(aID);"
//    "targetNode.style.display=aStatus;"
//    "};";
//
//    static NSString* sSetDisplayStatusForDivByClass = @"function SetDisplayStatusForDivByClass(aClass, aStatus)"
//    "{"
//    "var divElements = document.getElementsByTagName('div');"
//    "for (i=0; i<divElements.length; i++)"
//    "{"
//    "if (divElements[i].className == aClass)"
//    "{"
//    "divElements[i].style.display=aStatus;"
//    "}"
//    "}"
//    "};";
//    
//    //problematic
////    static NSString* sJSFunHideDivNodeByClass = @"function hideByClass(aClass, aStatus)"
////    "{"
////        "var elementsOfTargetClass = document.getElementsByClassName(aClass);"
////        "for (i=0; i<elementsOfTargetClass.length; i++)"
////        "{"
////            "if (elementsOfTargetClass[i].tagName == \"div')"
////            "{elementsOfTargetClass[i].style.display=aStatus;}"
////        "}"
////    "};";
//
//    
////    static NSString* sHideHeader = @"setDisplayStatusByTag(\"header\", \"block\");";
//    static NSString* sHideUIHeader = @"SetDisplayStatusForDivByClass(\"ui-header\", \"none\"); ";
//    static NSString* sHideGoBack = @"SetDisplayStatusForDivByClass(\"goback\", \"none\"); ";
//    static NSString* sHideFooter = @"SetDisplayStatusByID(\"footer\", \"none\"); ";
//        
//    NSString* sJSStr = [NSString stringWithFormat:@"%@ %@ %@ %@ %@", sSetDisplayStatusByID, sSetDisplayStatusForDivByClass, sHideGoBack, sHideUIHeader, sHideFooter];
//    
//    [self.mWebView stringByEvaluatingJavaScriptFromString:sJSStr];
//    
//    return;
//
//    
//}


- (void) hideWebView
{
    [self.mWebView setHidden:YES];
}

- (void) showWebView
{
    [self.mWebView setHidden:NO];
}

-(void) reShowWebView
{
    [self showWebView];

    [self.mActivityIndicatorView stopAnimating];
    [self refreshStopOrRefreshButton];
    [self refreshBackButton];
}

-(void) reShowBackWebView
{
    [self goBack:self.mBackButton];
    [self reShowWebView];
}

#pragma mark -
#pragma mark manipulate the web page browsing experience

- (void) goBack: (id) aButton
{
    if ([self.mWebView canGoBack])
    {
        [self.mWebView goBack];
    }

    return;
}

- (void) stopOrRefreshPage: (id) aButton
{
    
    if ([self.mWebView isLoading])
    {
        [self.mWebView stopLoading];
        [self reShowWebView];
    }
    else 
    {
        [self.mWebView reload];
    }
}

- (void) refreshBackButton
{
    if ([self.mWebView canGoBack])
    {
        [self.mBackButton setHidden:NO];
    }
    else 
    {
        [self.mBackButton setHidden:YES];
//        [self.mBackButton setImage:[UIImage imageNamed:@"back48.png"] forState:UIControlStateNormal];
    }
}

- (void) refreshStopOrRefreshButton
{
    
    if ([self.mWebView isLoading])
    {
        [self.mStopOrRefreshButton setImage:[UIImage imageNamed:@"stop48.png"] forState:UIControlStateNormal];
    }
    else 
    {
        [self.mStopOrRefreshButton setImage:[UIImage imageNamed:@"refresh48.png"] forState:UIControlStateNormal];    
    }

}

- (void) dismissLoadingErrAlert:(NSTimer*)aTimer
{
    [self.mLoadingErrAlertView dismissWithClickedButtonIndex:0 animated:YES];  
    self.mLoadingErrAlertView = nil;
    return;
}

- (void) handleLoadFailure
{
    [self reShowWebView];
    if (self.mWebView
        && !self.mIsDisappearing)
    {
        UIAlertView* sAlertView = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"fail to load page, please retry later", nil)  delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Ok", nil), nil];
        sAlertView.delegate = self;
        
        [sAlertView show];
        [sAlertView release];

    }

    
//    [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(dismissLoadingErrAlert:) userInfo:nil repeats:NO];  
}

#pragma mark delegate methods of UIWebView

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self refreshStopOrRefreshButton];
    [self.mActivityIndicatorView startAnimating];
    [self hideWebView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    [self hideBaiduBarByExecutingJS];  
    [self performSelector:@selector(reShowWebView) withObject:nil afterDelay:0.2];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.mWebView stopLoading];
//    [self hideBaiduBarByExecutingJS];  
    [self handleLoadFailure];
//    [self performSelector:@selector(handleLoadFailure) withObject:nil afterDelay:0.4];      

//    if (!self.mLoadingErrAlertView)
//    {
//        [self performSelector:@selector(handleLoadFailure) withObject:nil afterDelay:0.4];
//    }
//    else 
//    {
//        [self performSelector:@selector(reShowWebView) withObject:nil afterDelay:0.4];      
//    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}


@end
