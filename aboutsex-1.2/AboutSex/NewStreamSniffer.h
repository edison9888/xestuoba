//
//  NewStreamSniffer.h
//  AboutSex
//
//  Created by Shane Wen on 12-9-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "NewStreamSnifferDelegate.h"
#import "MyURLConnectionDelegate.h"


@protocol NewStreamSnifferDelegate <NSObject>

@required
- (void) newStreamFound:(NSInteger) aNumOfNewStream;
- (NSDate*) getStartingDate;

@end


@interface NewStreamSniffer : NSObject<MyURLConnectionDelegate, MyURLConnectionDelegate>
{
    id<NewStreamSnifferDelegate> mDelegate;
}

@property (nonatomic,assign)  id<NewStreamSnifferDelegate> mDelegate; //assign is proper here???

- (id) initWithDelegate: (id<NewStreamSnifferDelegate>) aDelegate;
- (void) start;
@end
