//
//  MessageStreamViewCotroller.h
//  AboutSex
//
//  Created by Shane Wen on 12-6-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FPPopover/FPPopoverView.h"
#import "Section.h"

#import "SharedVariables.h"
#import "CommonTableViewController.h"

#import "StoreManager.h"

#define INVALID_INDEX -1
//#define TAG_FOR_TABLE_VIEW 10


@interface SectionViewController : CommonTableViewController
{
    Section* mSection;
    NSString* mSectionName;
}

@property (nonatomic, retain) NSString* mSectionName;
@property (nonatomic, retain) Section* mSection;

- (BOOL) toggleColletedStatusOfSelectedRow;
- (BOOL) getCollectionStatuForSelectedRow;
- (id) initWithTitle:(NSString*)aTitle AndSectionName: (NSString*) aSectionName;


@end
