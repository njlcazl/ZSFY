//
//  DBManager.m
//  LoginDemo
//
//  Created by Apple on 15/12/4.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "DBManager.h"
//IOS 运行时
#import <objc/runtime.h>

// 通过实体获取类名
#define KCLASS_NAME(model) [NSString stringWithUTF8String:object_getClassName(model)]
// 通过实体获取属性数组数目
#define KMODEL_PROPERTYS_COUNT [[self getAllProperties:model] count]
// 通过实体获取属性数组
#define KMODEL_PROPERTYS [self getAllProperties:model]

static DBManager * manager = nil;

@implementation DBManager
{
    //数据库
    FMDatabase *qdmy_db;
}

//单例创建数据库对象
+(DBManager *)sharedInstace{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DBManager allocWithZone:nil]init];
    });
    return manager;
}


// 获取沙盒路径
- (NSString *)databaseFilePath
{
    NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [filePath objectAtIndex:0];
    NSLog(@"%@",filePath);
    NSString *dbFilePath = [documentPath stringByAppendingPathComponent:@"hty_db.sqlite"];
    NSLog(@"沙河路径：%@",documentPath);
    //返回沙河路径
    return dbFilePath;
}

/**
 *  传递一个model实体
 *
 *  @param model 实体
 *
 *  @return 实体的属性
 */
- (NSArray *)getAllProperties:(id)model
{
    u_int count;
    
    objc_property_t *properties  = class_copyPropertyList([model class], &count);
    
    NSMutableArray *propertiesArray = [NSMutableArray array];
    
    for (int i = 0; i < count ; i++)
    {
        const char* propertyName = property_getName(properties[i]);
        [propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];
    }
    
    free(properties);
    return propertiesArray;
}


// 创建数据库
- (void)creatDatabase
{
    qdmy_db = [FMDatabase databaseWithPath:[self databaseFilePath]];
}

//创建表
- (void)creatTable:(id)model
{
    //先判断数据库是否存在，如果不存在，创建数据库
    if (!qdmy_db) {
        [self creatDatabase];
    }
    //判断数据库是否已经打开，如果没有打开，提示失败
    if (![qdmy_db open]) {
        NSLog(@"数据库打开失败");
        return;
    }
    
    //为数据库设置缓存，提高查询效率
    [qdmy_db setShouldCacheStatements:YES];
    
    //判断数据库中是否已经存在这个表，如果不存在则创建该表
    if (![qdmy_db tableExists:KCLASS_NAME(model)]) {
        // 1.创建表语句头部拼接
        NSString *creatTableStrHeader = [NSString stringWithFormat:@"create table %@(id INTEGER PRIMARY KEY",KCLASS_NAME(model)];
        // 2.创建表语句中部拼接
        NSString *creatTableStrMiddle =[NSString string];
        for (int i = 0; i < KMODEL_PROPERTYS_COUNT; i++) {
            creatTableStrMiddle = [creatTableStrMiddle stringByAppendingFormat:@",%@ TEXT",[KMODEL_PROPERTYS objectAtIndex:i]];
        }
        // 3.创建表语句尾部拼接
        NSString *creatTableStrTail =[NSString stringWithFormat:@")"];
        // 4.整句创建表语句拼接
        NSString *creatTableStr = [NSString string];
        creatTableStr = [creatTableStr stringByAppendingFormat:@"%@%@%@",creatTableStrHeader,creatTableStrMiddle,creatTableStrTail];
        [qdmy_db executeUpdate:creatTableStr];
        
        NSLog(@"创建完成");
    }
    //    关闭数据库
    [qdmy_db close];
}


/**
 *  插入表或更新表操作
 *
 *  @param user 用户实体
 */
- (BOOL)insertOrUpdateModel:(id)model
{
    // 判断数据库是否存在
    if (!qdmy_db) {
        [self creatDatabase];
    }
    // 判断数据库能否打开
    if (![qdmy_db open]) {
        NSLog(@"数据库打开失败");
        return NO;
    }
    // 设置数据库缓存
    [qdmy_db setShouldCacheStatements:YES];
    
    // 判断是否存在对应的userModel表
    if(![qdmy_db tableExists:KCLASS_NAME(model)])
    {
        [self creatTable:model];
    }
    
    //以上操作与创建表是做的判断逻辑相同
    //现在表中查询有没有相同的元素，如果有，做修改操作
    // 拼接查询语句头部
    NSString *selectStrHeader = [NSString stringWithFormat:@"select * from %@ where ",KCLASS_NAME(model)];
    // 拼接查询语句尾部
    NSString *selectStrTail = [NSString stringWithFormat:@"%@ = ?",[KMODEL_PROPERTYS objectAtIndex:0]];
    // 整个查询语句拼接
    NSString *selectStr = [NSString string];
    selectStr = [selectStr stringByAppendingFormat:@"%@%@",selectStrHeader,selectStrTail];
    FMResultSet * resultSet = [qdmy_db executeQuery:selectStr,[model valueForKey:[KMODEL_PROPERTYS objectAtIndex:0]]];
    NSLog(@"%@",[KMODEL_PROPERTYS objectAtIndex:0]);
    if([resultSet next])
    {
        // 拼接更新语句的头部
        NSString *updateStrHeader = [NSString stringWithFormat:@"update %@ set ",KCLASS_NAME(model)];
        // 拼接更新语句的中部
        NSString *updateStrMiddle = [NSString string];
        for (int i = 0; i< KMODEL_PROPERTYS_COUNT; i++) {
            updateStrMiddle = [updateStrMiddle stringByAppendingFormat:@"%@ = ?",[KMODEL_PROPERTYS objectAtIndex:i]];
            if (i != KMODEL_PROPERTYS_COUNT -1) {
                updateStrMiddle = [updateStrMiddle stringByAppendingFormat:@","];
            }
        }
        // 拼接更新语句的尾部  where %@ = '%@'数据库语句语法，NSString类型，
        NSString *updateStrTail = [NSString stringWithFormat:@" where %@ = '%@'",[KMODEL_PROPERTYS objectAtIndex:0],[model valueForKey:[KMODEL_PROPERTYS objectAtIndex:0]]];
        // 整句拼接更新语句
        NSString *updateStr = [NSString string];
        updateStr = [updateStr stringByAppendingFormat:@"%@%@%@",updateStrHeader,updateStrMiddle,updateStrTail];
        NSMutableArray *propertyArray = [NSMutableArray array];
        
        for (int i = 0; i < KMODEL_PROPERTYS_COUNT; i++) {
            NSString *midStr = [model valueForKey:[KMODEL_PROPERTYS objectAtIndex:i]];
            // 判断属性值是否为空
            if (midStr == nil) {
                midStr = @"none";
            }
            [propertyArray addObject:midStr];
        }
        BOOL result = [qdmy_db executeUpdate:updateStr withArgumentsInArray:propertyArray];
        
        //    关闭数据库
        [qdmy_db close];
        
        return result;
    }
    //向数据库中插入一条数据
    else{
        // 拼接插入语句的头部
        NSString *insertStrHeader = [NSString stringWithFormat:@"INSERT INTO %@ (",KCLASS_NAME(model)];
        // 拼接插入语句的中部1
        NSString *insertStrMiddleOne = [NSString string];
        for (int i = 0; i < KMODEL_PROPERTYS_COUNT; i++) {
            insertStrMiddleOne = [insertStrMiddleOne stringByAppendingFormat:@"%@",[KMODEL_PROPERTYS objectAtIndex:i]];
            if (i != KMODEL_PROPERTYS_COUNT -1) {
                insertStrMiddleOne = [insertStrMiddleOne stringByAppendingFormat:@","];
            }
        }
        // 拼接插入语句的中部2
        NSString *insertStrMiddleTwo = [NSString stringWithFormat:@") VALUES ("];
        // 拼接插入语句的中部3
        NSString *insertStrMiddleThree = [NSString string];
        for (int i = 0; i < KMODEL_PROPERTYS_COUNT; i++) {
            insertStrMiddleThree = [insertStrMiddleThree stringByAppendingFormat:@"?"];
            if (i != KMODEL_PROPERTYS_COUNT-1) {
                insertStrMiddleThree = [insertStrMiddleThree stringByAppendingFormat:@","];
            }
        }
        // 拼接插入语句的尾部
        NSString *insertStrTail = [NSString stringWithFormat:@")"];
        // 整句插入语句拼接
        NSString *insertStr = [NSString string];
        insertStr = [insertStr stringByAppendingFormat:@"%@%@%@%@%@",insertStrHeader,insertStrMiddleOne,insertStrMiddleTwo,insertStrMiddleThree,insertStrTail];
        NSMutableArray *modelPropertyArray = [NSMutableArray array];
        for (int i = 0; i < KMODEL_PROPERTYS_COUNT; i++) {
            NSString *str = [NSString stringWithFormat:@"%@",[model valueForKey:[KMODEL_PROPERTYS objectAtIndex:i]]];
            if (str == nil) {
                str = @"none";
            }
            [modelPropertyArray addObject: str];
        }
        BOOL result = [qdmy_db executeUpdate:insertStr withArgumentsInArray:modelPropertyArray];
        
        //    关闭数据库
        [qdmy_db close];
        
        return result;
    }
}


/**
 *  删除对应id的数据表数据 （删除对应id的那一行数据，id作为第一个字段）
 *
 *  @param model 实体
 */
- (BOOL)deleteModel:(id)model andIsWhereId:(BOOL)isWhereId
{
    // 判断是否创建数据库
    if (!qdmy_db) {
        [self creatDatabase];
    }
    // 判断数据是否已经打开
    if (![qdmy_db open]) {
        NSLog(@"数据库打开失败");
        return NO;
    }
    // 设置数据库缓存，优点：高效
    [qdmy_db setShouldCacheStatements:YES];
    
    // 删除操作
    if(isWhereId)
    {
        // 判断是否有该表
        if(![qdmy_db tableExists:KCLASS_NAME(model)])
        {
            return NO;
        }
        // 拼接删除语句
        NSString *deletStr = [NSString stringWithFormat:@"delete from %@ where %@ = ?",KCLASS_NAME(model),[KMODEL_PROPERTYS objectAtIndex:0]];
        BOOL result = [qdmy_db executeUpdate:deletStr, [model valueForKey:[KMODEL_PROPERTYS objectAtIndex:0]]];
        NSLog(@"%@",deletStr);
        // 关闭数据库
        [qdmy_db close];
        return result;
    }
    else
    {
        // 判断是否有该表
        if(![qdmy_db tableExists:KCLASS_NAME(model)])
        {
            [self creatTable:KCLASS_NAME(model)];
        }
        // 拼接删除语句
        NSString *deletStr = [NSString stringWithFormat:@"delete from %@",KCLASS_NAME(model)];
        BOOL result = [qdmy_db executeUpdate:deletStr];
        NSLog(@"%@",deletStr);
        // 关闭数据库
        [qdmy_db close];
        return result;
    }
}


//删除对象，不需要根据ID
- (BOOL)deleteModelWithountID:(id)model
{
    // 判断是否创建数据库
    if (!qdmy_db) {
        [self creatDatabase];
    }
    // 判断数据是否已经打开
    if (![qdmy_db open]) {
        NSLog(@"数据库打开失败");
        return NO;
    }
    // 设置数据库缓存，优点：高效
    [qdmy_db setShouldCacheStatements:YES];
    
    // 判断是否有该表
    if(![qdmy_db tableExists:KCLASS_NAME(model)])
    {
        return NO;
    }
    // 删除操作
    // 拼接删除语句
    NSString *deletStr = [NSString stringWithFormat:@"delete from %@",KCLASS_NAME(model)];
    BOOL result = [qdmy_db executeUpdate:deletStr];
    NSLog(@"%@",deletStr);
    // 关闭数据库
    [qdmy_db close];
    return result;
}

/**
 *  查询表中所有内容
 *
 *  @return 所有实体的数组
 */
- (NSArray *)getAllModel:(id)model
{
    
    if (!qdmy_db) {
        [self creatDatabase];
    }
    
    if (![qdmy_db open]) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    
    [qdmy_db setShouldCacheStatements:YES];
    
    if(![qdmy_db tableExists:KCLASS_NAME(model)])
    {
        return nil;
    }
    //定义一个可变数组，用来存放查询的结果，返回给调用者
    NSMutableArray *userModelArray = [NSMutableArray array];
    //定义一个结果集，存放查询的数据
    //拼接查询语句  (通过表名来查询)
    NSString *selectStr = [NSString stringWithFormat:@"select * from %@",KCLASS_NAME(model)];
    FMResultSet *resultSet = [qdmy_db executeQuery:selectStr];
    //判断结果集中是否有数据，如果有则取出数据
    while ([resultSet next]) {
        // 用id类型变量的类去创建对象
        id modelResult = [[[model class]alloc] init];
        for (int i = 0; i < KMODEL_PROPERTYS_COUNT; i++) {
            [modelResult setValue:[resultSet stringForColumn:[KMODEL_PROPERTYS objectAtIndex:i]] forKey:[KMODEL_PROPERTYS objectAtIndex:i]];
        }
        //将查询到的数据放入数组中。
        [userModelArray addObject:modelResult];
    }
    // 关闭数据库
    [qdmy_db close];
    
    return userModelArray;
}


/**
 *  查询表中所有内容（model的id必须有值）
 *
 *  @param model 实体
 *
 *  @return 所有实体的数组
 */
- (NSArray *)getAllModelByID:(id)model
{
    if (!qdmy_db) {
        [self creatDatabase];
    }
    
    if (![qdmy_db open]) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    
    [qdmy_db setShouldCacheStatements:YES];
    
    if(![qdmy_db tableExists:KCLASS_NAME(model)])
    {
        return nil;
    }
    //定义一个可变数组，用来存放查询的结果，返回给调用者
    NSMutableArray *userModelArray = [NSMutableArray array];
    //定义一个结果集，存放查询的数据
    //拼接查询语句  (根据表ID来查询，而且需要将ID作为第一个属性)
    NSString *selectStr = [NSString stringWithFormat:@"select * from %@ where %@ = ?",KCLASS_NAME(model),[KMODEL_PROPERTYS objectAtIndex:0]];
    FMResultSet *resultSet = [qdmy_db executeQuery:selectStr,[model valueForKey:[KMODEL_PROPERTYS objectAtIndex:0]]];
    //判断结果集中是否有数据，如果有则取出数据
    while ([resultSet next]) {
        // 用id类型变量的类去创建对象
        id modelResult = [[[model class]alloc] init];
        for (int i = 0; i < KMODEL_PROPERTYS_COUNT; i++) {
            [modelResult setValue:[resultSet stringForColumn:[KMODEL_PROPERTYS objectAtIndex:i]] forKey:[KMODEL_PROPERTYS objectAtIndex:i]];
        }
        //将查询到的数据放入数组中。
        [userModelArray addObject:modelResult];
    }
    // 关闭数据库
    [qdmy_db close];
    
    return userModelArray;
}









@end
