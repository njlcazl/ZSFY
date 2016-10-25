//
//  UCSConversation.h
//  ucsimlib
//
//  Created by FredZhang on 15/5/5.
//  Copyright (c) 2015年 ucpaas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UCSMsgContent.h"
#import "UCSConversation.h"
#import "UCSIMDefine.h"

/*!
 *  @brief  会话类，每一个会话对应一个聊天
 */

@interface UCSConversation : NSObject


/*!
*  @brief  会话类型。单聊会话、讨论组会话、群会话
*/
@property(nonatomic, assign) UCS_IM_ConversationType conversationType;


/*!
 *  @brief  会话 Id。(单聊就是对方id,讨论组是讨论组id,群聊就是群组id)
 */
@property(nonatomic, copy) NSString *targetId;


/*!
 *  @brief  会话名称。
 */
@property(nonatomic, copy) NSString *conversationTitle;


/*!
 *  @brief  会话中未读消息数
 */
@property(nonatomic, assign) NSInteger unreadMessageCount;


/*!
 *  @brief  当前会话是否置顶
 */
@property(nonatomic, assign) BOOL isTop;


/*!
 *  @brief  消息接收状态。(仅仅用于接收消息，判断接收状态。)
 */
@property(nonatomic, assign) UCSReceivedStatus receivedStatus;


/*!
 *  @brief  消息发送状态。(仅仅用于自己发送消息时,判断发送状态。)
 */
@property(nonatomic, assign) UCSSendStatus sentStatus;


/*!
 *  @brief  时间.(如果这条消息是自己发送的,为自己发送该条消息的时间;如果这条消息是接收的,为对方发送这条消息的时间)
 */
@property (nonatomic, assign) long long time;


/*!
 *  @brief  消息草稿，尚未发送的消息内容。如果开发者需要使用这个字段，应该调用UCSIMClient.h中相关的接口操作消息草稿。
 */
@property(nonatomic, copy) NSString *draft;

/*!
 *  @brief  会话实体名(保留字段，暂时未使用)
 */
@property(nonatomic, copy) NSString *objectName;


 /*!
 *  @brief  当前会话最近的一条消息的发送者Id
 */
@property(nonatomic, copy) NSString *senderUserId;


/*!
 *  @brief   当前会话最近的一条消息发送者昵称
 */
@property(nonatomic, copy) NSString *senderUserName;


/*!
 *  @brief  当前会话最近一条消息实体的消息类型。具体参考UCS_IM_MsgType
 */
@property(nonatomic, assign) UCS_IM_MsgType lastestMessageType;

/*!
 *  @brief  当前会话最近一条消息的消息Id。当前会话对应的那条消息的messageId
 */
@property(nonatomic, assign) long long lastestMessageId;


/*!
 *  @brief  当前会话最近一条消息实体。这个字段是当前会话最近的一条聊天消息内容,是一个UCSMsgContent子类的对象。如果这个会话对应的消息类型是文本，那么这个字段存储的就是一个UCSTextMsg类型的对象；如果是图片，就是一个UCSImageMsg类型的对象；如果是语音，就是一个UCSVoiceMsg类型的对象。开发者可以解析这个对象，然后自定义展示在UI上。
 */
@property(nonatomic, strong) UCSMsgContent *lastestMessage;



@end
