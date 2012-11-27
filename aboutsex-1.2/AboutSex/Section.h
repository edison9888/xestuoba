//
//  Section.h
//  AboutSex
//
//  Created by Shane Wen on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"
#import "Category.h"


@interface Section : NSObject
{
    NSInteger mSectionID;
    NSString* mName;
    NSMutableArray* mCategories;
    CGFloat mOffset;
    
    NSMutableArray* mIndexOfTheFirstItemForEachCategory;
    NSInteger mItemCount;
    
    BOOL mIsCategoryZebraed;
}

@property (nonatomic, assign) NSInteger mSectionID;
@property (nonatomic, copy) NSString* mName;
@property (nonatomic, retain) NSMutableArray* mCategories;
@property (nonatomic, assign) CGFloat mOffset;
@property (nonatomic, retain) NSMutableArray* mIndexOfTheFirstItemForEachCategory;
@property (nonatomic, assign) NSInteger mItemCount;
@property (nonatomic, assign) BOOL mIsCategoryZebraed;


- (void) initIndexOfTheFirstItemForEachCategory;
- (NSInteger) getIndexOfTheFirstItemInCategory: (NSInteger) aCategoryIndex;

- (Item*) getItemByIndex: (NSInteger)aIndex;
- (Item*) getItemByIndexByCategory:(NSInteger)aIndex;
- (Item*) getItemByIndexLikeZebraStripes:(NSInteger)aIndex;
- (Item*) getItemByIndex: (NSInteger)aIndex InCategory: (NSInteger) aCategoryIndex;

@end
