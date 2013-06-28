//
//  StreamItem.m
//  AboutSex
//
//  Created by Shane Wen on 12-9-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "StreamItem.h"
#import "StoreManagerEx.h"
#import "NSString+MyString.h"
#import "NSURL+WithChanelID.h"

@implementation StreamItem

@synthesize mIconURL;
@synthesize mSummary;
@synthesize mNumVisits;
@synthesize mNumComments;
@synthesize mNumCollects;
@synthesize mNumLikes;
@synthesize mPicURL;
@synthesize mTag;
@synthesize mURLConnection;




- (void)dealloc
{
    self.mIconURL = nil;
    self.mSummary = nil;
    self.mPicURL = nil;
    self.mURLConnection = nil;
    
    [super dealloc];
}

- (void) readJSONDict:(NSDictionary*)sItemDict
{
    self.mItemID = [((NSNumber*)[sItemDict objectForKey:@"itemID"]) integerValue];
    self.mName = (NSString*) [sItemDict objectForKey:@"title"];
    self.mLocation = (NSString*) [sItemDict objectForKey:@"url"];
    self.mIsRead = NO;
    self.mIsMarked = NO;
    self.mReleasedTime = [NSDate dateWithTimeIntervalSince1970:[(NSString*) [sItemDict objectForKey:@"time"] integerValue]];
    self.mMarkedTime = [NSDate date];
    self.mIconURL = (NSString*) [sItemDict objectForKey:@"iconURL"];
    self.mSummary = (NSString*) [sItemDict objectForKey:@"summary"];
    self.mNumVisits = [((NSNumber*)[sItemDict objectForKey:@"numVisits"]) integerValue];
    self.mNumComments = [((NSNumber*)[sItemDict objectForKey:@"numComments"]) integerValue];
    self.mNumLikes = [((NSNumber*)[sItemDict objectForKey:@"numLikes"]) integerValue];
    self.mNumCollects = [((NSNumber*)[sItemDict objectForKey:@"numCollects"]) integerValue];

    self.mTag = [((NSNumber*)[sItemDict objectForKey:@"tag"]) integerValue];
}

- (void) bindUserInfo
{
    UserInfo* sUserInfo = [[StoreManagerEx shared] getUserInfoForStreamItem:self.mItemID];
    if (sUserInfo)
    {
        self.mIsRead = sUserInfo.mIsRead;
        self.mIsMarked = sUserInfo.mIsMarked;
        self.mIsLiked = sUserInfo.mIsLiked;
        self.mComment = sUserInfo.mComment;
    }
}

- (void) updateReadStatus
{
    if (self.mIsRead)
    {
        return;
    }
    
    self.mIsRead = YES;
    self.mNumVisits += 1;
    [[StoreManagerEx shared] updateStreamItemReadStatus:YES ItemID:self.mItemID];
    return;
}

- (void) updateMarkedStaus: (BOOL)aNewMarkedStatus
{
    if (self.mIsMarked == aNewMarkedStatus)
    {
        return;
    }
    
    self.mIsMarked = aNewMarkedStatus;
    
    //save html page to local storage, if it has not been saved before.
    if (aNewMarkedStatus
        && ![self.mLocation hasPrefix:@"StreamData/"])
    {
        NSMutableURLRequest* sURLRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL MyURLWithString:self.mLocation]];
        
        [sURLRequest setHTTPMethod:@"GET"];
        
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
    else 
    {
        [[StoreManagerEx shared] updateStreamItemMarkedStatus:aNewMarkedStatus ItemID:self.mItemID];
        if (aNewMarkedStatus)
        {
            self.mNumCollects += 1;
        }
        else
        {
            self.mNumCollects -= 1;
        }
    }
    
    return;
}

- (void) updateLikedStatus:(BOOL)aLiked
{
    if (self.mIsLiked)
    {
        return;
    }
    
    self.mIsLiked = YES;
    self.mNumLikes += 1;
    
    //storemanager
    [[StoreManagerEx shared] updateStreamItemLikedStatus:aLiked ItemID:self.mItemID];

    return;
}

- (void) updateComment:(NSString *)aComment
{
    if (self.mComment.length <=0 )
    {
        self.mNumComments += 1;      
    }
    self.mComment = aComment;

    [[StoreManagerEx shared] updateStreamItemComment:self.mComment ItemID:self.mItemID];
}

#pragma mark -
#pragma mark delegate methods for MyURLConnectionDelegate
- (void) failWithConnectionError: (NSError*)aErr
{
    return;
}

- (void) failWithServerError: (NSInteger)aStatusCode
{
    return;
}

- (void) succeed: (NSMutableData*)aData
{
    
    NSData* sFileContent = aData;
 
#ifdef LOCAL_SERVER    
    unsigned int sIndexOfLastSlash = [self.mLocation indexOfChar:'/' options:NSBackwardsSearch];
#else
    unsigned int sIndexOfLastSlash = [self.mLocation indexOfChar:'=' options:NSBackwardsSearch];  
#endif
    
    if (sIndexOfLastSlash != NSNotFound
        && sIndexOfLastSlash <(self.mLocation.length-1)) 
    {
        NSString* sFileName = nil;
        sFileName = [self.mLocation substringFromIndex:sIndexOfLastSlash+1];
        if(sFileName
           && sFileName.length>0)
        {
            NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,NSUserDomainMask, YES); 
            NSString *documentsDirectory = [paths objectAtIndex:0]; 
            NSString* sStreamDataDirName = [documentsDirectory stringByAppendingPathComponent:@"StreamData/"];
            
            BOOL sIsDir;
            if (![[NSFileManager defaultManager] fileExistsAtPath:sStreamDataDirName isDirectory:&sIsDir]
                || !sIsDir)
            {
                BOOL sStatus = [[NSFileManager defaultManager] createDirectoryAtPath:sStreamDataDirName withIntermediateDirectories:NO attributes:nil error:nil];
                if (!sStatus)
                {
                    return;
                }
            }
            NSString* sFullFileName = [sStreamDataDirName stringByAppendingPathComponent:sFileName];
            NSString* sNewFileNameCompoments = [NSString stringWithFormat:@"%@%@", @"StreamData/", sFileName];
            if([sFileContent writeToFile:sFullFileName atomically:YES]
               && [[StoreManagerEx shared] updateStreamItemLocation:sNewFileNameCompoments ItemID:self.mItemID])
            {
                [[StoreManagerEx shared] updateStreamItemMarkedStatus:YES ItemID:self.mItemID];
                self.mLocation = sNewFileNameCompoments;
                self.mNumCollects += 1;
            }

        }
        
    }
    
}


@end
