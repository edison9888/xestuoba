//
//  Category.m
//  AboutSex
//
//  Created by Shane Wen on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Category.h"

@implementation Category


@synthesize mCategoryID;
@synthesize mName;
@synthesize mItems;


- (void) dealloc
{
    self.mName = nil;
    self.mItems = nil;
    [super dealloc];

}

@end
