//
//  NSString+UCMessageInputView.m
//  UC_Demo_1.0.0
//
//  Created by Barry on 15/6/10.
//  Copyright (c) 2015年 Barry. All rights reserved.
//

#import "NSString+UCMessageInputView.h"

@implementation NSString (UCMessageInputView)

- (NSString *)stringByTrimingWhitespace {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSUInteger)numberOfLines {
    return [[self componentsSeparatedByString:@"\n"] count] + 1;
}

@end
