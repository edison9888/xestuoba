//
//  IconData.h
//  AboutSex
//
//  Created by Shane Wen on 12-7-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IconData : NSObject
{
    NSString*   mTitle;
    UIImage* mImage;
    NSString*   mJSONFilePath;
    NSString*   mSectionNameOrURL;
    BOOL    mIsLocal;

    NSInteger  mReadCount;
    NSInteger  mTotal;
}

@property (nonatomic, retain) UIImage* mImage;
@property (nonatomic, retain) NSString* mTitle;
@property (nonatomic, retain) NSString* mJSONFilePath;
@property (nonatomic, assign) NSInteger mReadCount;
@property (nonatomic, assign) NSInteger mTotal;
@property (nonatomic, retain) NSString* mSectionNameOrURL;
@property (nonatomic, assign) BOOL mIsLocal;

@end
