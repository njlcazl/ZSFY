//
//  Filing_ViewController.m
//  zsfy
//
//  Created by tiannuo on 15/11/12.
//  Copyright (c) 2015年 wzy. All rights reserved.
//

#import "Filing_ViewController.h"
#import "RegistViewController.h"

@interface Filing_ViewController ()

@end

@implementation Filing_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"网上立案";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initWithView];
}

-(void)initWithView
{
    UILabel *lblTitle = [CTB labelTag:1 toView:self.view text:@"登录立案中心" wordSize:13];
    lblTitle.frame = CGRectMake(-3, -3, Screen_Width+6, 38);
    lblTitle.textColor = [UIColor blackColor];
    lblTitle.backgroundColor = [CTB colorWithHexString:@"EAEAEA"];
    lblTitle.layer.borderWidth = 3;
    lblTitle.layer.borderColor = [CTB colorWithHexString:@"987C47"].CGColor;
    lblTitle.textAlignment = NSTextAlignmentCenter;
    
    UIScrollView *ScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 35, Screen_Width, Screen_Height-64-35)];
    ScrollView.showsHorizontalScrollIndicator = NO;
    // 设置UIScrollView的滚动范围（内容大小）
    ScrollView.bounces = YES;
    ScrollView.backgroundColor = [CTB colorWithHexString:@"EAEAEA"];
    [self.view addSubview:ScrollView];
    
    /** 头像图片*/
    UIImageView *headImageView = [[UIImageView alloc]initWithFrame:CGRectMake((Screen_Width - 60)*0.5, 10, 60, 60)];
    headImageView.image = [UIImage imageNamed:@"person_head"];
    [ScrollView addSubview:headImageView];
    
    /** 账号*/
    UIView *countView = [[UIView alloc]initWithFrame:CGRectMake(0, headImageView.y+headImageView.height+10, Screen_Width, 44)];
    UIImageView *countImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    countImageView.image = [UIImage imageNamed:@"person_head"];
    [countView addSubview:countImageView];
    countView.backgroundColor = [UIColor whiteColor];
    UITextField *countTextFiled = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(countImageView.frame)+10, 0, 200, 44)];
    countTextFiled.placeholder = @"请输入用户名";
    [countView addSubview:countTextFiled];
    [ScrollView addSubview:countView];
    
    /** 密码*/
    UIView *passwordView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(countView.frame)+5, Screen_Width, 44)];
    UIImageView *passwordImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    passwordImageView.image = [UIImage imageNamed:@"person_head"];
    [passwordView addSubview:passwordImageView];
    passwordView.backgroundColor = [UIColor whiteColor];
    UITextField *passwordTextField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(passwordImageView.frame)+10, 0, 200, 44)];
    passwordTextField.placeholder = @"密码";
    [passwordView addSubview:passwordTextField];
    [ScrollView addSubview:passwordView];
    
    /** 登录*/
    UIButton *loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(14, GetMaxY(passwordView.frame)+10, Screen_Width - 28, 44)];
    loginBtn.layer.cornerRadius = 4.0f;
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setBackgroundColor:FYColor(0, 111, 194)];
    [loginBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [ScrollView addSubview:loginBtn];
    
    /** 立即注册账号*/
    UIButton *registBtn = [[UIButton alloc]init];
    NSString *registBtnName = @"立即注册账号";
    CGSize registSize = [registBtnName sizeWithFont:[UIFont systemFontOfSize:13]];
    [registBtn setTitle:registBtnName forState:UIControlStateNormal];
    [registBtn setTitleColor:FYColor(0, 111, 194) forState:UIControlStateNormal];
    registBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [registBtn setFrame:CGRectMake(Screen_Width-120, CGRectGetMaxY(loginBtn.frame)+20, 116, 20)];
    registBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    registBtn.contentEdgeInsets = UIEdgeInsetsMake(0,0, 0, 10);
    [registBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [ScrollView addSubview:registBtn];

}

#pragma mark 按钮点击事件
- (void)clickBtn:(UIButton *)button
{
    if ([button.titleLabel.text isEqualToString:@"登录"]) {
        [MBProgressHUD showSuccess:@"登录"];
    }else if ([button.titleLabel.text isEqualToString:@"立即注册账号"])
    {
        RegistViewController *registVC = [[RegistViewController alloc]init];
        [self.navigationController pushViewController:registVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
