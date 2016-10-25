//
//  Helper.m
//  zsfy
//
//  Created by 曾祺植 on 11/14/15.
//  Copyright © 2015 wzy. All rights reserved.
//

#import "Helper.h"
#import "UCSIMSDK.h"

@interface Helper()


@end

@implementation Helper

+ (void)setDeviceToken:(NSString *)DeviceToken
{
    [[NSUserDefaults standardUserDefaults] setObject:DeviceToken forKey:@"DeviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getDeviceToken
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"DeviceToken"];
}

+ (void)setIM_Token:(NSString *)IM_Token
{
    [[NSUserDefaults standardUserDefaults] setValue:IM_Token forKey:@"kIM_Token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getIM_Token{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"kIM_Token"];
}

+ (void)setUserID:(NSString *)userID
{
    [[NSUserDefaults standardUserDefaults] setValue:userID forKey:@"kUserID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getUserID
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"kUserID"];
}

+ (void)setStatus:(BOOL)isLogin
{
    NSString *status = isLogin ? @"1" : @"0";
    [[NSUserDefaults standardUserDefaults] setValue:status forKey:@"kStatus"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)getStatus
{
    NSString *tmp = [[NSUserDefaults standardUserDefaults] stringForKey:@"kStatus"];
    if ([tmp isEqualToString:@"0"]) return NO;
    else return YES;
    
}

+ (void)setUser_Token:(NSString *)User_Token
{
    [[NSUserDefaults standardUserDefaults] setValue:User_Token forKey:@"User_Token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getUser_Token
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"User_Token"];
}

+ (void)setNickname:(NSString *)Nickname
{
    [[NSUserDefaults standardUserDefaults] setValue:Nickname forKey:@"kNickname"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getNickname
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"kNickname"];
}

+ (void)setUserName:(NSString *)UserName
{
    [[NSUserDefaults standardUserDefaults] setValue:UserName forKey:@"kUserName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getUserName
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"kUserName"];
}

+ (void)setImageUrl:(NSString *)ImageUrl
{
    [[NSUserDefaults standardUserDefaults] setValue:ImageUrl forKey:@"kImageUrl"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getImageUrl
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"kImageUrl"];
}

+ (void)setPassword:(NSString *)password
{
    [[NSUserDefaults standardUserDefaults] setValue:password forKey:@"kPassword"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getPassword
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"kPassword"];
}

+ (NSArray *)getMemberIdList:(NSArray *)MemberList
{
    NSMutableArray *tmp = [[NSMutableArray alloc] init];
    for (int i = 0; i < MemberList.count; i++) {
        UCSUserInfo *item = MemberList[i];
        [tmp addObject:item.userId];
    }
    return [tmp copy];
}

@end
