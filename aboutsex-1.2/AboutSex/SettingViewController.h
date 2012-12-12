//
//  SettingViewController.h
//  AboutSex
//
//  Created by Wen Shane on 12-11-28.
//
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"
#import "MyURLConnection.h"

@interface SettingViewController : CommonViewController<UITableViewDataSource, UITableViewDelegate, MyURLConnectionDelegate>



- (id) initWithTitle:(NSString*)aTitle;

@end
