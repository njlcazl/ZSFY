//
//  BaseNavigationViewController.m
//  UC_Demo_1.0.0
//
//  Created by Barry on 15/4/22.
//  Copyright (c) 2015年 Barry. All rights reserved.
//

#import "BaseNavigationViewController.h"

@interface BaseNavigationViewController ()

@end

@implementation BaseNavigationViewController




+(void)initialize{
    [self setupTheme];
}

+(void)setupTheme{
    //设置导航条背景
    UINavigationBar *navBar = [UINavigationBar appearance];
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7) {
        navBar.barTintColor = UIColorFromRGB(0x46ac5e); //设置导航栏颜色
    }else{
       navBar.tintColor = UIColorFromRGB(0x46ac5e);
    }

    
    // 设置全局状态栏样式
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    // 设置导航条标题字体样式
    NSMutableDictionary *titleAtt = [NSMutableDictionary dictionary];
    
    titleAtt[NSFontAttributeName] = [UIFont boldSystemFontOfSize:19];
    titleAtt[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [navBar setTitleTextAttributes:titleAtt];
    
    // 返回按钮的样式 白色
    [navBar setTintColor:[UIColor whiteColor]];
    
    // 设置导航条item的样式
    NSMutableDictionary *itemAtt = [NSMutableDictionary dictionary];
    
    itemAtt[NSFontAttributeName] = [UIFont boldSystemFontOfSize:15];
    itemAtt[NSForegroundColorAttributeName] = [UIColor whiteColor];
    UIBarButtonItem *barItem = [UIBarButtonItem appearance];
    [barItem setTitleTextAttributes:itemAtt forState:UIControlStateNormal];
    
    
    
}
@end
