//
//  AppInfo.h
//  AboutSex
//
//  Created by Wen Shane on 13-1-12.
//
//

#import <Foundation/Foundation.h>

@interface AppInfo : NSObject
{
    NSString* mName;
    NSString* mURLStr;
    NSString* mDetail;
    NSString* mIconURL;
    NSString* mProvider;
}

@property(nonatomic, copy) NSString* mName;
@property(nonatomic, copy) NSString* mURLStr;
@property(nonatomic, copy) NSString* mDetail;
@property(nonatomic, copy) NSString* mIconURL;
@property(nonatomic, copy) NSString* mProvider;


@end
