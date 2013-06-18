//
//  CommentItem.m
//  AboutSex
//
//  Created by Wen Shane on 13-2-6.
//
//

#import "CommentItem.h"

@implementation CommentItem
@synthesize mID;
@synthesize mItem;
@synthesize mName;
@synthesize mContent;
@synthesize mDate;
@synthesize mDings;
@synthesize mCais;
@synthesize mDidDing;
@synthesize mDidCai;

- (id) init
{
    self = [super init];
    if (self)
    {
        self.mDidDing = NO;
        self.mDidCai = NO;
    }
    
    return self;
}

- (void) dealloc
{
    self.mItem = nil;
    self.mName = nil;
    self.mContent = nil;
    self.mDate = nil;

    [super dealloc];
}

@end
