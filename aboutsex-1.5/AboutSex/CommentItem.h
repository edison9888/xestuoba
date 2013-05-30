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
    Item* mItem;
    NSString* mName;
    NSString* mContent;
    NSDate* mDate;
    
}

@property (nonatomic, assign) Item* mItem;
@property (nonatomic, copy) NSString* mName;
@property (nonatomic, copy) NSString* mContent;
@property (nonatomic, retain) NSDate* mDate;
@end
