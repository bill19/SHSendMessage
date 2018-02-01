//
//  SHSendMailHeaderCell.m
//  SHSendMessage
//
//  Created by HaoSun on 2018/1/31.
//  Copyright © 2018年 YHKIT. All rights reserved.
//

#import "SHSendMailHeaderCell.h"
#import "Masonry.h"
@interface SHSendMailHeaderCell ()<UITextFieldDelegate>

/**
 收件人地址
 */
@property (nonatomic, weak) UITextField *toTextField;

@property (nonatomic, weak) UIView *toTextFieldLine;
/**
  主题
 */
@property (nonatomic, weak) UITextField *titleTextField;

@property (nonatomic, weak) UIView *titleTextFieldLine;
@end

@implementation SHSendMailHeaderCell


+ (instancetype)cellWithTableView:(UITableView *)tableView {

    NSString *ID = NSStringFromClass([SHSendMailHeaderCell class]);

    SHSendMailHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SHSendMailHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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

    UITextField *toTextField = [[UITextField alloc] init];
    toTextField.placeholder = @"邮件地址";
    toTextField.delegate = self;
    toTextField.keyboardType = UIKeyboardTypeEmailAddress;
    _toTextField = toTextField;
    [self.contentView addSubview:_toTextField];

    UIView *toTextFieldLine = [[UIView alloc] init];
    toTextFieldLine.backgroundColor = [UIColor grayColor];
    toTextFieldLine.alpha = .3;
    _toTextFieldLine = toTextFieldLine;
    [self.contentView addSubview:_toTextFieldLine];

    UITextField *titleTextField = [[UITextField alloc] init];
    titleTextField.placeholder = @"请输入您的主题";
    titleTextField.delegate = self;
    _titleTextField = titleTextField;
    [self.contentView addSubview:_titleTextField];

    UIView *titleTextFieldLine = [[UIView alloc] init];
    titleTextFieldLine.backgroundColor = [UIColor grayColor];
    titleTextFieldLine.alpha = .3;
    _titleTextFieldLine = titleTextFieldLine;
    [self.contentView addSubview:_titleTextFieldLine];
    [self addTargetMethod];
}

#pragma mark - Layout
- (void)setupLayout {
    CGFloat padding = 10.0f;
    CGFloat kToTextField =  40.0f;
    [_toTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(padding);
        make.right.equalTo(self.contentView.mas_right).offset(-padding);
        make.top.equalTo(self.contentView.mas_top).offset(padding);
        make.height.equalTo(@(kToTextField));
    }];

    [_toTextFieldLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_toTextField.mas_bottom);
        make.height.equalTo(@(1.0f));
        make.left.right.equalTo(_toTextField);
    }];

    [_titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(padding);
        make.right.equalTo(self.contentView.mas_right).offset(-padding);
        make.top.equalTo(_toTextField.mas_bottom).offset(padding);
        make.height.equalTo(@(kToTextField));
    }];

    [_titleTextFieldLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleTextField.mas_bottom);
        make.height.equalTo(@(1.0f));
        make.left.right.equalTo(_titleTextField);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-padding);
    }];
}
#pragma mark - 直接添加监听方法
- (void)addTargetMethod {
    [self.toTextField addTarget:self action:@selector(textField1TextChange:) forControlEvents:UIControlEventEditingChanged];
    [self.titleTextField addTarget:self action:@selector(textField1TextChange:) forControlEvents:UIControlEventEditingChanged];
}
- (void)textField1TextChange:(UITextField *)textField {

    if (textField == self.toTextField) {
        _mailModel.toRecipients = [textField.text componentsSeparatedByString:@","];
    }
    if (textField == self.titleTextField) {
        _mailModel.subjectTitle = textField.text;
    }
}
- (void)setMailModel:(SHSendMailModel *)mailModel {
    _mailModel = mailModel;
    _toTextField.text = [_mailModel.toRecipients componentsJoinedByString:@","];
    _titleTextField.text = _mailModel.subjectTitle;
}

@end
