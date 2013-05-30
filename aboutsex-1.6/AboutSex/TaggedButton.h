//
//  TaggedButton.h
//  AboutSex
//
//  Created by Shane Wen on 12-7-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIButtonLarge.h"

@interface TaggedButton : UIButtonLarge
{
    NSIndexPath* mIndexPath;
}

@property (nonatomic, retain) NSIndexPath* mIndexPath;

@end
