//
//  MTWCPhotoView.m
//  MTRealEstate
//
//  Created by LuKane on 16/7/25.
//  Copyright © 2016年 MaiTianMM. All rights reserved.
//

#import "MTWCPhotoView.h"
#import "MTImageDeleteView.h"
#import "SHSendMailHeader.h"
#import "UIView+PBExtesion.h"
@implementation MTWCPhotoView

- (void)removeAllImage{
    for (NSInteger i = 0 ; i < self.subviews.count; i++) {
        [self.subviews[i] removeFromSuperview];
    }
    
}

- (void)addImage:(UIImage *)image{
    MTImageDeleteView *imageView = [[MTImageDeleteView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.image = image;
    [self addSubview:imageView];
}

- (void)removeObjectAtIndex:(NSInteger)index{
    [self.subviews[index] removeFromSuperview];
    [self layoutSubviews];
}

- (NSArray *)images{
    return [self.subviews valueForKeyPath:@"image"];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    int maxCols = 4;
    CGFloat leftRightMargin = 10;
    CGFloat imageMargin = 10;
    CGFloat imageW = (ScreenWidth - 2 * leftRightMargin - (maxCols - 1) * imageMargin)/maxCols;
    CGFloat imageH = imageW;
    
    for (NSUInteger i = 0; i < self.subviews.count; i++) {
        MTImageDeleteView *imageView = self.subviews[i];
        imageView.tag = i;
        imageView.userInteractionEnabled = YES;
        imageView.deleteImg.tag = imageView.tag;
        [imageView.deleteImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTap:)]];
        // 内容模式：填充这个imageView
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.width = imageW;
        imageView.height = imageH;
        imageView.x = leftRightMargin + (i % maxCols) * (imageW + imageMargin);
        imageView.y = (i / maxCols) * (imageH + imageMargin) + 10;
    }
}

- (void)imageViewTap:(UITapGestureRecognizer *)tap{
    if ([_delegate respondsToSelector:@selector(photoViewRemoveImageByIndex:)]) {
        [_delegate photoViewRemoveImageByIndex:tap.view.tag];
    }
}

@end
