//
//  CommonTableViewController.h
//  AboutSex
//
//  Created by Shane Wen on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "StreamItem.h"
#import "SharedVariables.h"
#import "StoreManager.h"
#import "StreamViewController.h"

@interface CommonTableViewController2 : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    BOOL mHasAppearedBefore;
    id<StreamViewControllerDelegate> mDelegate;

}

@property (nonatomic, retain) UITableView* mTableView;
@property (nonatomic, assign) BOOL mHasAppearedBefore;
@property (nonatomic, assign) id<StreamViewControllerDelegate> mDelegate;


- (id) initWithTitle:(NSString*)aTitle;
- (void) configTableView;
- (void) markItemOfSeletedRowAsReaded;


- (StreamItem*) getItemByIndexPath:(NSIndexPath*)aIndexPath;
- (BOOL) canCollectOnContentPage;
- (void) loadData;

- (void) refreshTableView;
- (BOOL) appearFirstTime;

//- (BOOL) toggleColletedStatusOfSelectedRow;
//- (BOOL) getCollectionStatuForSelectedRow;

@end
