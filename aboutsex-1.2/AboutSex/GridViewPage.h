//
//  GridView.h
//  AboutSex
//
//  Created by Wen Shane on 12-12-21.
//
//

#import <UIKit/UIKit.h>
#import "GMGridView/GMGridView.h"
#import "GMGridView/UIView+GMGridViewAdditions.h"
#import "LibraryViewController.h"

@interface GridViewPage : UIView<GMGridViewDataSource, GMGridViewSortingDelegate, GMGridViewTransformationDelegate, GMGridViewActionDelegate>
{
    
}


- (id)initWithFrame:(CGRect)frame andDelegate:(id) aDelegate withPageIndex:(NSInteger)aPageIndex;

@end
