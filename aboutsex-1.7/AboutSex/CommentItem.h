//
//  CommentItem.h
//  AboutSex
//
//  Created by Wen Shane on 13-2-6.
//
//

#import <Foundation/Foundation.h>
#import "Item.h"

@interface CommentItem : NSObject
{
    NSInteger mID;
    Item* mItem;
    NSString* mName;
    NSString* mContent;
    NSDate* mDate;
 
    NSInteger mDings;
    NSInteger mCais;
    BOOL mDidDing;
    BOOL mDidCai;
}

@property (nonatomic, assign) NSInteger mID;
@property (nonatomic, retain) Item* mItem;
@property (nonatomic, copy) NSString* mName;
@property (nonatomic, copy) NSString* mContent;
@property (nonatomic, retain) NSDate* mDate;
@property (nonatomic, assign) NSInteger mDings;
@property (nonatomic, assign) NSInteger mCais;
@property (nonatomic, assign) BOOL mDidDing;
@property (nonatomic, assign) BOOL mDidCai;


@end
