//
//  InteractivityCountManager.h
//  AboutSex
//
//  Created by Wen Shane on 13-3-14.
//
//

#import <Foundation/Foundation.h>
#import "StreamItem.h"
#import "CommentItem.h"

@interface InteractivityCountManager : NSObject


+ (InteractivityCountManager*) shared;

- (void) collectItem:(StreamItem*)aItem Collected:(BOOL)aIsCollected;
- (void) likeItem:(StreamItem*)aItem;

- (void) dingComment:(CommentItem*)aCommentItem;
- (void) caiComment:(CommentItem*)aCommentItem;
@end
