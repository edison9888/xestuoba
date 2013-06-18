//
//  SidebarViewController.h
//  AboutSex
//
//  Created by Wen Shane on 13-6-7.
//
//

#import <UIKit/UIKit.h>
#import "PPRevealSideViewController.h"


@interface SidebarViewController : UITableViewController

+ (SidebarViewController*) shared;


- (void) selectRow;
@end
