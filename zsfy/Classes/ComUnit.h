//
//  ComUnit.h
//  zsfy
//
//  Created by 曾祺植 on 11/14/15.
//  Copyright © 2015 wzy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FriendModel;
@class ApplyModel;

typedef void(^FetchInfo) (NSString *IM_Token, NSString *userID, NSString *User_Token, NSString *name, NSString *imageUrl, NSString *courtId, NSString *Info, BOOL succeed);
typedef void(^FetchQueryFriend) (NSArray *allQueryFriend, BOOL succeed);
typedef void(^FetchFriendInfo) (FriendModel *item, BOOL succeed);
typedef void(^FetchFriendList) (NSArray *allFriendInfo, BOOL succeed);
typedef void(^FetchApplyInfo) (NSArray *allApplyInfo, BOOL succeed);
typedef void(^FetchUnreadApply) (NSString *UnreadCount, BOOL succeed);
typedef void(^FetchPushInfo) (long long time, NSString *description, NSString *title, NSString * UnreadCount, BOOL succeed);
typedef void(^FetchNoteMsg) (NSArray *allNoteInfo, BOOL succeed);

typedef void(^requestSuccessBlock)(id data);
typedef void(^requestFailureBlock)(NSError *error);

@interface ComUnit : NSObject

+ (void)Register_countID:(int)countID userType:(int)userType userName:(NSString *)userName Password:(NSString *)password clientId:(NSString *)clientId Callback:(FetchInfo)callback;

+ (void)Login_userName:(NSString *)userName Password:(NSString *)password clientId:(NSString *)clientId Callback:(FetchInfo)callback;

+ (void)getFriendInfo:(NSString *)userToken targetID:(NSString *)targetID Callback:(FetchFriendInfo)callback;

+ (void)getApplyInfo:(NSString *)userToken Callback:(FetchApplyInfo)callback;

+ (BOOL)sendApply:(NSString *)userToken targetID:(NSString *)targetID Content:(NSString *)content;

+ (void)QueryFriend:(NSString *)userToken userName:(NSString *)userName nickName:(NSString *)nickName Callback:(FetchQueryFriend)callback;

+ (void)getFriendList:(NSString *)userToken Callback:(FetchFriendList)callback;

+ (void)AcceptApply:(NSString *)userToken targetUserId:(NSString *)targetUserId Callback:(FetchFriendInfo)callback;

+ (BOOL)RejectApply:(NSString *)userToken targetUserId:(NSString *)targetUserId;

+ (BOOL)DeleteFriend:(NSString *)userToken targetUserId:(NSString *)targetUserId;

+ (BOOL)readApplyMessage:(NSString *)userToken;

+ (void)getUnreadApply:(NSString *)userToken Callback:(FetchUnreadApply)callback;

+ (void)getPersonInfo:(NSString *)userToken PersonId:(NSString *)Pid Callback:(FetchFriendInfo)callback;

+ (void)PushNotificationTest:(NSString *)Token;

+ (void)getPushInfo:(NSString *)userToken ClientId:(NSString *)clientId Callback:(FetchPushInfo)callback;

+ (void)getNotificationMsgList:(NSString *)userToken ClientId:(NSString *)clientId Page:(int)page rowSize:(int)rowsize Callback:(FetchNoteMsg)callback;

+ (BOOL)ClearUnreadCount:(NSString *)userToken clientId:(NSString *)clientId;

//获取用户的详细信息
+ (void)getPersonInfoDetail:(NSString *)token success:(requestSuccessBlock)success failure:(requestFailureBlock)failure;

//修改地址
+ (void)updateAddress:(NSString *)token address:(NSString *)adress success:(requestSuccessBlock)success failure:(requestFailureBlock)failure;

//退出登录
+ (BOOL)UserLogout:(NSString *)token;
@end
