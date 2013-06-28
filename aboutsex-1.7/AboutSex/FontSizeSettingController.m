//
//  FontSizeSettingController.m
//  AboutSex
//
//  Created by Wen Shane on 12-11-28.
//
//

#import "FontSizeSettingController.h"
#import "SharedVariables.h"
#import "UserConfiger.h"

#import "SVSegmentedControl.h"

#import <QuartzCore/QuartzCore.h>


//#define FontSizeDemoHtmlTemp     @"<!DOCTYPE HTML><html><meta charset=\"utf-8\">      <head><title>出错页面</title><style type=\"text/css\">body{text-align:center; font-size:%d%%}</style> </head><body><p>　　在荷兰人眼中，性权益是人权之一，夫妻之间是非常重视性生活质量的。调查显示，在荷兰因性生活不合而离婚的人占离婚总数的45%以上。</p><p>　　一位心理咨询专家告诉记者，他处理过的婚姻矛盾个案中有相当比例的夫妻就是因为性生活不合，或是双方需求不一致而产生矛盾，从而产生婚外性行为，导致矛盾进一步激化。</p></body></html>"

#define FontSizeDemoHtmlTemp     @"<!DOCTYPE HTML><html><meta charset=\"utf-8\">      <head><title>出错页面</title><style type=\"text/css\">body{font-size:%d%%}</style> </head><body><p>　　选择合适的字体大小，能更好地保护您的眼睛哦。</p><p>　　另外，两性内参提醒各位亲：</p><ol><li>每次使用手机最好不要超过40-50分钟。</li><li>不要躺着看手机。</li><li>手机屏幕亮度要适中，夜间使用时，建议您在“设置”中开启“夜间模式“。</li></ol></body></html>"

@interface FontSizeSettingController ()
{
    UIWebView* mWebViewForTestText;
}

@property (nonatomic, retain)     UIWebView* mWebViewForTestText;

@end

@implementation FontSizeSettingController
@synthesize mWebViewForTestText;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) dealloc
{
    self.mWebViewForTestText = nil;
    [super dealloc];
}

- (void) loadView
{
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    UIView* sView = [[UIView alloc] initWithFrame:applicationFrame];
    sView.backgroundColor = [UIColor whiteColor];
    self.view = sView;
    [sView release];
    
    SVSegmentedControl *sSegmentedControl = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:NSLocalizedString(@"small", nil), NSLocalizedString(@"medium", nil), NSLocalizedString(@"large", nil), nil]];
    [sSegmentedControl addTarget:self action:@selector(fontSizeSettingSegmentedControlPressed:) forControlEvents:UIControlEventValueChanged];
	sSegmentedControl.font = [UIFont boldSystemFontOfSize:19];
	sSegmentedControl.titleEdgeInsets = UIEdgeInsetsMake(2, 25, 2, 25);
    sSegmentedControl.cornerRadius = 4.0f;
    sSegmentedControl.center = CGPointMake(160, 40);
	sSegmentedControl.thumb.tintColor = MAIN_BGCOLOR_TRANSPARENT;
    
    NSInteger sSelectedIndex;
    ENUM_FONT_SIZE_TYPE sFontSizeType = [UserConfiger getFontSizeType];
    switch (sFontSizeType) {
        case ENUM_FONT_SIZE_SMALL:
        {
            sSelectedIndex = 0;
        }
            break;
        case ENUM_FONT_SIZE_NORMAL:
        {
            sSelectedIndex = 1;
        }
            break;
        case ENUM_FONT_SIZE_LARGE:
        {
            sSelectedIndex = 2;
        }
            break;
        default:
        {
            sSelectedIndex = 1;
        }
            break;
    }
    [sSegmentedControl setSelectedIndex:sSelectedIndex];
	
    [self.view addSubview:sSegmentedControl];
   	[sSegmentedControl release];
    
    
    UIWebView* sWebView = [[UIWebView alloc]init];
    
    [sWebView setFrame:CGRectMake(30, 70, 260, self.view.bounds.size.height-70)];
    
    NSString* sFontSizeDemoHtml = [NSString stringWithFormat:FontSizeDemoHtmlTemp, [UserConfiger getFontSizeScalePercentByFontSizeType:sFontSizeType]];
    
    [sWebView loadHTMLString:sFontSizeDemoHtml baseURL:nil];
    
    sWebView.opaque = NO;
    sWebView.backgroundColor = [UIColor clearColor];
    sWebView.layer.cornerRadius = 8;
    sWebView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    sWebView.layer.borderWidth = 0;
    if ([sWebView respondsToSelector:@selector(scrollView)])
    {
        sWebView.scrollView.bounces = NO;        
    }
  
    self.mWebViewForTestText = sWebView;
    [sWebView release];
    

    [self.view addSubview:self.mWebViewForTestText];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void) viewDidUnload
{
    [super viewDidUnload];
    self.mWebViewForTestText = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) fontSizeSettingSegmentedControlPressed:(id)aSegementedControl
{
    NSInteger sSelectedIndex = ((SVSegmentedControl*)aSegementedControl).selectedIndex;
    ENUM_FONT_SIZE_TYPE sFontSizeType;
    switch (sSelectedIndex)
    {
        case 0:
        {
            sFontSizeType = ENUM_FONT_SIZE_SMALL;
        }
            break;
        case 1:
        {
            sFontSizeType = ENUM_FONT_SIZE_NORMAL;
        }
            break;
        case 2:
        {
            sFontSizeType = ENUM_FONT_SIZE_LARGE;
        }
            break;
        default:
        {
            sFontSizeType = ENUM_FONT_SIZE_NORMAL;
        }
            break;
    }
    
    ENUM_FONT_SIZE_TYPE sOldFontSizeType = [UserConfiger getFontSizeType];
    if (sFontSizeType != sOldFontSizeType)
    {
        [UserConfiger setFontSizeType:sFontSizeType];
        [self setFontSizeForWebViewText];
    }
}

- (void) setFontSizeForWebViewText
{
    ENUM_FONT_SIZE_TYPE sFontSizeType = [UserConfiger getFontSizeType];
    NSInteger sNewFontSizeScale = [UserConfiger getFontSizeScalePercentByFontSizeType:sFontSizeType];
    
    NSString* sFontSizeDemoHtml = [NSString stringWithFormat:FontSizeDemoHtmlTemp, sNewFontSizeScale];
    
    [self.mWebViewForTestText loadHTMLString:sFontSizeDemoHtml baseURL:nil];
}

//
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //    NSLog(@"navi touch begin");
    [super touchesBegan:touches withEvent:event];    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //    NSLog(@"navi touch end");
    
    
    [super touchesEnded:touches withEvent:event];
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    //    NSLog(@"navi touch cancel");
    
    
    [super touchesCancelled:touches withEvent:event];
}


@end
