//
//  JSONParser.h
//  BTT
//
//  Created by Wen Shane on 12-12-19.
//  Copyright (c) 2012年 Wen Shane. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JSONObjProviderDelegate <NSObject>

@required
- (void) dataLoadedOnline:(id)aJSONObj;
- (void) dataLoadedFailed;
- (void) dataLoadedLocally:(id)aJSONObj;

@end

@interface JSONObjProvider : NSObject
{
    NSURLRequest* mURLRequest;
    NSString* mCacheFilePath;
    id<JSONObjProviderDelegate> mDelegate;
    BOOL mUseCacheIfNeeded;
}
@property(nonatomic, retain) NSURLRequest* mURLRequest;
@property(nonatomic, copy) NSString* mCacheFilePath;
@property(nonatomic, assign) id<JSONObjProviderDelegate> mDelegate;
@property(nonatomic, assign) BOOL mUseCacheIfNeeded;

- (id) initWithURLRequest: (NSURLRequest*) aURLRequest CacheFilePath:(NSString*)aFilePath UseCacheIfNeeded:(BOOL)aUseCacheIfNeeded;
- (void) start;
@end
