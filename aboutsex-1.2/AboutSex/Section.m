            //
//  Section.m
//  AboutSex
//
//  Created by Shane Wen on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Section.h"
#import "SharedVariables.h"


#define INVALID_NUMBER -1

@implementation Section


@synthesize mSectionID;
@synthesize mName;
@synthesize mCategories;
@synthesize mOffset;

@synthesize mIndexOfTheFirstItemForEachCategory;
@synthesize mItemCount;
@synthesize mIsCategoryZebraed;

- (id) init 
{
    self = [super init];
    if (self)
    {
        self.mItemCount = INVALID_NUMBER;
        self.mIsCategoryZebraed = NO;
    }
    return self;
}

- (void) initIndexOfTheFirstItemForEachCategory
{
    if (self.mItemCount == INVALID_NUMBER)
    {
        self.mIndexOfTheFirstItemForEachCategory = nil;
        self.mItemCount = 0;
        if (self.mCategories)
        {
            NSMutableArray* sIndexOfTheFirstItemForEachCat = [[NSMutableArray alloc]init];
            NSInteger sCurFirstIndex = 0;
            Category* sCat;
            for (sCat in self.mCategories)
            {
                [sIndexOfTheFirstItemForEachCat addObject:[NSNumber  numberWithInt:sCurFirstIndex]];
                sCurFirstIndex += [sCat.mItems count];
            }
            self.mItemCount = sCurFirstIndex;
            self.mIndexOfTheFirstItemForEachCategory = sIndexOfTheFirstItemForEachCat;
            [sIndexOfTheFirstItemForEachCat release];
        }
        
    }
}

- (void) dealloc
{
    self.mName = nil;
    self.mCategories = nil;
    self.mIndexOfTheFirstItemForEachCategory = nil;
    
    [super dealloc];
}

- (Item*) getItemByIndex: (NSInteger)aIndex
{
    if (self.mIsCategoryZebraed)
    {
        return [self getItemByIndexLikeZebraStripes:aIndex];
    }
    else 
    {
        return [self getItemByIndexByCategory:aIndex];
    }
}

- (Item*) getItemByIndexByCategory:(NSInteger)aIndex
{
    if (INVALID_NUMBER == self.mItemCount)
    {
        [self initIndexOfTheFirstItemForEachCategory];
    }
    
    if (aIndex < 0
        || aIndex >= self.mItemCount)
    {
        return nil;
    }
    
    NSInteger i = 0;
    for ( i=0; i<self.mIndexOfTheFirstItemForEachCategory.count; i++)
    {
        NSInteger sFirstIndexForCat = [self getIndexOfTheFirstItemInCategory:i];
        if (aIndex < sFirstIndexForCat)
        {
            break;
        }
    }
    
    Category* sCat = (Category*)[self.mCategories objectAtIndex:i-1];
    NSInteger sIndexForResultItemInLastCat = aIndex - [self getIndexOfTheFirstItemInCategory:i-1];
    Item* sItem = (Item*)[sCat.mItems objectAtIndex:sIndexForResultItemInLastCat];
    return sItem; 
    
}

- (Item*) getItemByIndexLikeZebraStripes:(NSInteger)aIndex
{
    if (INVALID_NUMBER == self.mItemCount)
    {
        [self initIndexOfTheFirstItemForEachCategory];
    }

    if (aIndex < 0
        || aIndex >= self.mItemCount)
    {
        return nil;
    }

    NSInteger sCatIndex;
    NSInteger sItemIndexInCat;
    
    sCatIndex = aIndex%(self.mCategories.count);
    sItemIndexInCat = aIndex/(self.mCategories.count);
    
    return [self getItemByIndex:sItemIndexInCat InCategory:sCatIndex];
}

- (Item*) getItemByIndex: (NSInteger)aIndex InCategory: (NSInteger) aCategoryIndex
{
    if (INVALID_NUMBER == self.mItemCount)
    {
        [self initIndexOfTheFirstItemForEachCategory];
    }

    if (aCategoryIndex < 0 
        || aCategoryIndex >= self.mCategories.count)
    {
        return nil;
    }
    Category* sCategory = (Category*)[self.mCategories objectAtIndex:aCategoryIndex];
    
    if (aIndex < 0 
        || aIndex >= sCategory.mItems.count)
    {
        return nil;
    }
    return (Item*)[sCategory.mItems objectAtIndex:aIndex];
}

- (NSInteger) getIndexOfTheFirstItemInCategory: (NSInteger) aCategoryIndex
{
    if (INVALID_NUMBER == self.mItemCount)
    {
        [self initIndexOfTheFirstItemForEachCategory];
    }

    if (aCategoryIndex>=0
        && aCategoryIndex < self.mIndexOfTheFirstItemForEachCategory.count)
    {
        return ((NSNumber*)[self.mIndexOfTheFirstItemForEachCategory objectAtIndex:aCategoryIndex]).integerValue;
    }
    return -1;
}

@end
