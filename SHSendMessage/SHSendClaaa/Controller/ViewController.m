//
//  ViewController.m
//  SHSendMessage
//
//  Created by HaoSun on 2018/1/31.
//  Copyright © 2018年 YHKIT. All rights reserved.
//

#import "ViewController.h"
#import "SHSendMailHeaderCell.h"
#import "SHSendMailTextCell.h"
#import "SHSendMailAddCell.h"
#import <MessageUI/MessageUI.h>
#import "EasyMailSender.h"
#import "EasyMailAlertSender.h"
#import "SHSendMailHeader.h"
#import "SHSendMailModel.h"
#import "SKPSMTPMessage.h"
#import "NSData+Base64Additions.h"
 NSString *SHSendMailKey = @"SHSendMailKey";

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,SKPSMTPMessageDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *tableDataSource;
@property (nonatomic, strong) SHSendMailModel *mailModel;
@end

@implementation ViewController

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupController];
    NSUserDefaults *sendMailInfo = [NSUserDefaults standardUserDefaults];
    NSString *temp = [sendMailInfo objectForKey:SHSendMailKey];
    if (temp.length > 0) {
        SHSendMailModel * mailModel = [SHSendMailModel mj_objectWithKeyValues:temp];
        self.mailModel = mailModel;
    }else{
        SHSendMailModel * mailModel = [[SHSendMailModel alloc] init];
        self.mailModel = mailModel;
    }
    // Do any additional setup after loading the view.
    [self.tableView registerClass:[SHSendMailHeaderCell class] forCellReuseIdentifier:NSStringFromClass([SHSendMailHeaderCell class])];
    [self.tableView registerClass:[SHSendMailTextCell class] forCellReuseIdentifier:NSStringFromClass([SHSendMailTextCell class])];
    [self.tableView registerClass:[SHSendMailAddCell class] forCellReuseIdentifier:NSStringFromClass([SHSendMailAddCell class])];
}

- (void)dealloc {

}

#pragma mark setup controller
- (void)setupController {
    self.title = @"邮件发送";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *img = [[UIImage imageNamed:@"circle_send_start"] changeImageWithColor:[UIColor greenColor]];
    [btn setBackgroundImage:img forState:UIControlStateNormal];
    [btn setBackgroundImage:img forState:UIControlStateHighlighted];
    btn.frame = CGRectMake(0, 0, 30, 30);
    [btn addTarget:self action:@selector(sendAccusation) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

#pragma mark layout subviews
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    // Layout subviews in this method.
}

#pragma mark - button action

#pragma mark - gesture

#pragma mark - KVO

#pragma mark - noticfication

#pragma mark - data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        SHSendMailHeaderCell *headerCell = [SHSendMailHeaderCell cellWithTableView:_tableView];
        headerCell.mailModel = self.mailModel;
        return headerCell;
    }

    if (indexPath.row == 1) {
        SHSendMailTextCell *textCell = [SHSendMailTextCell cellWithTableView:_tableView];
        textCell.mailModel = self.mailModel;
        return textCell;
    }

    if (indexPath.row == 2) {
        SHSendMailAddCell *addCell = [SHSendMailAddCell cellWithTableView:_tableView];
        addCell.vc = self;
        addCell.mailModel = self.mailModel;
        return addCell;
    }
    return [UITableViewCell new];
}

#pragma mark - delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}


#pragma mark - model handler

#pragma mark - others

#pragma mark - setters

#pragma mark getters
- (UITableView *)tableView {
    if (_tableView == nil) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.estimatedRowHeight = 100.0f;
        tableView.estimatedSectionFooterHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.tableFooterView = [UITableViewHeaderFooterView new];
        [self.view addSubview:tableView];
        _tableView = tableView;
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.view);
            if (@available(iOS 11.0, *)) {
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            } else {
                make.bottom.equalTo(self.view);
            }
        }];
    }
    return _tableView;
}

- (NSArray *)tableDataSource {

    if (!_tableDataSource) {
        _tableDataSource = [NSArray array];
    }
    return _tableDataSource;

}

- (void)sendAccusation {
    [self sendMailForMe];
//    [self sendMail];
}

/**
 直接发送邮件
 */
- (void)sendMailForMe {
    SKPSMTPMessage *myMessage = [[SKPSMTPMessage alloc] init];
    myMessage.fromEmail = @"ocsh@qq.com";
    myMessage.toEmail = [_mailModel.toRecipients firstObject];
//    myMessage.bccEmail = @"ocsh@qq.com";
    myMessage.relayHost = @"smtp.qq.com";

    myMessage.requiresAuth=YES;
    if (myMessage.requiresAuth) {
        myMessage.login = @"ocsh@qq.com";
        myMessage.pass = @"axbzcseczehtbfha";
    }
    myMessage.wantsSecure = YES; //为gmail邮箱设置 smtp.gmail.com
    myMessage.subject = _mailModel.subjectTitle;
    myMessage.delegate = self;
    //设置邮件内容
    NSDictionary *plainPart = [NSDictionary dictionaryWithObjectsAndKeys:@"text/plain; charset=UTF-8",kSKPSMTPPartContentTypeKey,_mailModel.messageText,kSKPSMTPPartMessageKey,@"8bit",kSKPSMTPPartContentTransferEncodingKey,nil];
    myMessage.parts = [NSArray arrayWithObjects:plainPart,nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [myMessage send];
    });
}

/**
 使用MF发送邮件
 */
- (void)sendMail {
    EasyMailAlertSender *mailSender = [EasyMailAlertSender easyMail:^(MFMailComposeViewController *controller) {
        // Setup
        [controller setSubject:_mailModel.subjectTitle];
        [controller setToRecipients:_mailModel.toRecipients];
        [controller setMessageBody:_mailModel.messageText isHTML:NO];
        for (NSInteger index = 0; index < _mailModel.sendImages.count; index ++) {
            NSString *fileName2 = [NSString stringWithFormat:@"%ld.jpeg",index];
            UIImage *image = [_mailModel.sendImages objectAtIndex:index];
            NSData *data = UIImageJPEGRepresentation(image, 0.3);
            [controller addAttachmentData:data mimeType:@"image/jpeg" fileName:fileName2];
        }
        NSUserDefaults *sendMailInfo = [NSUserDefaults standardUserDefaults];
        SHSendMailModel *model = [SHSendMailModel new];
        model.subjectTitle = _mailModel.subjectTitle;
        model.toRecipients = _mailModel.toRecipients;
        [sendMailInfo setObject:[model mj_JSONString] forKey:SHSendMailKey];
    } complete:^(MFMailComposeViewController *controller, MFMailComposeResult result, NSError *error) {
        [controller dismissViewControllerAnimated:YES completion:nil];
    }];
    [mailSender showFromViewController:self competion:^{
        UIAlertController *alVc = [UIAlertController alertControllerWithTitle:@"信息提示" message:@"邮件发送成功" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alVc addAction:okAction];
        [self presentViewController:alVc animated:YES completion:^{

        }];

    }];

}

- (void)messageSent:(SKPSMTPMessage *)message {

    NSUserDefaults *sendMailInfo = [NSUserDefaults standardUserDefaults];
    SHSendMailModel *model = [SHSendMailModel new];
    model.subjectTitle = _mailModel.subjectTitle;
    model.toRecipients = _mailModel.toRecipients;
    [sendMailInfo setObject:[model mj_JSONString] forKey:SHSendMailKey];
    UIAlertController *alVc = [UIAlertController alertControllerWithTitle:@"信息提示" message:@"邮件发送成功" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alVc addAction:okAction];
    [self presentViewController:alVc animated:YES completion:^{

    }];
}

- (void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error {

    UIAlertController *alVc = [UIAlertController alertControllerWithTitle:@"信息提示" message:@"邮件发送失败" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alVc addAction:okAction];
    [self presentViewController:alVc animated:YES completion:^{

    }];
}

@end
