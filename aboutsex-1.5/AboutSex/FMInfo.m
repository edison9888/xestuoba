//
//  FMInfo.m
//  AboutSex
//
//  Created by Wen Shane on 13-4-27.
//
//

#import "FMInfo.h"

@implementation FMInfo
@synthesize mID;
@synthesize mName;
@synthesize mDuration;
@synthesize mSize;
@synthesize mPrice;
@synthesize mIconURLStr;
@synthesize mDate;
@synthesize mDownloadURLStr;
@synthesize mISDownloading;

- (id) init
{
    self = [super init];
    if (self)
    {
        self.mISDownloading = NO;
    }
    return self;
}

- (void) dealloc
{
    self.mName = nil;
    self.mIconURLStr = nil;
    self.mDownloadURLStr = nil;
    self.mDate = nil;
    
    [super dealloc];
}

@end
