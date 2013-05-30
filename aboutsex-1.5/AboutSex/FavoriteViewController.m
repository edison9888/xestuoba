//
//  FavoriteViewController.m
//  AboutSex
//
//  Created by Shane Wen on 12-6-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FavoriteViewController.h"
#import "AboutViewController.h"

#import "StoreManager.h"

#import "SharedVariables.h"

#import "NSDate+MyDate.h"

#import "ContentViewController.h"


@interface FavoriteViewController ()


//- (void) presentAbout;
//- (void) returnToFavorite;
- (void) toggleMainView;
- (UIView*) constructEmptyView;
- (void) toggleEditButton;
- (void) toggleEdittingMode:(id)aBarButtonItem;
@end

@implementation FavoriteViewController

@synthesize mFavorites;
@synthesize mEmptyView;
@synthesize mEditBarButtonItem;


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
    return [self initWithTitle:nil];
}

- (id) initWithTitle:(NSString*)aTitle
{
    self = [super initWithTitle:aTitle];
    if (self)
    {   
        self.mEmptyView = nil;
        
//        //about
//        UIButton* sButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
//        [sButton setFrame:CGRectMake(0, 0, 40, 22)];
//        [sButton addTarget:self action:@selector(presentAbout) forControlEvents:UIControlEventTouchDown];
//        UIBarButtonItem* sAboutBarButton = [[UIBarButtonItem alloc]initWithCustomView:sButton];
//        self.navigationItem.rightBarButtonItem = sAboutBarButton;
//        [sAboutBarButton release];
        
        //edit
        [self toggleEditButton];
        
    }
    return self;
}

- (void) dealloc
{
    self.mFavorites = nil;
    self.mEditBarButtonItem = nil;
    self.mEmptyView = nil;
    [super dealloc];
}

- (void) loadData
{
    self.mFavorites = [[[NSMutableArray alloc]init] autorelease];
    
    NSMutableArray* sArray = [StoreManager getAllFavoriteItems];
    
    NSDate* sDate = nil;
    NSMutableArray* sItemsForMonth = nil;
    for (Item* sItem in sArray)
    {
        if (!sDate
            || ![sItem.mMarkedTime isSameMonth:sDate])
        {
            if (sDate
                && sItemsForMonth
                && sItemsForMonth.count >0)
            {
                [self.mFavorites addObject:sItemsForMonth];
                sItemsForMonth = nil;
            }
            sDate = sItem.mMarkedTime;
            sItemsForMonth = [[[NSMutableArray alloc]init]autorelease];
            
        }
        [sItemsForMonth addObject:sItem];
    }
    if (sItemsForMonth)
    {
        [self.mFavorites addObject:sItemsForMonth];
    }
}

#pragma mark -
#pragma mark ListViewController's methods; overide them to configure FavoriteViewController.
- (Item*) getItemByIndexPath:(NSIndexPath*)aIndexPath
{
    NSMutableArray* sItemsOfGroup = (NSMutableArray*)[self.mFavorites objectAtIndex:[aIndexPath section]];
    Item* sItem = (Item*)[sItemsOfGroup objectAtIndex:[aIndexPath row]];
    return sItem;
}

- (BOOL) canCollectOnContentPage
{
    return NO;
}


- (UIView*) constructEmptyView
{
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    UILabel* sLabel = [[[UILabel alloc]initWithFrame:applicationFrame] autorelease];
    sLabel.text = @"噢，你还没有收藏过哦！";
    sLabel.backgroundColor = [UIColor clearColor];
//    [sLabel sizeToFit];
    sLabel.textAlignment = UITextAlignmentCenter;
    sLabel.center = CGPointMake(self.view.center.x, 50);
    
    return sLabel;
}

//just make the proper view appear, tableview's date reloading not included here.
- (void) toggleMainView
{
    if (self.mFavorites
        && [self.mFavorites count]>0)
    {
        if (self.mEmptyView)
        {
            [self.mEmptyView removeFromSuperview];
            self.mEmptyView = nil;
        }
        self.mTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//        [self.tableView reloadData];
    }
    else 
    {
        if(!self.mEmptyView)
        {
            self.mEmptyView = [self constructEmptyView];
        }
        self.mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view insertSubview:self.mEmptyView atIndex:0];
    }
    [self toggleEditButton];
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
    // Release any retained subviews of the main view.
    self.mEmptyView = nil;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self toggleMainView];
    return;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (self.mTableView.editing)
    {
        [self.mTableView setEditing:NO];
        mEditBarButtonItem.title = NSLocalizedString(@"Edit", nil);

    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) toggleEditButton
{
    if (self.mFavorites
        && self.mFavorites.count > 0)
    {
        if (!self.mEditBarButtonItem)
        {
            mEditBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Edit", nil) style:UIBarButtonItemStylePlain target:self action:@selector(toggleEdittingMode:)];
        }
        if (self.mTableView.editing)
        {
            mEditBarButtonItem.title = NSLocalizedString(@"Done", nil);
        }
        else 
        {
            mEditBarButtonItem.title = NSLocalizedString(@"Edit", nil);
        }
        self.navigationItem.rightBarButtonItem = mEditBarButtonItem;
    }
    else 
    {
        if (self.mTableView.editing)
        {
            [self.mTableView setEditing:NO];
        }
        self.navigationItem.rightBarButtonItem = nil;
    }

}

- (void) toggleEdittingMode:(id)aBarButtonItem
{
    UIBarButtonItem* sBarButtonItem = (UIBarButtonItem*)aBarButtonItem;
    NSString* sCurTitle =  sBarButtonItem.title;
    if ([sCurTitle compare:NSLocalizedString(@"Edit", nil)] == 0)
    {
        [self.mTableView setEditing:YES animated:YES];
        sBarButtonItem.title = NSLocalizedString(@"Done", nil);
//        sBarButtonItem.tintColor = [UIColor whiteColor];
    }
    else {
        [self.mTableView setEditing:NO animated:YES];
        sBarButtonItem.title = NSLocalizedString(@"Edit", nil);
    }
    return;
}

//- (void) presentAbout
//{
//    AboutViewController* sAboutViewController = [[AboutViewController alloc] init];
//
//    sAboutViewController.navigationItem.title = NSLocalizedString(@"About", nil);
//    UIBarButtonItem *sReturnButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil) style:UIBarButtonItemStylePlain target:self action:@selector(returnToFavorite)];
//    sAboutViewController.navigationItem.rightBarButtonItem = sReturnButton;
//    [sReturnButton release];
//
//    UINavigationController* sNavigationControllerOfAboutVC = [[UINavigationController alloc]initWithRootViewController:sAboutViewController];
//    sNavigationControllerOfAboutVC.navigationBar.barStyle = UIBarStyleBlack;
//    sNavigationControllerOfAboutVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//
//
//    if ([sNavigationControllerOfAboutVC.navigationBar respondsToSelector:@selector(setTintColor:)])
//    {
//        sNavigationControllerOfAboutVC.navigationBar.tintColor = MAIN_BGCOLOR;
//    }
//    else 
//    {
//       //ios 4. 
//    }
//    
//    
//    if ([self respondsToSelector:@selector(presentViewController:animated:completion:)])
//    {
//        [self presentViewController:sNavigationControllerOfAboutVC animated:YES completion:nil];
//    }
//    else
//    {
//        [self presentModalViewController:sNavigationControllerOfAboutVC animated:YES];
//    }
//        
////    [self.navigationController pushViewController:sAboutViewController animated:YES];
//    
//    [sAboutViewController release];
//    [sNavigationControllerOfAboutVC release];
//    return;
//}

//- (void) returnToFavorite
//{
//    if ([self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)])
//    {
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }
//    else 
//    {
//        [self dismissModalViewControllerAnimated:YES];
//    }
//    return;
//}

#pragma mark -
#pragma mark tableview's datasource methods


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.mFavorites.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSMutableArray* sItemsOfGroup = (NSMutableArray*)[self.mFavorites objectAtIndex:section];
    return [sItemsOfGroup count]; 
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSMutableArray* sItemsOfGroup = (NSMutableArray*)[self.mFavorites objectAtIndex:section];
    if (sItemsOfGroup
        && sItemsOfGroup.count >0)
    {
        Item* sItem = (Item*)[sItemsOfGroup objectAtIndex:0];
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSTimeZone* localzone = [NSTimeZone localTimeZone];
        [calendar setTimeZone:localzone];
        int unit =NSMonthCalendarUnit |NSYearCalendarUnit;
        NSDateComponents *fistComponets = [calendar components: unit fromDate: sItem.mMarkedTime];

        NSString* sTitle = [NSString stringWithFormat:@"%d-%d", [fistComponets year], [fistComponets month]];
        
        return sTitle;
    }
    return nil;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* sCell = [tableView dequeueReusableCellWithIdentifier:@"favcell"];
    if (!sCell) {
        sCell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle
                                        reuseIdentifier: @"favcell"] autorelease];
        
        UIView* sBGView = [[UIView alloc] initWithFrame:sCell.frame];
        sBGView.backgroundColor = SELECTED_CELL_COLOR;
        sCell.selectedBackgroundView = sBGView;
        [sBGView release];

        sCell.textLabel.font = [UIFont systemFontOfSize:17];
    }
    NSMutableArray* sItemsOfGroup = (NSMutableArray*)[self.mFavorites objectAtIndex:[indexPath section]];
    Item* sItem = (Item*)[sItemsOfGroup objectAtIndex:[indexPath row]];
    sCell.textLabel.text = sItem.mName;
    sCell.textLabel.backgroundColor = [UIColor clearColor];
    
    //isRead apperance
    if (sItem.mIsRead)
    {
        sCell.textLabel.textColor = [UIColor grayColor];
    }
    else 
    {
        sCell.textLabel.textColor = [UIColor blackColor];
    }
    
    return sCell;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sIndexPathes = [NSArray arrayWithObject:indexPath];
    switch (editingStyle) {
        case UITableViewCellEditingStyleDelete:
        {
            NSMutableArray* sItemsOfGroup = (NSMutableArray*)[self.mFavorites objectAtIndex:[indexPath section]];
            Item* sItem = (Item*)[sItemsOfGroup objectAtIndex:[indexPath row]];
            
            [sItem updateMarkedStaus:NO];
//            [StoreManager updateItemMarkedStatus:NO ItemID:sItem.mItemID];
            
            [sItemsOfGroup removeObject:sItem];
            if (sItemsOfGroup.count > 0)
            {
                [self.mTableView deleteRowsAtIndexPaths:sIndexPathes withRowAnimation:UITableViewRowAnimationNone];
            }
            else 
            {
                [self.mFavorites removeObject:sItemsOfGroup];
                
                if (self.mFavorites.count > 0)
                {
                    [self.mTableView deleteSections:[NSIndexSet indexSetWithIndex:[indexPath section]] withRowAnimation:UITableViewRowAnimationNone];
                }
                else 
                {
                    [self.mTableView reloadData];
                    [self toggleMainView];
                }
            }
            
        }
            break;
        default:
            break;
    }
}


#pragma mark -
#pragma mark tableview's delegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* sHeaderView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, [self tableView:tableView heightForHeaderInSection:section])] autorelease];
    sHeaderView.backgroundColor = [UIColor colorWithRed:RGB_DIV_255(115) green:RGB_DIV_255(126) blue:RGB_DIV_255(128) alpha:0.8f];
    
    UILabel *sLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, [self tableView:tableView heightForHeaderInSection:section])];
    sLabel.font = [UIFont systemFontOfSize:15];
    sLabel.textColor = [UIColor whiteColor];
    sLabel.backgroundColor = [UIColor clearColor];
    sLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    [sLabel sizeToFit];
    sLabel.frame = CGRectOffset(sLabel.frame, 320-sLabel.bounds.size.width-10, 0);
    
    [sHeaderView addSubview:sLabel];
    [sLabel release];
    return sHeaderView;
}

@end
