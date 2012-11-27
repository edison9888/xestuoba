//
//  StoreManager.h
//  AboutSex
//
//  Created by Shane Wen on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "Section.h"


@interface StoreManager : NSObject

+ (BOOL) openIfNecessary;
+ (void) close;
+ (NSString*) getPathForDBinDocunemtsDir;

//+ (NSMutableArray*) getAllItemsForSection:(NSString*)aSectionName;

+ (Section*) getStreamSectionForRecentNDays:(NSInteger)aNumberOfDays;

+ (Section*) getSectionByName: (NSString*) aName;
+ (NSInteger) getReadCountInSection: (NSString*) aSectionName;
+ (NSInteger) getTotalOfItemsInsection:(NSString*) aSectionName;
+ (NSMutableArray*) getAllFavoriteItems;


+ (BOOL) updateItemMarkedStatus:(BOOL)aIsMarked ItemID:(NSInteger)aItemID;
+ (BOOL) updateItemMarkedStatus:(BOOL)aIsMarked Time:(NSDate*)aDate ItemID:(NSInteger)aItemID;
+ (BOOL) updateItemReadStatus:(BOOL)aIsRead ItemID:(NSInteger)aItemID;
+ (BOOL) updateSectionOffset:(CGFloat)aOffset ForSection:(NSInteger)aSectionID;

+ (BOOL) updateItemReleasedTime:(NSDate*)aDate ItemID:(NSInteger)aItemID;

@end
