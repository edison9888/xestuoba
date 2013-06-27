//
//  SidebarViewController.m
//  AboutSex
//
//  Created by Wen Shane on 13-6-7.
//
//

#import "SidebarViewController.h"
#import "AffectionViewController.h"
#import "SharedVariables.h"
#import "CustomCellBackgroundView.h"


@interface SidebarViewController ()
{
    NSArray* mTitles;
}

@property (nonatomic, retain) NSArray* mTitles;
@end

@implementation SidebarViewController
@synthesize mTitles;

+ (SidebarViewController*) shared
{
    static SidebarViewController* S_SidebarViewController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        S_SidebarViewController = [[self alloc] initWithStyle:UITableViewStylePlain];
    });
    return S_SidebarViewController;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        UILabel* sTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        sTitleLabel.text = NSLocalizedString(@"All Categories", nil);
        sTitleLabel.backgroundColor = [UIColor clearColor];
        sTitleLabel.textColor = [UIColor whiteColor];
        sTitleLabel.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:sTitleLabel] autorelease];
        [sTitleLabel release];
        
        NSArray* sArray = @[NSLocalizedString(@"Latest Articles", nil), NSLocalizedString(@"Top Articles", nil), NSLocalizedString(@"Hot Comments", nil)];
        self.mTitles = [NSMutableArray arrayWithArray:sArray];
        
        //
        self.clearsSelectionOnViewWillAppear = NO;

    }
    return self;
}

- (void) dealloc
{
    self.mTitles = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = RGBA_COLOR(72, 38, 8, 1);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.bounces = NO;
    self.tableView.rowHeight = 60;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self selectRow];    
}

- (void) selectRow
{
    ENUM_AFFECTION_TYPE sCurType = [[AffectionViewController shared] getCurAffectionType];
    NSInteger sRow = 0;
    switch (sCurType) {
        case ENUM_AFFECTION_TYPE_LATEST_ARTICLES:
            sRow = 0;
            break;
        case ENUM_AFFECTION_TYPE_TOP_ARTICLES:
            sRow = 1;
            break;
        case ENUM_AFFECTION_TYPE_HOTCOMMENTS:
            sRow = 2;
            break;
        default:
            break;
    }
    
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:sRow inSection:0] animated:NO scrollPosition:UITableViewRowAnimationNone];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        
        CustomCellBackgroundView* sBGView = [CustomCellBackgroundView backgroundCellViewWithFrame:cell.frame Row:[indexPath row] totalRow:[tableView numberOfRowsInSection:[indexPath section]] borderColor:MAIN_BGCOLOR fillColor:MAIN_BGCOLOR tableViewStyle:tableView.style];
        cell.selectedBackgroundView = sBGView;
    }
    
    NSInteger sRow = indexPath.row;
    
    NSString* sTitle = [self.mTitles objectAtIndex:indexPath.row];
    cell.textLabel.text = sTitle;
    
    if (sRow == 0)
    {
        cell.imageView.image = [UIImage imageNamed:@"time24"];
    }
    else if (sRow == 1)
    {
        cell.imageView.image = [UIImage imageNamed:@"rank24"];        
    }
    else if (sRow == 2)
    {
        cell.imageView.image = [UIImage imageNamed:@"talk24"];
    }
    else
    {
        //
    }
    
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger sRow = indexPath.row;
    
    switch (sRow) {
        case 0:
        {
            [[AffectionViewController shared] switchToItem:ENUM_AFFECTION_TYPE_LATEST_ARTICLES];
            [self.revealSideViewController popViewControllerAnimated:YES];
        }
            break;
        case 1:
        {
            [[AffectionViewController shared] switchToItem:ENUM_AFFECTION_TYPE_TOP_ARTICLES];
            [self.revealSideViewController popViewControllerAnimated:YES];
        }
            break;
        case 2:
        {
            [[AffectionViewController shared] switchToItem:ENUM_AFFECTION_TYPE_HOTCOMMENTS];
            [self.revealSideViewController popViewControllerAnimated:YES];
        }
            break;
            
        default:
            break;
    }
}

@end
