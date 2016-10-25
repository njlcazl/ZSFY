//
//  UCSMsgContent.h
//  ucsimlib
//
//  Created by FredZhang on 15/5/5.
//  Copyright (c) 2015年 ucpaas. All rights reserved.
//

#import <Foundation/Foundation.h>


/*!
 *  @brief  UCSMsgContent是一个消息内容的基类,做为UCSTextMsg、UCSImageMsg等消息内容类的父类。
 */

@interface UCSMsgContent : NSObject

/*!
 *  @brief  Push消息内容
 */
@property(nonatomic, copy) NSString *pushContent;

/*!
 *  @brief  如果encode和decode失败，此基类会将服务器返回的存到此字段
 */
@property(nonatomic, strong, setter=setRawData:) NSData *rawData;

@end
