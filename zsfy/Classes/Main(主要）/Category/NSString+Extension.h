//
//  NSString+Extension.h
//  黑马微博2期
//
//  Created by apple on 14-10-18.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)
- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW;
- (CGSize)sizeWithFont:(UIFont *)font;
+ (BOOL)isPureInt:(NSString *)string;
// 判断字符串是否为空字符
+(BOOL) isBlankString:(NSString *)string;
+(BOOL)isValidateEmail:(NSString *)email;
@end
