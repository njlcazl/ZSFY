//
//  BNProgressHUD.m
//  BNEFansProject
//
//  Created by benniuMAC on 15/8/20.
//  Copyright (c) 2015年 BN. All rights reserved.
//

#import "BNProgressHUD.h"

static BNProgressHUD *HUD = nil;

@implementation BNProgressHUD

+ (void)createHUDWithSupView:(UIView *)supView andTitle:(NSString *)title
{
    if(HUD == nil)
    {
        HUD = [[BNProgressHUD alloc] init];
        HUD.HUD = [[MBProgressHUD alloc] init];
        HUD.HUD.removeFromSuperViewOnHide = YES;
    }
    HUD.HUD.labelText = title;
    [supView endEditing:YES];
    [supView addSubview:HUD.HUD];
    [supView bringSubviewToFront:HUD.HUD];
    [HUD.HUD show:NO];
}

+ (void)hidHUD
{
    if(HUD != nil)
    {
        [HUD.HUD hide:YES];
    }
}

@end
