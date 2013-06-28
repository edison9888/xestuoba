/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIButton+WebCache.h"
#import "objc/runtime.h"

//imported to resize image
#import "UIImage+Resize.h"


static char operationKey;

@implementation UIButton (WebCache)

- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state
{
    [self setImageWithURL:url forState:state placeholderImage:nil options:0 completed:nil];
}

- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder
{
    [self setImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:nil];
}

- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options
{
    [self setImageWithURL:url forState:state placeholderImage:placeholder options:options completed:nil];
}

- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state completed:(SDWebImageCompletedBlock)completedBlock
{
    [self setImageWithURL:url forState:state placeholderImage:nil options:0 completed:completedBlock];
}
- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletedBlock)completedBlock
{
    [self setImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:completedBlock];
}

- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletedBlock)completedBlock
{
    [self cancelCurrentImageLoad];

    [self setImage:placeholder forState:state];

    if (url)
    {
        __weak UIButton *wself = self;
        id<SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadWithURL:url options:options progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
        {
            if (!wself) return;
            void (^block)(void) = ^
            {
                __strong UIButton *sself = wself;
                if (!sself) return;
                if (image)
                {
                    [sself setImage:image forState:state];
                }
                if (completedBlock && finished)
                {
                    completedBlock(image, error, cacheType);
                }
            };
            if ([NSThread isMainThread])
            {
                block();
            }
            else
            {
                dispatch_sync(dispatch_get_main_queue(), block);
            }
        }];
        objc_setAssociatedObject(self, &operationKey, operation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state
{
    [self setBackgroundImageWithURL:url forState:state placeholderImage:nil options:0 completed:nil];
}

- (void)setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder
{
    [self setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:nil];
}

- (void)setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options
{
    [self setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:options completed:nil];
}

- (void)setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state completed:(SDWebImageCompletedBlock)completedBlock
{
    [self setBackgroundImageWithURL:url forState:state placeholderImage:nil options:0 completed:completedBlock];
}

- (void)setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletedBlock)completedBlock
{
    [self setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:completedBlock];
}

- (void)setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletedBlock)completedBlock
{
    [self cancelCurrentImageLoad];

    [self setBackgroundImage:placeholder forState:state];

    if (url)
    {
        __weak UIButton *wself = self;
        id<SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadWithURL:url options:options progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
        {
            if (!wself) return;
            void (^block)(void) = ^
            {
                __strong UIButton *sself = wself;
                if (!sself) return;
                if (image)
                {
                    //
                    [self setImageWithProperResize:image];

                    
                    
                    [sself setBackgroundImage:image forState:state];
                }
                if (completedBlock && finished)
                {
                    completedBlock(image, error, cacheType);
                }
            };
            if ([NSThread isMainThread])
            {
                block();
            }
            else
            {
                dispatch_sync(dispatch_get_main_queue(), block);
            }
        }];
        objc_setAssociatedObject(self, &operationKey, operation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}


- (void)cancelCurrentImageLoad
{
    // Cancel in progress downloader from queue
    id<SDWebImageOperation> operation = objc_getAssociatedObject(self, &operationKey);
    if (operation)
    {
        [operation cancel];
        objc_setAssociatedObject(self, &operationKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

//
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
