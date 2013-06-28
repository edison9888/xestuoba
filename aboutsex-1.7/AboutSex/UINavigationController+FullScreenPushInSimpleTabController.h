//
//  UINavigationController+FullScreenPushInSimpleTabController.h
//  BTT
//
//  Created by Wen Shane on 12-12-17.
//  Copyright (c) 2012年 Wen Shane. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (FullScreenPushInSimpleTabController)<UINavigationControllerDelegate>

- (void) prepareFullScreenPush;
- (CGSize) getPushedViewControllerSize;
@end
