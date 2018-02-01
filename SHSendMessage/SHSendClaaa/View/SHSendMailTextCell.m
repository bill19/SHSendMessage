//
//  SHSendMailTextCell.m
//  SHSendMessage
//
//  Created by HaoSun on 2018/1/31.
//  Copyright © 2018年 YHKIT. All rights reserved.
//

#import "SHSendMailTextCell.h"
#import "SHTextView.h"
#import "Masonry.h"
@interface SHSendMailTextCell ()<UITextViewDelegate>
@property (weak, nonatomic) SHTextView *contenTxtView;
@end

@implementation SHSendMailTextCell


+ (instancetype)cellWithTableView:(UITableView *)tableView {

    NSString *ID = NSStringFromClass([SHSendMailTextCell class]);

    SHSendMailTextCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SHSendMailTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
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
    SHTextView *contenTxtView = [[SHTextView alloc] init];
    contenTxtView.placeholder = @"输入您要发送的文字...";
    contenTxtView.placeholderFont = [UIFont systemFontOfSize:15];
    contenTxtView.placeholderColor = [UIColor grayColor];
//    contenTxtView.backgroundColor = [UIColor greenColor];
    contenTxtView.delegate = self;
    _contenTxtView = contenTxtView;
    [self.contentView addSubview:_contenTxtView];
}

#pragma mark - Layout
- (void)setupLayout {
    CGFloat padding = 10.0f;
    CGFloat kToTextField =  300.0f;
    [_contenTxtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(padding);
        make.right.equalTo(self.contentView.mas_right).offset(-padding);
        make.top.equalTo(self.contentView.mas_top).offset(padding);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-padding);
        make.height.equalTo(@(kToTextField));
    }];

}
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.markedTextRange == nil) {
        _mailModel.messageText = textView.text;
    }
}

- (void)setMailModel:(SHSendMailModel *)mailModel {
    _mailModel = mailModel;
    _contenTxtView.text = _mailModel.messageText;
}
@end
