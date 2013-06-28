////
////  StoreManager.h
////  AboutSex
////
////  Created by Shane Wen on 12-7-11.
////  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
////
//
//#import <Foundation/Foundation.h>
//#import "FMDatabase.h"
//#import "Section.h"
//
//
//@interface StoreManager : NSObject
//
//+ (BOOL) openIfNecessary;
//+ (void) close;
//+ (NSString*) getPathForDBinDocunemtsDir;
//+ (NSString*)  getPathForDocumentsFMItemsDir;
//
//+ (NSString*) getPathForFMCacheDir;
////+ (NSMutableArray*) getAllItemsForSection:(NSString*)aSectionName;
//
////add stream items into table streamitem, if the stream item does not exist in database already, otherwise update its numVisits field. Return the stream items inserted.
//+ (NSInteger) addOrUpdateStreamItems: (NSMutableArray*)aStreamItemsArray;
//
//+ (Section*) getStreamSectionForRecentNDays:(NSInteger)aNumberOfDays;
//+ (NSMutableArray*) getLatestStreamItems: (NSInteger) aMaxNumOfItems Offset:(NSInteger)aOffset;
//+ (UserInfo*) getUserInfoForStreamItem:(NSInteger)aStreamItemID;
//
//+ (Section*) getSectionByName: (NSString*) aName;
//+ (NSInteger) getReadCountInSection: (NSString*) aSectionName;
//+ (NSInteger) getTotalOfItemsInsection:(NSString*) aSectionName;
//+ (NSInteger) getTotalOfCategoriesInSection:(NSString*) aSectionName;
//+ (NSMutableArray*) getAllFavoriteItems;
//
//
//+ (BOOL) updateItemMarkedStatus:(BOOL)aIsMarked ItemID:(NSInteger)aItemID;
//+ (BOOL) updateItemMarkedStatus:(BOOL)aIsMarked Time:(NSDate*)aDate ItemID:(NSInteger)aItemID;
//+ (BOOL) updateItemReadStatus:(BOOL)aIsRead ItemID:(NSInteger)aItemID;
//
//
//
//+ (BOOL) updateStreamItemReadStatus:(BOOL)aIsRead ItemID:(NSInteger)aItemID;
//+ (BOOL) updateStreamItemMarkedStatus:(BOOL)aIsMarked ItemID:(NSInteger)aItemID;
//+ (BOOL) updateStreamItemMarkedStatus:(BOOL)aIsMarked Time:(NSDate*)aDate ItemID:(NSInteger)aItemID;
//+ (BOOL) updateStreamItemLikedStatus:(BOOL)aLiked ItemID:(NSInteger)aItemID;
//+ (BOOL) updateStreamItemComment:(NSString*)aComment ItemID:(NSInteger)aItemID;
//
//+ (BOOL) updateStreamItemLocation:(NSString*)aNewLoc ItemID:(NSInteger)aItemID;
//+ (BOOL) removeUncollectedStreamItemsIfExceeds:(NSInteger)aMaxCount aMinCount:(NSInteger)aMinCount;
//
//+ (BOOL) updateSectionOffset:(CGFloat)aOffset ForSection:(NSInteger)aSectionID;
//
//+ (BOOL) updateItemReleasedTime:(NSDate*)aDate ItemID:(NSInteger)aItemID;
//
//@end
