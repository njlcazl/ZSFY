//
//  AudioPlayManager.m
//  UC_Demo_1.0.0
//
//  Created by Barry on 15/5/20.
//  Copyright (c) 2015年 Barry. All rights reserved.
//


#import "AudioPlayManager.h"

static AudioPlayManager *detailInstance = nil;

@implementation AudioPlayManager


+ (id)defaultManager
{
    @synchronized(self){
        static dispatch_once_t pred;
        dispatch_once(&pred, ^{
            detailInstance = [[self alloc] init];
        });
    }

    return detailInstance;
}


- (BOOL)prepareMessageAudioModel:(MessageModel *)messageModel
            updateViewCompletion:(void (^)(MessageModel *prevAudioModel, MessageModel *currentAudioModel))updateCompletion
{
    BOOL isPrepare = NO;
    
    if(messageModel.type == MessageBodyType_Voice)
    {
        MessageModel *prevAudioModel = self.audioMessageModel;
        MessageModel *currentAudioModel = messageModel;
        self.audioMessageModel = messageModel;
        
        BOOL isPlaying = messageModel.isPlaying;
        if (isPlaying) {
            messageModel.isPlaying = NO;
            self.audioMessageModel = nil;
            prevAudioModel.isPlaying = NO;
            currentAudioModel = nil;
            //停止播放
            [self.audioManage stopPlaying];
        
        } else {
            messageModel.isPlaying = YES;
            prevAudioModel.isPlaying = NO;
            isPrepare = YES;
            
            //设置消息已读
            if (!messageModel.isPlayed) {
                messageModel.isPlayed = YES;
                
                UCSMessage * ucsmessage = messageModel.message;
                
                NSString * targetId = nil;
                if (ucsmessage.conversationType == UCS_IM_SOLOCHAT) {
                   targetId = (ucsmessage.messageDirection == MessageDirection_SEND )? (ucsmessage.receiveId):(ucsmessage.senderUserId);
                }else{
                    targetId = ucsmessage.receiveId;
                }
                
                
              BOOL read =  [[UCSIMClient sharedIM] setMessageReceivedStatus:ucsmessage.conversationType     targetId:targetId  messageId:messageModel.messageId receivedStatus:ReceivedStatus_LISTENED];

            }
        }
        
        if (updateCompletion) {
            updateCompletion(prevAudioModel, currentAudioModel);
        }
    }
    
    return isPrepare;
}

- (MessageModel *)stopMessageAudioModel
{
    MessageModel *model = nil;
    if (self.audioMessageModel.type == MessageBodyType_Voice) {
        if (self.audioMessageModel.isPlaying) {
            model = self.audioMessageModel;
        }
        self.audioMessageModel.isPlaying = NO;
        self.audioMessageModel = nil;
    }
    
    return model;
}


@end
