//
//  UCSTCPDelegateBase.h
//  ucstcplib
//
//  Created by Barry on 15/11/11.
//  Copyright © 2015年 ucpaas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UCSError.h"


@protocol UCSTCPDelegateBase <NSObject>

/*!
 *  @author barry, 15-11-12 15:11:36
 *
 *  @brief  连接状态变化时
 *
 *  @param connectionStatus 连接状态
 *  @param error            错误描述
 */
- (void)didConnectionStatusChanged:(UCSConnectionStatus)connectionStatus  error:(UCSError *) error;




@end
