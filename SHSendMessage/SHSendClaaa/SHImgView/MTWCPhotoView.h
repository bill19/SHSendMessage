//
//  MTWCPhotoView.h
//  MTRealEstate
//
//  Created by LuKane on 16/7/25.
//  Copyright © 2016年 MaiTianMM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "SHSendMailHeader.h"
@protocol MTWCPhotosViewDelegate <NSObject>

@optional

- (void)photoViewRemoveImageByIndex:(NSInteger)index;

@end

@interface MTWCPhotoView : UIView

- (void)addImage:(UIImage *)image;
- (void)removeObjectAtIndex:(NSInteger)index;
- (void)removeAllImage;

- (NSArray *)images;

@property (nonatomic, weak) id<MTWCPhotosViewDelegate> delegate;

@end
