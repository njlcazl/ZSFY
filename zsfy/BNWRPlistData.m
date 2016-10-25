//
//  BNWRPlistData.m
//  BNWritePlistDataProject
//
//  Created by benniuMAC on 15/12/9.
//  Copyright © 2015年 BN. All rights reserved.
//

#import "BNWRPlistData.h"

// 通过实体获取类名
#define KCLASS_NAME(model) [NSString stringWithUTF8String:object_getClassName(model)]
// 通过实体获取属性数组数目
#define KMODEL_PROPERTYS_COUNT [[self getAllProperties:model] count]
// 通过实体获取属性数组
#define KMODEL_PROPERTYS [self getAllProperties:model]

static BNWRPlistData *plistManager = nil;

@implementation BNWRPlistData
//创建单例对象
+ (BNWRPlistData *)sharedInstace
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        plistManager = [[BNWRPlistData allocWithZone:nil]init];
    });
    return plistManager;

}


#pragma mark ======================== 
//读取plist里面存储的数组
- (NSMutableArray *)readPlistArrayDataWithPlistName:(NSString *)plistNameStr andDicKeySTr:(NSString *)dicKeyStr
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *plistFilePath = [NSString stringWithFormat:@"%@",[path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",plistNameStr]]];
    NSLog(@"%@",path);
    //先判断文件是否存在
    NSMutableArray *muDataArray = [NSMutableArray array];
    if([fileManager fileExistsAtPath:plistFilePath])
    {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithContentsOfFile : plistFilePath];
        muDataArray = [dict objectForKey:dicKeyStr];
    }
    else
    {
        return nil;
    }
    return muDataArray;
}

//写入plist数组数据
- (BOOL)writePlistArrayDataWithPlistName:(NSString *)plistNameStr andDicKeySTr:(NSString *)dicKeyStr alsoAndDataArray:(NSMutableArray *)muDataArray
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *plistFilePath = [NSString stringWithFormat:@"%@",[path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",plistNameStr]]];
    NSLog(@"%@",path);
    //先判断文件是否存在
    if([fileManager fileExistsAtPath:plistFilePath])
    {
        NSMutableDictionary *muDic = [[NSMutableDictionary alloc] init];
        [muDic setObject:muDataArray forKey:dicKeyStr];
        return [muDic writeToFile: plistFilePath  atomically: YES] ;
    }
    else
    {
        if([fileManager createFileAtPath:plistFilePath contents:nil attributes:nil])
        {
            NSMutableDictionary *muDic = [[NSMutableDictionary alloc] init];
            [muDic setObject:muDataArray forKey:dicKeyStr];
            return [muDic writeToFile: plistFilePath  atomically: YES] ;
        }
    }
    return NO;
}

//删除plist数组数据
- (BOOL)deletePlistmuDataArrayWithPlistName:(NSString *)plistNameStr
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *plistFilePath = [NSString stringWithFormat:@"%@",[path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",plistNameStr]]];
    if([fileManager fileExistsAtPath:plistFilePath])
    {
        return [fileManager removeItemAtPath:plistFilePath error:nil];
    }
    else
    {
        NSLog(@"文件不存在");
        return NO;
    }
}







#pragma  mark ===========================
//获取plist文件路径
- (NSString *)getPlsitpathWithModel:(id)model
{
    //get the plist file from bundle
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSLog(@"%@",path);
    return  [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",KCLASS_NAME(model)]];
}

// 根据model写进plist文件
- (BOOL)writeOrUpdateToPlistWithModel:(id)model
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //get the plist file from bundle
    NSString *plistPath = [self getPlsitpathWithModel:model];
    //先判断沙盒里面的plist文件是否存在
    if([fileManager fileExistsAtPath:plistPath])
    {
        NSMutableDictionary *muDic = [[NSMutableDictionary alloc] init];
        //先遍历Model的所有属性
        for (int i = 0; i < KMODEL_PROPERTYS_COUNT; i ++) {
            NSString *str = [NSString stringWithFormat:@"%@",[model valueForKey:[KMODEL_PROPERTYS objectAtIndex:i]]];
            if(str == nil || [str isEqualToString:@"(null)"])
            {
                str = @"none";
            }
            NSLog(@"存在：%@",str);
            [muDic setObject:str forKey:[KMODEL_PROPERTYS objectAtIndex:i]];
        }
        return [muDic writeToFile: plistPath  atomically: YES] ;
    }
    //如果不存在，则先创建plist文件再写入
    else
    {
        BOOL result = NO;
        //创建plist文件
        if([fileManager createFileAtPath:plistPath contents:nil attributes:nil])
        {
            NSMutableDictionary *muDic = [[NSMutableDictionary alloc] init];
            //先遍历Model的所有属性
            for (int i = 0; i < KMODEL_PROPERTYS_COUNT; i ++) {
                NSString *str = [NSString stringWithFormat:@"%@",[model valueForKey:[KMODEL_PROPERTYS objectAtIndex:i]]];
                if(str == nil || [str isEqualToString:@"(null)"])
                {
                    str = @"none";
                }
                NSLog(@"不存在：%@",str);
                
                [muDic setObject:str forKey:[KMODEL_PROPERTYS objectAtIndex:i]];
            }
            result = [muDic writeToFile: plistPath  atomically: YES] ;
        }
        return result;
    }
}

//读取plist文件操作
- (id)readPlistDataWithModel:(id)model
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *plistPath = [self getPlsitpathWithModel:model];
    //先判断是否存在该plist文件
    if([fileManager fileExistsAtPath:plistPath])
    {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithContentsOfFile : plistPath];
        //通过runtime来创建一个新的对象（就是先拿到传过来的Model类名，以此类名创建一个新的对象，并读取plist文件里内容，再把该内容赋值给该新对象，然后返回return）
        Class readModelClass = NSClassFromString(KCLASS_NAME(model));
        id readModel = [[readModelClass alloc] init];
        [readModel setValuesForKeysWithDictionary:dict];
        return readModel;
    }
    else
    {
        return nil;
    }
}

//删除plist数据文件
- (BOOL)deletePlistDataWithModel:(id)model
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //get the plist file from bundle
    NSString *plistPath = [self getPlsitpathWithModel:model];
    if([fileManager fileExistsAtPath:plistPath])
    {
        return [fileManager removeItemAtPath:plistPath error:nil];
    }
    else
    {
        NSLog(@"文件不存在");
        return NO;
    }
}

/** 获取model的所有属性
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
@end






































