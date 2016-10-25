//
//  WelcomeViewController.m
//  FriendShop
//
//  Created by xiaojia on 15/6/20.
//  Copyright (c) 2015年 Sirius. All rights reserved.
//

#import "WelcomeViewController.h"
#import "FYHomeViewController.h"
#import "FYNavigationController.h"
#import "AppDelegate.h"

@interface WelcomeViewController ()<UIScrollViewDelegate>

//立刻体验按钮
@property (nonatomic,strong)UIButton *btn_enter;
@property (strong, nonatomic)  UIPageControl *pageControl;

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createWelcomeView];
//    [self addRACEvents];
    
}

- (void)createWelcomeView
{
    //欢迎页面的滑动视图
    UIScrollView *sv_welcome = ({
        UIScrollView *scrollView = [[UIScrollView alloc]init];
        [self.view addSubview:scrollView];
        scrollView.delegate = self;
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.bounces = NO;
        scrollView.contentSize = CGSizeMake(Screen_Width * 3, Screen_Height);
        [scrollView setFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];

        //This is the starting point of the ScrollView
        CGPoint scrollPoint = CGPointMake(0, 0);
        [scrollView setContentOffset:scrollPoint animated:YES];
        
    //循环创建scroller里面的内容
    for(int i = 0;i < 3 ;i++){
        UIImageView *iv_welcome = ({
        UIImageView *imageView = [[UIImageView alloc]init];
            imageView.frame = CGRectMake(Screen_Width * i, 0, Screen_Width, Screen_Height);
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"引导页%d.png",i+2]];
            [scrollView addSubview:imageView];
            if (i == 2) {
                imageView.userInteractionEnabled = YES;
               self.btn_enter = ({
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [imageView addSubview:button];
                   [button setBackgroundColor:FYBlueColor];
                   [button setTitle:@"进入" forState:UIControlStateNormal];
                   button.layer.cornerRadius = 10.0f;
                   button.layer.borderColor = [[UIColor whiteColor]CGColor];
                   button.layer.borderWidth = 1.0f;
                   [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                   [button setFrame:CGRectMake(14, Screen_Height - 180, Screen_Width - 28,44)];
                   [button addTarget:self action:@selector(clickWelcomeBtn) forControlEvents:UIControlEventTouchUpInside];
                button;
                });
            }
            imageView;
        });

        }

        scrollView;
    });
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height*.95, self.view.frame.size.width, 10)];
    self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1.000];
    [self.view addSubview:self.pageControl];
    
    self.pageControl.numberOfPages = 3;

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat pageWidth = CGRectGetWidth(self.view.bounds);
    CGFloat pageFraction = scrollView.contentOffset.x / pageWidth;
    self.pageControl.currentPage = roundf(pageFraction);
    
}

#pragma mark -------- RACEvents -------------
- (void)clickWelcomeBtn
{
           //第一次浏览完欢迎界面之后就不再显示了
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:@"isStarted" forKey:@"isStarted"];
        [ud synchronize];
        
        [HWNotificationCenter postNotificationName:RECREATE_ROOT_VIEWCONTROLLER object:nil];

 
   
}



@end
