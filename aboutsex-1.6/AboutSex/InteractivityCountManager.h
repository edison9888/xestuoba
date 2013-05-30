//
//  InteractivityCountManager.h
//  AboutSex
//
//  Created by Wen Shane on 13-3-14.
//
//

#import <Foundation/Foundation.h>
#import "StreamItem.h"

@interface InteractivityCountManager : NSObject


+ (InteractivityCountManager*) shared;

- (void) collectItem:(StreamItem*)aItem Collected:(BOOL)aIsCollected;
- (void) likeItem:(StreamItem*)aItem;

@end
