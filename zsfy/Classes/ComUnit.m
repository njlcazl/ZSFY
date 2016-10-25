//
//  ComUnit.m
//  zsfy
//
//  Created by 曾祺植 on 11/14/15.
//  Copyright © 2015 wzy. All rights reserved.
//

#import "ComUnit.h"
#import "ApplyModel.h"
#import "FriendModel.h"
#import "QueryFriendModel.h"
#import "NotificationModel.h"

#define baseURL @"http://183.63.189.107/PalmCourt"
#define register @"/app/user!registerAjax.action"
#define login @"/app/user!loginAjax.action"
#define FriendInfo @"/app/userRelationship!getFriendUserDetailAjax.action"
#define ApplyInfo @"/app/userRelationship!getApplyListAjax.action"
#define SendApply @"/app/userRelationship!sendApplyAjax.action"
#define FindFriend @"/app/userRelationship!searchAjax.action"
#define FriendList @"/app/userRelationship!getFriendListAjax.action"
#define Accept @"/app/userRelationship!addUserAjax.action"
#define Reject @"/app/userRelationship!rejectApplyAjax.action"
#define Delete @"/app/userRelationship!deleteFriendUserAjax.action"
#define ReadApplyMsg @"/app/userRelationship!readApplyMessage.action"
#define UnreadApply @"/app/userRelationship!getUnReadApplyMessage.action"
#define PersonInfo @"/app/userRelationship!getListByIdListAjax.action"
#define PushTest @"/app/noticeMessage!pushTestAjax.action"
#define GetPushInfo @"/app/noticeMessage!getSessionRecordAjax.action"
#define GetNoteInfo @"/app/noticeMessage!getListAjax.action"
#define ClearPushCount @"/app/noticeMessage!clearSessionRecordAjax.action"

#define PersonInfoDetail  @"/app/userInfo!getUserDetailAjax.action"
#define UpdateAddress     @"/app/userInfo!updateAdressAjax.action"
#define LogOut @"/app/user!loginOutAjax.action"

@implementation ComUnit

+ (void)Register_countID:(int)countID userType:(int)userType userName:(NSString *)userName Password:(NSString *)password clientId:(NSString *)clientId Callback:(FetchInfo)callback
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", baseURL, register]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSString *param = [NSString stringWithFormat:@"courtId=%d&userType=%d&userName=%@&nikeName=%@&password=%@&repeatPassword=%@&clientId=%@&osId=2", countID, userType, userName, userName, password, password, clientId];
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError) {
            callback(nil, nil, nil, nil, nil, nil, nil, NO);
        } else {
            NSString *IM_Token = [[NSString alloc] init];
            NSString *userID = [[NSString alloc] init];
            NSString *User_Token = [[NSString alloc] init];
            NSString *name = [[NSString alloc] init];
            NSString *ImageUrl = [[NSString alloc] init];
            NSString *courtId = [[NSString alloc] init];
            @try {
                NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSString *status = [[resultDic valueForKey:@"status"] stringValue];
                if ([status isEqualToString:@"0"]) {
                    IM_Token = [[resultDic valueForKey:@"attach"] valueForKey:@"loginToken"];
                    userID = [[resultDic valueForKey:@"attach"] valueForKey:@"id"];
                    User_Token = [[resultDic valueForKey:@"attach"] valueForKey:@"token"];
                    name = [[resultDic valueForKey:@"attach"] valueForKey:@"nikeName"];
                    ImageUrl = [[resultDic valueForKey:@"attach"] valueForKey:@"image"];
                    courtId = [[resultDic valueForKey:@"attach"] valueForKey:@"courtId"];
                    callback(IM_Token, userID, User_Token, name, ImageUrl, courtId, nil, YES);
                } else {
                    NSString *info = [resultDic objectForKey:@"message"];
                    callback(nil, nil, nil, nil, nil, nil, info, NO);
                }

            }
            @catch (NSException *exception) {
                NSLog(@"%@", exception);
            }
        }
    }];
}

+ (void)Login_userName:(NSString *)userName Password:(NSString *)password clientId:(NSString *)clientId Callback:(FetchInfo)callback
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", baseURL, login]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSString *param = [NSString stringWithFormat:@"userName=%@&password=%@&clientId=%@&osId=2", userName, password, clientId];
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError) {
            callback(nil, nil, nil, nil, nil, nil, nil, NO);
        } else {
            NSString *IM_Token = [[NSString alloc] init];
            NSString *userID = [[NSString alloc] init];
            NSString *User_Token = [[NSString alloc] init];
            NSString *name = [[NSString alloc] init];
            NSString *ImageUrl = [[NSString alloc] init];
            NSString *courtId = [[NSString alloc] init];
            @try {
                NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSString *status = [[resultDic valueForKey:@"status"] stringValue];
                if ([status isEqualToString:@"0"]) {
                    IM_Token = [[resultDic valueForKey:@"attach"] valueForKey:@"loginToken"];
                    userID = [[resultDic valueForKey:@"attach"] valueForKey:@"id"];
                    User_Token = [[resultDic valueForKey:@"attach"] valueForKey:@"token"];
                    name = [[resultDic valueForKey:@"attach"] valueForKey:@"nikeName"];
                    ImageUrl = [[resultDic valueForKey:@"attach"] valueForKey:@"image"];
                    courtId = [[resultDic valueForKey:@"attach"] valueForKey:@"courtId"];
                    callback(IM_Token, userID, User_Token, name, ImageUrl, courtId, nil, YES);
                } else {
                    NSString *info = [resultDic objectForKey:@"message"];
                    callback(nil, nil, nil, nil, nil, nil, info, NO);
                }
                
            }
            @catch (NSException *exception) {
                NSLog(@"%@", exception);
            }
        }
    }];
}

+ (void)getFriendInfo:(NSString *)userToken targetID:(NSString *)targetID Callback:(FetchFriendInfo)callback
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", baseURL, FriendInfo]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSString *param = [NSString stringWithFormat:@"token=%@&targetUserId=%@", userToken, targetID];
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError) {
            callback(nil, NO);
        } else {
            FriendModel *item = [[FriendModel alloc] init];
            @try {
                NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSString *status = [[resultDic valueForKey:@"status"] stringValue];
                if ([status isEqualToString:@"0"]) {
                    NSLog(@"%@", targetID);
                    item = [FriendModel FriendInfoWithObj:[resultDic valueForKey:@"attach"]];
                    callback(item, YES);
                } else {
                    callback(nil, NO);
                }
                
            }
            @catch (NSException *exception) {
                NSLog(@"%@", exception);
            }
        }
    }];
}

+ (void)getApplyInfo:(NSString *)userToken Callback:(FetchApplyInfo)callback
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", baseURL, ApplyInfo]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSString *param = [NSString stringWithFormat:@"token=%@", userToken];
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError) {
            callback(nil, NO);
        } else {
            NSMutableArray *allApplyInfo = [[NSMutableArray alloc] init];
            @try {
                NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSString *status = [[resultDic valueForKey:@"status"] stringValue];
                if ([status isEqualToString:@"0"]) {
                    NSArray *allInfo = [[NSArray alloc] init];
                    allInfo = [resultDic valueForKey:@"attach"];
                    for (int i = 0; i < allInfo.count; i++) {
                        [allApplyInfo addObject:[ApplyModel objWithDic:allInfo[i]]];
                    }
                    callback(allApplyInfo, YES);
                } else {
                    callback(nil, NO);
                }
                
            }
            @catch (NSException *exception) {
                NSLog(@"%@", exception);
            }
        }
    }];
}

+ (BOOL)sendApply:(NSString *)userToken targetID:(NSString *)targetID Content:(NSString *)content
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", baseURL, SendApply]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSString *param = [NSString stringWithFormat:@"token=%@&targetUserId=%@&content=%@", userToken, targetID, content];
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err = [[NSError alloc] init];
    NSData *retData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:retData options:NSJSONReadingMutableContainers error:nil];
    NSString *status = [[resultDic valueForKey:@"status"] stringValue];
    if ([status isEqualToString:@"0"]) {
        return YES;
    } else {
        return NO;
    }
}

+ (void)QueryFriend:(NSString *)userToken userName:(NSString *)userName nickName:(NSString *)nickName Callback:(FetchQueryFriend)callback
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", baseURL, FindFriend]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSString *param = [NSString stringWithFormat:@"token=%@&userName=%@&nikeName=%@", userToken, userName, nickName];
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError) {
            callback(nil, NO);
        } else {
            NSMutableArray *allQueryFriend = [[NSMutableArray alloc] init];
            @try {
                NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSString *status = [[resultDic valueForKey:@"status"] stringValue];
                if ([status isEqualToString:@"0"]) {
                    NSArray *allInfo = [[NSArray alloc] init];
                    allInfo = [resultDic valueForKey:@"attach"];
                    for (int i = 0; i < allInfo.count; i++) {
                        [allQueryFriend addObject:[QueryFriendModel FriendInfoWithObj:allInfo[i]]];
                    }
                    callback(allQueryFriend, YES);
                } else {
                    callback(nil, NO);
                }
                
            }
            @catch (NSException *exception) {
                NSLog(@"%@", exception);
            }
        }
    }];
}

+ (void)getFriendList:(NSString *)userToken Callback:(FetchFriendList)callback
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", baseURL, FriendList]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSString *param = [NSString stringWithFormat:@"token=%@", userToken];
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError) {
            callback(nil, NO);
        } else {
            NSMutableArray *allFriendInfo = [[NSMutableArray alloc] init];
            @try {
                NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSString *status = [[resultDic valueForKey:@"status"] stringValue];
                if ([status isEqualToString:@"0"]) {
                    NSArray *allInfo = [[NSArray alloc] init];
                    allInfo = [resultDic valueForKey:@"attach"];
                    for (int i = 0; i < allInfo.count; i++) {
                        [allFriendInfo addObject:[FriendModel FriendInfoWithObj:allInfo[i]]];
                    }
                    callback(allFriendInfo, YES);
                } else {
                    callback(nil, NO);
                }
                
            }
            @catch (NSException *exception) {
                NSLog(@"%@",exception);
            }
        }
    }];
}

+ (void)AcceptApply:(NSString *)userToken targetUserId:(NSString *)targetUserId Callback:(FetchFriendInfo)callback
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", baseURL, Accept]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSString *param = [NSString stringWithFormat:@"token=%@&targetUserId=%@", userToken, targetUserId];
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError) {
            callback(nil, NO);
        } else {
            FriendModel *item = [[FriendModel alloc] init];
            @try {
                NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSString *status = [[resultDic valueForKey:@"status"] stringValue];
                if ([status isEqualToString:@"0"]) {
                    item = [FriendModel FriendInfoWithObj:[resultDic valueForKey:@"attach"]];
                    callback(item, YES);
                } else {
                    callback(nil, NO);
                }
                
            }
            @catch (NSException *exception) {
                NSLog(@"%@", exception);
            }
        }
    }];
}

+ (BOOL)RejectApply:(NSString *)userToken targetUserId:(NSString *)targetUserId
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", baseURL, Reject]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSString *param = [NSString stringWithFormat:@"token=%@&targetUserId=%@", userToken, targetUserId];
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err = [NSError new];
    NSData *retData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:retData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"%@", [resultDic valueForKey:@"message"]);
    NSString *status = [[resultDic valueForKey:@"status"] stringValue];
    if ([status isEqualToString:@"0"]) {
        return YES;
    } else {
        return NO;
    }

}

+ (BOOL)DeleteFriend:(NSString *)userToken targetUserId:(NSString *)targetUserId
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", baseURL, Delete]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSString *param = [NSString stringWithFormat:@"token=%@&targetUserId=%@", userToken, targetUserId];
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err = [NSError new];
    NSData *retData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:retData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"%@", [resultDic valueForKey:@"message"]);
    NSString *status = [[resultDic valueForKey:@"status"] stringValue];
    if ([status isEqualToString:@"0"]) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)readApplyMessage:(NSString *)userToken
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", baseURL, ReadApplyMsg]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSString *param = [NSString stringWithFormat:@"token=%@", userToken];
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err = [NSError new];
    NSData *retData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
    if (!retData) {
        return NO;
    }
    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:retData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"%@", [resultDic valueForKey:@"message"]);
    NSString *status = [[resultDic valueForKey:@"status"] stringValue];
    if ([status isEqualToString:@"0"]) {
        return YES;
    } else {
        return NO;
    }
}

+ (void)getUnreadApply:(NSString *)userToken Callback:(FetchUnreadApply)callback
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", baseURL, UnreadApply]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSString *param = [NSString stringWithFormat:@"token=%@", userToken];
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError) {
            callback(0, NO);
        } else {
            NSString *unreadCount = [[NSString alloc] init];
            @try {
                NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSString *status = [[resultDic valueForKey:@"status"] stringValue];
                if ([status isEqualToString:@"0"]) {
                    unreadCount = [[resultDic valueForKey:@"attach"] stringValue];
                    callback(unreadCount, YES);
                } else {
                    callback(0, NO);
                }
                
            }
            @catch (NSException *exception) {
                NSLog(@"%@", exception);
            }
        }
    }];

}

+ (void)getPersonInfo:(NSString *)userToken PersonId:(NSString *)Pid Callback:(FetchFriendInfo)callback
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", baseURL, PersonInfo]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSString *param = [NSString stringWithFormat:@"token=%@&ids=%@", userToken, Pid];
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err = [NSError new];
        FriendModel *item = [[FriendModel alloc] init];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSString *status = [[resultDic valueForKey:@"status"] stringValue];
    if ([status isEqualToString:@"0"]) {
        NSArray *tmp = [resultDic valueForKey:@"attach"];
        item = [FriendModel FriendInfoWithObj:tmp[0]];
        callback(item, YES);
    } else {
        callback(nil, NO);
    }
}

+ (void)PushNotificationTest:(NSString *)Token
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", baseURL, PushTest]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSString *param = [NSString stringWithFormat:@"token=%@", Token];
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err = [NSError new];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSString *status = [[resultDic valueForKey:@"status"] stringValue];
    NSLog(@"%@", status);
}

+ (void)getPushInfo:(NSString *)userToken ClientId:(NSString *)clientId Callback:(FetchPushInfo)callback
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", baseURL, GetPushInfo]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSString *param = [NSString stringWithFormat:@"clientId=%@&token=%@", clientId, userToken];
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError) {
            callback(0, nil, nil, 0, NO);
        } else {
            NSString *time = [[NSString alloc] init];
            NSString *UnreadCount = [[NSString alloc] init];
            NSString *description = [[NSString alloc] init];
            NSString *title = [[NSString alloc] init];
            @try {
                NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSString *status = [[resultDic valueForKey:@"status"] stringValue];
                if ([status isEqualToString:@"0"]) {
                    
                    NSDictionary *attach = [resultDic valueForKey:@"attach"];
                    id tmp = [[attach valueForKey:@"date"] valueForKey:@"time"];
                    if (![tmp isKindOfClass:[NSNull class]]) {
                        time = [[[attach valueForKey:@"date"] valueForKey:@"time"] stringValue];
                        description = [attach valueForKey:@"description"];
                        title = [attach valueForKey:@"title"];
                        UnreadCount = [[attach valueForKey:@"unReadMessageCount"] stringValue];
                        callback([time longLongValue], description, title, UnreadCount, YES);
                    } else {
                        callback(0, nil, nil, 0, NO);
                    }
                    
                } else {
                    callback(0, nil, nil, 0, NO);
                }
            }
            @catch (NSException *exception) {
                NSLog(@"%@", exception);
            }
        }
    }];

}

+ (void)getNotificationMsgList:(NSString *)userToken ClientId:(NSString *)clientId Page:(int)page rowSize:(int)rowsize Callback:(FetchNoteMsg)callback
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", baseURL, GetNoteInfo]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSString *param = [NSString stringWithFormat:@"clientId=%@&token=%@&pageNo=%d&rowSize=%d", clientId, userToken, page, rowsize];
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError) {
            callback(nil, NO);
        } else {
            NSMutableArray *allNoteInfo = [[NSMutableArray alloc] init];
            @try {
                NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSString *status = [[resultDic valueForKey:@"status"] stringValue];
                if ([status isEqualToString:@"0"]) {
                    NSArray *allInfo = [[NSArray alloc] init];
                    allInfo = [[resultDic valueForKey:@"attach"] valueForKey:@"list"];
                    for (int i = 0; i < allInfo.count; i++) {
                        [allNoteInfo addObject:[NotificationModel NoteInfoWithObj:allInfo[i]]];
                    }
                    callback(allNoteInfo, YES);
                } else {
                    callback(nil, NO);
                }
                
            }
            @catch (NSException *exception) {
                NSLog(@"%@", exception);
            }
        }
    }];

}

+ (BOOL)ClearUnreadCount:(NSString *)userToken clientId:(NSString *)clientId
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", baseURL, ClearPushCount]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSString *param = [NSString stringWithFormat:@"clientId=%@&token=%@", clientId, userToken];
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err = [NSError new];
    NSData *retData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
    if (!retData) {
        return NO;
    }
    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:retData options:NSJSONReadingMutableContainers error:nil];
    NSString *status = [[resultDic valueForKey:@"status"] stringValue];
    if ([status isEqualToString:@"0"]) {
        return YES;
    } else {
        return NO;
    }
}

//获取用户的详细信息
+ (void)getPersonInfoDetail:(NSString *)token success:(requestSuccessBlock)success failure:(requestFailureBlock)failure
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", baseURL, PersonInfoDetail]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSString *param = [NSString stringWithFormat:@"token=%@", token];
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err = [NSError new];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSString *status = [[resultDic valueForKey:@"status"] stringValue];
    if ([status isEqualToString:@"0"]) {
        success(resultDic);
        NSLog(@"登录用户的详细信息%@",resultDic);
    }
    else {
        failure(err);
    }
}


//修改地址
+ (void)updateAddress:(NSString *)token address:(NSString *)adress success:(requestSuccessBlock)success failure:(requestFailureBlock)failure
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", baseURL, UpdateAddress]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSString *param = [NSString stringWithFormat:@"token=%@&adress=%@", token,adress];
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err = [NSError new];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if(success)
    {
        success(resultDic);
    }
    else {
        failure(err);
    }
}

+ (BOOL)UserLogout:(NSString *)token
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", baseURL, LogOut]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSString *param = [NSString stringWithFormat:@"token=%@", token];
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err = [NSError new];
    NSData *retData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
    if (!retData) {
        return NO;
    }
    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:retData options:NSJSONReadingMutableContainers error:nil];
    NSString *status = [[resultDic valueForKey:@"status"] stringValue];
    if ([status isEqualToString:@"0"]) {
        return YES;
    } else {
        return NO;
    }
}



@end
