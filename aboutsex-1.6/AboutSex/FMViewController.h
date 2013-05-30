//
//  FMViewController.h
//  AboutSex
//
//  Created by Wen Shane on 13-4-20.
//
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@interface FMViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, AVAudioPlayerDelegate>

- (id) initWithTitle:(NSString*)aTitle;
@end
