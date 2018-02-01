//
//  SHTextView.h
//  SHSendMessage
//
//  Created by HaoSun on 2018/1/31.
//  Copyright © 2018年 YHKIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHTextView : UITextView

/**
 *  textView 中的提示语
 */
@property (strong, nonatomic) NSString * placeholder;

/**
 *  textView 中提示语的颜色
 */
@property (strong, nonatomic)UIColor * placeholderColor;

/**
 *  textView 中提示语的字号
 */
@property (strong, nonatomic)UIFont * placeholderFont;
@end
