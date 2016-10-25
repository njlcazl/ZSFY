//
//  UCSNotificationMessage.h
//  ucsimlib
//
//  Created by FredZhang on 15/5/25.
//  Copyright (c) 2015年 ucpaas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UCSMsgContent.h"



/*!
 @enum
 @brief    事件通知
 @constant UCSKickOffNotification     账户别处登录，被踢线
 */
typedef enum{
    UCSKickOffNotification = 1,
}UCSNotificationMessageType;



/*!
 *  @brief  通知消息类型
 */
@interface UCSNotificationMessage : UCSMsgContent

/*!
 *   @brief  通知类型
 */
@property(nonatomic, assign) UCSNotificationMessageType type;

/*!
 *   @brief  扩展字段，用于存储服务器下发扩展信息
 */
@property(nonatomic, copy) NSString *extension;

@end
