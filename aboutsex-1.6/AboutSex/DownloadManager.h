//
//  DownloadManager.h
//  AboutSex
//
//  Created by Wen Shane on 13-4-30.
//
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"

@protocol DownloadManagerDelegate <NSObject>

@optional

- (void) setProgress:(double)aProgress ForTaskID:(NSInteger)aTaskID;

- (void) downloadDone:(NSInteger)aTaskID;
- (void) downloadFailed:(NSInteger)aTaskID;

@end


@interface DownloadManager : NSObject
{
//    id<DownloadManagerDelegate> mDelegate;
}
//@property (nonatomic, assign) id<DownloadManagerDelegate> mDelegate;
@property (nonatomic, copy) NSString* mTargetDirPath;
@property (nonatomic, copy) NSString* mCacheDirPath;

+ (DownloadManager*) shared;


- (BOOL) startTaskForURL:(NSString*)aURLStr withFileName:(NSString*)aFileName withProgressDelegate:(id<ASIProgressDelegate>)aProgressDelegate withTaskID:(NSInteger)aTaskID withDelegate:(id<DownloadManagerDelegate>)aDelegate;
- (void) pause:(NSInteger)aTaskID;


@end
