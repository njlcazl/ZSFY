//
//  ChatSendHelper.m
//  IMDemo_UI
//
//  Created by Barry on 15/4/20.
//  Copyright (c) 2015年 Barry. All rights reserved.
//

#import "ChatSendHelper.h"
#import "NSString+Emojize.h"

@implementation ChatSendHelper

singleton_implementation(ChatSendHelper)

- (UCSMessage * )sendText:(NSString *) text conversationType:(UCS_IM_ConversationType) conversationType  targetId:(NSString *) targetId
{
    UCSTextMsg *aText = [[UCSTextMsg alloc]init];
    
    //转换内置字符串为通用字符串
    NSString * aliasedString =  [text aliasedString];
    aText.content = aliasedString;
    
    return [[UCSIMClient sharedIM] sendMessage:conversationType receiveId:targetId msgType:UCS_IM_TEXT content:aText success:^(long long messageId) {
        
        if (_ChatListDelegate && [_ChatListDelegate respondsToSelector:@selector(chatSendHelper:sendStatusDidChanged:MessageId:error:)]) {
            [_ChatListDelegate chatSendHelper:self sendStatusDidChanged:YES MessageId:messageId error:0];
        }
        
        if (_ChatViewDelegate && [_ChatViewDelegate respondsToSelector:@selector(chatSendHelper:sendStatusDidChanged:MessageId:error:)]) {
            [_ChatViewDelegate chatSendHelper:self sendStatusDidChanged:YES MessageId:messageId error:0];
        }
        
    } failure:^(UCSError *error, long long messageId) {
        
        if (_ChatListDelegate && [_ChatListDelegate respondsToSelector:@selector(chatSendHelper:sendStatusDidChanged:MessageId:error:)]) {
            [_ChatListDelegate chatSendHelper:self sendStatusDidChanged:NO MessageId:messageId error:error.code];
        }
        
        if (_ChatViewDelegate && [_ChatViewDelegate respondsToSelector:@selector(chatSendHelper:sendStatusDidChanged:MessageId:error:)]) {
            [_ChatViewDelegate chatSendHelper:self sendStatusDidChanged:NO MessageId:messageId error:error.code];
        }
        
    }];
    
}


- (UCSMessage * )sendImage:(UIImage *) image conversationType:(UCS_IM_ConversationType) conversationType  targetId:(NSString *) targetId
{
    UCSImageMsg * imageMsg = [[UCSImageMsg alloc]init];
    imageMsg.originalImage = image;
    return  [[UCSIMClient sharedIM] sendMessage:conversationType receiveId:targetId msgType:UCS_IM_IMAGE content:imageMsg  success:^(long long messageId) {
        
        if (_ChatListDelegate && [_ChatListDelegate respondsToSelector:@selector(chatSendHelper:sendStatusDidChanged:MessageId:error:)]) {
            [_ChatListDelegate chatSendHelper:self sendStatusDidChanged:YES MessageId:messageId error:0];
        }
        
        if (_ChatViewDelegate && [_ChatViewDelegate respondsToSelector:@selector(chatSendHelper:sendStatusDidChanged:MessageId:error:)]) {
            [_ChatViewDelegate chatSendHelper:self sendStatusDidChanged:YES MessageId:messageId error:0];
        }
        
    } failure:^(UCSError *error, long long messageId) {
        
        if (_ChatListDelegate && [_ChatListDelegate respondsToSelector:@selector(chatSendHelper:sendStatusDidChanged:MessageId:error:)]) {
            [_ChatListDelegate chatSendHelper:self sendStatusDidChanged:NO MessageId:messageId error:error.code];
        }
        
        if (_ChatViewDelegate && [_ChatViewDelegate respondsToSelector:@selector(chatSendHelper:sendStatusDidChanged:MessageId:error:)]) {
            [_ChatViewDelegate chatSendHelper:self sendStatusDidChanged:NO MessageId:messageId error:error.code];
        }
    }];
}


- (UCSMessage * )sendVoice:(NSString *) voicePath duration:(NSTimeInterval) duration conversationType:(UCS_IM_ConversationType) conversationType  targetId:(NSString *) targetId
{
    NSData *data = [NSData dataWithContentsOfFile:voicePath];
    NSMutableData *voiceData = [NSMutableData dataWithData:data];
    
    UCSVoiceMsg * voiceMsg = [[UCSVoiceMsg alloc] init];
    voiceMsg.amrAudioData = voiceData;
    voiceMsg.duration = (duration >= 1.0)? duration : 1.0;
    
    return [[UCSIMClient sharedIM] sendMessage:conversationType receiveId:targetId msgType:UCS_IM_VOICE content:voiceMsg success:^(long long messageId) {
        
        if (_ChatListDelegate && [_ChatListDelegate respondsToSelector:@selector(chatSendHelper:sendStatusDidChanged:MessageId:error:)]) {
            [_ChatListDelegate chatSendHelper:self sendStatusDidChanged:YES MessageId:messageId error:0];
        }
        
        if (_ChatViewDelegate && [_ChatViewDelegate respondsToSelector:@selector(chatSendHelper:sendStatusDidChanged:MessageId:error:)]) {
            [_ChatViewDelegate chatSendHelper:self sendStatusDidChanged:YES MessageId:messageId error:0];
        }
        
    } failure:^(UCSError *error, long long messageId) {
        
        if (_ChatListDelegate && [_ChatListDelegate respondsToSelector:@selector(chatSendHelper:sendStatusDidChanged:MessageId:error:)]) {
            [_ChatListDelegate chatSendHelper:self sendStatusDidChanged:NO MessageId:messageId error:error.code];
        }
        
        if (_ChatViewDelegate && [_ChatViewDelegate respondsToSelector:@selector(chatSendHelper:sendStatusDidChanged:MessageId:error:)]) {
            [_ChatViewDelegate chatSendHelper:self sendStatusDidChanged:NO MessageId:messageId error:error.code];
        }
        
    }];
    
}




- (UCSMessage *)resendMessage:(UCSMessage *)message oldMessageId:(long long)oldMessageId{
    
    UCS_IM_MsgType messageType = 0 ;
    if ([message.content isKindOfClass:[UCSTextMsg class]]) {
        messageType = UCS_IM_TEXT;
    }else if([message.content isKindOfClass:[UCSImageMsg class]]){
        messageType = UCS_IM_IMAGE;
    }else if ([message.content isKindOfClass:[UCSVoiceMsg class]]){
        messageType = UCS_IM_VOICE;
    }else{
        
    }
    

    return [[UCSIMClient sharedIM] sendMessage:message.conversationType receiveId:message.receiveId msgType:messageType content:message.content  success:^(long long messageId) {
        
        if (_ChatListDelegate && [_ChatListDelegate respondsToSelector:@selector(chatSendHelper:sendStatusDidChanged:MessageId:error:)]) {
            [_ChatListDelegate chatSendHelper:self sendStatusDidChanged:YES MessageId:oldMessageId error:0];
        }
        
       
        if (_ChatViewDelegate && [_ChatViewDelegate respondsToSelector:@selector(chatSendHelper:reSendStatusDidChanged:oldMessageId:newMessageId:error:)]) {
            [_ChatViewDelegate chatSendHelper:self reSendStatusDidChanged:YES oldMessageId:oldMessageId newMessageId:messageId error:0];
        }
        
    } failure:^(UCSError *error, long long messageId) {
       
        if (_ChatListDelegate && [_ChatListDelegate respondsToSelector:@selector(chatSendHelper:sendStatusDidChanged:MessageId:error:)]) {
            [_ChatListDelegate chatSendHelper:self sendStatusDidChanged:NO MessageId:oldMessageId error:error.code];
        }
        
        if (_ChatViewDelegate && [_ChatViewDelegate respondsToSelector:@selector(chatSendHelper:reSendStatusDidChanged:oldMessageId:newMessageId:error:)]) {
            [_ChatViewDelegate chatSendHelper:self reSendStatusDidChanged:NO oldMessageId:oldMessageId newMessageId:messageId error:error.code];
        }
        
    }];
    
}



@end
