//
//  LibraryViewController.h
//  AboutSex
//
//  Created by Shane Wen on 12-6-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"

#import "IconData.h"

@protocol GridViewPageDelegate <NSObject>

@required

- (NSInteger) getNumberOfCellsOnPage:(NSInteger)aPageIndex;
- (IconData*) getIconDataForCellIndex:(NSInteger)aCellIndex onPage:(NSInteger)aPageIndex;
- (void) pushViewController:(UIViewController*)sViewController animated:(BOOL)animated;

//- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView onPage:(NSInteger)aPageIndex;
//- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index onPage:(NSInteger)aPageIndex;
//- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position onPage:(NSInteger)aPageIndex;
//

@end


@interface LibraryViewController : CommonViewController
{

}
@end
