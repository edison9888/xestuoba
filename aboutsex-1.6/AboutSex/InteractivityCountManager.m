//
//  InteractivityCountManager.m
//  AboutSex
//
//  Created by Wen Shane on 13-3-14.
//
//

#import "InteractivityCountManager.h"
#import "SharedVariables.h"
#import "AFNetworking.h"
#import "NSURL+WithChanelID.h"
#import "MobClick.h"


static InteractivityCountManager* S_ICManager = nil;


@implementation InteractivityCountManager


+ (InteractivityCountManager*) shared
{
    @synchronized([InteractivityCountManager class]){
        if(S_ICManager == nil){
            S_ICManager = [[self alloc]init];
        }
    }
    return S_ICManager;

}

- (void) collectItem:(StreamItem*)aItem Collected:(BOOL)aIsCollected
{
    NSString* sURLStr = [NSString stringWithFormat:@"%@?itemID=%d&collected=%d", URL_COLLECT_ITEM, aItem.mItemID, aIsCollected];
    
    [self uploadInteractivityInfoByGetURL:sURLStr];
    
    
    NSDictionary* sDict = [NSDictionary dictionaryWithObject:aItem.mName forKey:@"title"];
    if (aIsCollected)
    {
        [MobClick event:@"UEID_COLLECT" attributes: sDict];
    }
    else
    {
        [MobClick event:@"UEID_UNCOLLECT" attributes: sDict];
    }

}

- (void) likeItem:(StreamItem*)aItem
{
    NSString* sURLStr = [NSString stringWithFormat:@"%@?itemID=%d", URL_LIKE_ITEM, aItem.mItemID];
    
    [self uploadInteractivityInfoByGetURL:sURLStr];
    
    NSDictionary* sDict = [NSDictionary dictionaryWithObject:aItem.mName forKey:@"title"];
    [MobClick event:@"UEID_LIKE" attributes: sDict];
}

- (void) dingComment:(CommentItem*)aCommentItem
{
    NSString* sURLStr = URL_DING_COMMENT(aCommentItem.mID);
    [self uploadInteractivityInfoByGetURL:sURLStr];
        
    [MobClick event:@"UEID_DING_COMMENT"];
}

- (void) caiComment:(CommentItem*)aCommentItem
{
    NSString* sURLStr = URL_CAI_COMMENT(aCommentItem.mID);
    [self uploadInteractivityInfoByGetURL:sURLStr];
    
    [MobClick event:@"UEID_CAI_COMMENT"];
}

- (void) uploadInteractivityInfoByGetURL:(NSString*)aURLStr
{
    NSString* sURLStr = [aURLStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL MyURLWithString:sURLStr]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
    }];
    [operation start];
    [operation release];
}

@end
