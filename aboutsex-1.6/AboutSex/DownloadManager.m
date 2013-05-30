//
//  DownloadManager.m
//  AboutSex
//
//  Created by Wen Shane on 13-4-30.
//
//

#import "DownloadManager.h"

#import "StoreManager.h"

@interface DownloadManager()
{
    ASINetworkQueue* mNetQueue;
    NSString* mTargetDirPath;
    NSString* mCacheDirPath;
}

@property (nonatomic, retain) ASINetworkQueue* mNetQueue;
@end


@implementation DownloadManager
@synthesize mDelegate;
@synthesize mNetQueue;
@synthesize mTargetDirPath;
@synthesize mCacheDirPath;

+ (DownloadManager*) shared
{
    static DownloadManager* S_DownloadManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        S_DownloadManager = [[self alloc] init];
    });
    
    return S_DownloadManager;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        self.mNetQueue = [[[ASINetworkQueue alloc] init] autorelease];
//        [self.mNetQueue setShowAccurateProgress:YES];//高精度进度
        [self.mNetQueue setShouldCancelAllRequestsOnFailure:NO];//in default, if one request is failed, other requests are canceled.
        [self.mNetQueue go];

    }
    return self;
}

- (void) dealloc
{
    self.mNetQueue = nil;
    self.mTargetDirPath = nil;
    self.mCacheDirPath = nil;
    
    [super dealloc];
}

- (BOOL) startTaskForURL:(NSString*)aURLStr withFileName:(NSString*)aFileName withProgressDelegate:(id<ASIProgressDelegate>)aProgressDelegate withTaskID:(NSInteger)aTaskID
{
    if (self.mTargetDirPath.length > 0
        && aFileName.length > 0)
    {
        NSString* sTargetFilePath = [self.mTargetDirPath stringByAppendingPathComponent:aFileName];
        NSString* sTargetFilePathTemp = [self.mCacheDirPath stringByAppendingPathComponent:[aFileName stringByAppendingString:@".temp"]];
        
        NSString* sURLStrEncoded = [aURLStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL* sUrl = [NSURL URLWithString:sURLStrEncoded];

        ASIHTTPRequest* sRequest = [ASIHTTPRequest requestWithURL:sUrl];
        sRequest.delegate = self;//代理
        [sRequest setDownloadDestinationPath:sTargetFilePath];
        [sRequest setTemporaryFileDownloadPath:sTargetFilePathTemp];
        [sRequest setAllowResumeForFileDownloads:YES];
         sRequest.downloadProgressDelegate = aProgressDelegate;
        [sRequest setShowAccurateProgress:YES];
        [sRequest setShouldContinueWhenAppEntersBackground:YES];
        sRequest.tag = aTaskID;
        
        [self.mNetQueue addOperation:sRequest];
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void) pause:(NSInteger)aTaskID
{    
    for (ASIHTTPRequest* sRequest in self.mNetQueue.operations)
    {
        if (sRequest.tag == aTaskID)
        {
            [sRequest clearDelegatesAndCancel];
            return;
        }
    }
}

#pragma mark - ASIHttp Delegate

- (void)requestFinished:(ASIHTTPRequest *)request
{
    if ([self.mDelegate respondsToSelector:@selector(downloadDone:)])
    {
        [self.mDelegate downloadDone:request.tag];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Failed: %d", request.tag);
    if ([self.mDelegate respondsToSelector:@selector(downloadFailed:)])
    {
        [self.mDelegate downloadFailed:request.tag];
    }

}




@end
