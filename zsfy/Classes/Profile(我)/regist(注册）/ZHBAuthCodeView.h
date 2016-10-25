//
//  ZHBAuthCodeView.h
//  ZHBTestDemo
//
//  Created by 庄彪 on 15/9/7.
//  Copyright (c) 2015年 zhuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHBAuthCodeView : UIView

/*! @brief  当前验证码 */
@property (nonatomic, copy, readonly) NSString *authCode;

- (BOOL)isCorrectAuthCode:(NSString *)code;

- (void)changeAuthCode;

@end
