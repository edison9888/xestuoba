//
//  Item.h
//  AboutSex
//
//  Created by Shane Wen on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserInfo : NSObject
{
    BOOL mIsRead;
    BOOL mIsMarked;
    BOOL mIsLiked;
    NSString* mComment; //user's comment; a local copy of one's comment

}
@property (nonatomic, assign) BOOL mIsRead;
@property (nonatomic, assign) BOOL mIsMarked;
@property (nonatomic, assign) BOOL mIsLiked;
@property (nonatomic, copy) NSString* mComment;

@end


@class Category;
@class Section;

@interface Item : UserInfo
{
    NSInteger mItemID;
    NSString* mName;
    NSString* mLocation;
    NSDate* mReleasedTime;
    NSDate* mMarkedTime;
    Category* mCategory;
    Section* mSection;
}

@property (nonatomic, assign) NSInteger mItemID;
@property (nonatomic, copy) NSString* mName;
@property (nonatomic, copy) NSString* mLocation;
@property (nonatomic, retain) NSDate* mReleasedTime;
@property (nonatomic, retain) NSDate* mMarkedTime;
@property (nonatomic, assign) Category* mCategory;
@property (nonatomic, assign) Section* mSection;

- (void) updateReadStatus;
- (void) updateMarkedStaus: (BOOL)aNewMarkedStatus;
- (void) updateLikedStatus:(BOOL)aLiked;
- (void) updateComment:(NSString *)aComment;

- (NSURL*) getURL;
@end
