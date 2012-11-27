//
//  LibraryViewController.m
//  AboutSex
//
//  Created by Shane Wen on 12-6-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "SharedVariables.h"
#import "LibraryViewController.h"
#import "GMGridView/GMGridView.h"
#import "GMGridView/UIView+GMGridViewAdditions.h"
#import "IconData.h"

#import "SectionViewController.h"
#import "BaiduWrapperViewController.h"

#import "StoreManager.h"


#define SPACING 10
#define SIZE_OF_CELL  CGSizeMake(140, 100)
#define BGCOLOR_OF_CELL CELL_BGCOLOR
#define INVALID_INDEX -1

#define TAG_FOR_READCOUNT_LABEL 201

@interface LibraryViewController () <GMGridViewDataSource, GMGridViewSortingDelegate, GMGridViewTransformationDelegate, GMGridViewActionDelegate>
{
    GMGridView* mGridView;
    NSMutableArray* mIconDataArray;
    NSInteger mIndexOfIconTouched;
}

@property (nonatomic, retain) GMGridView* mGridView;
@property (nonatomic, retain) NSMutableArray* mIconDataArray;
@property (nonatomic, assign) NSInteger mIndexOfIconTouched;

- (void) returToLibrary;

@end


@implementation LibraryViewController

@synthesize mGridView;
@synthesize mIconDataArray;
@synthesize mIndexOfIconTouched;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
#ifdef DEBUG
        NSLog(@"library ....");
#endif

    }
    return self;
}

- (id) init
{
    self = [super init];
    
    if (self)
    {
        self.title =  NSLocalizedString(@"Library", nil);
        self.mIndexOfIconTouched = INVALID_INDEX;
        
//        UIBarButtonItem* sSearchButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:nil action:@selector(clickSearchButton)];
//        self.navigationItem.rightBarButtonItem = sSearchButton;
//        
//        [sSearchButton release];
        
        
        self.mIconDataArray = [self loadIconData];
    }
    
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.mIconDataArray = [self loadIconData];
    [self.mGridView reloadData];
}

- (void) dealloc
{
    self.mIconDataArray = nil;
    [super dealloc];
}

- (NSMutableArray*) loadIconData
{
    NSMutableArray* sIconDataArray = [[[NSMutableArray alloc] init] autorelease];
    
    //Physilogy
    IconData* sPhysiologyIcon = [[IconData alloc]init];
    sPhysiologyIcon.mTitle = NSLocalizedString(@"Commonsense", nil);
    sPhysiologyIcon.mImage = nil;
    sPhysiologyIcon.mJSONFilePath = nil;
    sPhysiologyIcon.mSectionNameOrURL = SECTION_NAME_COMMONSENSE;
    sPhysiologyIcon.mTotal = [StoreManager getTotalOfItemsInsection:sPhysiologyIcon.mSectionNameOrURL];
    sPhysiologyIcon.mReadCount = [StoreManager getReadCountInSection:sPhysiologyIcon.mSectionNameOrURL];
    [sIconDataArray addObject: sPhysiologyIcon];
    [sPhysiologyIcon release];
    
    IconData* sSexualHealthIcon = [[IconData alloc]init];
    sSexualHealthIcon.mTitle = NSLocalizedString(@"SexualHealth",nil);
    sSexualHealthIcon.mImage = nil;
    sSexualHealthIcon.mJSONFilePath = nil;
    sSexualHealthIcon.mSectionNameOrURL  = SECTION_NAME_HELATH;
    sSexualHealthIcon.mTotal = [StoreManager getTotalOfItemsInsection:sSexualHealthIcon.mSectionNameOrURL];
    sSexualHealthIcon.mReadCount = [StoreManager getReadCountInSection:sSexualHealthIcon.mSectionNameOrURL];
    [sIconDataArray addObject: sSexualHealthIcon];
    [sSexualHealthIcon release];
    
    IconData* sSexualSkillsIcon = [[IconData alloc]init];
    sSexualSkillsIcon.mTitle = NSLocalizedString(@"SexualSkills",nil);
    sSexualSkillsIcon.mImage = nil;
    sSexualSkillsIcon.mJSONFilePath = nil;
    sSexualSkillsIcon.mSectionNameOrURL = SECTION_NAME_SKILLS;
    sSexualSkillsIcon.mTotal = [StoreManager getTotalOfItemsInsection:sSexualSkillsIcon.mSectionNameOrURL];
    sSexualSkillsIcon.mReadCount = [StoreManager getReadCountInSection:sSexualSkillsIcon.mSectionNameOrURL];
    [sIconDataArray addObject: sSexualSkillsIcon];
    [sSexualSkillsIcon release];
    
//    IconData* sSexualPsyChologyIcon = [[IconData alloc]init];
//    sSexualPsyChologyIcon.mTitle =  NSLocalizedString(@"SexualPsychology",nil);
//    sSexualPsyChologyIcon.mImage = nil;
//    sSexualPsyChologyIcon.mJSONFilePath = nil;
//    sSexualPsyChologyIcon.mSectionNameOrURL = SECTION_NAME_PSYCHOLOGY;
//    sSexualPsyChologyIcon.mTotal = [StoreManager getTotalOfItemsInsection:sSexualPsyChologyIcon.mSectionNameOrURL];
//    sSexualPsyChologyIcon.mReadCount = [StoreManager getReadCountInSection:sSexualPsyChologyIcon.mSectionNameOrURL];
//    [sIconDataArray addObject:sSexualPsyChologyIcon];
//    [sSexualPsyChologyIcon release];
    
    IconData* sAskandAnswerIcon = [[IconData alloc]init];
    sAskandAnswerIcon.mTitle = NSLocalizedString(@"AskandAnswer",nil);
    sAskandAnswerIcon.mImage = nil;
    sAskandAnswerIcon.mJSONFilePath = nil;
    sAskandAnswerIcon.mSectionNameOrURL = nil;
    sAskandAnswerIcon.mTotal = -1;
    sAskandAnswerIcon.mReadCount = -1;
    sAskandAnswerIcon.mIsLocal = NO;
    [sIconDataArray addObject: sAskandAnswerIcon];
    [sAskandAnswerIcon release];
    
//    IconData* sTEMP = [[IconData alloc]init];
//    sTEMP.mTitle = NSLocalizedString(@"临时",nil);
//    sTEMP.mImage = nil;
//    sTEMP.mJSONFilePath = nil;
//    sTEMP.mTotal = 100;
//    sTEMP.mReadCount = 1;
//    [mIconDataArray addObject: sTEMP];
//
//    [sTEMP release];

    return sIconDataArray;
}

- (void) loadView 
{
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];

    mGridView = [[GMGridView alloc] initWithFrame:applicationFrame];
    mGridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    mGridView.backgroundColor = TAB_PAGE_BGCOLOR;

    mGridView.style = GMGridViewStyleSwap;
    mGridView.itemSpacing = SPACING;
    mGridView.minEdgeInsets = UIEdgeInsetsMake(SPACING+20, SPACING+5, SPACING+50, SPACING);
//    mGridView.centerGrid = YES;
    mGridView.actionDelegate = self;
    mGridView.sortingDelegate = self;
    mGridView.transformDelegate = self;
    mGridView.dataSource = self;

    self.view = mGridView;
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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


//////////////////////////////////////////////////////////////
#pragma mark GMGridViewDataSource
//////////////////////////////////////////////////////////////

- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    return [self.mIconDataArray count];
}

- (CGSize)sizeForItemsInGMGridView:(GMGridView *)gridView
{
    return SIZE_OF_CELL;
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
    //NSLog(@"Creating view indx %d", index);
    
    
    GMGridViewCell *cell = [gridView dequeueReusableCell];
    
    if (!cell) 
    {
        cell = [[[GMGridViewCell alloc] init] autorelease];
//        cell.deleteButtonIcon = [UIImage imageNamed:@"close_x.png"];
//        cell.deleteButtonOffset = CGPointMake(-15, -15);
        CGSize size = [self sizeForItemsInGMGridView:gridView];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        view.backgroundColor = BGCOLOR_OF_CELL;
        view.layer.masksToBounds = NO;
        view.layer.cornerRadius = 8;
        view.layer.shadowColor = [UIColor grayColor].CGColor;
        view.layer.shadowOffset = CGSizeMake(5, 5);
        view.layer.shadowPath = [UIBezierPath bezierPathWithRect:view.bounds].CGPath;
        view.layer.shadowRadius = 8;
        view.layer.shadowOpacity = 1.0f;
        
        cell.contentView = view;
        [view release];
    }
    
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    
    IconData* sIconData = (IconData*)[mIconDataArray objectAtIndex:index];
    
    //label displaying the title for the corresponding category.
    UILabel *sTitleLabel = [[UILabel alloc] initWithFrame:cell.contentView.bounds];
    sTitleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    sTitleLabel.text = sIconData.mTitle;
    sTitleLabel.textAlignment = UITextAlignmentCenter;
    sTitleLabel.backgroundColor = [UIColor clearColor];
    sTitleLabel.textColor = [UIColor blackColor];
    sTitleLabel.font = [UIFont boldSystemFontOfSize:20];
    [sTitleLabel sizeToFit];
    sTitleLabel.center = cell.contentView.center;
    [cell.contentView addSubview:sTitleLabel];
    [sTitleLabel release];
    
    //label displaying number of items read and item in total respectively.
    if (sIconData.mIsLocal)
    {
        UILabel* sCountLabel = [[UILabel alloc] initWithFrame:cell.contentView.bounds];
        sCountLabel.text = [NSString stringWithFormat:@"%d / %d", sIconData.mReadCount, sIconData.mTotal];
        sCountLabel.font = [UIFont fontWithName:@"Helvetica" size:10];
        sCountLabel.textColor = [UIColor grayColor];
        sCountLabel.backgroundColor = [UIColor clearColor];
        [sCountLabel sizeToFit];
        sCountLabel.center = CGPointMake(cell.contentView.bounds.size.width-sCountLabel.bounds.size.width/2, 
                                         sCountLabel.bounds.size.height/2);
        sCountLabel.tag = TAG_FOR_READCOUNT_LABEL;
        [cell.contentView addSubview:sCountLabel];
        [sCountLabel release];
    }
    
    return cell;
}

- (void)GMGridView:(GMGridView *)gridView deleteItemAtIndex:(NSInteger)index
{
    //icon data now cannot be removed by user!!!
//    [mIconDataArray removeObjectAtIndex:index];
}

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewActionDelegate
//////////////////////////////////////////////////////////////

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
    self.mIndexOfIconTouched = position;
    
    GMGridViewCell* sCell = [gridView cellForItemAtIndex:position];
    
    //1. haha, the cell has to shake for a moment before open a page for you.
    CGFloat rotation = 0.03;
    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"transform"];
    shake.duration = 0.1;
    shake.autoreverses = YES;
    shake.repeatCount  = 1;
    shake.removedOnCompletion = YES;
    shake.delegate = self;
    shake.fromValue = [NSValue valueWithCATransform3D:CATransform3DRotate(sCell.contentView.layer.transform,-rotation, 0.0 ,0.0 ,1.0)];
    shake.toValue   = [NSValue valueWithCATransform3D:CATransform3DRotate(sCell.contentView.layer.transform, rotation, 0.0 ,0.0 ,1.0)];
    
    [sCell.layer addAnimation:shake forKey:nil];                        
    
    return;
}

- (void) returToLibrary
{
    [self dismissViewControllerAnimated:YES completion:nil];
    return;
}

-(void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    //2. present a new viewcontroller holding items for corresponding content.
   if (INVALID_INDEX != mIndexOfIconTouched)
    {
        IconData* sIconData = (IconData*)[self.mIconDataArray objectAtIndex:mIndexOfIconTouched];
        NSString* sTitle = sIconData.mTitle;
        NSString* sSectionName = sIconData.mSectionNameOrURL;
        
        UIViewController* sSectionViewController;
        if (sIconData.mIsLocal)
        {
            sSectionViewController = [[SectionViewController alloc] initWithTitle:sTitle AndSectionName:sSectionName];
        }
        else 
        {
            sSectionViewController = [[BaiduWrapperViewController alloc]initWithTitle:sTitle];
        }
        sSectionViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:sSectionViewController animated:YES];
        [sSectionViewController release];
#ifdef DEBUG
        NSLog(@"Did tap at index %d", mIndexOfIconTouched);
#endif
    }
}



#pragma mark -
#pragma mark -
#pragma mark cos we now disable the rotation,sorting, pinching recognizer, the below methods for the corresponding delegates are useless. you may implemet them as you like when you need these funcionalities, in the future.
#pragma mark -

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewSortingDelegate
//////////////////////////////////////////////////////////////

- (void)GMGridView:(GMGridView *)gridView didStartMovingCell:(GMGridViewCell *)cell
{
//    [UIView animateWithDuration:0.3 
//                          delay:0 
//                        options:UIViewAnimationOptionAllowUserInteraction 
//                     animations:^{
//                         cell.contentView.backgroundColor = [UIColor orangeColor];
//                         cell.contentView.layer.shadowOpacity = 0.7;
//                     } 
//                     completion:nil
//     ];
}

- (void)GMGridView:(GMGridView *)gridView didEndMovingCell:(GMGridViewCell *)cell
{
//    [UIView animateWithDuration:0.3 
//                          delay:0 
//                        options:UIViewAnimationOptionAllowUserInteraction 
//                     animations:^{  
//                         cell.contentView.backgroundColor = [UIColor greenColor];
//                         cell.contentView.layer.shadowOpacity = 0;
//                     }
//                     completion:nil
//     ];
}

- (BOOL)GMGridView:(GMGridView *)gridView shouldAllowShakingBehaviorWhenMovingCell:(GMGridViewCell *)cell atIndex:(NSInteger)index
{
    return YES;
}

- (void)GMGridView:(GMGridView *)gridView moveItemAtIndex:(NSInteger)oldIndex toIndex:(NSInteger)newIndex
{
//    NSObject *object = [_data objectAtIndex:oldIndex];
//    [_data removeObject:object];
//    [_data insertObject:object atIndex:newIndex];
}

- (void)GMGridView:(GMGridView *)gridView exchangeItemAtIndex:(NSInteger)index1 withItemAtIndex:(NSInteger)index2
{
//    [mIconDataArray exchangeObjectAtIndex:index1 withObjectAtIndex:index2];
}


//////////////////////////////////////////////////////////////
#pragma mark DraggableGridViewTransformingDelegate
//////////////////////////////////////////////////////////////

- (CGSize)GMGridView:(GMGridView *)gridView sizeInFullSizeForCell:(GMGridViewCell *)cell atIndex:(NSInteger)index
{
//    return CGSizeMake(310, 310);
    return CGSizeZero;
}

- (UIView *)GMGridView:(GMGridView *)gridView fullSizeViewForCell:(GMGridViewCell *)cell atIndex:(NSInteger)index
{
//    UIView *fullView = [[UIView alloc] init];
//    fullView.backgroundColor = [UIColor yellowColor];
//    fullView.layer.masksToBounds = NO;
//    fullView.layer.cornerRadius = 8;
//    
//    CGSize size = [self GMGridView:gridView sizeInFullSizeForCell:cell atIndex:index];
//    fullView.bounds = CGRectMake(0, 0, size.width, size.height);
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:fullView.bounds];
//    label.text = [NSString stringWithFormat:@"Fullscreen View for cell at index %d", index];
//    label.textAlignment = UITextAlignmentCenter;
//    label.backgroundColor = [UIColor clearColor];
//    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    
//
//    label.font = [UIFont boldSystemFontOfSize:15];
//    
//    
//    [fullView addSubview:label];
//    
//    
//    return fullView;
    return nil;
}

- (void)GMGridView:(GMGridView *)gridView didStartTransformingCell:(GMGridViewCell *)cell
{
//    [UIView animateWithDuration:0.5 
//                          delay:0 
//                        options:UIViewAnimationOptionAllowUserInteraction 
//                     animations:^{
//                         cell.contentView.backgroundColor = [UIColor blueColor];
//                         cell.contentView.layer.shadowOpacity = 0.7;
//                     } 
//                     completion:nil];
}

- (void)GMGridView:(GMGridView *)gridView didEndTransformingCell:(GMGridViewCell *)cell
{
//    [UIView animateWithDuration:0.5 
//                          delay:0 
//                        options:UIViewAnimationOptionAllowUserInteraction 
//                     animations:^{
//                         cell.contentView.backgroundColor = [UIColor redColor];
//                         cell.contentView.layer.shadowOpacity = 0;
//                     } 
//                     completion:nil];
}

- (void)GMGridView:(GMGridView *)gridView didEnterFullSizeForCell:(UIView *)cell
{
    
}


@end
