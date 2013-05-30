//
//  Item.m
//  AboutSex
//
//  Created by Shane Wen on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Item.h"
#import "StoreManager.h"
#import "NSURL+WithChanelID.h"

@implementation UserInfo
@synthesize mIsRead;
@synthesize mIsMarked;
@synthesize mIsLiked;
@synthesize mComment;

- (void) dealloc
{
    self.mComment = nil;
    [super dealloc];
}


@end


@implementation Item


@synthesize mItemID;
@synthesize mName;
@synthesize mLocation;
@synthesize mReleasedTime;
@synthesize mMarkedTime;
@synthesize mCategory;
@synthesize mSection;


- (void)dealloc
{
    self.mName = nil;
    self.mLocation = nil;
    self.mReleasedTime = nil;
    self.mMarkedTime = nil;
    self.mSection = nil;
    self.mCategory = nil;
    
    [super dealloc];

}

- (void) updateReadStatus
{
    self.mIsRead = YES;
    [StoreManager updateItemReadStatus:YES ItemID:self.mItemID];
    return;
}

- (void) updateMarkedStaus: (BOOL)aNewMarkedStatus
{
    self.mIsMarked = aNewMarkedStatus;
    [StoreManager updateItemMarkedStatus:aNewMarkedStatus ItemID:self.mItemID];
    return;
}

- (void) updateLikedStatus:(BOOL)aLiked
{
    self.mIsLiked = aLiked;
    //StoreManager
    
    return;
}

- (void) updateComment:(NSString *)aComment
{
    self.mComment = aComment;
    
//    [StoreManager updateItemMarkedStatus:<#(BOOL)#> ItemID:<#(NSInteger)#>]
}



- (NSURL*) getURL
{
    NSString* sLoc = self.mLocation;
    NSURL* sURL = nil;
    if ([sLoc hasPrefix:@"data/"])
    {
        NSString* sBundlePath = [[NSBundle mainBundle] bundlePath];
        sLoc = [sBundlePath stringByAppendingPathComponent:sLoc];
        sURL = [NSURL fileURLWithPath:sLoc];
    }
    else if([sLoc hasPrefix:@"StreamData/"])
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        sLoc = [documentsDirectory stringByAppendingPathComponent:sLoc];
        sURL = [NSURL fileURLWithPath:sLoc];
    }
    else
    {
        sURL = [NSURL MyURLWithString:sLoc];
    }

    return sURL;
}

@end
