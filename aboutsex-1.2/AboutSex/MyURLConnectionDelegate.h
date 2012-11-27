//
//  MyURLConnectionDelegate.h
//  AboutSex
//
//  Created by Shane Wen on 12-9-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MyURLConnectionDelegate <NSObject>
- (void) failWithConnectionError: (NSError*)aErr;
- (void) failWithServerError: (NSInteger)aStatusCode;
- (void) succeed: (NSMutableData*)aData;
@end
