# SHSendMessage
制作一款能自己发邮件的app
[简书地址-](https://www.jianshu.com/p/4fb7a5dec287)
###生活中每做一件小事儿，聚沙成塔也能成就一件大事儿。
####最近一年真的是特别特别忙，但是也在这一块时间做了两件小事儿。
####其中一件小事儿就是制作了一下iOS关于邮件发送的相关内容。
[iOS发邮件点击链接进入项目](https://github.com/bill19/SHSendMessage)

#大图开张
![发个邮件哟-0.png](http://upload-images.jianshu.io/upload_images/693139-dda687c4dbd4b1b5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###那么开始吧
####使用邮件系统参考有两种方式
=============================================
####一种是调用iPhone原生的邮件页面
####一种是调用非原生的邮件功能，实现邮件的发送
假如当成一个产品，或者当成一个模块来设计这个发邮件的功能应该分为下面几块内容。
先当做一个简单的app来设计：
![发个U件哟.png](http://upload-images.jianshu.io/upload_images/693139-b218719cd8675dc5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

为了学习发邮件功能，我们将两种方式都进行编写，下面进行比较
![技术优缺点比较.001.jpeg](http://upload-images.jianshu.io/upload_images/693139-dd75a9730eedfd52.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

####关于UI搭建，根据简洁的原则，我们分为三个模块如下：
![发个邮件哟-1@2x.png](http://upload-images.jianshu.io/upload_images/693139-3c4046b91da44a3f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

非常简单的三个小模块
1-添加收件人邮箱
2-邮件的主题文字
3-增加图片附件

使用MF(也就是原生)发送核心代码如下
```
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
```

使用非原生核心代码如下

```
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
    NSString *mailBody = _mailModel.messageText.length>0?_mailModel.messageText:@"";

    NSMutableArray *mu = [NSMutableArray array];
    //设置邮件内容
    NSDictionary *plainPart = [NSDictionary dictionaryWithObjectsAndKeys:@"image/jpeg; charset=UTF-8",kSKPSMTPPartContentTypeKey,mailBody,kSKPSMTPPartMessageKey,@"8bit",kSKPSMTPPartContentTransferEncodingKey,nil];
    //添加图片
    for (NSInteger index = 0; index < _mailModel.sendImages.count; index ++) {
        NSString *fileName2 = [NSString stringWithFormat:@"attachment;\r\n\tfilename=\"%ld.jpeg\"",index];
        UIImage *image = [_mailModel.sendImages objectAtIndex:index];
        NSData *imgData = UIImageJPEGRepresentation(image, 0.3);
        NSDictionary *imagePart = [NSDictionary dictionaryWithObjectsAndKeys:@"image/jpg;\r\n\tx-unix-mode=0644;\r\n\tname=\"test.jpg\"",kSKPSMTPPartContentTypeKey,
                                   fileName2,kSKPSMTPPartContentDispositionKey,[imgData encodeBase64ForData],kSKPSMTPPartMessageKey,@"base64",kSKPSMTPPartContentTransferEncodingKey,nil];
        [mu addObject:imagePart];
    }

    [mu addObject:plainPart];

    myMessage.parts = [NSArray arrayWithArray:mu];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [myMessage send];
    });
}
```

一切内容都以代码为实际依据来进行编写。






