//
//  SimpleTabBar.h
//  BTT
//
//  Created by Wen Shane on 12-12-8.
//  Copyright (c) 2012年 Wen Shane. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimpleTabControllerStyle.h"

@protocol SimpleTabBarDelegate <NSObject>
@required
- (SimpleTabControllerStyle*) getStyleOfCorrespondingController;

@end

//simple tab bar
@interface SimpleTabBar : UIView
{
    id<SimpleTabBarDelegate> mDelegate;
}

@property (nonatomic, assign) id<SimpleTabBarDelegate> mDelegate;
@property (nonatomic, retain) NSArray* mBarItems;


- (id)initWithFrame:(CGRect)frame BarItems:(NSArray*)aBarItems Delegate:(id<SimpleTabBarDelegate>)aDelegate;

- (void) moveTo:(NSInteger)aIndex;

@end
