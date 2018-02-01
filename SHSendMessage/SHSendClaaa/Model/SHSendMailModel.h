//
//  SHSendMailModel.h
//  SHSendMessage
//
//  Created by HaoSun on 2018/1/31.
//  Copyright © 2018年 YHKIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface SHSendMailModel : NSObject

/**
 主题
 */
@property (nonatomic, copy) NSString *subjectTitle;

/**
  收件人数组
 */
@property (nonatomic, strong) NSArray *toRecipients;

/**
 消息主题内容
 */
@property (nonatomic, copy) NSString *messageText;

/**
 发送图片数组
 */
@property (nonatomic, strong) NSArray<UIImage *> *sendImages;
@end
