//
//  UIImage+ChangeImage.h
//  MaiTian
//
//  Created by 姜泽东 on 2017/10/16.
//  Copyright © 2017年 YL. All rights reserved.
//

#import <UIKit/UIKit.h>

//有时候图片的显示格式可能不正确 需要转成Apple支持的格式
NS_INLINE UIImage * resetImageScale(UIImage *image){
    CGSize scaledSize = CGSizeMake(image.size.width * image.scale, image.size.height * image.scale);
    UIGraphicsBeginImageContextWithOptions( scaledSize, NO, 1 );
    CGRect scaledImageRect = CGRectMake( 0.0, 0.0, scaledSize.width, scaledSize.height );
    [image drawInRect:scaledImageRect];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

//截图
NS_INLINE UIImage * imageFromUIView(UIView * view,float scale){
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(floorf(view.frame.size.width), floorf(view.frame.size.height)), NO, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resetImageScale(snapshotImage);
}

//截图时图片需要的扩大倍数
NS_INLINE CGFloat imageMaxScaleWithViewSize(UIImage *image,CGSize viewSize){
    CGFloat wScale = (image.size.width * image.scale) / viewSize.width;
    CGFloat hScale = (image.size.height * image.scale) / viewSize.height;
    return roundf(MAX(wScale, hScale));
}

//图片实际的缩放倍数
NS_INLINE CGFloat imageMinScaleWithViewSize(UIImage *image,CGSize viewSize) {
    CGFloat scale = MIN(viewSize.width / image.size.width * image.scale,
                        viewSize.height / image.size.height * image.scale);
    return scale;
}

@interface UIImage (ChangeImage)

//修改图片颜色
- (UIImage *)changeImageWithColor:(UIColor *)color;

/**
 图片渲染模式
 
 UIImageRenderingModeAutomatic,
 //始终绘制图片原始状态,不使用Tint Color
 UIImageRenderingModeAlwaysOriginal,
 //始终根据Tint Color绘制图片,忽略图片的颜色信息
 UIImageRenderingModeAlwaysTemplate,
 
 @param mode UIImageRenderingMode
 */
- (UIImage *)renderMode:(UIImageRenderingMode)mode;

/**
 修改图片尺寸
 
 @param newSize 新的尺寸
 @return 修改后的图片
 */
- (UIImage *)resizedImageToSize:(CGSize)newSize;


- (UIImage *)imageWithRoundedCorner:(CGFloat)radius;

@end
