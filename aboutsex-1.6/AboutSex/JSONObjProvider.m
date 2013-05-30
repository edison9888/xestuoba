//
//  JSONParser.m
//  BTT
//
//  Created by Wen Shane on 12-12-19.
//  Copyright (c) 2012年 Wen Shane. All rights reserved.
//

#import "JSONObjProvider.h"
#import "AFNetworking.h"
#import "JSONWrapper.h"


@implementation JSONObjProvider
@synthesize mURLRequest;
@synthesize mCacheFilePath;
@synthesize mDelegate;
@synthesize mUseCacheIfNeeded;


- (id) initWithURLRequest: (NSURLRequest*) aURLRequest CacheFilePath:(NSString*)aFilePath UseCacheIfNeeded:(BOOL)aUseCacheIfNeeded;
{
    self = [super init];
    if (self)
    {
        self.mURLRequest = aURLRequest;
        self.mCacheFilePath = aFilePath;
        self.mUseCacheIfNeeded = aUseCacheIfNeeded;
    }
    return self;
}

- (void) dealloc
{
    self.mURLRequest = nil;
    self.mCacheFilePath = nil;
    
    [super dealloc];
}

- (void) start
{
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:self.mURLRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [self loadSucessfully:JSON];
    } failure:^( NSURLRequest *request , NSHTTPURLResponse *response , NSError *error , id JSON ){
        [self loadFailed:error];
    }];
    [operation start];
}

- (void) loadSucessfully:(id)aJSONObj
{
    [self backupData:aJSONObj];
    [self.mDelegate dataLoadedOnline:aJSONObj];
}

- (void) loadFailed:(NSError*)aError
{
    if (self.mUseCacheIfNeeded)
    {
        id sJSONObj = [self restoreBackup];
        if (sJSONObj)
        {
            [self.mDelegate dataLoadedLocally:sJSONObj];
            return;
        }
    }
    
    if ([self.mDelegate respondsToSelector:@selector(dataLoadedFailed)])
    {
        [self.mDelegate dataLoadedFailed];      
    }
}


- (void) backupData:(id)aJSONObj
{
    NSData* sData = [JSONWrapper dataWithJSONObject:aJSONObj options:NSJSONWritingPrettyPrinted error:nil];
    if (sData)
    {
        [sData writeToFile:self.mCacheFilePath atomically:YES];      
    }
}

- (id) restoreBackup
{
    //?
#if DEBUG
    NSLog(@"loading data locally");
#endif
    id sJSONObj = nil;
    NSData* sData = [NSData dataWithContentsOfFile:self.mCacheFilePath];
    if (sData)
    {
        sJSONObj = [JSONWrapper JSONObjectWithData:sData options:NSJSONReadingMutableContainers error:nil];
    }
    return sJSONObj;
}




@end
