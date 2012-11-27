//
//  AboutSex.m
//  AboutSex
//
//  Created by Shane Wen on 12-6-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SharedStates.h"
#import "StreamViewController.h"
#import "FavoriteViewController.h"
#import "LibraryViewController.h"

#import "SharedVariables.h"
#import "MobClick.h"


#import "MyURLConnection.h"
//
#define BAIDU_ZHIDAO_URL_HARDCODE    @"http://wapiknow.baidu.com/browse/174/?ssid=0&from=844b&bd_page_type=1&uid=wiaui_1340783265_7490&pu=sz%401320_2001&st=3&font=0&step=6&lm=0"

#define DEFUALTS_KEY_LAST_RUN_VERSION   @"LAST_RUN_VERSION_KEY"
#define DEFAULTS_KEY_NEED_USER_GUIDE_ON_SECTION_INDEX    @"NEED_USER_GIDE_ON_SECTION_INDEX"
#define DEFAULTS_NEED_SHOW_LIBRARY  @"NEED_SHOW_LIBRARY"


static SharedStates* singleton = nil;
static UITabBarController* MTabBarController = nil; //static variable will be released when the application exits.

@interface SharedStates ()

- (void) setBaiduZhidaoURL;
- (void) setSomeVariables;
@end


@implementation SharedStates


@synthesize mURLConnection;
@synthesize mBaiduZhidaoURLStr;
@synthesize mIsFirstLaunch;

+(SharedStates*)getInstance
{
    @synchronized([SharedStates class]){
        if(singleton ==nil){
            singleton = [[self alloc]init];
        }
    }
    return singleton;
}

+(id)alloc
{
    @synchronized([SharedStates class]){
        if (singleton ==nil) {
            singleton = [super alloc];
        }
        return singleton;
    }
    
    return nil;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        [self setSomeVariables];
        [self setBaiduZhidaoURL];
    }
    return self;
}
- (void) dealloc
{
    self.mURLConnection = nil;
    self.mBaiduZhidaoURLStr = nil;
    [super dealloc];
}

- (UITabBarController*) getMainTabController
{
    if (nil == MTabBarController)
    {
        MTabBarController = [[[UITabBarController alloc] init] autorelease];
        
        NSString* sTitle = nil;
        UITabBarItem* sTabBarItem = nil;
        
       
 // message vc       
        sTitle = NSLocalizedString(@"News", "new message type of which may be dictations");
        UINavigationController* sNaviContainerOfMessageViewController = [[UINavigationController alloc]initWithRootViewController:[[[StreamViewController alloc] initWithTitle:sTitle] autorelease]];
        
//        sNaviContainerOfMessageViewController.navigationBar.barStyle = UIBarStyleBlack;
//        sNaviContainerOfMessageViewController.navigationBar.tintColor = [UIColor colorWithRed:RGB_DIV_255(102) green:RGB_DIV_255(57) blue:RGB_DIV_255(26) alpha:1.0f];
//        [sNaviContainerOfMessageViewController.navigationBar setBackgroundImage:[UIImage imageNamed:@"library32.png"] forBarMetrics:UIBarMetricsDefault];
//        sNaviContainerOfMessageViewController.navigationBar.translucent = YES;

        sTabBarItem = [[UITabBarItem alloc]initWithTitle:sTitle image:nil tag:0];
//        sTabBarItem.badgeValue = @"N";
        sTabBarItem.image = [UIImage imageNamed:@"new24.png"];
        sNaviContainerOfMessageViewController.tabBarItem = sTabBarItem;
        [sTabBarItem release];
      
 //library vc       
        UINavigationController* sNaviContainerOfLibraryViewController =  [[UINavigationController alloc]initWithRootViewController:[[[LibraryViewController alloc] init] autorelease]];
        sNaviContainerOfLibraryViewController.navigationBar.barStyle = UIBarStyleBlack;
        sTitle = NSLocalizedString(@"Library", "Library where user get whatever he/she wants on sex");
        sTabBarItem = [[UITabBarItem alloc]initWithTitle:sTitle image:nil tag:0];
        sTabBarItem.image = [UIImage imageNamed:@"library32.png"];
        sNaviContainerOfLibraryViewController.tabBarItem = sTabBarItem;
        [sTabBarItem release];       
     
//favorite vc
        UINavigationController* sNaviContainerOfFavoriteViewController =  [[UINavigationController alloc]initWithRootViewController:[[[FavoriteViewController alloc] initWithTitle:NSLocalizedString(@"Favorite", nil)] autorelease]];
        sNaviContainerOfFavoriteViewController.navigationBar.barStyle = UIBarStyleBlack;
        sTitle = NSLocalizedString(@"Favorite", "user's favorite articles");
        sTabBarItem = [[UITabBarItem alloc]initWithTitle:sTitle image:nil tag:0];
        sTabBarItem.image = [UIImage imageNamed:@"favorite32.png"];
        
        sNaviContainerOfFavoriteViewController.tabBarItem = sTabBarItem;
        [sTabBarItem release];

        
        NSArray* sControllers;
        
        sControllers = [NSArray arrayWithObjects:sNaviContainerOfMessageViewController, sNaviContainerOfLibraryViewController,sNaviContainerOfFavoriteViewController, nil];

//        if ([self needShowLibrary])
//        {
//                    sControllers = [NSArray arrayWithObjects:sNaviContainerOfMessageViewController, sNaviContainerOfLibraryViewController,sNaviContainerOfFavoriteViewController, nil];
//        }
//        else 
//        {
//            sControllers = [NSArray arrayWithObjects:sNaviContainerOfMessageViewController,sNaviContainerOfFavoriteViewController, nil];
//        }
        
        MTabBarController.viewControllers = sControllers;
        MTabBarController.selectedIndex = 0;
        
        [self configApperance:MTabBarController];
        
        
        [sNaviContainerOfMessageViewController release];
        [sNaviContainerOfLibraryViewController release];
        [sNaviContainerOfFavoriteViewController release];      
    }
    return MTabBarController;
}

- (void) configApperance: (UITabBarController*)aTabBarController 
{
    for (UINavigationController* sChildViewController in aTabBarController.viewControllers)
    {
        if ([sChildViewController.navigationBar respondsToSelector:@selector(setTintColor:)])
        {
            sChildViewController.navigationBar.tintColor = MAIN_BGCOLOR;
        }
    }
    
    if ([aTabBarController.tabBar respondsToSelector:@selector(setTintColor:)])
    {
        aTabBarController.tabBar.tintColor =  MAIN_BGCOLOR;
    }
    else 
    {
        //it does not work on ios5, why?
        CGRect sFrame = CGRectMake(0, 0, aTabBarController.tabBar.bounds.size.width,  aTabBarController.tabBar.bounds.size.height);
        UIView *sBGView = [[UIView alloc] initWithFrame:sFrame];
        sBGView.backgroundColor = MAIN_BGCOLOR;
        [aTabBarController.tabBar insertSubview:sBGView atIndex:0];
        [sBGView release];
    }
    
}



- (void) setBaiduZhidaoURL;
{
    //first initialize it as the hardcode url.
    self.mBaiduZhidaoURLStr = BAIDU_ZHIDAO_URL_HARDCODE;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];  
    NSMutableURLRequest* sURLRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:GET_CONF]];
    
    [sURLRequest setHTTPMethod:@"POST"];

    [sURLRequest setValue:[NSString stringWithFormat:@"%d", 0] forHTTPHeaderField:@"Content-length"];
    [sURLRequest setHTTPBody:nil];
    
    MyURLConnection* sURLConnection = [[MyURLConnection alloc]initWithDelegate:sURLRequest withDelegate:self];
    self.mURLConnection = sURLConnection;
    [sURLRequest release];
    [sURLConnection release];

    if (![self.mURLConnection start])
    {
#ifdef DEBUG
        NSLog(@"conncetin creation error.");
#endif
    }
    
    return;
}

- (void) setSomeVariables
{
    //1. 
    srand((unsigned)time(NULL));

    //2. set mIsFirstLaunch
    self.mIsFirstLaunch = NO;
    //judge if this is the first time this app launches.
    NSString* sCurrentRunVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleVersion"];
    NSUserDefaults* sDefaults = [NSUserDefaults standardUserDefaults];
    NSString* sLastRunVersion = [sDefaults objectForKey:DEFUALTS_KEY_LAST_RUN_VERSION];
    if (!sLastRunVersion
        || ![sCurrentRunVersion isEqualToString:sLastRunVersion])
    {
        [sDefaults setObject:sCurrentRunVersion forKey:DEFUALTS_KEY_LAST_RUN_VERSION];
        [sDefaults setBool:YES forKey:DEFAULTS_KEY_NEED_USER_GUIDE_ON_SECTION_INDEX];
    }
    
    //test
//    [sDefaults setBool:YES forKey:DEFAULTS_KEY_NEED_USER_GUIDE_ON_SECTION_INDEX];
    //[sDefaults setBool:YES forKey:DEFAULTS_NEED_SHOW_LIBRARY];

}

- (NSString*) getBaiduZhidaoURL
{
    return self.mBaiduZhidaoURLStr;
}

- (BOOL) needUserGuideOnSectionIndex
{
    NSUserDefaults* sDefaults = [NSUserDefaults standardUserDefaults];

    BOOL sNeedUserGuideOnSectionIndex = [sDefaults boolForKey:DEFAULTS_KEY_NEED_USER_GUIDE_ON_SECTION_INDEX];

    return sNeedUserGuideOnSectionIndex;
}

- (BOOL) needShowLibrary
{
    NSUserDefaults* sDefaults = [NSUserDefaults standardUserDefaults];
    
    BOOL sNeedShowLibrary = [sDefaults boolForKey:DEFAULTS_NEED_SHOW_LIBRARY];
    
    return sNeedShowLibrary;
}

- (void) setShowLibrary
{
    NSUserDefaults* sDefaults = [NSUserDefaults standardUserDefaults];
    [sDefaults setBool:YES forKey:DEFAULTS_NEED_SHOW_LIBRARY];
    
}


- (void) closeUserGuideOnSectionIndex
{
    NSUserDefaults* sDefaults = [NSUserDefaults standardUserDefaults];
    [sDefaults setBool:NO forKey:DEFAULTS_KEY_NEED_USER_GUIDE_ON_SECTION_INDEX];
    return;
}

#pragma mark -
#pragma mark delegate methods for MyURLConnectionDelegate

//- (void) failWithConnectionError: (NSError*)aErr
//{
//    
//}
//
//- (void) failWithServerError: (NSInteger)aStatusCode
//{
//    
//}

- (void) succeed: (NSMutableData*)aData
{
    NSError* sErr = nil;
    NSString* sBaiduZhidaoURLStr = nil;
    BOOL sNeedShowLibrary = FALSE;

    //api for json is only available on ios 5.0 and later, so you should do it yourself on versions before 5.0.
    id sJSONObject =  [NSJSONSerialization JSONObjectWithData: aData 
                                             options:NSJSONReadingMutableContainers
                                               error:&sErr];
    if ([sJSONObject isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *sDict = (NSDictionary *)sJSONObject;
        sBaiduZhidaoURLStr = (NSString*)[sDict objectForKey:@"url"];
        sNeedShowLibrary = [((NSNumber*)[sDict objectForKey:@"need_show_library"]) boolValue];
    }    
    
    if (sBaiduZhidaoURLStr)
    {
        self.mBaiduZhidaoURLStr = sBaiduZhidaoURLStr;
    }
    
    if (sNeedShowLibrary
        && ![self needShowLibrary])
    {
        [self setShowLibrary];
    }
    
    return;

}



@end
