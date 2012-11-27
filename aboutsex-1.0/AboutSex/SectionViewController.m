//
//  MessageStreamViewCotroller.m
//  AboutSex
//
//  Created by Shane Wen on 12-6-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SectionViewController.h"
#import "SharedVariables.h"
#import "ContentViewController.h"

#import "StoreManager.h"
#import "Item.h"

#import "TaggedButton.h"

@interface SectionViewController ()


- (void) loadDataFromJsonFile;

- (BOOL) toggleCollectedStatusByButton:(id)aButton;
- (BOOL) reverseCollectedStatusOnData:(NSInteger) aIndex;



@end


@implementation SectionViewController


@synthesize mSection;
@synthesize mSectionName;
//@synthesize mTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) init
{
    return [self initWithTitle:nil AndSectionName:nil];
}

- (id) initWithTitle:(NSString*)aTitle AndSectionName: (NSString*) aSectionName
{
    self = [super initWithTitle:aTitle];
    if (self)
    {   
        self.mSectionName = aSectionName;
    }
    return self;
}

//when is dealloc invoked???
- (void) dealloc
{    
    self.mSection = nil;
    self.mSectionName = nil;
 
    [super dealloc];
    return;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void) loadData
{
    self.mSection = [StoreManager getSectionByName: self.mSectionName];
    
    return;
}

- (Item*) getItemByIndexPath:(NSIndexPath*)aIndexPath
{
    NSInteger sRow = [aIndexPath row];
    Item* sItem = [self.mSection getItemByIndex:sRow];
    return sItem;
}

- (BOOL) canCollectOnContentPage
{
    return YES;
}

- (void) loadDataFromJsonFile
{
//    NSString* sPath = [DATA_PATH stringByAppendingString:@"dict/outline.json"];
//    
//    NSData* sFileData = [NSData dataWithContentsOfFile:sPath];
//    NSError* sErr = nil;
//    self.mSection = [NSJSONSerialization JSONObjectWithData: sFileData 
//        options:NSJSONReadingMutableContainers
//        error:&sErr];
}

- (void) storeDataToJsonFile
{
//    NSError* sErr = nil;
//    NSString* sPath = [DATA_PATH stringByAppendingString:@"dict/outline.json"];
//    
//    NSData* sData = [NSJSONSerialization dataWithJSONObject:self.mSection options:NSJSONReadingMutableContainers error:&sErr];
//    
//    [sData writeToFile:sPath atomically:YES];
//    
//    return;  
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL) getCollectionStatuForSelectedRow
{
    NSIndexPath* sSelectedIndexPath = [self.tableView indexPathForSelectedRow];
    NSInteger sRow = [sSelectedIndexPath row];
    return [mSection getItemByIndex:sRow].mIsMarked;
}

- (BOOL) toggleCollectedStatusByButton:(id)aButton
{
#ifdef DEBUG
    NSLog(@"aButton: %@", [aButton class]);
#endif
    TaggedButton* sFavButton = (TaggedButton*)aButton;
    NSIndexPath* sIndexPath = sFavButton.mIndexPath;
    
    BOOL sRet = [self reverseColletedStatus:sIndexPath];
    
    if (sRet)
    {
        [sFavButton setImage: [UIImage imageNamed:@"favorite24.png"] forState:UIControlStateNormal];
    }
    else 
    {
        [sFavButton setImage: [UIImage imageNamed:@"favorite24_bw.png"] forState:UIControlStateNormal];
    }   

    
    return sRet;
}

- (BOOL) toggleColletedStatusOfSelectedRow
{
    NSIndexPath* sSelectedIndexPath =  [self.tableView indexPathForSelectedRow];

    BOOL sRet = [self reverseColletedStatus:sSelectedIndexPath];
    //the following line does not work, strangely, so use UITableView selectRowAtIndexPath:
//        [self.tableView cellForRowAtIndexPath:sSelectedIndexPath].selected = YES;
//    [self.tableView selectRowAtIndexPath:sSelectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    return sRet;
    
}

#pragma mark -
#pragma mark methods to chanage message's collection status.
- (BOOL) reverseColletedStatus:(NSIndexPath*)aIndexPath
{    
       
    NSInteger sRow = [aIndexPath row];

    //1. reverse collection status on the data
    BOOL sRet = [self reverseCollectedStatusOnData:sRow];
    
////    //2. refresh the collection status in the cell.
//    NSArray* sReloadedRows = [NSArray arrayWithObject:aIndexPath];
//    [self.tableView reloadRowsAtIndexPaths:sReloadedRows withRowAnimation:UITableViewRowAnimationFade];
    return sRet;
}


- (BOOL) reverseCollectedStatusOnData:(NSInteger) aIndex
{
    Item* sItem = [self.mSection getItemByIndex:aIndex];
    
    sItem.mIsMarked = !sItem.mIsMarked;
    [StoreManager updateItemMarkedStatus:sItem.mIsMarked ItemID:sItem.mItemID];
    
    return sItem.mIsMarked;
}

#pragma mark -
#pragma mark DataSource interface for UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section)
    {
        return self.mSection.mItemCount; 
    }
    else
    {
        return 0;
    }
} 
//

#pragma mark -
#pragma mark UITableViewDelegate interface for UITableView


@end
