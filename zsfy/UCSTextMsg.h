//
//  UCSTextMsg.h
//  ucsimlib
//
//  Created by FredZhang on 15/5/5.
//  Copyright (c) 2015年 ucpaas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UCSMsgContent.h"


/*!
 *  @brief  文本消息类型，继承UCSMsgContent
 */
@interface UCSTextMsg : UCSMsgContent


/*!
*  @brief  文本消息内容
*/
@property(nonatomic, copy) NSString *content;


/*!
 *  @brief  附加信息。(暂时未被使用)
 */
@property(nonatomic, copy) NSString *extra;


@end
