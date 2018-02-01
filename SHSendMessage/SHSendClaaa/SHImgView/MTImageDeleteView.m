//
//  MTImageDeleteView.m
//  MTRealEstate
//
//  Created by LuKane on 16/7/25.
//  Copyright © 2016年 MaiTianMM. All rights reserved.
//

#import "MTImageDeleteView.h"

@implementation MTImageDeleteView

- (instancetype)init{
    if (self = [super init]) {
        [self setupSubViews];
        self.contentMode = UIViewContentModeScaleAspectFill;
    }
    return self;
}

- (void)setupSubViews{
    self.userInteractionEnabled = YES;
    UIImageView *deleteImg = [[UIImageView alloc] init];
    deleteImg.userInteractionEnabled = YES;
    deleteImg.frame = CGRectMake((ScreenWidth - (12 * 5)) * 0.25 - 15, 5, 15, 15);
    deleteImg.image = [UIImage imageNamed:@"circle_send_close2"];
    self.backgroundColor = [UIColor grayColor];
    _deleteImg = deleteImg;
    [self addSubview:deleteImg];
}

@end
