//
//  SGFocusImageItem.m
//  SGFocusImageFrame
//
//  Created by Shane Gao on 17/6/12.
//  Copyright (c) 2012 Shane Gao. All rights reserved.
//

#import "SGFocusImageItem.h"

@implementation SGFocusImageItem
@synthesize title =  _title;
@synthesize image =  _image;
@synthesize tag =  _tag;
@synthesize mURLStr;

- (void)dealloc
{
    [_title release];
    [_image release];
    self.mURLStr = nil;
    [super dealloc];
}

- (id)initWithTitle:(NSString *)title image:(UIImage *)image tag:(NSInteger)tag
{
    self = [super init];
    if (self) {
        self.title = title;
        self.image = image;
        self.tag = tag;
    }
    
    return self;
}

- (id)initWithTitle:(NSString *)title urlStr:(NSString *)urlStr tag:(NSInteger)tag
{
    self = [super init];
    if (self)
    {
        self.title = title;
        self.mURLStr = urlStr;
        self.tag = tag;
    }
    
    return self;
}

@end
