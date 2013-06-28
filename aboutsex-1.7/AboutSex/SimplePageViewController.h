//
//  SimplePageViewController.h
//  BTT
//
//  Created by Wen Shane on 13-1-7.
//  Copyright (c) 2013年 Wen Shane. All rights reserved.
//

#import "PullToRefreshController.h"
#import "JSONObjProvider.h"

//do not use this class directly; typically you create a class derived from it for page who needs capablities such as, pull-to-refresh, json-data fetching, data cache, and tableview style display. 
@interface SimplePageViewController : PullToRefreshController<JSONObjProviderDelegate>

//store an array of data for displaying in a table view. make it atomic(default value) to ensure safe setter-getter.
@property (retain) NSMutableArray* mData;
@property (retain) NSLock* mDataLock;


//you can overide it to do what you want to, and, mind you, invoke the super method later.
- (void) configTableView;

//overide 4 methods below.
- (NSString*) getCacheFilePath;
- (NSString*) getURLStr;
- (void) parseData:(id)aJSONObj;
- (void) beforeDisplayTable;//you can config the table before it shows

@end


@interface SimplePageViewControllerMore : SimplePageViewController

//CALLING: set mIsDataComplete to a proper value after parsing a series of json data.
@property (nonatomic, assign) BOOL mIsDataComplete;

//OVERIDING: 2 methods below.
- (NSInteger) getStartingPageIndex;
- (NSString*) getURLStrByPageIndex:(NSInteger)aPageIndex;

//NO OVERIDING: do not overide this method
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

//CALLING: in the corresponding derived methods, call them instead if [indexPath row] is the last row.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end

