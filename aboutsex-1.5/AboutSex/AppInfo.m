//
//  AppInfo.m
//  AboutSex
//
//  Created by Wen Shane on 13-1-12.
//
//

#import "AppInfo.h"

@implementation AppInfo
@synthesize mName;
@synthesize mURLStr;
@synthesize mDetail;
@synthesize mIconURL;
@synthesize mProvider;


- (void) dealloc
{
    self.mName = nil;
    self.mURLStr = nil;
    self.mDetail = nil;
    self.mIconURL = nil;
    self.mProvider = nil;
    
    [super dealloc];
}
@end
