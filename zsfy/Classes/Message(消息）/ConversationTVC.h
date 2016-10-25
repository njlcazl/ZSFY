//
//  ConversationTVC.h
//  ucpaas_IM
//
//  Created by 曾祺植 on 8/21/15.
//  Copyright (c) 2015 曾祺植. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCSIMSDK.h"
@class ConversationTVC;

@protocol ConversationCellDelegate<NSObject>

// 通知cell被点击，执行删除操作
- (void) updateBadge;

@end


@interface ConversationTVC : UITableViewCell

@property (nonatomic, strong) UCSConversation *conversationItem;
@property (nonatomic, assign) id<ConversationCellDelegate>delegate;

- (void)setInfo;

- (void)setPushInfo:(UIView *)Superview;

- (void)hideBadge;

- (void)showBadge;

@end
