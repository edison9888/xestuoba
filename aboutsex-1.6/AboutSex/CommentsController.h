//
//  CommentsController.h
//  AboutSex
//
//  Created by Wen Shane on 13-2-6.
//
//

#import <UIKit/UIKit.h>
#import "Item.h"

@interface CommentsController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    Item* mItem;
    UITableView* mTableView;
    UIActivityIndicatorView* mPageLoadingIndicator;

    NSMutableArray* mComments;
}

@property (nonatomic, retain) Item* mItem;
@property (nonatomic, retain) UITableView* mTableView;
@property (nonatomic, retain) UIActivityIndicatorView* mPageLoadingIndicator;
@property (nonatomic, retain) NSMutableArray* mComments;

- (id) initWithItem:(Item*)aItem;
@end
