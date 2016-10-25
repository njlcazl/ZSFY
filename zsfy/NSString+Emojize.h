//
//  NSString+Emojize.h
//  UC_Demo_1.0.0
//
//  Created by Barry on 15/5/8.
//  Copyright (c) 2015年 Barry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Emojize)

/**
 *  通用字符串转成表情字符串,
 *
 *  这里的转换是灵活的，只对中间有意义的字符串进行转换，没有意义的原样输出。
 *
 *  @return 转好的表情字符串
 */
- (NSString *)emojizedString;
+ (NSString *)emojizedStringWithString:(NSString *)text;


/**
 *  表情字符串转成通用字符串
 *
 *  @return 转好的通用字符串
 */
- (NSString *)aliasedString;
+ (NSString *)aliasedStringWithString:(NSString *)text;


/**
 *  获取所有的表情字符串。
 *
 *  @return 字典。key是通用字符，value是表情字符
 */
+ (NSDictionary *)emojiForAliases;

/**
 *  获取所有的通用字符串
 *
 *  @return 通用字符串. key是表情字符，value是通用字符串
 */
+ (NSDictionary *)aliaseForEmojis;


/**
 *  转换单个表情字符串 对应的 通用字符串
 *
 *  @return 通用字符串（单个）
 */
- (NSString *)toAliase;


/**
 *  转换 单个通用字符串 为对应的表情字符串
 *
 *  @return 表情字符串（单个）
 */
- (NSString *)toEmoji;



@end
