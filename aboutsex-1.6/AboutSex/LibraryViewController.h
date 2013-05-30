//
//  LibraryViewController.h
//  AboutSex
//
//  Created by Shane Wen on 12-6-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconData.h"
#import "BannerAdapter.h"

@protocol GridViewPageDelegate <NSObject>

@required

- (NSInteger) getNumberOfCellsOnPage:(NSInteger)aPageIndex;
- (IconData*) getIconDataForCellIndex:(NSInteger)aCellIndex onPage:(NSInteger)aPageIndex;
- (void) pushViewController:(UIViewController*)sViewController animated:(BOOL)animated;

@end


@interface LibraryViewController : UIViewController<AdBannerDelegate>
{

}
@end
