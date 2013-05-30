//
//  CommentItem.m
//  AboutSex
//
//  Created by Wen Shane on 13-2-6.
//
//

#import "CommentItem.h"

@implementation CommentItem
@synthesize mItem;
@synthesize mName;
@synthesize mContent;
@synthesize mDate;

- (void) dealloc
{
    self.mItem = nil;
    self.mName = nil;
    self.mContent = nil;
    self.mDate = nil;

    [super dealloc];
}

@end
