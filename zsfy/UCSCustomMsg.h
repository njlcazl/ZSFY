//
//  UCSCustomMsg.h
//  ucsimlib
//
//  Created by Barry on 15/12/2.
//  Copyright © 2015年 ucpaas. All rights reserved.
//

#import "UCSMsgContent.h"

/*!
 *  @brief  自定义消息
 */
@interface UCSCustomMsg : UCSMsgContent

/*!
 *  @brief 自定义消息体
 */
@property (strong, nonatomic) NSData *data;



/*!
 *  @author barry, 15-12-02 15:12:43
 *
 *  @brief  构建自定义消息对象
 *
 *  @param data 自定义消息体
 *
 *  @return 自定义消息对象
 */
- (instancetype)initWithData:(NSData *)data;

@end
