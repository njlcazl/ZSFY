//
//  UCSUnknownMsg.h
//  ucsimlib
//
//  Created by Barry on 15/12/7.
//  Copyright © 2015年 ucpaas. All rights reserved.
//

#import "UCSMsgContent.h"

/*!
 *  @brief  未知消息类型，继承UCSMsgContent
 */
@interface UCSUnknownMsg : UCSMsgContent

/*!
 *  @brief  未知类型内容
 */
@property(nonatomic, copy) NSString *content;

@end
