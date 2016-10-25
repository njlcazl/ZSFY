//
//  MorePlistOperate.h
//  zsfy
//
//  Created by Apple on 16/1/29.
//  Copyright © 2016年 wzy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <objc/runtime.h>

@interface MorePlistOperate : NSObject

+ (MorePlistOperate *)sharedInstace;

//write some information into plist
+ (void) writeToPlist:(NSString *)item key:(NSString *)key;

//read some information from plist with NSString return
+ (NSString *) read:(NSString *)temp;

//write array infomation into plist
+ (void) writeInfoToPlist:(NSMutableArray *)infoArray key:(NSString *)key;

//read array infomation from plist with NSArray return
+ (NSArray *) readInfoFromPlist:(NSString *)key;

//remove plist
+ (void)removePlist;

@end
