//
//  NotificationTVC.h
//  zsfy
//
//  Created by 曾祺植 on 1/29/16.
//  Copyright © 2016 wzy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NotificationModel;

@interface NotificationTVC : UITableViewCell

@property (nonatomic, strong) NotificationModel *NoteItem;



- (void)setInfo;

@end
