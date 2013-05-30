//
//  FMItem.m
//  AboutSex
//
//  Created by Wen Shane on 13-4-21.
//
//

#import "FMItem.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

#define ICON_FILE_SUFFIX  @".png"

@implementation FMItem
@synthesize mFileURL;
@synthesize mAudioFileInfo;
@synthesize mArtwork;
@synthesize mBoughtTime;

- (id) initWithFilepath:(NSString*)aFilePath
{
    self = [super init];
    if (self)
    {
        self.mFileURL = [NSURL fileURLWithPath:aFilePath];
        self.mAudioFileInfo = [self songID3Tags];
        self.mArtwork = [self extractArtwork];
        
        NSDictionary* sAttributesDict = [[NSFileManager defaultManager] attributesOfItemAtPath:aFilePath error:nil];
        self.mBoughtTime = (NSDate*)[sAttributesDict objectForKey: NSFileModificationDate];
    }
    return self;
}

- (void) dealloc
{
    self.mFileURL = nil;
    self.mAudioFileInfo = nil;
    self.mArtwork = nil;
    self.mBoughtTime = nil;
    
    [super dealloc];
}

- (NSString*) getTitle
{
//    if ([self.mAudioFileInfo objectForKey:[NSString stringWithUTF8String:kAFInfoDictionary_Title]])
//    {
//		return [self.mAudioFileInfo objectForKey:[NSString stringWithUTF8String:kAFInfoDictionary_Title]];
//	}
//	else
    {
        NSString* sFileName = self.mFileURL.lastPathComponent;
        
        if (sFileName.length > 4
            && [sFileName hasSuffix:@".mp3"])
        {
            sFileName = [sFileName substringToIndex:sFileName.length-@".mp3".length];
        }
        
		return sFileName;
	}
	
	return nil;
}

- (NSTimeInterval) getDuration
{
    if ([self.mAudioFileInfo objectForKey:[NSString stringWithUTF8String:kAFInfoDictionary_ApproximateDurationInSeconds]])
		return [[self.mAudioFileInfo objectForKey:[NSString stringWithUTF8String:kAFInfoDictionary_ApproximateDurationInSeconds]] floatValue];
	else
		return 0;

}

- (NSDate*) getBoughDate
{
    return self.mBoughtTime;
}

- (UIImage *)getCoverImage
{
    return self.mArtwork;
}

- (BOOL) suicideOnDisk
{
    return [[NSFileManager defaultManager] removeItemAtURL:self.mFileURL error:nil];
}

- (BOOL)isEqual:(id)other
{
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    return [self.mFileURL isEqual:((FMItem*)other).mFileURL];
}

- (NSDictionary *)songID3Tags
{
	AudioFileID fileID = nil;
	OSStatus error = noErr;
	
	error = AudioFileOpenURL((CFURLRef)self.mFileURL, kAudioFileReadPermission, 0, &fileID);
	if (error != noErr) {
        NSLog(@"AudioFileOpenURL failed");
    }
	
	UInt32 id3DataSize  = 0;
    char *rawID3Tag    = NULL;
	
    error = AudioFileGetPropertyInfo(fileID, kAudioFilePropertyID3Tag, &id3DataSize, NULL);
    if (error != noErr)
        NSLog(@"AudioFileGetPropertyInfo failed for ID3 tag");
	
    rawID3Tag = (char *)malloc(id3DataSize);
    if (rawID3Tag == NULL)
        NSLog(@"could not allocate %d bytes of memory for ID3 tag", (NSInteger)id3DataSize);
    
    error = AudioFileGetProperty(fileID, kAudioFilePropertyID3Tag, &id3DataSize, rawID3Tag);
    if( error != noErr )
        NSLog(@"AudioFileGetPropertyID3Tag failed");
	
	UInt32 id3TagSize = 0;
    UInt32 id3TagSizeLength = 0;
	
	error = AudioFormatGetProperty(kAudioFormatProperty_ID3TagSize, id3DataSize, rawID3Tag, &id3TagSizeLength, &id3TagSize);
	
    if (error != noErr) {
        NSLog( @"AudioFormatGetProperty_ID3TagSize failed" );
        switch(error) {
            case kAudioFormatUnspecifiedError:
                NSLog( @"Error: audio format unspecified error" );
                break;
            case kAudioFormatUnsupportedPropertyError:
                NSLog( @"Error: audio format unsupported property error" );
                break;
            case kAudioFormatBadPropertySizeError:
                NSLog( @"Error: audio format bad property size error" );
                break;
            case kAudioFormatBadSpecifierSizeError:
                NSLog( @"Error: audio format bad specifier size error" );
                break;
            case kAudioFormatUnsupportedDataFormatError:
                NSLog( @"Error: audio format unsupported data format error" );
                break;
            case kAudioFormatUnknownFormatError:
                NSLog( @"Error: audio format unknown format error" );
                break;
            default:
                NSLog( @"Error: unknown audio format error" );
                break;
        }
    }
	
	CFDictionaryRef piDict = nil;
    UInt32 piDataSize = sizeof(piDict);
	
    error = AudioFileGetProperty(fileID, kAudioFilePropertyInfoDictionary, &piDataSize, &piDict);
    if (error != noErr)
        NSLog(@"AudioFileGetProperty failed for property info dictionary");
	
	free(rawID3Tag);
	
	return (NSDictionary*)piDict;
}

- (UIImage*) extractArtwork
{
    AVAsset* asset = [AVAsset assetWithURL:self.mFileURL];
    for (AVMetadataItem* sMetadataItem in asset.commonMetadata)
    {
        if ([sMetadataItem.commonKey isEqualToString:@"artwork"])
        {
            NSDictionary* imageDataDictionary = (NSDictionary *)sMetadataItem.value;
            NSData *imageData = [imageDataDictionary objectForKey:@"data"];
            UIImage* sImage = [UIImage imageWithData:imageData];
            return sImage;
        }
    }
    return nil;
}
@end
