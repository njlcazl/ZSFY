//
//  UCSImageMsg.h
//  ucsimlib
//
//  Created by FredZhang on 15/5/5.
//  Copyright (c) 2015年 ucpaas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UCSMsgContent.h"


/*!
 *  @brief  图片消息类型，继承UCSMsgContent。
 */
@interface UCSImageMsg : UCSMsgContent


/*!
 *  @brief  缩略图本地路径。
 */
@property(nonatomic, copy) NSString *thumbnailLocalPath;

/*!
 *  @brief  大图的远程url。自己发送的图片消息，这个字段为空。
 */
@property(nonatomic, copy) NSString *imageRemoteUrl;

/*!
 *  @brief  大图的本地路径。收到的图片消息，这个字段为空。
 */
@property(nonatomic, copy) NSString *imageLocalPath;

/*!
 *  @brief  原图。(发送图片时，只需要给这个参数赋值就行，其他的参数不需要赋值)。发送时必填。
                当收到别人的图片消息时，这个字段为空。获取图片可以通过imageRemoteUrl这个参数自定义下载。
                当取出聊天的历史消息时，无论消息是发送的还是接收的，这个参数都为空。自己发送的图片可以通过imageLocalPath这个参数去获取，接收的图片可以通过imageRemoteUrl这个参数去获取。
 */
@property(nonatomic, strong) UIImage *originalImage;

/*!
 *  @brief  附加信息(暂时未被使用)
 */
@property(nonatomic, strong) NSString *extra;

@end
