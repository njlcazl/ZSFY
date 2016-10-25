//
//  DBManager.h
//  LoginDemo
//
//  Created by Apple on 15/12/4.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

@interface DBManager : NSObject

/**
 *  单例方法
 *
 *  @return DBManager对象
 */
+ (DBManager *)sharedInstace;

/**
 *  创建数据及数据表
 */
- (void)creatTable:(id)model;

/**
 *  插入表操作
 *
 *  @param model 实体
 */
- (BOOL)insertOrUpdateModel:(id)model;

/**
 *  删除对应ID的数据表数据 （删除对应ID的那一行数据，ID作为第一个字段）
 *
 *  @param model 实体
 */
- (BOOL)deleteModel:(id)model andIsWhereId:(BOOL)isWhereId;

/**
 *  删除对应ID的数据表数据 （不需要根据ID删除，删除整张表数据结构）
 *
 *  @param model 实体
 */
- (BOOL)deleteModelWithountID:(id)model;



/**
 *  查询表中所有内容
 *
 *  @return 所有实体的数组
 */
- (NSArray *)getAllModel:(id)model;

/**
 *  查询表中所有内容（model的id必须有值）
 *
 *  @param model 实体
 *
 *  @return 所有实体的数组
 */
- (NSArray *)getAllModelByID:(id)model;


@end
