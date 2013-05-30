//
//  TopStreamController.h
//  AboutSex
//
//  Created by Wen Shane on 13-2-2.
//
//

#import "CommonTableViewController2.h"
#import "StreamViewController.h"
#import "SGFocusImageFrame.h"
#import "SimplePageViewController.h"

@interface HotStreamController : SimplePageViewController<SGFocusImageFrameDelegate>
{
    id<StreamViewControllerDelegate> mDelegate;

}
@property (nonatomic, assign) id<StreamViewControllerDelegate> mDelegate;


@end
