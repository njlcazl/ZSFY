//
//  BNWRPlistData.h
//  BNWritePlistDataProject
//
//  Created by benniuMAC on 15/12/9.
//  Copyright © 2015年 BN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface BNWRPlistData : NSObject
/**
 *  单例方法
 *
 *  @return 返回单例对象
 */
+ (BNWRPlistData *)sharedInstace;
/**
 *  根据model写进plist文件
 *
 *  @param model 要写入的数据Model
 *
 *  @return 是否写入成功
 */
- (BOOL)writeOrUpdateToPlistWithModel:(id)model;
/**
 *  读取plist里存储的数据
 *
 *  @param model 要读取数据Model
 *
 *  @return 返回读取的Model数据
 */
- (id)readPlistDataWithModel:(id)model;
/**
 *  删除plist文件
 *
 *  @param model 要删除的plist数据Model
 *
 *  @return 删除是否成功
 */
- (BOOL)deletePlistDataWithModel:(id)model;


#pragma mark ======================== 读写数组用的，我只是实现而已，到时你可以自己封装优化
//读取plist里面存储的数组
- (NSMutableArray *)readPlistArrayDataWithPlistName:(NSString *)plistNameStr andDicKeySTr:(NSString *)dicKeyStr;

//写入plist数组数据
- (BOOL)writePlistArrayDataWithPlistName:(NSString *)plistNameStr andDicKeySTr:(NSString *)dicKeyStr alsoAndDataArray:(NSMutableArray *)muDataArray;

//删除plist数组数据
- (BOOL)deletePlistmuDataArrayWithPlistName:(NSString *)plistNameStr;


@end




































