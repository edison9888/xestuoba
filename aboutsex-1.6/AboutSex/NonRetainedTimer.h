//
//  NonRetainedTimer.h
//  AboutSex
//
//  Created by Wen Shane on 13-5-21.
//
//

#import <Foundation/Foundation.h>

@interface NonRetainedTimer : NSObject

+ (NonRetainedTimer*) shared;

- (void) callInvocation:(id)sender;


@end
