//
//  MessageStreamViewControllerIndexed.h
//  AboutSex
//
//  Created by Shane Wen on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CommonTableViewController.h"
#import "IndexDelegate.h"

@interface SectionViewController : CommonTableViewController<IndexDelegate>
{
    Section* mSection;
    NSString* mSectionName;
}

@property (nonatomic, retain) NSString* mSectionName;
@property (nonatomic, retain) Section* mSection;

- (id) initWithTitle:(NSString*)aTitle AndSectionName: (NSString*) aSectionName;
@end
