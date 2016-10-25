//
//  FYModelFactory.m
//  zsfy
//
//  Created by pyj on 15/11/22.
//  Copyright (c) 2015年 wzy. All rights reserved.
//

#import "FYModelFactory.h"
#include "Helper.h"
#import "YTKKeyValueStore.h"
static FYModelFactory *_sharedUser ;

@implementation FYModelFactory
+(instancetype )shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedUser = [[FYModelFactory alloc] init];
        
    });
    return _sharedUser;
}

- (void)initDataWithObject:(NSDictionary *)userInfoDictionary andId:(NSString *)userId
{
    //创建数据库，数据库会自动检测，已经建立过，不再重复建立
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:[NSString stringWithFormat:@"%@.db",DB_NAME]];
    NSString *tableName = @"person_table";
    //创建名为user_table的表，如果已存在，不再重复建立
    [store createTableWithName:tableName];
    [store putObject:userInfoDictionary withId:userId intoTable:tableName];
    [self parse:self.userId];
}


//获取数据库的存储内容
- (id)getObjectById:(NSString *)Id fromTable:(NSString *)tableName{
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:[NSString stringWithFormat:@"%@.db",DB_NAME]];
    [store createTableWithName:tableName];
    NSMutableDictionary * dict = [store getObjectById:Id fromTable:tableName];
    
    return dict;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initDataId];
    }
    return self;
}

//获取本地Id
- (void)initDataId
{
    NSUserDefaults *mUser = [NSUserDefaults standardUserDefaults];
    self.userId = [mUser objectForKey:@"user_id"];
 
}

- (void)parse:(NSString *)UserId
{
 
   
    NSUserDefaults *mUser = [NSUserDefaults standardUserDefaults];  //存本地User_Id
    [mUser setObject:UserId forKey:@"user_id"];
    [mUser synchronize];


}


- (void)cancelLoginId
{
    NSUserDefaults *mUser = [NSUserDefaults standardUserDefaults];
    [mUser setObject:@"" forKey:@"user_id"];
    
    [mUser synchronize];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self initDataId];
    });
}


@end
