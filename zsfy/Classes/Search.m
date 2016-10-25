//
//  Search.m
//  zsfy
//
//  Created by 曾祺植 on 11/29/15.
//  Copyright © 2015 wzy. All rights reserved.
//

#import "Search.h"
#import "ComUnit.h"
#import "Helper.h"
#import "FriendModel.h"

@interface Search()

@property (nonatomic, strong) NSArray *FriendInfo;
@property (nonatomic, strong) NSMutableArray *OtherInfo;
@property (nonatomic, strong) FriendModel *tmp;

@end

@implementation Search


+ (id)shareInstance
{
    static Search *shareInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        shareInstance = [[self alloc] init];
    });
    
    return shareInstance;
}

- (NSMutableArray *)OtherInfo
{
    if (!_OtherInfo) {
        _OtherInfo = [[NSMutableArray alloc] init];
    }
    return _OtherInfo;
}

- (void)setFriendData:(NSArray *)FriendInfo
{
    self.FriendInfo = FriendInfo;
}

- (NSString *)getImageUrl:(NSString *)Fid
{
    if ([Fid isEqualToString:@""] || Fid == nil || [Fid isKindOfClass:[NSNull class]]) {
        return @"";
    } else {
        BOOL flag = NO;
        for (int i = 0; i < self.FriendInfo.count; i++) {
            FriendModel *item = self.FriendInfo[i];
            if ([item.Fid isEqualToString:Fid]) {
                flag = YES;
                return item.imageUrl;
            }
        }
        for (int i = 0; i < self.OtherInfo.count; i++) {
            FriendModel *item = self.OtherInfo[i];
            if ([item.Fid isEqualToString:Fid]) {
                flag = YES;
                return item.imageUrl;
            }
        }
        if (!flag) {
            [ComUnit getPersonInfo:[Helper getUser_Token] PersonId:Fid Callback:^(FriendModel *item, BOOL succeed) {
                if(succeed) {
                    self.tmp = item;
                    [self.OtherInfo addObject:item];
                }
            }];
        }
        return self.tmp.imageUrl;
    }
    
}

- (NSString *)getNickName:(NSString *)Fid
{
    if ([Fid isEqualToString:@""] || Fid == nil || [Fid isKindOfClass:[NSNull class]]) {
        return @"";
    } else {
        BOOL flag = NO;
        for (int i = 0; i < self.FriendInfo.count; i++) {
            FriendModel *item = self.FriendInfo[i];
            if ([item.Fid isEqualToString:Fid]) {
                flag = YES;
                return item.nikeName;
            }
        }
        for (int i = 0; i < self.OtherInfo.count; i++) {
            FriendModel *item = self.OtherInfo[i];
            if ([item.Fid isEqualToString:Fid]) {
                flag = YES;
                return item.nikeName;
            }
        }
        if (!flag) {
            [ComUnit getPersonInfo:[Helper getUser_Token] PersonId:Fid Callback:^(FriendModel *item, BOOL succeed) {
                if(succeed) {
                    self.tmp = item;
                    [self.OtherInfo addObject:item];

                }
            }];
        }
        return self.tmp.nikeName;
    }
}

- (FriendModel *)getAllInfo:(NSString *)Fid
{
    if ([Fid isEqualToString:@""] || Fid == nil || [Fid isKindOfClass:[NSNull class]]) {
        return nil;
    } else {
        BOOL flag = NO;
        for (int i = 0; i < self.FriendInfo.count; i++) {
            FriendModel *item = self.FriendInfo[i];
            if ([item.Fid isEqualToString:Fid]) {
                flag = YES;
                return item;
            }
        }
        for (int i = 0; i < self.OtherInfo.count; i++) {
            FriendModel *item = self.OtherInfo[i];
            if ([item.Fid isEqualToString:Fid]) {
                flag = YES;
                return item;
            }
        }
        if (!flag) {
            [ComUnit getPersonInfo:[Helper getUser_Token] PersonId:Fid Callback:^(FriendModel *item, BOOL succeed) {
                if(succeed) {
                    self.tmp = item;
                    [self.OtherInfo addObject:item];
                    
                }
            }];
        }
        return self.tmp;
    }

}

- (BOOL)checkFriend:(NSString *)Fid
{
    BOOL isFriend = NO;
    for (int i = 0; i < self.FriendInfo.count; i++) {
        FriendModel *item = self.FriendInfo[i];
        if ([item.Fid isEqualToString:Fid]) {
            isFriend = YES;
            break;
        }
    }
    return isFriend;
}

@end