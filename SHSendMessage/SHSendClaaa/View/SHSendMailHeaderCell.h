//
//  SHSendMailHeaderCell.h
//  SHSendMessage
//
//  Created by HaoSun on 2018/1/31.
//  Copyright © 2018年 YHKIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHSendMailModel.h"
@interface SHSendMailHeaderCell : UITableViewCell

/*创建TableviewCell**/
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) SHSendMailModel *mailModel;
@end
