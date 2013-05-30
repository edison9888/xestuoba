//
//  AboutSex.h
//  AboutSex
//
//  Created by Shane Wen on 12-6-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MyURLConnection.h"

//

typedef enum  {
    ENUM_AD_BAR_SOURCE_TYPE_GUOMENG,
    ENUM_AD_BAR_SOURCE_TYPE_YOUMI,
    ENUM_AD_BAR_SOURCE_TYPE_MOBWIN,
    ENUM_AD_BAR_SOURCE_TYPE_DOMOB,
    ENUM_AD_BAR_SOURCE_TYPE_DISABLED,
}ENUM_AD_BAR_SOURCE_TYPE;


@interface SharedStates : NSObject<UITabBarControllerDelegate, MyURLConnectionDelegate>
{
//    NSMutableData* mWebData;
    
    //for the 3 members below, use what sent from the server if network works right, otherwise use values if they have been stored in defaults.
    NSString* mAskURL;
    NSString* mAskProvider;
    NSString* mCommentURL;

    //mDate4NumUpdatesForRecAppsServer is used to determine whether NumOfUpdatesForRecommanedApps sent from the server takes effect on the clientside, by comparing it with that on the client.
    NSInteger mNumOfUpdatesForRecommanedApps;
    NSString* mDate4NumUpdatesForRecAppsServer; //if the date is older than the date set from the server, then we should employ the NumOfUpdatesForRecommanedApps sent from server, ignore that otherwise.
    
    //
    
    MyURLConnection* mURLConnection;
    
    BOOL mIsFirstLaunch;
    
    NSCache* mCache;
    
}

@property (nonatomic, retain) MyURLConnection* mURLConnection;
@property (nonatomic, copy) NSString* mAskURL;
@property (nonatomic, copy) NSString* mAskProvider;
@property (nonatomic, copy) NSString* mCommentURL;
@property (nonatomic, assign) NSInteger mNumOfUpdatesForRecommanedApps;
@property (nonatomic, copy) NSString* mDate4NumUpdatesForRecAppsServer;

@property (nonatomic, assign) BOOL mIsFirstLaunch;
@property (nonatomic, retain) NSCache* mCache;

+ (SharedStates*)getInstance;

- (UITabBarController*) getMainTabController;

- (void) configApperance: (UITabBarController*)aTabBarController;
- (void) configBackground;


- (NSDate*) getLastUpdateTime;
- (void) storeLastUpdateTime:(NSDate*)aDate;

- (NSString*) getAskURL;
- (NSString*) getAskProvider;
- (NSString*) getCommentURL;
- (NSInteger) getNumOfUpdatesForRecommandedApps;

- (NSData*) getRecommandedAppCacheData;
- (void) cacheRecommandedAppData:(NSData*)aData;

- (NSInteger) getLastIndexOFFMItem;
- (void) setFMItemIndex:(NSInteger)aIndex;

- (NSTimeInterval) getLasCurrentTimeOfFMItem;
- (void) setFMItemCurrentTime:(NSTimeInterval)aCurrentTime;

//- (void) cacheObject:(id)aObj forKey:(id)aKey;
//- (id) getCachedObjectForKey:(id)aKey;

- (NSString*) getLastVersion;
- (BOOL) isFirstLaunchOfCurrentVersion;
- (BOOL) needUserGuideOnSectionIndex;
- (void) closeUserGuideOnSectionIndex;

- (BOOL) needShowNoticeForAsKAndAnswer;
- (void) closeShowAskAndAnswerNotice;
- (void) latestRecommendAppsViewed;

- (NSString*) getUserName;
- (NSString*) getUUID;


- (NSInteger) getLucksOfToday;
- (BOOL) decreaseLuckOfToday;

- (ENUM_AD_BAR_SOURCE_TYPE) getADBarSourceType;
- (NSString*) getCommentNotice;
@end
