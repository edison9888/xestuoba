//
//  FMStoreTabController.h
//  AboutSex
//
//  Created by Wen Shane on 13-6-14.
//
//

#import "SimpleTabController.h"
#import "FMListController.h"


@interface FMStoreController : SimpleTabController<UINavigationBarDelegate, FMListControllerDelegate>

+ (UIViewController*) shared;

@end
