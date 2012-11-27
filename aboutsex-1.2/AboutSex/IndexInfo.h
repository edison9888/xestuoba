//
//  IndexInfo.h
//  AboutSex
//
//  Created by Shane Wen on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IndexInfo : NSObject
{
    NSString* mName;
    NSInteger   mPos;
}

@property (nonatomic, retain) NSString* mName;
@property (nonatomic, assign) NSInteger mPos;

@end
