//
//  AffectionViewController.h
//  AboutSex
//
//  Created by Wen Shane on 13-6-7.
//
//

#import <UIKit/UIKit.h>

typedef enum _ENUM_AFFECTION_TYPE{
    ENUM_AFFECTION_TYPE_INVALID,
    ENUM_AFFECTION_TYPE_LATEST_ARTICLES,
    ENUM_AFFECTION_TYPE_TOP_ARTICLES,
    ENUM_AFFECTION_TYPE_HOTCOMMENTS,
    
}ENUM_AFFECTION_TYPE;


@protocol AffectionViewControllerDelegate <NSObject>

- (void) pushController:(UIViewController *)viewController animated:(BOOL)animated;
- (void) beginLoading;
- (void) endLoading;


@end



@interface AffectionViewController : UIViewController<AffectionViewControllerDelegate, UINavigationControllerDelegate>

+ (AffectionViewController*) shared;

- (void) switchToItem:(ENUM_AFFECTION_TYPE)aItem;
- (ENUM_AFFECTION_TYPE) getCurAffectionType;

@end
