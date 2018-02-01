//
//  MTAddImgView.h
//  MTRealEstate
//
//  Created by HaoSun on 2017/6/8.
//  Copyright © 2017年 MaiTianMM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "SHSendMailHeader.h"
#import "MTWCPhotoView.h"
#import "ACActionSheet.h"
#import "ZYQAssetPickerController.h"

@protocol MTAddImgViewDelegate <NSObject>
@optional
- (void)getSendMailImages:(NSArray *)images;

@end

@interface MTAddImgView : UIView
- (instancetype)initWithController:(UIViewController *)viewController;
@property (nonatomic, assign) NSInteger maxPhoto;//默认是9
@property (nonatomic, strong) NSMutableArray *imageArray;// 这个是为了获取的，请不要传数值
@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, weak) id <MTAddImgViewDelegate> delegate;
@end
