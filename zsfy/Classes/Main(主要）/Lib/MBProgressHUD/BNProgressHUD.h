//
//  BNProgressHUD.h
//  BNEFansProject
//
//  Created by benniuMAC on 15/8/20.
//  Copyright (c) 2015年 BN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNProgressHUD : UIView

@property (nonatomic, strong) MBProgressHUD *HUD;

+ (void)createHUDWithSupView:(UIView *)supView andTitle:(NSString *)title;

+ (void)hidHUD;

@end
