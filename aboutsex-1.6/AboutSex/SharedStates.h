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

#define GENERAL_DURATION 5
#define MIN_DURATION 1
#define MAX_DURATION 7
#define GENERAL_PERIOD 28
#define MIN_PERIOD 25



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
    
    NSMutableArray* mPeriods;
    
}

@property (nonatomic, retain) MyURLConnection* mURLConnection;
@property (nonatomic, copy) NSString* mAskURL;
@property (nonatomic, copy) NSString* mAskProvider;
@property (nonatomic, copy) NSString* mCommentURL;
@property (nonatomic, assign) NSInteger mNumOfUpdatesForRecommanedApps;
@property (nonatomic, copy) NSString* mDate4NumUpdatesForRecAppsServer;

@property (nonatomic, assign) BOOL mIsFirstLaunch;
@property (nonatomic, retain) NSCache* mCache;
@property (nonatomic, retain) NSMutableArray* mPeriods;

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

+ (BOOL) isCurLanguageChinese;


- (NSArray*) getPeriods;
- (NSDate*) getLastPeriodStartDate;
- (NSDate*) getLastPeriodEndDate;

- (void) addPeriodStartDate:(NSDate*)aStartDate EndDate:(NSDate*)aEndDate;
- (NSInteger) getPeriodDays;
- (NSInteger) getDuration;

@end
