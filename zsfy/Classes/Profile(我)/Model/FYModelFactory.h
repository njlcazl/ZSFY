//
//  FYModelFactory.h
//  zsfy
//
//  Created by pyj on 15/11/22.
//  Copyright (c) 2015年 wzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FYModelFactory : NSObject

@property (nonatomic,strong)NSString *userId;
@property (nonatomic,strong)NSDictionary * userInfoDictionary;
+(instancetype )shareInstance;
- (void)initDataWithObject:(NSDictionary *)userInfoDictionary andId:(NSString *)userId;
- (id)getObjectById:(NSString *)userId fromTable:(NSString *)tableName;
- (void)SaveIdForUser;//存ID号
- (void)cancelLoginId;//清除ID数据
- (void)initDataId; //读取ID账号
-(void)parse:(NSString *)UserId;

@end
