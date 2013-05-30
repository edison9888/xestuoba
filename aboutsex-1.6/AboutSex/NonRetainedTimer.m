//
//  NonRetainedTimer.m
//  AboutSex
//
//  Created by Wen Shane on 13-5-21.
//
//

#import "NonRetainedTimer.h"

@implementation NonRetainedTimer

+ (NonRetainedTimer*) shared
{
    static NonRetainedTimer* S_NonRetainedTimer = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        S_NonRetainedTimer = [[self alloc] init];
    });
    
    return S_NonRetainedTimer;
}

- (void) callInvocation:(id)sender
{
    NSInvocation* sInvocation = (NSInvocation*)[sender userInfo];
    if (sInvocation)
    {
        
        [sInvocation invoke];
    }
}

@end
