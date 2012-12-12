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


@interface SharedStates : NSObject<UITabBarControllerDelegate, MyURLConnectionDelegate>
{
//    NSMutableData* mWebData;
    NSString* mBaiduZhidaoURLStr;
    MyURLConnection* mURLConnection;
    
    BOOL mIsFirstLaunch;
}

@property (nonatomic, retain) MyURLConnection* mURLConnection;
@property (nonatomic, copy) NSString* mBaiduZhidaoURLStr;

@property (nonatomic, assign) BOOL mIsFirstLaunch;

+ (SharedStates*)getInstance;

- (UITabBarController*) getMainTabController;

- (void) configApperance: (UITabBarController*)aTabBarController;



- (NSString*) getBaiduZhidaoURL;
- (BOOL) isFirstLaunchOfCurrentVersion;
- (BOOL) needUserGuideOnSectionIndex;
- (void) closeUserGuideOnSectionIndex;

- (UIView*) getABGColorView;
- (void) dimBGColorViews;
- (void) restoreBGColorViews;

@end
