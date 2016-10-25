//
//  UCSIMDefine.h
//  ucsimlib
//
//  Created by FredZhang on 15/5/5.
//  Copyright (c) 2015年 ucpaas. All rights reserved.
//



/*!
 *  @brief  IM相关枚举
 */

#ifndef ucsimlib_UCSIMDefine_h
#define ucsimlib_UCSIMDefine_h


/*!
 @enum
 @brief    会话列表的类型
 @constant soloChatOnly        只获取单聊会话列表
 @constant groupChatOnly       只获取群聊会话列表
 @constant discussionChatOnly  只获取讨论组会话列表
 @constant broadcastChatOnly  只获取广播会话列表
 @constant UnknownConversationTypeOnly  只获取未知会话列表
 @constant solochatAndGroupChat  获取单聊和群会话列表
 @constant soloChatAndDiscussionChat       获取单聊和讨论组会话列表
 @constant groupChatAndDiscussionChat  获取群和讨论组会话列表
 @constant allChat       获取所有类型的会话列表
 */
typedef enum{
    soloChatOnly = 1,
    groupChatOnly ,
    discussionChatOnly,
    broadcastChatOnly,
    UnknownConversationTypeOnly,
    solochatAndGroupChat,
    soloChatAndDiscussionChat,
    groupChatAndDiscussionChat,
    allChat,
}UCS_IM_ConversationListType;


/*!
 @enum
 @brief    会话的类型
 @constant UCS_IM_SOLOCHAT        单聊，一对一聊天
 @constant UCS_IM_GROUPCHAT       群聊
 @constant UCS_IM_DISCUSSIONCHAT  讨论组聊天
 @constant UCS_IM_SYSTEMMSG       系统
 @constant UCS_IM_Broadcast       广播
 @constant UCS_IM_UnknownConversationType         未知类型
 */
typedef enum{
    UCS_IM_SOLOCHAT = 1,
    UCS_IM_GROUPCHAT = 2,
    UCS_IM_DISCUSSIONCHAT = 3,
    UCS_IM_SYSTEMMSG = 4,
    UCS_IM_Broadcast = 5,
    UCS_IM_UnknownConversationType = 10,
}UCS_IM_ConversationType;


/*!
 @enum
 @brief    聊天消息类型
 @constant UCS_IM_TEXT  文本消息
 @constant UCS_IM_IMAGE 图片消息
 @constant UCS_IM_VOICE 语音消息
 @constant UCS_IM_Location 位置信息
 @constant UCS_IM_Custom  自定义消息
 @constant UCS_IM_UnknownType 未知类型
 @constant UCS_IM_DiscussionNotification 讨论组通知，加人、踢人等
 @constant UCS_IM_Notification 全局通知，踢线等
 */
typedef enum{
    UCS_IM_TEXT = 1,
    UCS_IM_IMAGE = 3,
    UCS_IM_VOICE = 34,
    UCS_IM_Location = 48,
    UCS_IM_Custom = 49,
    UCS_IM_UnknownType = 10 ,
    UCS_IM_DiscussionNotification = 11,
    UCS_IM_Notification,
}UCS_IM_MsgType;




/*!
 @enum
 @brief    聊天消息接收状态
 @constant ReceivedStatus_UNREAD     未读(如果是语音消息,那么语音已经下载成功)
 @constant ReceivedStatus_READ       已读
 @constant ReceivedStatus_LISTENED   已听(用于语音消息)
 @constant ReceivedStatus_DOWNLOADED 已下载(用于语音消息)
 @constant ReceivedStatus_DOWNLOADING   正在下载(用于语音消息)
 @constant ReceivedStatus_DOWNLOADFail 下载失败(用于语音消息)
 @constant
 */
typedef enum{
    ReceivedStatus_UNREAD = 0,
    ReceivedStatus_READ = 1,
    ReceivedStatus_LISTENED = 2,
    ReceivedStatus_DOWNLOADED = 3,
    ReceivedStatus_DOWNLOADING = 4,
    ReceivedStatus_DOWNLOADFail = 5,
}UCSReceivedStatus;




/*!
 @enum
 @brief    聊天消息发送状态
 @constant SendStatus_success  发送成功
 @constant SendStatus_sending  正在发送中
 @constant SendStatus_fail     发送失败
 */
typedef enum{
    SendStatus_success = 0,
    SendStatus_sending = 1,
    SendStatus_fail = 2, 
}UCSSendStatus;



/*!
 @enum
 @brief    聊天消息发送方向
 @constant MessageDirection_SEND     发送
 @constant MessageDirection_RECEIVE  接收
 */
typedef enum {
    MessageDirection_SEND = 1,
    MessageDirection_RECEIVE
}UCSMessageDirection;



#endif
