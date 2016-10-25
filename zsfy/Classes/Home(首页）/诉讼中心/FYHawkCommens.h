//
//  FYHawkCommens.h
//  zsfy
//
//  Created by 李晓飞 on 15/11/30.
//  Copyright (c) 2015年 wzy. All rights reserved.
//

/**
 *    [defaults setObject:[dic objectForKey:@"clientId"] forKey:@"clientId"];
 [defaults setObject:[dic objectForKey:@"clientNumber"] forKey:@"clientNumber"];
 [defaults setObject:[dic objectForKey:@"courtId"] forKey:@"courtId"];
 [defaults setObject:[dic objectForKey:@"id"] forKey:@"user_id"];
 [defaults setObject:[dic objectForKey:@"userName"] forKey:@"userName"];
 [defaults setObject:[dic objectForKey:@"token"] forKey:@"token"];
 *
 *  @param BOOL
 *
 *  @return
 */
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface FYHawkCommens : NSObject

/**
 *  检测是否登录,未登录,让丫的登录
 *
 *  @param nav 控制器所属导航栏
 *
 *  @return 如果登陆过了返回YES
 */
+ (BOOL)checkIfLogin:(UINavigationController *)nav;

/**
 *  通过key值获取用户信息
 *
 *  @param key
 *
 *  @return
 */
+ (NSString *)fetchUserInfoByKey:(NSString *)key;

/**
 *  存放信
 *
 *  @param key 信息标注的key
 *
 *  @return
 */
+ (void)setUserInfo:(id)info WithKey:(NSString *)key;
@end
