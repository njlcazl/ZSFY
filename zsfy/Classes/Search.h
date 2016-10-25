//
//  Search.h
//  zsfy
//
//  Created by 曾祺植 on 11/29/15.
//  Copyright © 2015 wzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FriendModel;

@interface Search : NSObject

+ (id)shareInstance;

- (void)setFriendData:(NSArray *)FriendInfo;

- (NSString *)getImageUrl:(NSString *)Fid;

- (NSString *)getNickName:(NSString *)Fid;

- (BOOL)checkFriend:(NSString *)Fid;

- (FriendModel *)getAllInfo:(NSString *)Fid;

@end
