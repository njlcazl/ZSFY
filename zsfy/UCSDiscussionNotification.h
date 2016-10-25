//
//  UCSDiscussionNotification.h
//  ucsimlib
//
//  Created by FredZhang on 15/5/23.
//  Copyright (c) 2015年 ucpaas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UCSMsgContent.h"



/*!
 *  @brief  讨论组通知类。
 */
@interface UCSDiscussionNotification : UCSMsgContent


/*!
 *  @brief  讨论组的id
 */
@property(nonatomic, copy) NSString *operatorId;

/*!
 *  @brief  扩展字段，用于存储服务器下发扩展信息。比如“张三 移除了 李四”。
 */
@property(nonatomic, copy) NSString *extension;


@end
