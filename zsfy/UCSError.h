//
//  UCSError.h
//  ucstcplib
//
//  Created by Barry on 15/8/27.
//  Copyright (c) 2015年 ucpaas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UCSTcpDefine.h"

/*!
 @class
 @brief SDK错误信息定义类
 @discussion
 */
@interface UCSError : NSObject


/*!
 *  @brief  错误信息描述，有可能为空
 */
@property (nonatomic,copy) NSString *errorDescription;


/*!
 *  @brief  错误码
 */
@property (nonatomic,assign) UCSErrorCode code;


/*!
 *  @brief  创建一个UCSError实例对象
 *
 *  @param errorCode        错误码
 *  @param errorDescription 错误描述
 *
 *  @return UCSError实例对象
 */
+(instancetype)errorWithCode:(UCSErrorCode)errorCode
              andDescription:(NSString *)errorDescription;

@end
