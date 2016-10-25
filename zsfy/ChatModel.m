//
//  ChatModel.m
//  UUChatTableView
//
//  Created by shake on 15/1/6.
//  Copyright (c) 2015年 uyiuyao. All rights reserved.
//

#import "ChatModel.h"
#import "FriendModel.h"
#import "SDWebImageManager.h"
#import "UCSConversation.h"
#import "UCSIMClient.h"
#import "Helper.h"
#import "ComUnit.h"
#import "UUMessage.h"
#import "UUMessageFrame.h"

static NSString *previousTime = nil;

@implementation ChatModel

/**
 *  加载收到的新消息
 *
 *  @param conversationItem
 *  @param dataMsg
 */
- (void)Conversation:(UCSConversation *)conversationItem loadNewMsg:(NSArray *)dataMsg
{
    for (int i = 0; i < dataMsg.count; i++) {
        UCSMessage *MsgItem = dataMsg[i];
        if (MsgItem.messageType == UCS_IM_DiscussionNotification || MsgItem.messageType == UCS_IM_Notification || MsgItem.messageType == UCS_IM_SYSTEMMSG) {
            continue;
        }
        if (conversationItem.conversationType == UCS_IM_DISCUSSIONCHAT || conversationItem.conversationType == UCS_IM_GROUPCHAT) {
            if ([conversationItem.targetId isEqualToString:MsgItem.receiveId]) {
                [self.dataSource addObject:[self addMsg:MsgItem]];
            }
        } else if(conversationItem.conversationType == UCS_IM_SOLOCHAT) {
            if ([[Helper getUserID] isEqualToString:MsgItem.receiveId]) {
                [self.dataSource addObject:[self addMsg:MsgItem]];
            }
        }
        
    }
}

/**
 *  加载会话的历史消息
 *
 *  @param conversationItem
 */
- (void)loadConversation:(UCSConversation *)conversationItem
{
    self.targetID = conversationItem.targetId;
    self.dataSource = [NSMutableArray array];
    NSArray *latestMsg = [[UCSIMClient sharedIM] getLatestMessages:conversationItem.conversationType
                                                          targetId:conversationItem.targetId
                                                             count:10];
    for (int i = 0;i < latestMsg.count;i++)
    {
        if ([(UCSMessage *)latestMsg[i] messageType] == UCS_IM_DiscussionNotification || [(UCSMessage *)latestMsg[i] messageType] == UCS_IM_Notification) {
            continue;
        }
        [self.dataSource addObject:[self addMsg:latestMsg[i]]];
       // NSLog(@"%@", [(UCSTextMsg *)[(UCSMessage *)latestMsg[i] content] content]);
    }
    if(latestMsg.count > 0)self.oldestMsgID = [(UCSMessage *)latestMsg[0] messageId];
    //NSLog(@"\n");
}


- (BOOL)addItemsToDataSource:(UCSConversation *)conversationItem count:(NSInteger)number;
{
    int count = (int)number;
    NSArray *historyMsg = [[UCSIMClient sharedIM] getHistoryMessages:conversationItem.conversationType
                                                            targetId:conversationItem.targetId
                                                     oldestMessageId:self.oldestMsgID
                                                               count:count];
    if (historyMsg.count <= 0) {
        return NO;
    }
    for (int i = (int)historyMsg.count - 1; i >= 0; i--) {
        if ([(UCSMessage *)historyMsg[i] messageType] == UCS_IM_DiscussionNotification || [(UCSMessage *)historyMsg[i] messageType] == UCS_IM_Notification) {
            continue;
        }
        [self.dataSource insertObject:[self addMsg:historyMsg[i]] atIndex:0];
    }
    self.oldestMsgID = [(UCSMessage *)historyMsg[0] messageId];
    return YES;
}

/**
 *  添加自己发出的信息
 *
 *  @param dic
 *
 *  @return
 */
- (int)addSpecifiedItem:(NSDictionary *)dic
{
    UUMessageFrame *messageFrame = [[UUMessageFrame alloc]init];
    UUMessage *message = [[UUMessage alloc] init];
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    [dataDic setObject:@(UUMessageSending) forKey:@"state"];
    [dataDic setObject:@(UUMessageFromMe) forKey:@"from"];
    [dataDic setObject:[[NSDate date] description] forKey:@"strTime"];
    [dataDic setObject:[Helper getNickname] forKey:@"strName"];
    [dataDic setObject:@"" forKey:@"strIcon"];
    
    [message setWithDict:dataDic];
    [message minuteOffSetStart:previousTime end:dataDic[@"strTime"]];
    messageFrame.showTime = message.showDateLabel;
    [messageFrame setMessage:message];
    
    if (message.showDateLabel) {
        previousTime = dataDic[@"strTime"];
    }
    int ret = (int)self.dataSource.count;
    [self.dataSource addObject:messageFrame];
    return ret;
}

/**
 *  添加聊天item（一个cell内容）
 *
 *  @param MsgItem
 *
 *  @return
 */
- (UUMessageFrame *)addMsg:(UCSMessage *)MsgItem
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    if (MsgItem.messageType == UCS_IM_IMAGE) {
        UCSImageMsg *imageMsg = (UCSImageMsg *)MsgItem.content;
        if ([MsgItem.senderUserId isEqualToString:[Helper getUserID]]) {
            UIImage *item = [UIImage imageWithData:[NSData dataWithContentsOfFile:imageMsg.imageLocalPath]];
            [dictionary setObject:item forKey:@"picture"];
        } else {
            [dictionary setObject:imageMsg.imageRemoteUrl forKey:@"pictureUrl"];
            
        }
    } else if (MsgItem.messageType == UCS_IM_TEXT) {
        UCSTextMsg *textMsg = (UCSTextMsg *)MsgItem.content;
        [dictionary setObject:textMsg.content forKey:@"strContent"];
    } else if (MsgItem.messageType == UCS_IM_VOICE) {
        UCSVoiceMsg *voiceMsg = (UCSVoiceMsg *)MsgItem.content;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDir = [paths objectAtIndex:0];
        //拼接语音文件本地存放的路径
        NSString *voicePath = [NSString stringWithFormat:@"%@/%@", docDir, voiceMsg.voicePath];
        NSData *voiceData = [NSData dataWithContentsOfFile:voicePath];
        [dictionary setObject:voiceData forKey:@"voice"];
        [dictionary setObject:[NSString stringWithFormat:@"%ld", voiceMsg.duration] forKey:@"strVoiceTime"];
    } else if (MsgItem.messageType == UCS_IM_Notification) {
        return nil;
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:MsgItem.time];
    if ([MsgItem.senderUserId isEqualToString:[Helper getUserID]]) {
        [dictionary setObject:@(UUMessageFromMe) forKey:@"from"];
    } else {
        [dictionary setObject:@(UUMessageFromOther) forKey:@"from"];
    }
    if (MsgItem.messageType == UCS_IM_TEXT) {
        [dictionary setObject:@0 forKey:@"type"];
    } else if (MsgItem.messageType == UCS_IM_IMAGE) {
        [dictionary setObject:@1 forKey:@"type"];
    } else if (MsgItem.messageType == UCS_IM_VOICE) {
        [dictionary setObject:@2 forKey:@"type"];
    } else {
        
    }
    
    [dictionary setObject:[NSString stringWithFormat:@"%lld", MsgItem.messageId] forKeyedSubscript:@"MsgID"];
    [dictionary setObject:@(UUMessageSendSuccess) forKeyedSubscript:@"state"];
    [dictionary setObject:[date description] forKey:@"strTime"];
    if ([MsgItem.senderUserId isEqualToString:[Helper getUserID]]) {
        [dictionary setObject:[Helper getNickname] forKey:@"strName"];
    } else {
        for (int i = 0; i < self.FriendsInfo.count; i++) {
            FriendModel *item = self.FriendsInfo[i];
            if ([MsgItem.senderUserId isEqualToString:item.Fid]) {
                 [dictionary setObject:item.nikeName forKey:@"strName"];
                break;
            }
        }
    }

    
    NSDictionary *dataDic = dictionary;
    UUMessageFrame *messageFrame = [[UUMessageFrame alloc] init];
    UUMessage *message = [[UUMessage alloc] init];
    [message setWithDict:dataDic];
    [message minuteOffSetStart:previousTime end:dataDic[@"strTime"]];
    messageFrame.showTime = message.showDateLabel;
    [messageFrame setMessage:message];
    if (message.showDateLabel) {
        previousTime = dataDic[@"strTime"];
    }
    return messageFrame;
}

@end
