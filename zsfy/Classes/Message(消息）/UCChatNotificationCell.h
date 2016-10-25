//
//  UCChatNotificationCell.h
//  UC_Demo_1.0.0
//
//  Created by Barry on 15/5/23.
//  Copyright (c) 2015年 Barry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"

@interface UCChatNotificationCell : UITableViewCell

@property (nonatomic, strong) MessageModel * model; //通知模型

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath withObject:(MessageModel *)model;


+ (CGFloat)lineSpacing;
+ (UIFont *)textLabelFont;

@end
