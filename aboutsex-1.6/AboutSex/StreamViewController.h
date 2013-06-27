//
//  StreamViewController.h
//  AboutSex
//
//  Created by Wen Shane on 13-2-2.
//
//

#import <UIKit/UIKit.h>
#import "AffectionViewController.h"

@protocol StreamViewControllerDelegate <NSObject>

- (void) beginLoading;
- (void) endLoading;
- (void) pushController:(UIViewController *)viewController animated:(BOOL)animated;


@end

@interface StreamViewController : UIViewController<StreamViewControllerDelegate, AffectionViewControllerDelegate>

+ (UINavigationController*) shared;
- (void) refreshFromOutside;//just goto the newstream viewcontroller and the refresh for new streams if any.

@end
