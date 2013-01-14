//
//  GridView.m
//  AboutSex
//
//  Created by Wen Shane on 12-12-21.
//
//

#import "GridViewPage.h"
#import <QuartzCore/QuartzCore.h>

#import "SharedVariables.h"
#import "UserConfiger.h"
#import "SectionViewController.h"

#define SPACING 10
#define SIZE_OF_CELL  CGSizeMake(140, 100)
#define BGCOLOR_OF_CELL CELL_BGCOLOR
#define INVALID_INDEX -1

#define TAG_FOR_READCOUNT_LABEL 201



@interface GridViewPage()
{
    id<GridViewPageDelegate> mDelegate;
    NSInteger mPageIndex;
    
    GMGridView* mGridView;  
    NSInteger mIndexOfIconTouched;

}
@property (nonatomic, assign)     id<GridViewPageDelegate> mDelegate;
@property (nonatomic, assign)     NSInteger mPageIndex;

@property (nonatomic, retain)     GMGridView* mGridView;
@property (nonatomic, assign)     NSInteger mIndexOfIconTouched;


@end


@implementation GridViewPage

@synthesize mDelegate;
@synthesize mPageIndex;
@synthesize mGridView;
@synthesize mIndexOfIconTouched;

- (id)initWithFrame:(CGRect)frame andDelegate:(id) aDelegate withPageIndex:(NSInteger)aPageIndex
{
    self = [super initWithFrame:frame];
    if (self) {
        self.mDelegate = aDelegate;
        self.mPageIndex = aPageIndex;
        self.mIndexOfIconTouched = INVALID_INDEX;
        
        [self prepareSubviews];
    }
    return self;
}

- (void) dealloc
{
    self.mGridView = nil;
    [super dealloc];
}

- (void) prepareSubviews
{
    mGridView = [[GMGridView alloc] initWithFrame:self.frame];
    mGridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    mGridView.backgroundColor = [UIColor clearColor];
    
    mGridView.style = GMGridViewStyleSwap;
    mGridView.itemSpacing = SPACING;
    mGridView.minEdgeInsets = UIEdgeInsetsMake(SPACING+20, SPACING+5, SPACING+50, SPACING);
//    mGridView.centerGrid = YES;
    mGridView.actionDelegate = self;
    mGridView.sortingDelegate = self;
    mGridView.transformDelegate = self;
    mGridView.dataSource = self;
    
    [self addSubview:mGridView];

}

- (void) reloadIcons
{
    [self.mGridView reloadData];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


//////////////////////////////////////////////////////////////
#pragma mark GMGridViewDataSource
//////////////////////////////////////////////////////////////

- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    return  [self.mDelegate getNumberOfCellsOnPage:self.mPageIndex];
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
        //        cell.deleteButtonIcon = [UIImage imageNamed:@"icon72.png"];
        //        cell.deleteButtonOffset = CGPointMake(-15, -15);
        CGSize size = [self sizeForItemsInGMGridView:gridView];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        view.backgroundColor = BGCOLOR_OF_CELL;
        view.layer.masksToBounds = NO;
//        view.layer.cornerRadius = 8;
        view.layer.shadowColor = [UIColor grayColor].CGColor;
        view.layer.shadowOffset = CGSizeMake(0, 5);
        //        view.layer.shadowPath = [UIBezierPath bezierPathWithRect:view.bounds].CGPath;
        //        view.layer.shadowRadius = 8;
        //        view.layer.shadowOpacity = 1.0f;
        
        cell.contentView = view;
        [view release];
    }
    
    //??
//    if ([UserConfiger isNightModeOn])
//    {
//        cell.contentView.backgroundColor = [UIColor grayColor];
//    }
//    else
//    {
//        cell.contentView.backgroundColor = BGCOLOR_OF_CELL;
//    }

    
    
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    
//    IconData* sIconData = (IconData*)[mIconDataArray objectAtIndex:index];
    IconData* sIconData = [self.mDelegate getIconDataForCellIndex: index onPage: self.mPageIndex];
    
    //
    cell.contentView.backgroundColor = [UIColor colorWithPatternImage: sIconData.mImage];
    
    
    //label displaying the title for the corresponding category.
    CGFloat sHeightOfTitle = 20;
    UILabel *sTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, cell.contentView.bounds.size.height-sHeightOfTitle, cell.contentView.bounds.size.width, sHeightOfTitle)];
    sTitleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    sTitleLabel.text = sIconData.mTitle;
    sTitleLabel.font = [UIFont boldSystemFontOfSize:15];
    sTitleLabel.textAlignment = UITextAlignmentCenter;
    sTitleLabel.backgroundColor = [UIColor grayColor];
    sTitleLabel.textColor = [UIColor whiteColor];
    sTitleLabel.alpha = 0.8;
    //    sTitleLabel.font = [UIFont boldSystemFontOfSize:20];
//    [sTitleLabel sizeToFit];
//    sTitleLabel.layer.cornerRadius = 8;

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

//- (void) returToLibrary
//{
//    [self dismissViewControllerAnimated:YES completion:nil];
//    return;
//}

-(void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    //2. present a new viewcontroller holding items for corresponding content.
   if (INVALID_INDEX != mIndexOfIconTouched)
    {
        IconData* sIconData = [self.mDelegate getIconDataForCellIndex: self.mIndexOfIconTouched onPage: self.mPageIndex];
        NSString* sTitle = sIconData.mTitle;
        NSString* sSectionName = sIconData.mSectionNameOrURL;

        
        BOOL sNeedShowCategories = NO;
        NSInteger sNumberOfCategoriesInSection = [StoreManager getTotalOfCategoriesInSection:sSectionName];
        if (sNumberOfCategoriesInSection > 1)
        {
            sNeedShowCategories = YES;
        }
        
        UIViewController* sSectionViewController = [[SectionViewController alloc] initWithTitle:sTitle AndSectionName:sSectionName AndShowCategories:sNeedShowCategories];
        
        sSectionViewController.hidesBottomBarWhenPushed = YES;
        [self.mDelegate pushViewController:sSectionViewController animated:YES];
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
