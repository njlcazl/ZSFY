//
//  MessageModelManager.m
//  UC_Demo_1.0.0
//
//  Created by Barry on 15/5/19.
//  Copyright (c) 2015年 Barry. All rights reserved.
//

#import "MessageModelManager.h"
#import "NSString+Emojize.h"
#import "Search.h"
#import "Helper.h"


@implementation MessageModelManager

+ (id)modelWithMessage:(UCSMessage *) message{
    
    MessageModel * model = [[MessageModel alloc] init];
    
    model.messageId =  message.messageId;
    model.message = message;
    model.isRead = (message.receivedStatus == ReceivedStatus_UNREAD)?NO:YES;
    model.isPlayed = (message.receivedStatus == ReceivedStatus_LISTENED)?YES:NO;  //语音是否被播放过了
    
    //判断发送状态
    if (message.messageDirection == MessageDirection_SEND) {
        switch (message.sentStatus) {
            case 0:
                model.status = MessageDeliveryState_Delivered;
                break;
            case 1:
                model.status = MessageDeliveryState_Delivering;
                break;
            case 2:
                model.status = MessageDeliveryState_Failure;
                break;
            default:
                break;
        }
    }

    
    model.isSender = (message.messageDirection == MessageDirection_SEND)?(YES):(NO);
    model.nickName = (message.senderNickName && message.senderNickName.length > 0)? [[Search shareInstance] getNickName:message.senderUserId]  : message.senderUserId;
    model.username = message.senderUserId;
    model.isChatGroup = (message.conversationType == UCS_IM_SOLOCHAT)?(NO):(YES);
    
    if (message.conversationType == UCS_IM_SOLOCHAT || message.conversationType == UCS_IM_DISCUSSIONCHAT) {
        
        if (message.messageDirection == MessageDirection_SEND) {
            NSString * portraituri = [Helper getImageUrl];
            model.headImageURL = [NSURL URLWithString:portraituri];
        } else {
            NSString *ImageUrl = [[Search shareInstance] getImageUrl:message.senderUserId];
            model.headImageURL = [NSURL URLWithString:ImageUrl];
        }
    }else if (message.conversationType == UCS_IM_GROUPCHAT){
        
       
    }
    

    if (message.messageType == UCS_IM_TEXT) {  //文本
        
        model.type = MessageBodyType_Text;
        UCSTextMsg * aTextMsg = (UCSTextMsg *)message.content;
        NSString * str = aTextMsg.content;
        //转换内容里面的通用字符串为表情字符串
        NSString * emojizedString  =  [str emojizedString];
        model.content = emojizedString;
        
    }else if (message.messageType == UCS_IM_IMAGE){ //图片
        
        model.type = MessageBodyType_Image;
        UCSImageMsg * imageMsg = (UCSImageMsg *)message.content;
        
        //小图图片
        model.thumbnailImage = [UIImage imageWithContentsOfFile:imageMsg.thumbnailLocalPath];
        
        model.imageRemoteURL = (imageMsg.imageRemoteUrl)
                                ? ([[NSURL alloc] initWithString:imageMsg.imageRemoteUrl])
                                :(nil);
        
        model.imageLocalPath = imageMsg.imageLocalPath?imageMsg.imageLocalPath:nil;
        model.image = [UIImage imageWithContentsOfFile:imageMsg.imageLocalPath];
        
        model.size = (model.isSender)?(model.image.size):(model.thumbnailImage.size);
        
    }else if (message.messageType == UCS_IM_VOICE){  //语音
        
        model.type = MessageBodyType_Voice;
        UCSVoiceMsg * voiceMsg = (UCSVoiceMsg *)message.content;
        model.time = voiceMsg.duration;
        model.localPath = [[SanboxHelper docPath] stringByAppendingString:[NSString stringWithFormat:@"/%@", voiceMsg.voicePath]];
        
    }else if(message.messageType == UCS_IM_DiscussionNotification){ //加群通知等
        
        model.type = MessageBodyType_notification;
        UCSDiscussionNotification * notificationMsg = (UCSDiscussionNotification *)message.content;
        model.content = notificationMsg.extension;
    }
    
    return model;

}


- (NSString *)string2PathString:(NSString *) string {
    return [[SanboxHelper docPath] stringByAppendingString:[NSString stringWithFormat:@"/%@", string]];
}



@end
