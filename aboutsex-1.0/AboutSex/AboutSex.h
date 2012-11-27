//
//  AboutSex.h
//  AboutSex
//
//  Created by Shane Wen on 12-6-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


//


@interface AboutSex : NSObject

+ (UITabBarController*) getMainTabController;

+ (void) configApperance: (UITabBarController*)aTabBarController;

+ (void) checkUpdateAutomatically;

@end
