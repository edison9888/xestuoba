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
    BOOL mNeedShowCategoriesView;
}

@property (nonatomic, retain) NSString* mSectionName;
@property (nonatomic, retain) Section* mSection;
@property (nonatomic, assign) BOOL mNeedShowCategoriesView;

- (id) initWithTitle:(NSString*)aTitle AndSectionName: (NSString*) aSectionName AndShowCategories:(BOOL)aShowCategories;

@end
