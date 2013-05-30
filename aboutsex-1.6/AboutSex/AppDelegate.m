//
//  AppDelegate.m
//  AboutSex
//
//  Created by Shane Wen on 12-6-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "SharedStates.h"

#import "StoreManager.h"

#import "MobClick.h"
#import "SharedVariables.h"

#import "time.h"
#import "SDURLCache.h"
#import "AFKReviewTroller.h"
#import <AudioToolbox/AudioServices.h>

#import "KKPasscodeLock.h"
#import "PointsManager.h"
#import "YouMiConfig.h"
#import "DianRuAdWall.h"
#import "WapsOffer/AppConnect.h"
#import <AVFoundation/AVFoundation.h>


#define LOCAL_NOTIFICATION_INTERVAL  (7*24*60*60)


@interface AppDelegate ()
{
    UINavigationController* mNavOfPasswordEnterViewController;
}
@property (nonatomic, retain) UINavigationController* mNavOfPasswordEnterViewController;

- (void) checkUpdateAutomatically;

@end


@implementation AppDelegate

@synthesize window = _window;
@synthesize mNavOfPasswordEnterViewController;

- (void)dealloc
{
    [_window release];
    self.mNavOfPasswordEnterViewController = nil;
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //ad config.
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
//        [YouMiConfig launchWithAppID: SECRET_ID_YOUMI appSecret: SECRET_KEY_YOUMI];
//        [YouMiConfig setUseInAppStore:NO];
//        [YouMiConfig setIsTesting:YES];
//        [DianRuAdWall beforehandAdWallWithDianRuAppKey:AD_DIANRU_ID];
//        [AppConnect getConnect:AD_WAPS_ID pid:CHANNEL_ID];
//        [AppConnect initPopAd];
//    });
    
    [YouMiConfig launchWithAppID: SECRET_ID_YOUMI appSecret: SECRET_KEY_YOUMI];
    [YouMiConfig setUseInAppStore:NO];
    [YouMiConfig setIsTesting:NO];
    [DianRuAdWall beforehandAdWallWithDianRuAppKey:AD_DIANRU_ID];
    [AppConnect getConnect:AD_WAPS_ID pid:CHANNEL_ID];
    [AppConnect initPopAd];

    
    //
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor whiteColor];
//    self.window.rootViewController = [[SharedStates getInstance] getMainTabController];
    [self.window makeKeyAndVisible];

    [StoreManager openIfNecessary];
    self.window.rootViewController = [[SharedStates getInstance] getMainTabController];
    [[SharedStates getInstance] configBackground];
    
    
    //    
    //UMeng SDK invocation
    [MobClick startWithAppkey:APP_KEY_UMENG reportPolicy:BATCH channelId:CHANNEL_ID];
    [MobClick updateOnlineConfig];

    [AFKReviewTroller numberOfExecutions];
    [self checkUpdateAutomatically];
    

    
    
    //init SharedStates.
    [SharedStates getInstance];
    
 
    
    //for now, we do not need to cache to disk.
//    SDURLCache *urlCache = [[SDURLCache alloc] initWithMemoryCapacity:1024*1024   // 1MB mem cache
//                                                         diskCapacity:1024*1024*5 // 5MB disk cache
//                                                             diskPath:[SDURLCache defaultCachePath]];
//    [NSURLCache setSharedURLCache:urlCache];
//    [urlCache release];
    
    
    
    
    //register remote notification: let APNS know we want to receive notification from him.
    //note that:
    //1、可以参照workplace中的PushMeBaby向APNS发起push请求
    //2、发布版，要记得打开了PUSH的发布证书，并且发布版的APNS地址与开发版不同。
    //3、若程序未启动时收到notification，则若用户点击notification启动应用，则notification的内容通过didFinishLaunchingWithOptions传进来；若在程序开启的情况下收到notificaiton,则程序会在didReceiveRemoteNotification收到notification的内容，并可以在其中作相应处理。
    //4. devicetoken每次启动都要获取，并更新到自己的server上。
//    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    
    //
    [[KKPasscodeLock sharedLock] setDefaultSettings];
    [[KKPasscodeLock sharedLock] invalidatePasswordAfter5Times];
    
    //
//    NSString* sBlankFilePath = [[NSBundle mainBundle] pathForResource:@"5sec" ofType:@"mp3"];
//    AVAudioPlayer*  sPlayer = [[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:sBlankFilePath] error:nil] autorelease];
//	[sPlayer prepareToPlay];
//    [sPlayer play];
//    [sPlayer stop];
    
    // Handle launching from a notification
	UILocalNotification *localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotif)
    {
        [MobClick event:@"UEID_LAUNCH_BY_LOCAL_NOTIFICATION"];
		NSLog(@"Recieved Notification %@",localNotif);
	}

    [self scheduleLocalNotification];
    

    
    return YES;
}

- (void) scheduleLocalNotification
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];

    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil)
        return;
    localNotif.fireDate = [NSDate dateWithTimeIntervalSinceNow:LOCAL_NOTIFICATION_INTERVAL];
    localNotif.timeZone = [NSTimeZone localTimeZone];
	
	// Notification details
    localNotif.alertBody = NSLocalizedString(@"You've got updates in Aboutsex", nil);
	
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.applicationIconBadgeNumber = 1;
		
	// Schedule the notification
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    [localNotif release];
}



//- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
//{
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    [userDefaults removeObjectForKey:@"deviceToken"];
//    [userDefaults setObject:deviceToken forKey:@"deviceToken"];
//    
//    NSLog(@"Device token is: %@", deviceToken);
//    
//    //notification types set by user in preference setting.
//    NSUInteger rntypes = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
//	NSString *results = [NSString stringWithFormat:@"Badge: %@, Alert:%@, Sound: %@",
//						 (rntypes & UIRemoteNotificationTypeBadge) ? @"Yes" : @"No",
//						 (rntypes & UIRemoteNotificationTypeAlert) ? @"Yes" : @"No",
//						 (rntypes & UIRemoteNotificationTypeSound) ? @"Yes" : @"No"];
//	
//    NSString *status = [NSString stringWithFormat:@"Registration succeeded：%@", results];
//
//    NSLog(@"%@", status);
//}
//
//- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
//{
//    NSLog(@"Failed to get token, error: %@", error);
//}
//
//// Handle an actual notification
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
//{
//	NSString *status = [NSString stringWithFormat:@"Notification received:\n%@",[userInfo description]];
//
//	NSLog(@"%@", status);
//    CFShow([userInfo description]);
//	
//	//接收到push  打开程序以后设置badge的值
//	NSString *badgeStr = [[userInfo objectForKey:@"aps"] objectForKey:@"badge"];
//	if (badgeStr != nil)
//		[UIApplication sharedApplication].applicationIconBadgeNumber = [badgeStr intValue];
//	
//	//接收到push  打开程序以后会震动
//    NSString* path = [[NSBundle mainBundle] pathForResource:@"ping2" ofType:@"caf"];
//    SystemSoundID soundID;
//    AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:path],&soundID);
//    
//    AudioServicesPlaySystemSound(soundID);
//    
//
//	AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//    
//	
//}
//

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [DianRuAdWall dianruOnPause];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    //refresh point from all ad platform
    [DianRuAdWall dianruOnResume];
    [[PointsManager shared] refreshPoints];
    
    //
    if ([[KKPasscodeLock sharedLock] isPasscodeRequired]) {
        KKPasscodeViewController* sPasscodeViewController = [[KKPasscodeViewController alloc] initWithNibName:nil bundle:nil];
        sPasscodeViewController.mode = KKPasscodeModeEnter;
        sPasscodeViewController.title = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
        sPasscodeViewController.delegate = self;
        
        dispatch_async(dispatch_get_main_queue(),^ {
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:sPasscodeViewController];
            nav.navigationBar.tintColor = MAIN_BGCOLOR;
//            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//                nav.modalPresentationStyle = UIModalPresentationFormSheet;
//                nav.navigationBar.barStyle = UIBarStyleBlack;
//                nav.navigationBar.opaque = NO;
//            } else
//            {
//                nav.navigationBar.tintColor = _navigationController.navigationBar.tintColor;
//                nav.navigationBar.translucent = _navigationController.navigationBar.translucent;
//                nav.navigationBar.opaque = _navigationController.navigationBar.opaque;
//                nav.navigationBar.barStyle = _navigationController.navigationBar.barStyle;
//            }
            self.mNavOfPasswordEnterViewController = nav;
            [self.window.rootViewController presentModalViewController:self.mNavOfPasswordEnterViewController animated:NO];
            sPasscodeViewController.title = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
            [nav release];
        });
        
    }
    
    
    //
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

}

- (void)shouldEraseApplicationData:(KKPasscodeViewController*)viewController
{
    

}

- (void)didPasscodeEnteredIncorrectly:(KKPasscodeViewController*)viewController
{
    [[KKPasscodeLock sharedLock] unLockBrutly];
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 60000
    [self.mNavOfPasswordEnterViewController dismissModalViewControllerAnimated:YES];
#else
    [self.mNavOfPasswordEnterViewController dismissViewControllerAnimated:YES completion:nil];
#endif
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Notice", nil) message:NSLocalizedString(@"You have entered an incorrect passcode more than five times. Password become invalid automatically.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil];
    [alert show];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [StoreManager close];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void) checkUpdateAutomatically
{
    [MobClick checkUpdate:NSLocalizedString(@"New Version Found", nil) cancelButtonTitle:NSLocalizedString(@"Skip", nil) otherButtonTitles:NSLocalizedString(@"Update now", nil)];
}


@end
