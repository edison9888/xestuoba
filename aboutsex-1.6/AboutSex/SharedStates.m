//
//  AboutSex.m
//  AboutSex
//


//  Created by Shane Wen on 12-6-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SharedStates.h"
#import "FavoriteViewController.h"
#import "LibraryViewController.h"
#import "FMViewController.h"
#import "SettingViewController.h"

#import "SharedVariables.h"
#import "MobClick.h"
#import "UserConfiger.h"
#import "StreamViewController.h"

#import "MyURLConnection.h"
#import "NSDate-Utilities.h"
#import "NSURL+WithChanelID.h"
#import "MLNavigationController.h"
#import "NSDate+MyDate.h"
#import "AffectionViewController.h"


//
//#define BAIDU_ZHIDAO_URL_HARDCODE    @"http://wapiknow.baidu.com/browse/174/?ssid=0&from=844b&bd_page_type=1&uid=wiaui_1340783265_7490&pu=sz%401320_2001&st=3&font=0&step=6&lm=0"

#define DEFUALTS_KEY_CURRENT_VERSION   @"CURRENT_VERSION_KEY"
#define DEFUALTS_KEY_LAST_VERSION       @"LAST_VERSION_KEY"
#define DEFAULTS_KEY_FIRST_LAUNCH_OF_CURRENT_VERSION  @"FIRST_LUANCH_AFTER_OF_CURRENT_VERSION"
#define DEFAULTS_KEY_NEED_USER_GUIDE_ON_SECTION_INDEX    @"NEED_USER_GIDE_ON_SECTION_INDEX"
#define DEFAULTS_KEY_NEED_SHOW_ASKANDANSWER_NOTICE @"NEED_SHOW_ASK_AND_ANSWER_NOTICE"
//#define DEFAULTS_NEED_SHOW_LIBRARY  @"NEED_SHOW_LIBRARY"
#define DEFAULTS_ASK_PROVIDER   @"ASK_PROVIDER"
#define DEFAULTS_ASK_URL    @"ASK_URL"
#define DEFAULTS_DATE_FOR_NUM_OF_UPDATES_FOR_RECOMMANDED_APPS @"DATE_FOR_NUM_OF_UPDATES_FOR_RECOMMANDED_APPS"
#define DEFAULTS_COMMENT_URL @"COMMENT_URL"
#define DEFAULTS_USER_NAME @"USER_NAME"
#define DEFAULTS_UUID   @"UUID"
#define DEFAULTS_LAST_UPDATE_TIME_STREAM  @"LAST_UPDATE_TIME_STREAM"
#define DEFAULTS_LAST_DAILY_LUCK_DATE       @"LAST_DAILY_LUCK_DATE"
#define DEFAULTS_LAST_DAILY_LUCK_LUCKS      @"LAST_DAILY_LUCK_LUCKS"
#define DEFAULTS_FM_LAST_SELECTED_INDEX     @"FM_LAST_INDEX"
#define DEFAULTS_FM_LAST_CURRENT_TIME       @"FM_LAST_CURRENT_TIME"
#define DEFAULTS_PERIOD                    @"PERIOD"

#define CACHE_KEY_RECOMMANDED_APPS_CACHE @"CACHE_KEY_RECOMMANDED_APPS_CACHE"

#define ALPAH_FOR_NIGHT_MODE 0.2
#define MAX_NUM_LUCKS  3




static SharedStates* singleton = nil;
static UITabBarController* MTabBarController = nil; //static variable will be released when the application exits.

@interface SharedStates ()

- (void) startGetConf;
- (void) setSomeVariables;
@end


@implementation SharedStates


@synthesize mURLConnection;
@synthesize mAskURL;
@synthesize mAskProvider;
@synthesize mCommentURL;
@synthesize mNumOfUpdatesForRecommanedApps;
@synthesize mDate4NumUpdatesForRecAppsServer;
@synthesize mIsFirstLaunch;
@synthesize mCache;
@synthesize mPeriods;

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
        self.mCache = [[[NSCache alloc] init] autorelease];
        
        [self setDefaultsValue];
        [self setSomeVariables];
        [self startGetConf];
    }
    return self;
}
- (void) dealloc
{
    self.mURLConnection = nil;
    self.mAskURL = nil;
    self.mAskProvider = nil;
    self.mCommentURL = nil;

    self.mDate4NumUpdatesForRecAppsServer = nil;
    self.mCache = nil;
    self.mPeriods = nil;
    
    [super dealloc];
}

- (UITabBarController*) getMainTabController
{
    if (nil == MTabBarController)
    {
        MTabBarController = [[[UITabBarController alloc] init] autorelease];
        
        NSString* sTitle = nil;
        UITabBarItem* sTabBarItem = nil;
        
       
 // affection vc       
        MLNavigationController* sNaviContainerOfAffectionViewController = [[MLNavigationController alloc]initWithRootViewController:[AffectionViewController shared]];
        sNaviContainerOfAffectionViewController.delegate = [AffectionViewController shared];
        sTitle = NSLocalizedString(@"News", nil);
        sTabBarItem = [[UITabBarItem alloc]initWithTitle:sTitle image:nil tag:0];
//        sTabBarItem.badgeValue = @"N";
        sTabBarItem.image = [UIImage imageNamed:@"news30"];
        sNaviContainerOfAffectionViewController.tabBarItem = sTabBarItem;
        [sTabBarItem release];

 //library vc       
        MLNavigationController* sNaviContainerOfLibraryViewController =  [[MLNavigationController alloc]initWithRootViewController:[[[LibraryViewController alloc] init] autorelease]];
        sNaviContainerOfLibraryViewController.navigationBar.barStyle = UIBarStyleBlack;
        sTitle = NSLocalizedString(@"Library", "Library where user get whatever he/she wants on sex");
        sTabBarItem = [[UITabBarItem alloc]initWithTitle:sTitle image:nil tag:0];
        sTabBarItem.image = [UIImage imageNamed:@"library30"];
        sNaviContainerOfLibraryViewController.tabBarItem = sTabBarItem;
        [sTabBarItem release];       
     
//favorite vc
//        UINavigationController* sNaviContainerOfFavoriteViewController =  [[UINavigationController alloc]initWithRootViewController:[[[FavoriteViewController alloc] initWithTitle:NSLocalizedString(@"Favorite", nil)] autorelease]];
//        sNaviContainerOfFavoriteViewController.navigationBar.barStyle = UIBarStyleBlack;
//        sTitle = NSLocalizedString(@"Favorite", "user's favorite articles");
//        sTabBarItem = [[UITabBarItem alloc]initWithTitle:sTitle image:nil tag:0];
//        sTabBarItem.image = [UIImage imageNamed:@"favorite32.png"];
//        
//        sNaviContainerOfFavoriteViewController.tabBarItem = sTabBarItem;
//        [sTabBarItem release];
        
        UINavigationController* sNaviContainerOfFMController =  [[UINavigationController alloc]initWithRootViewController:[[[FMViewController alloc] initWithTitle:NSLocalizedString(@"FM", nil)] autorelease]];
        sNaviContainerOfFMController.navigationBar.barStyle = UIBarStyleBlack;
        sTitle = NSLocalizedString(@"FM", nil);
        sTabBarItem = [[UITabBarItem alloc]initWithTitle:sTitle image:nil tag:0];
        sTabBarItem.image = [UIImage imageNamed:@"FM32"];
        
        sNaviContainerOfFMController.tabBarItem = sTabBarItem;
        [sTabBarItem release];
        
//setting vc
        UINavigationController* sNaviContainerOfSettingViewController =  [[UINavigationController alloc]initWithRootViewController:[[[SettingViewController alloc] initWithTitle:NSLocalizedString(@"Setting", nil)] autorelease]];
        sNaviContainerOfSettingViewController.navigationBar.barStyle = UIBarStyleBlack;
        sTitle = NSLocalizedString(@"Setting", nil);
        sTabBarItem = [[UITabBarItem alloc]initWithTitle:sTitle image:nil tag:0];
//        sTabBarItem = [[UITabBarItem alloc] initWithTitle:sTitle tag:0];
        sTabBarItem.image = [UIImage imageNamed:@"setting32"];
        
        sNaviContainerOfSettingViewController.tabBarItem = sTabBarItem;
        [sTabBarItem release];
        
        NSArray* sControllers;
        
        sControllers = [NSArray arrayWithObjects:sNaviContainerOfAffectionViewController, sNaviContainerOfLibraryViewController, sNaviContainerOfFMController, sNaviContainerOfSettingViewController, nil];
        
        MTabBarController.viewControllers = sControllers;
        MTabBarController.selectedIndex = 0;
        [self tabBarController:MTabBarController shouldSelectViewController:[sControllers objectAtIndex:0]];
        MTabBarController.delegate = self;
        [self configApperance:MTabBarController];
        
        
        [sNaviContainerOfAffectionViewController release];
        [sNaviContainerOfLibraryViewController release];
//        [sNaviContainerOfFavoriteViewController release];
        [sNaviContainerOfSettingViewController release];
        [sNaviContainerOfFMController release];
    }
    return MTabBarController;
}

- (void) configApperance: (UITabBarController*)aTabBarController 
{
    for (UINavigationController* sChildViewController in aTabBarController.viewControllers)
    {
        if ([sChildViewController respondsToSelector:@selector(navigationBar)]
            && [sChildViewController.navigationBar respondsToSelector:@selector(setTintColor:)])
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

- (void) configBackground
{
    [UserConfiger setNightMode:[UserConfiger isNightModeOn]];
}

- (void) startGetConf;
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];  
    NSMutableURLRequest* sURLRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL MyURLWithString:GET_CONF]];
    
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

- (void) setDefaultsValue
{
    self.mNumOfUpdatesForRecommanedApps = 0;
    
    NSUserDefaults* sDefaults = [NSUserDefaults standardUserDefaults];

    self.mAskProvider = [sDefaults objectForKey:DEFAULTS_ASK_PROVIDER];
    self.mAskURL = [sDefaults objectForKey:DEFAULTS_ASK_URL];
    self.mCommentURL = [sDefaults objectForKey:DEFAULTS_COMMENT_URL];

    self.mDate4NumUpdatesForRecAppsServer = nil;
}

- (void) setSomeVariables
{
    //1. 
    srand((unsigned)time(NULL));

    //2. set mIsFirstLaunch
    self.mIsFirstLaunch = NO;
    //judge if this is the first time this app launches.
    NSString* sRunningVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleVersion"];
    NSUserDefaults* sDefaults = [NSUserDefaults standardUserDefaults];
    NSString* sCurrentVersion = [sDefaults objectForKey:DEFUALTS_KEY_CURRENT_VERSION];
    if (!sCurrentVersion
        || ![sRunningVersion isEqualToString:sCurrentVersion])
    {
        if (sCurrentVersion)
        {
            [sDefaults setObject:sCurrentVersion forKey:DEFUALTS_KEY_LAST_VERSION];
        }
        
        [sDefaults setObject:sRunningVersion forKey:DEFUALTS_KEY_CURRENT_VERSION];
        
        [sDefaults setBool:YES forKey:DEFAULTS_KEY_FIRST_LAUNCH_OF_CURRENT_VERSION];
        [sDefaults setBool:YES forKey:DEFAULTS_KEY_NEED_USER_GUIDE_ON_SECTION_INDEX];
        [sDefaults setBool:YES forKey:DEFAULTS_KEY_NEED_SHOW_ASKANDANSWER_NOTICE];
    }
    else
    {
        [sDefaults setBool:NO forKey:DEFAULTS_KEY_FIRST_LAUNCH_OF_CURRENT_VERSION];
    }
}

- (NSDate*) getLastUpdateTime
{
    NSUserDefaults* sDefaults = [NSUserDefaults standardUserDefaults];
    NSDate* sLastUpdateTime = [sDefaults objectForKey:DEFAULTS_LAST_UPDATE_TIME_STREAM];

    return sLastUpdateTime;
}

- (void) storeLastUpdateTime:(NSDate*)aDate
{
    if (aDate)
    {
        NSUserDefaults* sDefaults = [NSUserDefaults standardUserDefaults];
        [sDefaults setObject:aDate forKey:DEFAULTS_LAST_UPDATE_TIME_STREAM];
    }
}

- (NSString*) getAskURL
{
    return self.mAskURL;
}

- (NSString*) getAskProvider
{
    return self.mAskProvider;
}

- (NSString*) getCommentURL
{
    //test
//    return @"http://www.baidu.com";
    
    NSString* sCommnentURL = [MobClick getConfigParams:@"UPID_COMMENT_URL"];
    return sCommnentURL;
}

- (NSInteger) getNumOfUpdatesForRecommandedApps
{
    return self.mNumOfUpdatesForRecommanedApps;
}

- (NSData*) getRecommandedAppCacheData
{
    return [self.mCache objectForKey:CACHE_KEY_RECOMMANDED_APPS_CACHE];
}

- (void) cacheRecommandedAppData:(NSData*)aData
{    
    [self.mCache setObject:aData forKey:CACHE_KEY_RECOMMANDED_APPS_CACHE];
}

- (NSInteger) getLastIndexOFFMItem
{    
    NSUserDefaults* sDefaults = [NSUserDefaults standardUserDefaults];
    
    return [sDefaults integerForKey:DEFAULTS_FM_LAST_SELECTED_INDEX];    
}

- (void) setFMItemIndex:(NSInteger)aIndex
{
    NSUserDefaults* sDefaults = [NSUserDefaults standardUserDefaults];
    [sDefaults setInteger:aIndex forKey:DEFAULTS_FM_LAST_SELECTED_INDEX];
}

- (NSTimeInterval) getLasCurrentTimeOfFMItem
{
    NSUserDefaults* sDefaults = [NSUserDefaults standardUserDefaults];
    return [sDefaults doubleForKey:DEFAULTS_FM_LAST_CURRENT_TIME];
}

- (void) setFMItemCurrentTime:(NSTimeInterval)aCurrentTime
{
    NSUserDefaults* sDefaults = [NSUserDefaults standardUserDefaults];
    [sDefaults setDouble:aCurrentTime forKey:DEFAULTS_FM_LAST_CURRENT_TIME];
}

//- (void) cacheObject:(id)aObj forKey:(id)aKey
//{
//    [self.mCache setObject:aObj forKey:aKey];
//}
//
//- (id) getCachedObjectForKey:(id)aKey
//{
//    return [self.mCache objectForKey:aKey];
//}
//

- (BOOL) isFirstLaunchOfCurrentVersion
{
    BOOL sIsFirstLaunchAfterUpdate = [[NSUserDefaults standardUserDefaults] boolForKey:DEFAULTS_KEY_FIRST_LAUNCH_OF_CURRENT_VERSION];
    return sIsFirstLaunchAfterUpdate;
}

- (NSString*) getLastVersion
{
    NSString* sLastVersion = [[NSUserDefaults standardUserDefaults] stringForKey:DEFUALTS_KEY_LAST_VERSION];
    return sLastVersion;
}

- (BOOL) needUserGuideOnSectionIndex
{
    NSUserDefaults* sDefaults = [NSUserDefaults standardUserDefaults];

    BOOL sNeedUserGuideOnSectionIndex = [sDefaults boolForKey:DEFAULTS_KEY_NEED_USER_GUIDE_ON_SECTION_INDEX];

    return sNeedUserGuideOnSectionIndex;
}

- (BOOL) needShowNoticeForAsKAndAnswer
{
    NSUserDefaults* sDefaults = [NSUserDefaults standardUserDefaults];
    
    BOOL sShowNoticeForAskAndAnswer = [sDefaults boolForKey:DEFAULTS_KEY_NEED_SHOW_ASKANDANSWER_NOTICE];
    
    return sShowNoticeForAskAndAnswer;

}

- (void) closeUserGuideOnSectionIndex
{
    NSUserDefaults* sDefaults = [NSUserDefaults standardUserDefaults];
    [sDefaults setBool:NO forKey:DEFAULTS_KEY_NEED_USER_GUIDE_ON_SECTION_INDEX];
    return;
}

- (void) closeShowAskAndAnswerNotice
{
    NSUserDefaults* sDefaults = [NSUserDefaults standardUserDefaults];
    [sDefaults setBool:NO forKey:DEFAULTS_KEY_NEED_SHOW_ASKANDANSWER_NOTICE];
    return;
}

- (void) latestRecommendAppsViewed
{
    self.mNumOfUpdatesForRecommanedApps = -1;
    if (self.mDate4NumUpdatesForRecAppsServer)
    {
        NSUserDefaults* sDefaults = [NSUserDefaults standardUserDefaults];
        [sDefaults setObject:self.mDate4NumUpdatesForRecAppsServer forKey:DEFAULTS_DATE_FOR_NUM_OF_UPDATES_FOR_RECOMMANDED_APPS];
    }
}

- (NSString*) getUserName
{
    NSString* sUserName = nil;
    NSUserDefaults* sDefaults = [NSUserDefaults standardUserDefaults];
    sUserName = [sDefaults objectForKey:DEFAULTS_USER_NAME];
    
    if (!sUserName)
    {
        NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        
        NSDate* sRefDate = [dateFormatter dateFromString:@"2013-02-14 23:35"];
        
        NSTimeInterval sTimeInterval = [[NSDate date] timeIntervalSinceDate:sRefDate];
        
        sUserName = [NSString stringWithFormat:@"%.0f", sTimeInterval];
        
        [sDefaults setValue:sUserName forKey:DEFAULTS_USER_NAME];
    }
    
    return sUserName;

}

- (NSString*) getUUID
{
    NSString* sUUID = nil;
    NSUserDefaults* sDefaults = [NSUserDefaults standardUserDefaults];
    sUUID = [sDefaults objectForKey:DEFAULTS_UUID];
    
    if (!sUUID)
    {
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        NSString* sUUIDStr = (NSString *)CFUUIDCreateString (kCFAllocatorDefault,uuidRef);
        sUUID = [[sUUIDStr copy] autorelease];
        
        CFRelease(uuidRef);
        CFRelease(sUUIDStr);
        [sDefaults setValue:sUUID forKey:DEFAULTS_UUID];
    }
    
    return sUUID;
}

- (NSInteger) getLucksOfToday
{    
    NSUserDefaults* sDefaults = [NSUserDefaults standardUserDefaults];
    NSDate* sDate = [sDefaults objectForKey:DEFAULTS_LAST_DAILY_LUCK_DATE];
    if (sDate
        && [sDate isToday])
    {
//        //test
//        NSUserDefaults* sDefaults = [NSUserDefaults standardUserDefaults];
//        [sDefaults setInteger:MAX_NUM_LUCKS forKey:DEFAULTS_LAST_DAILY_LUCK_LUCKS];
        NSNumber* sLucksNumber = [sDefaults objectForKey:DEFAULTS_LAST_DAILY_LUCK_LUCKS];
        if (sLucksNumber)
        {
            return sLucksNumber.integerValue;
        }
        else
        {
            return 0;
        }
    }
    else
    {
        [sDefaults setObject:[NSDate date] forKey:DEFAULTS_LAST_DAILY_LUCK_DATE];
        [sDefaults setInteger:MAX_NUM_LUCKS forKey:DEFAULTS_LAST_DAILY_LUCK_LUCKS];
        
        return MAX_NUM_LUCKS;
    }    
}

- (BOOL) decreaseLuckOfToday
{
    NSInteger sLuckOfToday = [self getLucksOfToday];
    if (sLuckOfToday > 0)
    {
        NSUserDefaults* sDefaults = [NSUserDefaults standardUserDefaults];
        [sDefaults setInteger:sLuckOfToday-1 forKey:DEFAULTS_LAST_DAILY_LUCK_LUCKS];
        return YES;
    }
    else
    {
        return NO;
    }
}

- (ENUM_AD_BAR_SOURCE_TYPE) getADBarSourceType
{
//    return ENUM_AD_BAR_SOURCE_TYPE_YOUMI;
    //
    ENUM_AD_BAR_SOURCE_TYPE sType = ENUM_AD_BAR_SOURCE_TYPE_DISABLED;
    NSString* sTypeStr = [MobClick getConfigParams:@"UPID_BAR_SOURCE_TYPE"];
    if ([sTypeStr isEqualToString:@"Youmi"])
    {
        sType = ENUM_AD_BAR_SOURCE_TYPE_YOUMI;
    }
    else if ([sTypeStr isEqualToString:@"Guomeng"])
    {
        sType = ENUM_AD_BAR_SOURCE_TYPE_GUOMENG;
    }
    else if ([sTypeStr isEqualToString:@"Mobwin"])
    {
        sType = ENUM_AD_BAR_SOURCE_TYPE_MOBWIN;
    }
    else if ([sTypeStr isEqualToString:@"Domob"])
    {
        sType = ENUM_AD_BAR_SOURCE_TYPE_DOMOB;
    }
    else
    {   
        sType = ENUM_AD_BAR_SOURCE_TYPE_DISABLED;
    }
        
    return sType;
}

- (NSString*) getCommentNotice
{
    NSString* sCommentNotice = [MobClick getConfigParams:@"UPID_COMMENT_NOTICE"];
    if (!sCommentNotice
        || sCommentNotice.length <= 0)
    {
        sCommentNotice = NSLocalizedString(@"Comment", nil);
    }
    return sCommentNotice;
}

- (Period*) getPeriod
{
    NSUserDefaults* sDefaults = [NSUserDefaults standardUserDefaults];
    NSData *sEncodedPeriod = [sDefaults objectForKey:DEFAULTS_PERIOD];
    if (sEncodedPeriod)
    {
        Period* sPeriod = (Period *)[NSKeyedUnarchiver unarchiveObjectWithData: sEncodedPeriod];
        return sPeriod;
    }
    else
    {
        return nil;
    }
}

- (void) savePeriod:(Period*)aPeriod
{
    NSUserDefaults* sDefaults = [NSUserDefaults standardUserDefaults];
    NSData* sEncodedPeriod = [NSKeyedArchiver archivedDataWithRootObject:aPeriod];
    [sDefaults setObject:sEncodedPeriod forKey:DEFAULTS_PERIOD];
    [sDefaults synchronize];
}

#pragma mark -
#pragma mark delegate methods for MyURLConnectionDelegate

- (void) failWithConnectionError: (NSError*)aErr
{
    
}

- (void) failWithServerError: (NSInteger)aStatusCode
{
    
}

- (void) succeed: (NSMutableData*)aData
{
    NSError* sErr = nil;
    
    id sJSONObject =  [JSONWrapper JSONObjectWithData: aData
                                                      options:NSJSONReadingMutableContainers
                                                        error:&sErr];

    if ([sJSONObject isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *sDict = (NSDictionary *)sJSONObject;
        
        //Ask URL
        self.mAskURL = (NSString*)[sDict objectForKey:@"ask_url"];
        [[NSUserDefaults standardUserDefaults] setObject:self.mAskURL forKey:DEFAULTS_ASK_URL];
        
        //Ask Provider
        self.mAskProvider = (NSString*)[sDict objectForKey:@"ask_provider"];
        [[NSUserDefaults standardUserDefaults] setObject:self.mAskProvider forKey:DEFAULTS_ASK_PROVIDER];
        
        //Comment URL
        self.mCommentURL = (NSString*)[sDict objectForKey:@"comment_url"];
        [[NSUserDefaults standardUserDefaults] setObject:self.mCommentURL forKey:DEFAULTS_COMMENT_URL];
        
        //about recommand apps
        NSString* sDate4NumUpdatesForRecAppsClient = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULTS_DATE_FOR_NUM_OF_UPDATES_FOR_RECOMMANDED_APPS];
        NSString* sDate4NumUpdatesForRecAppsServer= (NSString*)[sDict objectForKey:@"date_num_of_updates_for_recommanded_apps"];
        
        self.mNumOfUpdatesForRecommanedApps = -1;
        if (sDate4NumUpdatesForRecAppsServer)
        {
            if (!sDate4NumUpdatesForRecAppsClient
                || [sDate4NumUpdatesForRecAppsClient compare:sDate4NumUpdatesForRecAppsServer] == NSOrderedAscending)
            {
                self.mNumOfUpdatesForRecommanedApps =  ((NSNumber*)[sDict objectForKey:@"num_of_updates_for_recommanded_apps"]).integerValue;
            }
        }
        self.mDate4NumUpdatesForRecAppsServer = sDate4NumUpdatesForRecAppsServer;
    }
    
    
    return;
}


#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    UIViewController* sNewsViewController = [tabBarController.viewControllers objectAtIndex:0];
    if ([viewController.tabBarItem.title isEqualToString:sNewsViewController.tabBarItem.title])
    {
        if (sNewsViewController.tabBarItem.badgeValue
            && sNewsViewController.tabBarItem.badgeValue.integerValue > 0)
        {
            UIViewController* sViewControllerToBeRefreshed = sNewsViewController;
            if ([sNewsViewController isKindOfClass:[UINavigationController class]])
            {
                sViewControllerToBeRefreshed = ((UINavigationController*)sNewsViewController).topViewController;
            }

            if ([sViewControllerToBeRefreshed respondsToSelector:@selector(refreshFromOutside)])
            {
                [sViewControllerToBeRefreshed performSelector:@selector(refreshFromOutside)];
            }
        }
    }
    
    return YES;
}

+ (BOOL) isCurLanguageChinese
{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    if ([currentLanguage isEqualToString:@"zh-Hans"]
        || [currentLanguage isEqualToString:@"zh-Hant"])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


@end
