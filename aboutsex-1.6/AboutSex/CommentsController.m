//
//  CommentsController.m
//  AboutSex
//
//  Created by Wen Shane on 13-2-6.
//
//

#import "CommentsController.h"
#import "CommentItem.h"
#import "AFNetworking.h"
#import "NSURL+WithChanelID.h"
#import "SharedVariables.h"
#import "UserConfiger.h"
#import "InteractivityCountManager.h"


#define PAGE_SIZE_COMMENTS  10

@interface CommentsController ()
{
    NSInteger mPageIndex;
    BOOL mHasMoreData;
    BOOL mIsLoading;
    UILabel* mAnimatedLabel;
}

@property (nonatomic, assign) NSInteger mPageIndex;
@property (nonatomic, assign) BOOL mHasMoreData;
@property (nonatomic, assign) BOOL mIsLoading;
@property (nonatomic, retain) UILabel* mAnimatedLabel;
@end

@implementation CommentsController
@synthesize mItem;
@synthesize mTableView;
@synthesize mPageLoadingIndicator;
@synthesize mComments;
@synthesize mPageIndex;
@synthesize mHasMoreData;
@synthesize mIsLoading;
@synthesize mAnimatedLabel;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (id) initWithItem:(Item*)aItem
{
    self = [super init];
    if (self)
    {
        self.mItem = aItem;
        self.mComments = [NSMutableArray array];
        
        //
        NSString* sTitle = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Comments", nil), self.mItem.mName];
        
        UIButton* sTitleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sTitleButton.userInteractionEnabled = NO;
        UIFont* sFont = [UIFont fontWithName:@"Arial" size:15];
        sTitleButton.titleLabel.font = sFont;
        sTitleButton.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
        [sTitleButton setFrame:CGRectMake(0, 0, 300, self.navigationController.navigationBar.frame.size.height)];
        [sTitleButton setTitle:sTitle forState:UIControlStateNormal];
        
        [self.navigationItem setTitleView:sTitleButton];

    }
    return self;
}

- (void) dealloc
{
    self.mItem = nil;
    self.mTableView = nil;
    self.mPageLoadingIndicator = nil;
    self.mComments = nil;
    self.mAnimatedLabel = nil;
    
    [super dealloc];
}

- (void) loadView
{
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    
    UIView* sView = [[UIView alloc] initWithFrame:applicationFrame];
    sView.backgroundColor = [UIColor whiteColor];
    self.view = sView;
    [sView release];
    
    UITableView* sTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 0, self.view.bounds.size.width-10, self.view.bounds.size.height)];
    sTableView.autoresizesSubviews = YES;
    sTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    sTableView.dataSource = self;
    sTableView.delegate = self;
    sTableView.backgroundColor = [UIColor clearColor];
    sTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:sTableView];
    
    self.mTableView = sTableView;
    [sTableView release];
    
    if (!self.mComments
        || self.mComments.count <= 0)
    {
        self.mTableView.hidden = YES;
        
        UIActivityIndicatorView* sPageLoadingIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
        [sPageLoadingIndicator setCenter:self.view.center];
        sPageLoadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        
        [self.view addSubview: sPageLoadingIndicator];
        
        self.mPageLoadingIndicator = sPageLoadingIndicator;
        [sPageLoadingIndicator release];
        
        [self.mPageLoadingIndicator startAnimating];
    }


}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self fetchComments];
}

- (void) viewDidUnload
{
    [super viewDidUnload];
    self.mTableView = nil;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];    
}

- (void) fetchComments
{
    self.mIsLoading = YES;
    NSString* sURLStr = URL_GET_COMMENTS(self.mItem.mItemID, self.mPageIndex++, PAGE_SIZE_COMMENTS);

    NSURL *url = [NSURL MyURLWithString: sURLStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:10];

    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [self loadSucessfully:JSON];
    } failure:^( NSURLRequest *request , NSHTTPURLResponse *response , NSError *error , id JSON ){
        [self loadFailed:error];
    }];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"text/html", nil]];
    [operation start];
}

- (void) loadSucessfully:(id)aJSONObj
{
    if (![aJSONObj isKindOfClass:[NSDictionary class]])
    {
        return;
    }

    self.mHasMoreData = ((NSNumber*)[aJSONObj objectForKey:@"hasMore"]).boolValue;
    for (NSDictionary* sItemDict in (NSArray*)[aJSONObj objectForKey:@"comments"])
    {
        CommentItem* sCommentItem = [[CommentItem alloc] init];
        
        sCommentItem.mItem = self.mItem;
        sCommentItem.mID = ((NSNumber*)[sItemDict objectForKey:@"commentID"]).integerValue;
        sCommentItem.mName = (NSString*) [sItemDict objectForKey:@"user"];
        sCommentItem.mContent = (NSString*) [sItemDict objectForKey:@"content"];
        sCommentItem.mDate = [NSDate dateWithTimeIntervalSince1970:[(NSString*) [sItemDict objectForKey:@"time"] integerValue]];
        sCommentItem.mDings = ((NSNumber*)[sItemDict objectForKey:@"numDings"]).integerValue;
        sCommentItem.mCais = ((NSNumber*)[sItemDict objectForKey:@"numCais"]).integerValue;
        
        [self.mComments addObject:sCommentItem];
        [sCommentItem release];
    }
    
    //
    if (self.mPageLoadingIndicator)
    {
        [self.mPageLoadingIndicator stopAnimating];       
    }
    
    if (self.mComments.count <= 0)
    {
        self.mTableView.tableHeaderView = [self headerViewWithNotice:NSLocalizedString(@"No comments yet", nil)];
    }
    
    if (self.mTableView)
    {
        self.mTableView.hidden = NO;
        [self.mTableView reloadData];
    }
    
    self.mIsLoading = NO;
}

- (void) loadFailed:(NSError*)aError
{
    NSLog(@"comments load failure.");
    if (self.mPageLoadingIndicator)
    {
        [self.mPageLoadingIndicator stopAnimating];
    }
    
    if (self.mComments.count <= 0)
    {
        self.mTableView.tableHeaderView = [self headerViewWithNotice:NSLocalizedString(@"Load failure, please try again later", nil)];
    }
    else
    {
        self.mTableView.tableHeaderView = nil;
    }

    self.mIsLoading = NO;

    return;//???show a notice page
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - taleview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.mHasMoreData
        && self.mComments.count > 0)
    {
        return self.mComments.count+1;
    }
    else
    {
        return self.mComments.count;      
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger sRow = [indexPath row];
    if (sRow < self.mComments.count)
    {
        CommentItem* sCommentItem = [self.mComments objectAtIndex:sRow];
        return [CommentItemCell getCellHeightByComment:sCommentItem];
    }
    else
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger sRow = [indexPath row];
    if (sRow >= self.mComments.count)
    {
        static NSString* sIdentifier = @"footer_cell";
        UITableViewCell* sCell = [tableView dequeueReusableCellWithIdentifier:sIdentifier];
        if (!sCell)
        {
            sCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sIdentifier] autorelease];
            
            UIActivityIndicatorView* sLoadingMoreIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            sLoadingMoreIndicator.frame = CGRectMake(100, 0, 40, 40);
            sLoadingMoreIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
            [sLoadingMoreIndicator startAnimating];
            [sCell.contentView addSubview: sLoadingMoreIndicator];
            [sLoadingMoreIndicator release];
            
            UILabel* sLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 0, 80, 40)];
            sLabel.text = NSLocalizedString(@"Loading...", nil);
            sLabel.textColor = [UIColor grayColor];
            [sCell.contentView addSubview:sLabel];
            [sLabel release];
        }
        return sCell;
    }
    else
    {
        static NSString* sIdentifier = @"cell";
        CommentItemCell* sCell = [tableView dequeueReusableCellWithIdentifier:sIdentifier];
        if (!sCell)
        {
            sCell =  [[[CommentItemCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:sIdentifier withFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.rowHeight)] autorelease];
            
            sCell.selectionStyle = UITableViewCellSelectionStyleNone;
            sCell.backgroundView = nil;
            sCell.mDelegate = self;
        }
        
        CommentItem* sCommentItem = [self.mComments objectAtIndex:sRow];
        [sCell fillValueByComment:sCommentItem];
        
        if (sRow%2 == 0)
        {
            sCell.backgroundColor = [UIColor lightGrayColor];
        }
        else
        {
            sCell.backgroundColor = [UIColor clearColor];
        }
        
        return sCell;
    }
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger sRow = indexPath.row;
    if (self.mHasMoreData
        && sRow == self.mComments.count
        && !self.mIsLoading)
    {
        [self fetchComments];
    }
}

- (UIView*) headerViewWithNotice:(NSString*)sNotice
{
    UILabel* sNoDataNoticeLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 50)] autorelease];
    sNoDataNoticeLabel.textAlignment = UITextAlignmentCenter;
    sNoDataNoticeLabel.textColor = [UIColor grayColor];
    sNoDataNoticeLabel.text = sNotice;
    sNoDataNoticeLabel.font = [UIFont systemFontOfSize:15];
    
    return sNoDataNoticeLabel;
}

#pragma mark - CommentItemViewDelegate
- (void) dingAt:(CommentItemCell*)aCommentItemView
{
    NSIndexPath* sClickedIndexPath = [self.mTableView indexPathForCell:aCommentItemView];
    if (sClickedIndexPath.row < self.mComments.count)
    {
        CommentItem* sCommentItem = [self.mComments objectAtIndex:sClickedIndexPath.row];
        if (!sCommentItem.mDidDing)
        {
            sCommentItem.mDings++;
            [[InteractivityCountManager shared] dingComment:sCommentItem];
            sCommentItem.mDidDing = YES;
            
            
            CGPoint sPosInTableView = [aCommentItemView convertPoint:CGPointMake(aCommentItemView.bounds.size.width/2, aCommentItemView.bounds.size.height/2) toView:self.view];
            
            [self doAnnimation:YES atPosInTableView:sPosInTableView];
            
            [self.mTableView reloadRowsAtIndexPaths:@[sClickedIndexPath] withRowAnimation:UITableViewRowAnimationNone];

        }
    }
}

- (void) caiAt:(CommentItemCell*)aCommentItemView
{
    NSIndexPath* sClickedIndexPath = [self.mTableView indexPathForCell:aCommentItemView];
    if (sClickedIndexPath.row < self.mComments.count)
    {
        CommentItem* sCommentItem = [self.mComments objectAtIndex:sClickedIndexPath.row];
        if (!sCommentItem.mDidCai)
        {
            sCommentItem.mCais++;
            [[InteractivityCountManager shared] caiComment:sCommentItem];
            sCommentItem.mDidCai = YES;
            
            
            CGPoint sPosInTableView = [aCommentItemView convertPoint:CGPointMake(aCommentItemView.bounds.size.width/2, aCommentItemView.bounds.size.height/2) toView:self.view];
            [self doAnnimation:NO atPosInTableView:sPosInTableView];
            
            [self.mTableView reloadRowsAtIndexPaths:@[sClickedIndexPath] withRowAnimation:UITableViewRowAnimationNone];

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

- (CommentItem*) getCommentItemByCell:(UITableViewCell*)aCommentItemView
{
    NSIndexPath* sClickedIndexPath = [self.mTableView indexPathForCell:aCommentItemView];
    if (sClickedIndexPath.row < self.mComments.count)
    {
        CommentItem* sCommentItem = [self.mComments objectAtIndex:sClickedIndexPath.row];
        return sCommentItem;
    }

    return nil;
}


@end
