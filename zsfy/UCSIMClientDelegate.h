//
//  UCSIMClientDelegate.h
//  ucsimlib
//
//  Created by FredZhang on 15-4-7.
//  Copyright (c) 2015年 ucpaas. All rights reserved.
//


#ifndef ucsimlib_UCSIMClientDelegate_h
#define ucsimlib_UCSIMClientDelegate_h
#import "UCSError.h"
@class UCSIMClient;
@class UCSMessage;


/*!
 @protocol
 @brief 本协议包括：讨论组事件产生时的回调、接收到消息时的回调等其它操作
 @discussion
 */
@protocol UCSIMClientDelegate<NSObject>

@required

/*!
 *  @brief  收到服务器推送的消息时回调
 *
 *  @param messageArray  消息数组。数组中每一个元素是一个UCSMessage对象
 */
- (void)didReceiveMessages:(NSArray*)messageArray;



/*!
 *  @brief  自动下载语音成功时回调。主动调用接口下载语音成功不会回调。
 *
 *  @param message 语音消息
 */
- (void)didVoiceDownloadSuccessWithMessage:(UCSMessage *)message;

/*!
 *  @brief  自动语音下载失败时回调。主动调用接口下载语音失败不会回调。
 *
 *  @param message 语音消息
 */
- (void)didVoiceDownloadFailWithMessage:(UCSMessage *)message;



#pragma mark 讨论组

/*!
 *  @brief  当自己被移除出某个讨论组的时候回调。(自己主动退出不会回调)。
 *
 *  @param discussionID  对应的讨论组id
 */
- (void)didRemoveFromDiscussionWithDiscussionId:(NSString *) discussionID;

@end
#endif
