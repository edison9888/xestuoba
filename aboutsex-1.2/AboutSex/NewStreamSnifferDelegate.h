//
//  NewStreamSnifferDelegate.h
//  AboutSex
//
//  Created by Shane Wen on 12-9-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NewStreamSnifferDelegate <NSObject>

@required
- (void) newStreamFound:(NSInteger) aNumOfNewStream;
- (NSDate*) getStartingDate;

@end
