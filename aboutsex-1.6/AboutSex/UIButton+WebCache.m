//
//  UIButton+WebCache.m
//  AboutSex
//
//  Created by Wen Shane on 13-3-17.
//
//

#import "UIButton+WebCache.h"
#import "SDWebImageManager.h"
#import "UIImage+Resize.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIButton (WebCache)


- (void)setBackgroundImageWithURL:(NSURL *)url
{
    [self setBackgroundImageWithURL:url placeholderImage:nil];
}

- (void)setBackgroundImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];
    
    UIImage *cachedImage = [manager imageWithURL:url];
    
    if (cachedImage)
    {
        [self setImageWithProperResize:cachedImage];
    }
    else
    {
        if (placeholder)
        {
            [self setImageWithProperResize:placeholder];
        }
        
        [manager downloadWithURL:url delegate:self];
    }
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    [self setImageWithProperResize:image];
}

- (void) setImageWithProperResize:(UIImage*)aImage
{
    CGSize sBtnSize = self.bounds.size;
    CGSize sImgSize = aImage.size;
    
    CGFloat sRatioWidth = sBtnSize.width/sImgSize.width;
    CGFloat sRatioHeight = sBtnSize.height/sImgSize.height;
   
    CGFloat sRatio;
    if (sRatioWidth < sRatioHeight)
    {
        sRatio = sRatioHeight;
    }
    else
    {
        sRatio = sRatioWidth;
    }
    
    CGSize sSize = CGSizeMake(sRatio*sImgSize.width, sRatio*sImgSize.height);
    
    UIImage* sResizedImage = [aImage resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:sSize
                                            interpolationQuality:kCGInterpolationDefault];
    
    CGSize sSizeDiff = CGSizeMake(sSize.width-sBtnSize.width, sSize.height-sBtnSize.height);
    
    self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, -sSizeDiff.height, -sSizeDiff.width);

    [self setImage:sResizedImage forState:UIControlStateNormal];
}

@end
