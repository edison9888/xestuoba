//
//  NobackupManager.h
//  AboutSex
//
//  Created by Wen Shane on 13-7-16.
//
//

#import <Foundation/Foundation.h>


//iOS does not allow store no-user-generated data in Documents file, cos files there will be backuped automatically and thus hurt user experience. prior to 5.0.1, you have to put them in Caches directory; since 5.0.1, you can add attribute to the directory to avoid being backed up, but since 5.1, attribute adding differs.
@interface NobackupManager : NSObject

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;

@end
