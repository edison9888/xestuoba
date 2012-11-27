//
//  IconData.m
//  AboutSex
//
//  Created by Shane Wen on 12-7-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IconData.h"

@implementation IconData:NSObject

@synthesize mTitle;
@synthesize mImage;
@synthesize mJSONFilePath;
@synthesize mReadCount;
@synthesize mTotal;
@synthesize mSectionNameOrURL;
@synthesize mIsLocal;


- (id) init
{
    self = [super init];
    if (self)
    {
        self.mIsLocal = YES; //default value; 
    }
    return self;
}


@end
