//
//  UIButton+WebCache.h
//  AboutSex
//
//  Created by Wen Shane on 13-3-17.
//
//

#import <UIKit/UIKit.h>
#import "SDWebImageManagerDelegate.h"

@interface UIButton (WebCache) <SDWebImageManagerDelegate>

- (void)setBackgroundImageWithURL:(NSURL *)url;
- (void)setBackgroundImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

@end
