//
//  ContentViewController.m
//  AboutSex
//
//  Created by Shane Wen on 12-6-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ContentViewController2.h"
//#import "SVSegmentedControl.h"
//#import "CMPopTipView.h"
#import "UIWebView+Clean.h"

#import "UserConfiger.h"
#import "CommentsController.h"
#import "JSONWrapper.h"
#import "AFNetworking.h"
#import "SharedStates.h"
#import "ATMHud.h"
#import <QuartzCore/QuartzCore.h>
#import "NSURL+WithChanelID.h"
#import "UIGlossyButton.h"
#import "UIView+LayerEffects.h"
#import "SharedVariables.h"
#import "TaggedButton.h"
#import "InteractivityCountManager.h"
#import "MobClick.h"
#import "AdBannerManager.h"
#import "NSString+MyString.h"
#import "NonRetainedTimer.h"

#define TAG_FOR_TITLE_BAR 100
#define TAG_FOR_RIGHT_COLLECTIN_BARBUTTON 101

#define TIME_FOR_JS_EXECUTATION     0.1
#define HEIGHT_COMMENT_BAR      40

@interface ContentViewController2 ()
{
    NSTimer* mJSExecutationTimer;
    BOOL mCanCollect;
    
  
    UIButton* mCollectionButton;
    TaggedButton* mLikeButton;
}

@property (nonatomic, retain) UIButton* mCollectionButton;
@property (nonatomic, retain) NSTimer* mJSExecutationTimer;
@property (nonatomic, assign) BOOL mCanCollect;
@property (nonatomic, retain) TaggedButton* mLikeButton;

- (void) configureNaviBar: (NSString*) aTitle WithCollectionSupport:(BOOL)canCollect;
- (void) constructSubviewsWithTitle:(NSString*)aTitle AndContentLoc:(NSURL*)aContentURL;
- (void) leftButtonPressed:(id)aButton;

@end

@implementation ContentViewController2

@synthesize mItemListViewController;
@synthesize mBodyView;
@synthesize mWebView;
@synthesize containerView;
@synthesize mTextView;
@synthesize mPageLoadingIndicator;

@synthesize mCollectionButton;

@synthesize mJSExecutationTimer;
@synthesize mItem;

@synthesize mRequest;
@synthesize mCanCollect;
@synthesize mLikeButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void) setTitle:(NSString*)aTitle AndContentLoc: (NSURL*)aLoc AndWithCollectionSupport: (BOOL) canCollect;
{
//    [self configureNaviBar:aTitle WithCollectionSupport:canCollect];
//    [self constructSubviewsWithTitle: aTitle AndContentLoc: aLoc];

    return;
}

- (void) setItem:(StreamItem*)aItem AndWithCollectionSupport: (BOOL) canCollect;
{
    self.mItem = aItem;
    self.mCanCollect = canCollect;
    return;
}

- (BOOL) canCollect
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString* sTitle = self.mItem.mName;
    NSURL* sURL = [self.mItem getURL];
    
    [self configureNaviBar:sTitle WithCollectionSupport:self.mCanCollect];
    [self constructSubviewsWithTitle: sTitle AndContentLoc: sURL];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

}

//- (void) swipe2Left
//{
//    [self presentCommentsController];
//}
//
//- (void) swipe2Right
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    self.mPageLoadingIndicator = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];    
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];    
    [self.mTextView resignFirstResponder];
}

- (void) dealloc
{
    NSLog(@"dealoc.........");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [self.mWebView cleanForDealloc];
    self.mBodyView = nil;
    self.mWebView = nil;
    self.containerView = nil;
    self.mTextView = nil;
    self.mPageLoadingIndicator = nil;
    
    self.mCollectionButton = nil;

    [self.mJSExecutationTimer invalidate];
    self.mJSExecutationTimer = nil;
    self.mItem = nil;
    self.mRequest = nil;
    
    self.mLikeButton = nil;
    
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
    
    

    UIGlossyButton* b = [[[UIGlossyButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30)] autorelease];
    [b setTitle:[self getRightBarButtonItemText] forState:UIControlStateNormal];
    [b sizeToFit];

	[b useWhiteLabel: YES];
    b.tintColor = [UIColor blackColor];
    b.titleLabel.font = [UIFont systemFontOfSize:12];
    b.titleLabel.textAlignment = UITextAlignmentLeft;
	[b setShadow:[UIColor blackColor] opacity:0.8 offset:CGSizeMake(0, 1) blurRadius: 4];
//    b.invertGraidentOnSelected = YES;
    b.buttonBorderWidth = 2.0f;
    b.borderColor = [UIColor blackColor];
    b.backgroundOpacity = 0.5;
    [b setGradientType: kUIGlossyButtonGradientTypeSolid];
//	[b setExtraShadingType:kUIGlossyButtonExtraShadingTypeAngleLeft];
    [b addTarget:self action:@selector(presentCommentsController) forControlEvents:UIControlEventTouchDown];

    UIBarButtonItem* sBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:b];    
    self.navigationItem.rightBarButtonItem = sBarButtonItem;
    [sBarButtonItem release];
    
    return;
}

- (NSString*) getRightBarButtonItemText
{
    NSString* sCommentsStr = [NSString stringWithFormat:@" %d%@", self.mItem.mNumComments, NSLocalizedString(@"Comments", nil)];
    return sCommentsStr;
}

- (void) presentCommentsController
{
    CommentsController* sCommentsController = [[CommentsController alloc] initWithItem:self.mItem];
    
    [self.navigationController pushViewController:sCommentsController animated:YES];
    
    [sCommentsController release];
    
    [MobClick event:@"UEID_COMMENT_VIEW"];

    
    return;
}

- (void) constructSubviewsWithTitle:(NSString*)aTitle AndContentLoc:(NSURL*)aContentURL;
{
    UIActivityIndicatorView* sPageLoadingIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    [sPageLoadingIndicator setCenter:self.view.center];
    sPageLoadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    
    [self.view addSubview: sPageLoadingIndicator];
    self.mPageLoadingIndicator = sPageLoadingIndicator;
    [sPageLoadingIndicator release];
    
    //UIWebView
    UIWebView* sWebView = [[UIWebView alloc]init];
    self.mWebView = sWebView;

    CGRect sWebRect = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-self.navigationController.navigationBar.bounds.size.height - HEIGHT_COMMENT_BAR);
    [sWebView setFrame:sWebRect];
    
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
//    sWebView.scrollView.delegate = self;
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

    [sWebView setOpaque:NO];
    
    [sWebView setBackgroundColor:[UIColor clearColor]];
        
    if ([UserConfiger getFontSizeType] != ENUM_FONT_SIZE_NORMAL)
    {
        NSMethodSignature* sMethodSignature = [[ContentViewController2 class] instanceMethodSignatureForSelector:@selector(setFontSizeForWebViewIfNecessary)];
        NSInvocation* sInvocation = [NSInvocation invocationWithMethodSignature:sMethodSignature];
        [sInvocation setTarget:self];//self is not retained
        [sInvocation setSelector:@selector(setFontSizeForWebViewIfNecessary)];
        
        //rely this timer on a static help object, not self, keep away from a serious crash.
        //that is, if this timer's target is self, then it will retain it.
        //if the timer is the last holder of self, then invalidating timer will trigger self being deallocated.
        //after leaving this page(timer is its only holder), we go into webviewDidFinished, and invalidate the timer, then dealloc will be executed immediately and simaltaneously, then mPageLoadingIndicator in  webviewDidFinished will cause a crash because self is deallocated and inexistant already.
        NSTimer* sTimer = [[NSTimer alloc]initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:TIME_FOR_JS_EXECUTATION]  interval:TIME_FOR_JS_EXECUTATION target:[NonRetainedTimer shared] selector:@selector(callInvocation:) userInfo:sInvocation repeats:YES];

        [[NSRunLoop currentRunLoop] addTimer:sTimer forMode:NSDefaultRunLoopMode];
        
        self.mJSExecutationTimer = sTimer;
        
        [sTimer release];

    }
    [sWebView release];
    
    //
    UIScrollView* sScrollView = [[UIScrollView alloc] initWithFrame:sWebRect];
    sScrollView.scrollEnabled = YES;
    [sScrollView addSubview:self.mWebView];
    
    [self.view addSubview:sScrollView];
    
    self.mBodyView = sScrollView;
    [sScrollView release];
        
    //comment text view
    UIView* sContainerView = [[[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-HEIGHT_COMMENT_BAR, self.view.bounds.size.width, HEIGHT_COMMENT_BAR)] autorelease];
    [self.view addSubview: sContainerView];
    
    self.containerView = sContainerView;
    
    HPGrowingTextView* sTextView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(0, 3, 230, 40)];//original width 270
    sTextView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
    sTextView.minNumberOfLines = 1;
	sTextView.maxNumberOfLines = 6;
	sTextView.returnKeyType = UIReturnKeySend; //just as an example
	sTextView.font = [UIFont systemFontOfSize:15.0f];
    if (self.mItem.mComment.length > 0)
    {
        sTextView.placeHolder = self.mItem.mComment;
    }
    else
    {
        sTextView.placeHolder = NSLocalizedString(@"Say something", nil);
    }

	sTextView.delegate = self;
    sTextView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    sTextView.backgroundColor = [UIColor whiteColor];
    sTextView.editable = NO;
    [self.containerView addSubview:sTextView];
    
    self.mTextView = sTextView;
    [mTextView release];
    // textView.text = @"test\n\ntest";
	// textView.animateHeightChange = NO; //turns off animation
	
    UIImage *rawEntryBackground = [UIImage imageNamed:@"MessageEntryInputField.png"];
//    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:17 topCapHeight:22];

    UIImageView *entryImageView = [[[UIImageView alloc] initWithImage:entryBackground] autorelease];
//    entryImageView.frame = CGRectMake(0, 0, 248, 40);
    entryImageView.frame = CGRectMake(0, 0, 238, 40); ////original width 278

    entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    UIImage *rawBackground = [UIImage imageNamed:@"MessageEntryBackground.png"];
    UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *imageView = [[[UIImageView alloc] initWithImage:background] autorelease];
    imageView.frame = CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height);
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    mTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    // view hierachy
    [self.containerView addSubview:imageView];
    [self.containerView addSubview:sTextView];
    [self.containerView addSubview:entryImageView];
    
	TaggedButton *sCollectionBtn = [TaggedButton buttonWithType:UIButtonTypeCustom];
    sCollectionBtn.frame = CGRectMake(containerView.frame.size.width - 36, 8, 24, 24);
    sCollectionBtn.mMarginInsets = UIEdgeInsetsMake(5, 5, 8, 12);
    sCollectionBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
	[sCollectionBtn addTarget:self action:@selector(collectionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [sCollectionBtn setImage:[UIImage imageNamed:@"heart_inactive24"] forState:UIControlStateNormal];
    [sCollectionBtn setImage:[UIImage imageNamed:@"heart_active24"] forState:UIControlStateSelected];
    [sCollectionBtn setSelected:self.mItem.mIsMarked];
    sCollectionBtn.enabled = NO;
	[self.containerView addSubview:sCollectionBtn];
    
    self.mCollectionButton = sCollectionBtn;
    
    //
    TaggedButton *sLikeBtn = [TaggedButton buttonWithType:UIButtonTypeCustom];
    sLikeBtn.frame = CGRectMake(containerView.frame.size.width - 75, 8, 24, 24);
    sLikeBtn.mMarginInsets = UIEdgeInsetsMake(5, 20, 8, 5);
    sLikeBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
	[sLikeBtn addTarget:self action:@selector(likeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [sLikeBtn setImage:[UIImage imageNamed:@"like_inactive_24"] forState:UIControlStateNormal];
    [sLikeBtn setImage:[UIImage imageNamed:@"like_active_24"] forState:UIControlStateSelected];
    [sLikeBtn setSelected:self.mItem.mIsLiked];
    sLikeBtn.enabled = NO;
	[self.containerView addSubview:sLikeBtn];
    
    self.mLikeButton = sLikeBtn;

    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
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

- (void) likeButtonPressed:(UIButton*)aButton
{
    if (!aButton.selected)
    {
        [aButton setSelected:YES];
        [self.mItem updateLikedStatus:YES];
        
        [[InteractivityCountManager shared] likeItem:self.mItem];
    }
 }

- (void) collectionButtonPressed:(UIButton*)aButton
{
    BOOL sCollected = !(aButton.selected);
    [self.mCollectionButton setSelected:sCollected];
    [self.mItem updateMarkedStaus:sCollected];
    
    [[InteractivityCountManager shared] collectItem:self.mItem Collected:sCollected];
    
    return;
}

#pragma mark UIWebView delegate methods
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webview did start loading.");

    if (self.mPageLoadingIndicator)
    {
        [self.mPageLoadingIndicator startAnimating];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webview did finish loading.");
    
    //
    self.mLikeButton.enabled = YES;
    self.mTextView.editable = YES;
    self.mCollectionButton.enabled = YES;
    
    if (self.mJSExecutationTimer)
    {
        [self.mJSExecutationTimer invalidate];
    }
    
    if (self.mPageLoadingIndicator)
    {
        [self.mPageLoadingIndicator stopAnimating];
    }
    
    [self setFontSizeForWebViewIfNecessary];
    
    NSString *heightString = [self.mWebView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"];
    CGFloat sHeight = [heightString floatValue];
    [self.mBodyView setContentSize:CGSizeMake(self.mBodyView.bounds.size.width, sHeight)];
    [self.mWebView setFrame:CGRectMake(0, 0, self.mWebView.bounds.size.width, sHeight)];
    
    [self.mBodyView setContentSize:CGSizeMake(self.mBodyView.contentSize.width, self.mBodyView.contentSize.height+25)];
    UIView* sAdView = [[[UIView alloc] initWithFrame:CGRectMake(0, sHeight-30, 320, 55)] autorelease];
    [self.mBodyView addSubview:sAdView];
    
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
    if (self.mWebView)
    {
        if (self.mPageLoadingIndicator)
        {
            [self.mPageLoadingIndicator stopAnimating];
        }
        UIAlertView *alterview = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"fail to load page, please retry later", nil)  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alterview show];
        [alterview release];
    }
}

//disable horizontal scrolling.
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x > 0)
    {
        scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y);  
    }
}

//
-(void) keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
	// get a rect for the textView frame
	CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	
	// set views with new info
	self.containerView.frame = containerFrame;
	
	// commit animations
	[UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)note
{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
	
	// get a rect for the textView frame
	CGRect containerFrame = self.containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
	
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
	// set views with new info
	self.containerView.frame = containerFrame;
	
	// commit animations
	[UIView commitAnimations];
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
	CGRect r = self.containerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	self.containerView.frame = r;
}

- (BOOL) isLegal:(NSString*)aContent
{
    NSString* sMyPlist = [[NSBundle mainBundle] pathForResource:@"My" ofType:@"plist"];
    NSDictionary* sDict = [NSDictionary dictionaryWithContentsOfFile:sMyPlist];

    NSArray* sSensitiveWords = [sDict objectForKey:@"SensitiveWords"];
    
    for (NSString* sSentiveWord in sSensitiveWords)
    {
        if ([aContent containsString:sSentiveWord options:NSCaseInsensitiveSearch])
        {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView
{
    if (growingTextView.text
        && growingTextView.text.length > 0)
    {
        if (![self isLegal:growingTextView.text])
        {
            [self showNotice:NSLocalizedString(@"Your comment not legal", nil)];
        }
        else
        {
            NSMutableDictionary* sCommentsDict = [NSMutableDictionary dictionary];
            
            //user=it'sme&time=123521516396&content=ilovethispage&itemID=1
            //        [sCommentsDict setValue:[[SharedStates getInstance] getUUID] forKey:@"uuid"];
            [sCommentsDict setValue:[[SharedStates getInstance] getUserName] forKey:@"user"];
            [sCommentsDict setValue:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] forKey:@"time"];
            [sCommentsDict setValue:growingTextView.text forKey:@"content"];
            [sCommentsDict setValue:[NSNumber numberWithInteger:self.mItem.mItemID] forKey:@"itemID"];
            
            NSError* sErr = nil;
            NSData* sData = [JSONWrapper dataWithJSONObject:sCommentsDict options:NSJSONReadingMutableContainers error:&sErr];
            
            NSMutableURLRequest* sRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL MyURLWithString:URL_POST_COMMENT]];
            [sRequest setHTTPMethod:@"POST"];
            
            [sRequest setHTTPBody:sData];
            [sRequest setValue:[NSString stringWithFormat:@"%d", [sData length]] forHTTPHeaderField:@"Content-length"];
            
            self.mRequest = sRequest;
            [sRequest release];
            
            AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:self.mRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                [self postSuccessfully:JSON];
            } failure:^( NSURLRequest *request , NSHTTPURLResponse *response , NSError *error , id JSON ){
                [self postFailed:error];
            }];
            [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"text/html", nil]];
            [operation start];
        }
    }    
    return YES;
}

- (void) postSuccessfully:(id)aJSONObj
{
    if (self.mTextView.text.length == 0)
    {
        return;
    }
    else
    {
        //1.
        if (self.mItem.mComment.length <= 0)
        {
            [self showNotice:NSLocalizedString(@"Post comments successfully", nil)];
        }
        else
        {
            [self showNotice:NSLocalizedString(@"Modify comments successfully", nil)];
        }
        
        //2.
        [self.mItem updateComment:self.mTextView.text];

        UIGlossyButton* sRightButton = (UIGlossyButton*)self.navigationItem.rightBarButtonItem.customView;
        [sRightButton setTitle:[self getRightBarButtonItemText] forState:UIControlStateNormal];

        //3. make text as placeholder
        self.mTextView.placeHolder = self.mTextView.text;
        self.mTextView.text = nil;
    }
    
    [MobClick event:@"UEID_COMMENT"];
    return;
}

- (void) postFailed:(NSError*)aError
{
    [self showNotice:NSLocalizedString(@"Fail to post comment", nil)];
    return;
}

- (void) showNotice:(NSString*)aNotice
{
    ATMHud* sHudForSaveSuccess = [[[ATMHud alloc] initWithDelegate:self] autorelease];
    [sHudForSaveSuccess setAlpha:0.6];
    [sHudForSaveSuccess setDisappearScaleFactor:1];
    [sHudForSaveSuccess setShadowEnabled:YES];
    [self.view addSubview:sHudForSaveSuccess.view];
    
    [sHudForSaveSuccess setCaption:aNotice];
    [sHudForSaveSuccess show];
    [sHudForSaveSuccess hideAfter:1.2];

}

@end
