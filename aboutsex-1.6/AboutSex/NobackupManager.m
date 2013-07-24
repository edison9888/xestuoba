//
//  NobackupManager.m
//  AboutSex
//
//  Created by Wen Shane on 13-7-16.
//
//

#import "NobackupManager.h"
#import <sys/xattr.h>


@implementation NobackupManager

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    NSString *reqSysVer = @"5.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending)
    {
        return [self addSkipBackupAttributeToItemAtURLSince51:URL];
    }
    else
    {
        return [self addSkipBackupAttributeToItemAtURL501To51:URL];
    }
}

//[5.0.1, 5.1) ;btw, if you want store non-user-generated data on device which is prior 5.0.1, then you should store them in Caches directory, to avoid data being backed up. And, iOS will delete your files from the Caches directory when necessary, so your app will need to degrade gracefully if it's data files are deleted.
+ (BOOL)addSkipBackupAttributeToItemAtURL501To51:(NSURL *)URL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    const char* filePath = [[URL path] fileSystemRepresentation];
    
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;

}

//[5.1, ...)
+ (BOOL)addSkipBackupAttributeToItemAtURLSince51:(NSURL *)URL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;

}


@end
