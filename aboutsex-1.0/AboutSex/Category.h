//
//  Category.h
//  AboutSex
//
//  Created by Shane Wen on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Category : NSObject
{
    NSInteger mCategoryID;
    NSString* mName;
    NSMutableArray* mItems;
    
}

@property (nonatomic, assign) NSInteger mCategoryID;
@property (nonatomic, copy) NSString* mName;
@property (nonatomic, retain) NSMutableArray* mItems;

@end
