//
//  StreamItem.m
//  AboutSex
//
//  Created by Shane Wen on 12-9-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "StreamItem.h"
#import "StoreManager.h"
#import "NSString+MyString.h"

@implementation StreamItem

@synthesize mIconURL;
@synthesize mSummary;
@synthesize mNumVisits;
@synthesize mTag;
@synthesize mURLConnection;



- (void)dealloc
{
    self.mIconURL = nil;
    self.mSummary = nil;
    self.mURLConnection = nil;
    
    [super dealloc];
}

- (void) markAsReadInDatabase
{
    [StoreManager updateStreamItemReadStatus:YES ItemID:self.mItemID];
    return;
}

- (void) updateMarkedStaus: (BOOL)aNewMarkedStatus
{
    
  
    //save html page to local storage, if it has not been saved before.
    if (aNewMarkedStatus
        && ![self.mLocation hasPrefix:@"StreamData/"])
    {
        NSMutableURLRequest* sURLRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:self.mLocation]];
        
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

        
        //
        
        

    }
    else 
    {
        [StoreManager updateStreamItemMarkedStatus:aNewMarkedStatus ItemID:self.mItemID];
    }
    
    return;
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
               && [StoreManager updateStreamItemLocation:sNewFileNameCompoments ItemID:self.mItemID])
            {
                [StoreManager updateStreamItemMarkedStatus:YES ItemID:self.mItemID];
                self.mLocation = sNewFileNameCompoments;
            }

        }
        
    }
    
}


@end
