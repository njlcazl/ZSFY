//
//  FYNavigationController.m
//  zsfy
//
//  Created by pyj on 15/11/9.
//  Copyright (c) 2015年 wzy. All rights reserved.
//

#import "FYNavigationController.h"
#import "Tools_F.h"

@interface FYNavigationController ()

@end

@implementation FYNavigationController
+ (void)initialize
{
    // 设置整个项目所有item的主题样式
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    
    //导航条背景
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    [navigationBarAppearance setBackgroundImage:[Tools_F imageWithColor:FYBlueColor size:CGSizeMake(10, 10)] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    //[navigationBarAppearance setBackgroundImage:[Tools_F imageWithColor:FYBlueColor size:CGSizeMake(10, 10)] forBarMetrics:UIBarMetricsDefault];
    
    //导航条字体颜色
    [navigationBarAppearance setTintColor:[UIColor whiteColor]];
    NSMutableDictionary *titleDict = [NSMutableDictionary dictionary];
    titleDict[NSForegroundColorAttributeName] = [UIColor whiteColor];
    titleDict[NSFontAttributeName] = [UIFont boldSystemFontOfSize:17];
    [navigationBarAppearance setTitleTextAttributes:titleDict];
    
    // 设置普通状态
    // key：NS****AttributeName
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    // 设置不可用状态
    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionary];
    disableTextAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.7];
    disableTextAttrs[NSFontAttributeName] = textAttrs[NSFontAttributeName];
    [item setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
    
//    
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    // 透明状态栏的延伸
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    [self.navigationController.navigationBar setBackgroundImage:kImageWithName(@"标题栏")
//                                                 forBarPosition:UIBarPositionAny
//                                                     barMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/**
 *  重写这个方法目的：能够拦截所有push进来的控制器
 *
 *  @param viewController 即将push进来的控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) { // 这时push进来的控制器viewController，不是第一个子控制器（不是根控制器）
        /* 自动显示和隐藏tabbar */
        viewController.hidesBottomBarWhenPushed = YES;
        
        /* 设置导航栏上面的内容 */
        // 设置左边的返回按钮
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"nav_back" highImage:@"nav_back"];
        
        // 设置右边的更多按钮
        viewController.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(more) image:@"navigationbar_more" highImage:@"navigationbar_more_highlighted"];
    }
    
    [super pushViewController:viewController animated:animated];
}


- (void)back
{
    
#warning 这里要用self，不是self.navigationController
    // 因为self本来就是一个导航控制器，self.navigationController这里是nil的
    [self popViewControllerAnimated:YES];
}

- (void)more
{
    [self popToRootViewControllerAnimated:YES];
}
@end
