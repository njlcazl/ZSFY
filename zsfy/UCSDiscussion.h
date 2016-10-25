//
//  UCSDiscussion.h
//  ucsimlib
//
//  Created by FredZhang on 15/5/5.
//  Copyright (c) 2015年 ucpaas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UCSIMDefine.h"

/*!
 *  @brief  讨论组类型
 */

@interface UCSDiscussion : NSObject

/*!
 *  @brief  讨论组ID
 */
@property(nonatomic, copy) NSString *discussionId;

/*!
 *  @brief  讨论组名称
 */
@property(nonatomic, copy) NSString *discussionName;

/*!
 *  @brief  创建讨论组用户ID 
 */
@property(nonatomic, copy) NSString *creatorId;

/*!
 *  @brief  会话类型
 */
@property(nonatomic, assign) UCS_IM_ConversationType conversationType;

/*!
 *  @brief  讨论组成员列表,每个元素是一个UCSUserInfo对象
 */
@property(nonatomic, strong) NSArray *memberList;

/*!
 *  @brief  保留字段（未被使用）
 */
@property(nonatomic, assign) int inviteStatus;

/*!
 *  @brief  保留字段(未被使用)
 */
@property(nonatomic, assign) int pushMessageNotificationStatus;

/*!
 *  @brief  保留字段(未被使用)
 */
@property(nonatomic, copy) NSString *extra;

@end
