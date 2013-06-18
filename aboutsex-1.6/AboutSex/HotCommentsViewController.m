//
//  HotCommentsViewController.m
//  AboutSex
//
//  Created by Wen Shane on 13-6-7.
//
//

#import "HotCommentsViewController.h"
#import "SharedVariables.h"
#import "StreamItem.h"
#import "CommentItem.h"
#import "MobClick.h"
#import "ContentViewController2.h"
#import "HotCommentItemCell.h"
#import "QBPopupMenu.h"
#import "InteractivityCountManager.h"

@interface HotCommentsViewController ()
{
    QBPopupMenu* mPopupMenu;
    UILabel* mAnimatedLabel;

}

@property (nonatomic, retain)   QBPopupMenu* mPopupMenu;
@property (nonatomic, retain) UILabel* mAnimatedLabel;

@end

@implementation HotCommentsViewController
@synthesize mDelegate;
@synthesize mPopupMenu;
@synthesize mAnimatedLabel;

+ (HotCommentsViewController*) shared
{
    static HotCommentsViewController* S_HotCommentsViewController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        S_HotCommentsViewController = [[self alloc] init];
    });
    return S_HotCommentsViewController;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.title = NSLocalizedString(@"Hot Comments", nil);
    }
    return self;
}

- (void) dealloc
{
    self.mPopupMenu = nil;
    self.mAnimatedLabel = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     self.clearsSelectionOnViewWillAppear = YES;
    
    QBPopupMenu* popupMenu = [[QBPopupMenu alloc] init];

    QBPopupMenuItem *item1 = [QBPopupMenuItem itemWithTitle:NSLocalizedString(@"Ding", nil) target:nil action:NULL];
    item1.width = 64;
    QBPopupMenuItem *item2 = [QBPopupMenuItem itemWithTitle:NSLocalizedString(@"Cai", nil) image:[UIImage imageNamed:@"icon_favorite.png"] target:nil action:NULL];
    item2.width = 64;
    QBPopupMenuItem *item3 = [QBPopupMenuItem itemWithTitle:NSLocalizedString(@"Read", nil) image:[UIImage imageNamed:@"icon_retweet.png"] target:nil action:NULL];
    item3.width = 80;
    popupMenu.items = [NSArray arrayWithObjects:item1, item2, item3, nil];
    
    self.mPopupMenu = popupMenu;
    [popupMenu release];

}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - overide methods from SimplepageViewController
//you can overide it to do what you want to, and, mind you, invoke the super method later.
- (void) configTableView
{
    [super configTableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}


//overide 4 methods below.
- (NSString*) getCacheFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* sCacheFilePath = [documentsDirectory stringByAppendingPathComponent:CACHE_FILE_HOT_COMMENTS];
    return sCacheFilePath;
}

- (NSString*) getURLStr
{
    return URL_GET_HOT_COMMENTS;
}

- (void) parseData:(id)aJSONObj
{    
    for (NSDictionary* sItemDict in (NSArray*)[aJSONObj objectForKey:@"comments"])
    {
        CommentItem* sCommentItem = [[CommentItem alloc] init];
        
        sCommentItem.mItem = nil;
        sCommentItem.mID = ((NSNumber*)[sItemDict objectForKey:@"commentID"]).integerValue;
        sCommentItem.mName = (NSString*) [sItemDict objectForKey:@"user"];
        sCommentItem.mContent = (NSString*) [sItemDict objectForKey:@"content"];
        sCommentItem.mDate = [NSDate dateWithTimeIntervalSince1970:[(NSString*) [sItemDict objectForKey:@"time"] integerValue]];
        sCommentItem.mDings = ((NSNumber*)[sItemDict objectForKey:@"numDings"]).integerValue;
        sCommentItem.mCais = ((NSNumber*)[sItemDict objectForKey:@"numCais"]).integerValue;
        
        StreamItem* sItem = [[StreamItem alloc] init];
        [sItem readJSONDict: [sItemDict objectForKey:@"refItem"]];
        sCommentItem.mItem = sItem;
        [sItem release];
        
        [self.mData addObject:sCommentItem];
        [sCommentItem release];

    }
}
- (void) beforeDisplayTable
{
    //
}



#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";    
    HotCommentItemCell* sCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!sCell)
    {
        sCell =  [[[HotCommentItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        sCell.selectionStyle =  UITableViewCellSelectionStyleNone;
        sCell.mDelegate = self;
//        UIView* sBGView = [[UIView alloc] initWithFrame:sCell.frame];
//        sBGView.backgroundColor = SELECTED_CELL_COLOR;
//        sCell.selectedBackgroundView = sBGView;
//        [sBGView release];
    }
    
    NSInteger sRow = [indexPath row];
    CommentItem* sCommentItem = [self.mData objectAtIndex:sRow];
    [sCell fillValueByComment:sCommentItem];
    
    return sCell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger sRow = [indexPath row];
    if (sRow < self.mData.count)
    {
        CommentItem* sCommentItem = [self.mData objectAtIndex:sRow];
        return [HotCommentItemCell getCellHeightByComment:sCommentItem];
    }
    else
    {
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger sRow = [indexPath row];
    if (sRow >=0
        && sRow < self.mData.count)
    {
        
//        [self showPopMenu];
        CommentItem* sCommentItem = [self.mData objectAtIndex:sRow];
        [self pushViewControllerForStreamItem:(StreamItem*)sCommentItem.mItem];
        
        [MobClick event:@"UEID_HOT_COMMENT_ITEM"];
    }
    return;
}

- (void) showPopMenu
{
//    CGPoint sPoint = CGPointMake(100, 100);
    CGRect sSelectedRect = [self.tableView rectForRowAtIndexPath:self.tableView.indexPathForSelectedRow];
    CGPoint sCenterPoint = CGPointMake(sSelectedRect.origin.x+sSelectedRect.size.width/2, sSelectedRect.origin.y+sSelectedRect.size.height/2);
    //    CGPoint sPosInTableView = [aCommentItemView convertPoint:CGPointMake(aCommentItemView.bounds.size.width/2, aCommentItemView.bounds.size.height/2) toView:self.view];

    [self.mPopupMenu showInView:self.tableView atPoint:sCenterPoint];
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
- (void) dingAt:(UITableViewCell*)aCommentItemView
{
    NSIndexPath* sClickedIndexPath = [self.tableView indexPathForCell:aCommentItemView];
    if (sClickedIndexPath.row < self.mData.count)
    {
        CommentItem* sCommentItem = [self.mData objectAtIndex:sClickedIndexPath.row];
        if (!sCommentItem.mDidDing)
        {
            sCommentItem.mDings++;
            [[InteractivityCountManager shared] dingComment:sCommentItem];
            sCommentItem.mDidDing = YES;
            
            
            CGPoint sPosInTableView = [aCommentItemView convertPoint:CGPointMake(aCommentItemView.bounds.size.width/2, aCommentItemView.bounds.size.height/2) toView:self.view];
            
            [self doAnnimation:YES atPosInTableView:sPosInTableView];
            
            [self.tableView reloadRowsAtIndexPaths:@[sClickedIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            
        }
    }
}

- (void) doAnnimation:(BOOL)aDing atPosInTableView:(CGPoint)aPoint
{
    if (!self.mAnimatedLabel)
    {
        UILabel* sLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
        sLabel.text = @"+1";
        sLabel.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
        sLabel.backgroundColor = [UIColor clearColor];
        sLabel.textAlignment = UITextAlignmentCenter;
        sLabel.alpha = 0;
        [self.view addSubview:sLabel];
        self.mAnimatedLabel = sLabel;
        [sLabel release];
    }
    
    if (aDing)
    {
        self.mAnimatedLabel.textColor = [UIColor redColor];
    }
    else
    {
        self.mAnimatedLabel.textColor = [UIColor greenColor];
    }
    
    self.mAnimatedLabel.center = aPoint;
    [self.view bringSubviewToFront:self.mAnimatedLabel];
    
    [UIView animateWithDuration:1.0 animations:^{
        self.mAnimatedLabel.alpha = 1;
        self.mAnimatedLabel.transform = CGAffineTransformMakeScale(1.5,1.5);
        
    }completion:^(BOOL finished) {
        self.mAnimatedLabel.alpha = 0;
    }];
    
}


@end
