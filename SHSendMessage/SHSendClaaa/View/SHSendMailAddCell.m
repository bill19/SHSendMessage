//
//  SHSendMailAddCell.m
//  SHSendMessage
//
//  Created by HaoSun on 2018/1/31.
//  Copyright © 2018年 YHKIT. All rights reserved.
//

#import "SHSendMailAddCell.h"
#import "Masonry.h"
#import "MTAddImgView.h"
@interface SHSendMailAddCell ()<MTAddImgViewDelegate>
@property (nonatomic, weak) MTAddImgView *addimageView ;
@end

@implementation SHSendMailAddCell


+ (instancetype)cellWithTableView:(UITableView *)tableView {

    NSString *ID = NSStringFromClass([SHSendMailAddCell class]);
    SHSendMailAddCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SHSendMailAddCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setAccessoryType:UITableViewCellAccessoryNone];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setupSubViews];
        [self setupLayout];
    }
    return self;
}

#pragma mark - UISetup
- (void)setupSubViews {
    MTAddImgView *addimageView  = [[MTAddImgView alloc] initWithController:self.vc];
    addimageView.maxPhoto = 9;
    addimageView.delegate = self;
    _addimageView = addimageView;
    [self.contentView addSubview:_addimageView];
}

- (void)getSendMailImages:(NSArray *)images {
    _mailModel.sendImages = images;
}

#pragma mark - Layout
- (void)setupLayout {
    [_addimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10.0f);
        make.right.equalTo(self.contentView.mas_right).offset(-10.0f);
        make.top.bottom.equalTo(self.contentView);
        make.height.equalTo(@300.0f);
    }];

}
- (void)setMailModel:(SHSendMailModel *)mailModel {
    _mailModel = mailModel;

}

- (void)setVc:(UIViewController *)vc {
    _vc = vc;
    _addimageView.viewController = _vc;
}
@end
