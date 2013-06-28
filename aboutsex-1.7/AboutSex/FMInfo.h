//
//  FMInfo.h
//  AboutSex
//
//  Created by Wen Shane on 13-4-27.
//
//

#import <Foundation/Foundation.h>

@interface FMInfo : NSObject
{
    NSInteger mID;
    NSString* mName;
    NSString* mIconURLStr;
    double mDuration;
    double mSize;
    NSInteger mPrice;
    
    NSString* mDownloadURLStr;
    NSDate* mDate;
    
    BOOL mISDownloading;
}

@property (nonatomic, assign)     NSInteger mID;
@property (nonatomic, copy)       NSString* mName;
@property (nonatomic, copy)       NSString* mIconURLStr;
@property (nonatomic, assign)     double mDuration;
@property (nonatomic, assign)     double mSize;
@property (nonatomic, assign)     NSInteger mPrice;
@property (nonatomic, retain)     NSDate* mDate;

@property (nonatomic, copy)       NSString* mDownloadURLStr;
@property (nonatomic, assign)     BOOL mISDownloading;

@end
