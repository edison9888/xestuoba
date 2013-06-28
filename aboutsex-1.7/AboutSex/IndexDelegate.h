//
//  IndexDelegate.h
//  AboutSex
//
//  Created by Shane Wen on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IndexInfo.h"

@protocol IndexDelegate <NSObject>

@optional
- (void) clickTheIndexInfo: (IndexInfo*) aClickedIndex;

@required
- (NSInteger) getTotalNumberOfIndexes;
- (IndexInfo*) getIndexInfo: (NSInteger)aSerialNumber;
- (void) clickTheIndex: (NSInteger) aSeriNumberOfTheClickedIndex;

@end
