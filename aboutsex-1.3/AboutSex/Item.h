//
//  Item.h
//  AboutSex
//
//  Created by Shane Wen on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Category;
@class Section;

@interface Item : NSObject
{
    NSInteger mItemID;
    NSString* mName;
    NSString* mLocation;
    BOOL mIsRead;
    BOOL mIsMarked;
    NSDate* mReleasedTime;
    NSDate* mMarkedTime;
    Category* mCategory;
    Section* mSection;
}

@property (nonatomic, assign) NSInteger mItemID;
@property (nonatomic, copy) NSString* mName;
@property (nonatomic, copy) NSString* mLocation;
@property (nonatomic, assign) BOOL mIsRead;
@property (nonatomic, assign) BOOL mIsMarked;
@property (nonatomic, retain) NSDate* mReleasedTime;
@property (nonatomic, retain) NSDate* mMarkedTime;
@property (nonatomic, assign) Category* mCategory;
@property (nonatomic, assign) Section* mSection;

- (void) markAsReadInDatabase;
- (void) updateMarkedStaus: (BOOL)aNewMarkedStatus;

@end
