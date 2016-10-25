//
//  UCSUserInfo.h
//  ucsimlib
//
//  Created by FredZhang on 15/5/5.
//  Copyright (c) 2015年 ucpaas. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *  @brief  用户信息类型.
 */
@interface UCSUserInfo : NSObject

/*!
 *  @brief  用户ID。(必填)
 */
@property(nonatomic, copy) NSString *userId;

/*!
 *  @brief  昵称。(选填)
 */
@property(nonatomic, copy) NSString *name;

/*!
 *  @brief  头像URL.(选填)
 */
@property(nonatomic, copy) NSString *portraitUri;

@end
