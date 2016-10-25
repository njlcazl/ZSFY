//
//  UCSVoiceMsg.h
//  ucsimlib
//
//  Created by FredZhang on 15/5/5.
//  Copyright (c) 2015年 ucpaas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UCSMsgContent.h"


/*!
 *  @brief  语音消息类型，继承UCSMsgContent。
 
            发送语音时，填充 amrAudioData、duration这两个字段,voicePath不需要填充
 
            接收语音时 或者 获取聊天记录时，voicePath、duration这两个字段有值,amrAudioData为空
 */
@interface UCSVoiceMsg : UCSMsgContent

/*!
 *  @brief  AMR格式的data。(发送语音的时，必填)
 */
@property(nonatomic, strong) NSData *amrAudioData;

/*!
 *  @brief  语音的本地路径。(接收语音时，这个参数存放语音在本地的地址)
 */
@property(nonatomic, copy) NSString *voicePath;

/*!
 *  @brief  语音时长。(发送语音时，必填)
 */
@property(nonatomic, assign) long duration;

/*!
 *  @brief  附加信息(暂时未使用)
 */
@property(nonatomic, copy) NSString *extra;

@end
