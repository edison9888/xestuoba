//
//  FMItem.h
//  AboutSex
//
//  Created by Wen Shane on 13-4-21.
//
//

#import <Foundation/Foundation.h>

@interface FMItem : NSObject
{
	NSURL			*mFileURL;
    
	NSDictionary	*mAudioFileInfo;
    UIImage*        mArtwork;
    NSDate*         mBoughtTime;
}

- (id) initWithFilepath:(NSString*)aFilePath;

@property (nonatomic, retain)       	NSURL			*mFileURL;
@property (nonatomic, retain)       	NSDictionary	*mAudioFileInfo;
@property (nonatomic, retain)           UIImage*        mArtwork;
@property (nonatomic, retain)       	NSDate*         mBoughtTime;

- (NSString*) getTitle;
- (NSTimeInterval) getDuration;
- (NSDate*) getBoughDate;
- (UIImage *)getCoverImage;
- (BOOL) suicideOnDisk;

@end
