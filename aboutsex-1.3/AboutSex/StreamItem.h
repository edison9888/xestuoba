//
//  StreamItem.h
//  AboutSex
//
//  Created by Shane Wen on 12-9-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Item.h"
#import "MyURLConnection.h"

@interface StreamItem : Item<MyURLConnectionDelegate>
{
    NSString* mIconURL;
    NSString* mSummary;
    NSInteger mNumVisits;
    NSInteger mTag;
    
    
    MyURLConnection* mURLConnection;
}

@property (nonatomic, copy) NSString* mIconURL;
@property (nonatomic, copy) NSString* mSummary;
@property (nonatomic, assign) NSInteger mNumVisits;
@property (nonatomic, assign) NSInteger mTag;

@property (nonatomic, retain) MyURLConnection* mURLConnection;

@end
