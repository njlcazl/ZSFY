//
//  AudioPlayManager.h
//  UC_Demo_1.0.0
//
//  Created by Barry on 15/5/20.
//  Copyright (c) 2015年 Barry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AudioManage.h"

#import "MessageModel.h"

typedef void (^FinishBlock)(BOOL success);
typedef void (^PlayBlock)(BOOL playing, MessageModel *messageModel);

@interface AudioPlayManager : NSObject

@property (strong, nonatomic) FinishBlock  finishBlock;
@property (strong, nonatomic) MessageModel *audioMessageModel;
@property (strong, nonatomic) AudioManage  * audioManage;

+ (id)defaultManager;

/**
 *  准备播放语音文件
 *
 *  @param messageModel     要播放的语音文件
 *  @param updateCompletion 需要更新model所在的Cell
 *
 *  @return 若返回NO，则不需要调用播放方法
 *
 */
- (BOOL)prepareMessageAudioModel:(MessageModel *)messageModel
            updateViewCompletion:(void (^)(MessageModel *prevAudioModel, MessageModel *currentAudioModel))updateCompletion;

- (MessageModel *)stopMessageAudioModel;

@end
