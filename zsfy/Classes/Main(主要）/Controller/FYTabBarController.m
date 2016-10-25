//
//  FYTabBarController.m
//  zsfy
//
//  Created by pyj on 15/11/9.
//  Copyright (c) 2015年 wzy. All rights reserved.
//

#import "FYTabBarController.h"
#import "FYHomeViewController.h"
#import "FYMessageCenterViewController.h"
#import "FYProfileViewController.h"
#import "FYCourtViewController.h"
#import "FYNavigationController.h"
#import "ConversationVC.h"

@interface FYTabBarController ()

@end

@implementation FYTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.初始化子控制器
    
    
    ConversationVC *messageCenter = [[ConversationVC alloc] init];
    [self addChildVc:messageCenter title:@"消息" image:@"message" selectedImage:@"message_high"];
    
    
    FYHomeViewController *home = [[FYHomeViewController alloc] init];
    [self addChildVc:home title:@"首页" image:@"home" selectedImage:@"home_high"];
     
    
    /*
    HomeViewController *home = [[HomeViewController alloc]init];
     [self addChildVc:home title:@"首页" image:@"home" selectedImage:@"home_high"];
     */
    
    
    FYProfileViewController *profile = [[FYProfileViewController alloc] init];
    [self addChildVc:profile title:@"我" image:@"my" selectedImage:@"my_high"];
    
    
    FYCourtViewController *court = [[FYCourtViewController alloc] init];
    [self addChildVc:court title:@"法院" image:@"fy" selectedImage:@"fy_high"];
    
   
    self.selectedIndex = 1;

    /*
     [self setValue:tabBar forKeyPath:@"tabBar"];相当于self.tabBar = tabBar;
     [self setValue:tabBar forKeyPath:@"tabBar"];这行代码过后，tabBar的delegate就是HWTabBarViewController
     说明，不用再设置tabBar.delegate = self;
     */
    
    /*
     1.如果tabBar设置完delegate后，再执行下面代码修改delegate，就会报错
     tabBar.delegate = self;
     
     2.如果再次修改tabBar的delegate属性，就会报下面的错误
     错误信息：Changing the delegate of a tab bar managed by a tab bar controller is not allowed.
     错误意思：不允许修改TabBar的delegate属性(这个TabBar是被TabBarViewController所管理的)
     */

   
}

/**
 *  添加一个子控制器
 *
 *  @param childVc       子控制器
 *  @param title         标题
 *  @param image         图片
 *  @param selectedImage 选中的图片
 */
- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置子控制器的文字
    childVc.title = title; // 同时设置tabbar和navigationBar的文字
    
    // 设置子控制器的图片
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 设置文字的样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = FYColor(123, 123, 123);
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = FYColor(0, 100, 178);
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    
    // 先给外面传进来的小控制器 包装 一个导航控制器
    FYNavigationController *nav = [[FYNavigationController alloc] initWithRootViewController:childVc];
    // 添加为子控制器
    [self addChildViewController:nav];
}


@end
