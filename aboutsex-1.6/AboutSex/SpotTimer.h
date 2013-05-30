//
//  SpotTimer.h
//  AboutSex
//
//  Created by Wen Shane on 13-5-14.
//
//

#import <Foundation/Foundation.h>

@interface SpotTimer : NSObject

+ (SpotTimer*) shared;

- (BOOL) startWithDelay:(NSTimeInterval)aDelay;
- (void) cancel;


@end
