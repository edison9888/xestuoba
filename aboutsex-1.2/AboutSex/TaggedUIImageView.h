//
//  TaggedUIImageView.h
//  AboutSex
//
//  Created by Shane Wen on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaggedUIImageView : UIImageView
{
    NSIndexPath* mIndexPath;
}
@property (nonatomic, retain) NSIndexPath* mIndexPath;

@end
