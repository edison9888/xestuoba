//
//  NSString+MyString.m
//  AboutSex
//
//  Created by Shane Wen on 12-9-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSString+MyString.h"

@implementation NSString (MyString)


- (unsigned int) indexOfChar: (char) aChar options:(NSStringCompareOptions)mask
{
    // you could experiment with this, I suspect linear searching each 
    // character would be about as fast as it can get.
    NSString *substring = [NSString stringWithFormat: @"%c", aChar];
    NSRange range = [self rangeOfString: substring options:mask];
    return range.location;
}

@end
