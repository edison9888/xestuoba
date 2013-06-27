//
//  TopStreamController.m
//  AboutSex
//
//  Created by Wen Shane on 13-2-2.
//
//

#import "HotStreamController.h"
#import "StreamItem.h"
#import "ContentViewController2.h"
#import "HotItemCell.h"
#import "SharedVariables.h"
#import "UserConfiger.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"
#import "MobClick.h"
#import "MLNavigationController.h"
#import "StoreManagerEx.h"

@interface HotStreamController ()
{
    NSMutableArray* mImageItems;
    NSMutableArray* mTextItems;
    NSMutableDictionary* mImages;
}
@property (nonatomic, retain) NSMutableArray* mImageItems;
@property (nonatomic, retain) NSMutableArray* mTextItems;
@property (nonatomic, retain) NSMutableDictionary* mImages;

@end

@implementation HotStreamController
@synthesize mImageItems;
@synthesize mTextItems;
@synthesize mDelegate;
@synthesize mImages;


+ (HotStreamController*) shared
{
    static HotStreamController* S_HotStreamController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        S_HotStreamController = [[HotStreamController alloc] init];
    });
    
    return S_HotStreamController;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.mImageItems = [NSMutableArray array];
        self.mTextItems = [NSMutableArray array];
        self.mImages = [NSMutableDictionary dictionary];
        self.title = NSLocalizedString(@"Top Articles", nil);
    }
    return self;
}

- (void) dealloc
{
    self.mImageItems = nil;
    self.mTextItems = nil;
    self.mImages = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void) viewDidUnload
{
    [super viewDidUnload];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    for (StreamItem* sItem in self.mTextItems)
    {
        [sItem bindUserInfo];
    }
    for (StreamItem* sItem in self.mImageItems)
    {
        [sItem bindUserInfo];
    }
    [self.tableView reloadData];
    
    [MobClick beginLogPageView:@"HotStream"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"HotStream"];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setAutoScrollImages
{
    if (self.mImageItems.count > 0)
    {
        self.tableView.tableHeaderView = [self setupTableHeaderView];       
    }
}

- (UIView*) setupTableHeaderView
{
    CGFloat sX = 0;
    CGFloat sY = 0;
    CGFloat sWidth = self.view.bounds.size.width;
    CGFloat sHeight = 1;
    
    
    UIView* sSeperatorLineView = [[UIView alloc] initWithFrame:CGRectMake(sX, sY, sWidth, sHeight)];
    sSeperatorLineView.backgroundColor = RGBA_COLOR(222, 222, 222, 1);
    sSeperatorLineView.layer.shadowColor = [RGBA_COLOR(224, 224, 224, 1) CGColor];
    sSeperatorLineView.layer.shadowOffset = CGSizeMake(0, -10);
    sSeperatorLineView.layer.shadowOpacity = .5f;
    sSeperatorLineView.layer.shadowRadius = 2.0f;
    sSeperatorLineView.clipsToBounds = NO;
    sSeperatorLineView.layer.cornerRadius = 5;

    
    sX = 0;
    sY += sHeight;
    sWidth = self.view.bounds.size.width-2*sX;
    sHeight = 150;

    NSMutableArray* sFocusImageItems = [NSMutableArray array];
    int i=0;
    for (StreamItem* sItem in self.mImageItems)
    {
        SGFocusImageItem* sSGFocusImageItem = [[[SGFocusImageItem alloc] initWithTitle:sItem.mName urlStr:sItem.mIconURL tag:i] autorelease];
        [sFocusImageItems addObject:sSGFocusImageItem];
        i++;
    }
        

    SGFocusImageFrame *imageFrame = [[SGFocusImageFrame alloc] initWithFrame:CGRectMake(sX, sY, sWidth, sHeight) delegate:self focusImageArr:sFocusImageItems];
    
    UIView* sView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, imageFrame.bounds.size.width, imageFrame.bounds.size.height+1)] autorelease];
    [sView addSubview:sSeperatorLineView];
    [sView addSubview:imageFrame];
    [sSeperatorLineView release];
    [imageFrame release];
    
    return sView;
}

#pragma mark - overide methods from SimplepageViewController

//you can overide it to do what you want to, and, mind you, invoke the super method later.
- (void) configTableView
{
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    self.tableView.rowHeight = 80;
//    self.tableView.tableHeaderView = [self setupTableHeaderView];
    
    [super configTableView];

}

//overide 4 methods below.
- (NSString*) getCacheFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* sCacheFilePath = [documentsDirectory stringByAppendingPathComponent:CACHE_FILE_HOT_STREAMS];
    return sCacheFilePath;
}

- (NSString*) getURLStr
{
    return URL_GET_HOT_STREAM;
}

- (void) parseData:(id)aJSONObj
{
    [self.mTextItems removeAllObjects];
    [self.mImageItems removeAllObjects];
    
    
    if ([aJSONObj isKindOfClass:[NSDictionary class]])
    {
        NSArray* sTextItems = [((NSDictionary*)aJSONObj) objectForKey:@"textItems"];
        for (NSDictionary* sItemDict in sTextItems)
        {
            StreamItem* sItem = [[StreamItem alloc] init];
            [sItem readJSONDict:sItemDict];
            [sItem bindUserInfo];
            
            
            [self.mTextItems addObject:sItem];
            [sItem release];
        }
        
        NSArray* sImageItems = [((NSDictionary*)aJSONObj) objectForKey:@"imageItems"];
        for (NSDictionary* sItemDict in sImageItems)
        {
            StreamItem* sItem = [[StreamItem alloc] init];
            [sItem readJSONDict:sItemDict];
            [sItem bindUserInfo];
            [self.mImageItems addObject:sItem];
            [sItem release];
        }
        
        //invoke image dowloading
        [self setAutoScrollImages];
        
        [self.mData addObjectsFromArray:self.mTextItems];
        [self.mData addObjectsFromArray:self.mImageItems];
        
        //
        [[StoreManagerEx shared] addOrUpdateStreamItems:self.mData];
    }
    
    return;
}

- (void) beforeDisplayTable
{
    //

}


#pragma mark - tableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mTextItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* sCellIdentifier = @"hot_item_cell";
    
    HotItemCell* sCell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    if (!sCell)
    {
        sCell = [[[HotItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sCellIdentifier withFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.rowHeight)] autorelease];
        UIView* sBGView = [[UIView alloc] initWithFrame:sCell.frame];
        sBGView.backgroundColor = SELECTED_CELL_COLOR;
        sCell.selectedBackgroundView = sBGView;
        [sBGView release];
    }
    
    NSInteger sRow = indexPath.row;
    StreamItem* sItem = [self.mTextItems objectAtIndex:sRow];
    
    [sCell fillValueByItem:sItem withRank:sRow+1];
    
    return sCell;
}

#pragma mark - tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger sRow = [indexPath row];
    if (sRow >=0
        && sRow < self.mTextItems.count)
    {
        StreamItem* sItem = [self.mTextItems objectAtIndex:sRow];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];

        [self pushViewControllerForStreamItem:sItem];
        
        
        if (!sItem.mIsRead)
        {
            [sItem updateReadStatus];
        }
        
        NSDictionary* sDict = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSString stringWithFormat:@"%d", sRow+1], @"index", nil];
        [MobClick event:@"UEID_HOT_VIEW_ITEM" attributes: sDict];
    }
    return;
}

- (void) pushViewControllerForStreamItem:(StreamItem*)aStreamItem
{
    ContentViewController2* sContentViewController;
    sContentViewController = [[ContentViewController2 alloc]init];
    sContentViewController.hidesBottomBarWhenPushed = YES;
//    sContentViewController.mItemListViewController = self;
    [sContentViewController setItem:aStreamItem AndWithCollectionSupport:YES];
    
    if ([self.mDelegate respondsToSelector:@selector(pushController:animated:)])
    {
        [self.mDelegate pushController:sContentViewController animated:YES];
    }

    [sContentViewController release];
}

#pragma mark -
- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame didSelectItem:(SGFocusImageItem *)item
{
    NSInteger sIndexOfImageItem = item.tag;
    if (sIndexOfImageItem>=0
        && sIndexOfImageItem < self.mImageItems.count)
    {
        StreamItem* sItem = [self.mImageItems objectAtIndex:sIndexOfImageItem];
        if (!sItem.mIsRead)
        {
            [sItem updateReadStatus];
        }
        NSRange textRange = [sItem.mLocation rangeOfString:@"adlink_tinyapps"];
        NSRange textRange2 = [sItem.mLocation rangeOfString:@"itunes.apple.com"];
        if(textRange.location != NSNotFound
           || textRange2.location != NSNotFound)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: sItem.mLocation]];
            [MobClick event:@"UEID_SELF_AD"];

        }else
        {
            [self pushViewControllerForStreamItem:sItem];
        }
        
        NSDictionary* sDict = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d", 0] forKey:@"index"];
        [MobClick event:@"UEID_HOT_VIEW_ITEM" attributes: sDict];
    }
    

    NSLog(@"%@ tapped", item.title);
}

@end
