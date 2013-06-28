//
//  SettingViewController.h
//  AboutSex
//
//  Created by Wen Shane on 12-11-28.
//
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"
#import <StoreKit/StoreKit.h>


@interface SettingViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, SKStoreProductViewControllerDelegate>

- (id) initWithTitle:(NSString*)aTitle;

@end
