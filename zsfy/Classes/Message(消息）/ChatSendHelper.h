//
//  ChatSendHelper.h
//  IMDemo_UI
//
//  Created by Barry on 15/4/20.
//  Copyright (c) 2015年 Barry. All rights reserved.
//




#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "UCSIMSDK.h"

@class ChatSendHelper;

@protocol ChatSendHelperDelegate <NSObject>

/**
 *  发送的消息状态发送了变化，用来检测消息的发送成功、失败
 *
 *  @param sendHelper <#sendHelper description#>
 *  @param success    yes 成功， no失败
 *  @param messageId  这条消息的messageId
 */
- (void)chatSendHelper:(ChatSendHelper *) sendHelper sendStatusDidChanged:(BOOL) success MessageId:(long long) messageId error:(UCSErrorCode) error;

/*!
 *  @brief  重发的消息状态变化了
 *
 *  @param sendHelper   <#sendHelper description#>
 *  @param success      <#success description#>
 *  @param oldMessageId 旧的messageid
 *  @param newMessageId 新的messageid
 *  @param error        <#error description#>
 */
- (void)chatSendHelper:(ChatSendHelper *)sendHelper reSendStatusDidChanged:(BOOL)success oldMessageId:(long long)oldMessageId  newMessageId:(long long)newMessageId error:(UCSErrorCode)error;

@end


@interface ChatSendHelper : NSObject

@property (weak, nonatomic) id<ChatSendHelperDelegate> ChatListDelegate; //通知会话界面
@property (weak, nonatomic) id<ChatSendHelperDelegate> ChatViewDelegate; //通知聊天界面

singleton_interface(ChatSendHelper)


- (UCSMessage * )sendText:(NSString *) text conversationType:(UCS_IM_ConversationType) conversationType  targetId:(NSString *) targetId ;


- (UCSMessage * )sendImage:(UIImage *) image conversationType:(UCS_IM_ConversationType) conversationType  targetId:(NSString *) targetId;


- (UCSMessage * )sendVoice:(NSString *) voicePath duration:(NSTimeInterval) duration conversationType:(UCS_IM_ConversationType) conversationType  targetId:(NSString *) targetId ;


/**
 *  重发一条消息
 *
 *  @param message      消息体
 *  @param oldMessageId 旧的messageid,因为重发消息返回的messageid，不是新的messageid，所以我们传一个旧的messageid回去
 *
 *  @return <#return value description#>
 */
- (UCSMessage *)resendMessage:(UCSMessage *) message oldMessageId:(long long) oldMessageId;


@end
