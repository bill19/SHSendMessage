//
//  UIImage+ChangeImage.m
//  MaiTian
//
//  Created by 姜泽东 on 2017/10/16.
//  Copyright © 2017年 YL. All rights reserved.
//

#import "UIImage+ChangeImage.h"

@implementation UIImage (ChangeImage)

- (UIImage *)changeImageWithColor:(UIColor *)color
{
    CGBlendMode blendMode = kCGBlendModeOverlay;
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [UIScreen mainScreen].scale);
    [color setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    [self drawInRect:bounds blendMode:blendMode alpha:1.0f];
    
    if (blendMode != kCGBlendModeDestinationIn)
        [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)resizedImageToSize:(CGSize)newSize{
    CGSize scaledSize = newSize;
    float scaleFactor = 1.0;
    
    if(self.size.width > self.size.height ) {
        scaleFactor = self.size.width / self.size.height;
        scaledSize.width = newSize.width;
        scaledSize.height = newSize.height / scaleFactor;
    } else {
        scaleFactor = self.size.height / self.size.width;
        scaledSize.height = newSize.height;
        scaledSize.width = newSize.width / scaleFactor;
    }
    
    UIGraphicsBeginImageContextWithOptions(scaledSize, NO, 1);
    CGRect scaledImageRect = CGRectMake(0.0, 0.0, scaledSize.width, scaledSize.height);
    [self drawInRect:scaledImageRect];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

- (UIImage *)imageWithRoundedCorner:(CGFloat)radius
{
    CGRect rect = (CGRect){0.f, 0.f, self.size};
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, UIScreen.mainScreen.scale);
    CGContextAddPath(UIGraphicsGetCurrentContext(),
                     [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath);
    CGContextClip(UIGraphicsGetCurrentContext());
    
    [self drawInRect:rect];
    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return output;
}

- (UIImage *)renderMode:(UIImageRenderingMode)mode
{
    return [self imageWithRenderingMode:mode];
}

@end
