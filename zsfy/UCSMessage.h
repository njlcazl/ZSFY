//
//  UCSMessage.h
//  ucsimlib
//
//  Created by FredZhang on 15/5/5.
//  Copyright (c) 2015年 ucpaas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UCSMsgContent.h"
#import "UCSIMDefine.h"

/*!
 *   @brief  IM消息元数据,用于描述消息的所有信息
 */

@interface UCSMessage : NSObject

/*!
 *  @brief  消息对应的会话类型。单聊会话、讨论组会话、群会话
 */
@property(nonatomic, assign) UCS_IM_ConversationType conversationType;

/*!
 *  @brief  消息的类型。文本、语音、图片、通知等
 */
@property(nonatomic, assign) UCS_IM_MsgType messageType;

/*!
 *  @brief  目标ID。(如果这条消息是群组消息，receiveId是群id;如果这条消息是单聊消息，receveId是消息接收者的id;如果这条消息是讨论组消息，receveId是讨论组Id)
 */
@property(nonatomic, copy) NSString *receiveId;

/*!
 *  @brief  消息ID。这条消息的唯一标识。
 */
@property(nonatomic, assign) long long messageId;

/*!
 *  @brief  消息方向。判断是发送的消息，还是接收的消息
 */
@property(nonatomic, assign) UCSMessageDirection messageDirection;

/*!
 *  @brief  发送者ID。这条消息是谁发的。
 */
@property(nonatomic, copy) NSString *senderUserId;

/*!
 *  @brief  发送者昵称。发送这条消息的人的昵称。可能为空。
 */
@property(nonatomic, copy) NSString *senderNickName;

/*!
 *   @brief  接收状态。仅仅用于接收消息，判断接收状态。
 */
@property(nonatomic, assign) UCSReceivedStatus receivedStatus;

/*!
 *  @brief  发送状态。仅仅用于自己发送消息时,判断发送状态。
 */
@property(nonatomic, assign) UCSSendStatus sentStatus;

/*!
 *  @brief  时间
 */
@property(nonatomic, assign) long long time;

/*!
 *  @brief  消息体名称(保留字段，暂时没有被使用)
 */
@property(nonatomic, copy) NSString *objectName;

/*!
 *  @brief  消息内容。这个字段包含一个UCSMsgContent的子类的对象。如果这个会话对应的消息类型是文本，那么这个字段存储的就是一个UCSTextMsg类型的对象；如果是图片，就是一个UCSImageMsg类型的对象；如果是语音，就是一个UCSVoiceMsg类型的对象。开发者可以解析这个对象，然后自定义展示在UI上。
 */
@property(nonatomic, strong) UCSMsgContent *content;

/*!
 *  @brief  附加字段(保留字段,暂时未使用)
 */
@property(nonatomic, copy) NSString *extra;



@end
