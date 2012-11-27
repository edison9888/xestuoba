//
//  CommonTableViewController.h
//  AboutSex
//
//  Created by Shane Wen on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Item.h"
#import "SharedVariables.h"
#import "StoreManager.h"

@interface CommonTableViewController : UITableViewController


- (id) initWithTitle:(NSString*)aTitle;
- (void) configTableView;
- (void) markItemOfSeletedRowAsReaded;


- (Item*) getItemByIndexPath:(NSIndexPath*)aIndexPath;
- (BOOL) canCollectOnContentPage;
- (void) loadData;

//methods below should be deleted
- (BOOL) toggleColletedStatusOfSelectedRow;
- (BOOL) getCollectionStatuForSelectedRow;


@end
