//
//  WelcomeViewController.m
//  FriendShop
//
//  Created by xiaojia on 15/6/20.
//  Copyright (c) 2015年 Sirius. All rights reserved.
//

#import "WelcomeViewController.h"
#import "HomeViewController.h"
#import "FSNavigationViewController.h"
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
    [self addRACEvents];
    
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
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(scrollView.superview);
            make.left.equalTo(scrollView.superview);
            make.right.equalTo(scrollView.superview);
            make.bottom.equalTo(scrollView.superview);
        }];
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
                [button setImage:[UIImage imageNamed:@"开店"] forState:UIControlStateNormal];
               [button mas_makeConstraints:^(MASConstraintMaker *make) {
                       make.left.equalTo(imageView).with.offset(0.15*Screen_Width);
                       make.bottom.equalTo(imageView.mas_bottom).with.offset(-0.07*Screen_Height);
                       make.right.equalTo(imageView.mas_right).with.offset(-0.15*Screen_Width);
                }];
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
- (void)addRACEvents
{
    [[self.btn_enter rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        //第一次浏览完欢迎界面之后就不再显示了
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:@"isStarted" forKey:@"isStarted"];
        [ud synchronize];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:RECREATE_ROOT_VIEWCONTROLLER object:nil];

        
    }];
   
}



@end
