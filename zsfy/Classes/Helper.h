//
//  Helper.h
//  zsfy
//
//  Created by 曾祺植 on 11/14/15.
//  Copyright © 2015 wzy. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Helper : NSObject

+ (void)setDeviceToken:(NSString *)DeviceToken;

+ (NSString *)getDeviceToken;

+ (void)setIM_Token:(NSString *)IM_Token;

+ (NSString *)getIM_Token;

+ (void)setUserID:(NSString *)userID;

+ (NSString *)getUserID;

+ (void)setUser_Token:(NSString *)User_Token;

+ (NSString *)getUser_Token;

+ (void)setNickname:(NSString *)Nickname;

+ (NSString *)getNickname;

+ (void)setUserName:(NSString *)UserName;

+ (NSString *)getUserName;

+ (void)setStatus:(BOOL)isLogin;

+ (BOOL)getStatus;

+ (void)setImageUrl:(NSString *)ImageUrl;

+ (NSString *)getImageUrl;

+ (void)setPassword:(NSString *)password;

+ (NSString *)getPassword;

+ (NSArray *)getMemberIdList:(NSArray *)MemberList;

@end
