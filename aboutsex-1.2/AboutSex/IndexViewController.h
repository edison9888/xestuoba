//
//  IndexViewController.h
//  AboutSex
//
//  Created by Shane Wen on 12-7-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IndexDelegate.h"
#import "SharedVariables.h"

@interface IndexViewController : UITableViewController
{
    id<IndexDelegate> mDelegate;
}

@property (nonatomic, assign) id<IndexDelegate> mDelegate;
 
@end
