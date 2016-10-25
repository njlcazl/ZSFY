//
//  UIColor+Hex.h
//  zsfy
//
//  Created by 曾祺植 on 1/29/16.
//  Copyright © 2016 wzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

+ (UIColor *)colorWithHexString:(NSString *)color;

+ (UIColor *)hexStringToColor:(NSString *)color;

@end
