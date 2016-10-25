//
//  FYLoginViewController.m
//  zsfy
//
//  Created by pyj on 15/11/10.
//  Copyright (c) 2015年 wzy. All rights reserved.
//

#import "FYLoginViewController.h"
#import "UCSIMSDK.h"
#import "ComUnit.h"
#import "GeTuiSdk.h"
#import "Helper.h"
#import "RegistViewController.h"

#import "ItemInfo.h"
#import "DBManager.h"



@interface FYLoginViewController ()
{
    UITextField *countTextFiled;
    UITextField *passwordTextField;
    DBManager *_dbManager;
    NSArray *dicArr1;
    NSArray *dicArr2;
    NSArray *dicArr3;
}

@end

@implementation FYLoginViewController

- (instancetype)init
{
    self = [super init];
    if(self)
    {
//        [self initDatas];
    }
    return self;
}

- (void)initDatas
{
    _dbManager = [DBManager sharedInstace];
    dicArr1 = @[@{@"Title":@"网上立案",@"Icon":@"i00.png"},@{@"Title":@"网上阅卷",@"Icon":@"i01.png"}];
    
    dicArr2 = @[@{@"Title":@"网上立案",@"Icon":@"i00.png"},@{@"Title":@"网上阅卷",@"Icon":@"i01.png"},@{@"Title":@"一卡通",@"Icon":@"i02.png"},@{@"Title":@"工作台历",@"Icon":@"i03.png"}];
    dicArr3 = @[@{@"Title":@"网上立案",@"Icon":@"i00.png"},@{@"Title":@"网上阅卷",@"Icon":@"i01.png"},@{@"Title":@"工作台历",@"Icon":@"i03.png"},@{@"Title":@"院内通知",@"Icon":@"i04.png"},@{@"Title":@"通信录",@"Icon":@"i05.png"}];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
     [self initDatas];
    
    self.navigationItem.title = @"登录";
    self.view.backgroundColor = FYBackgroundColor;
    [self initWithView];
    
}

- (void)initWithView
{
    /** 头像图片*/
    UIImageView *headImageView = [[UIImageView alloc]initWithFrame:CGRectMake((Screen_Width - 60)*0.5, 10, 60, 60)];
    headImageView.image = [UIImage imageNamed:@"person_head"];
    [self.view addSubview:headImageView];
    
    
    /** 账号*/
    UIView *countView = [[UIView alloc]initWithFrame:CGRectMake(0, headImageView.y+headImageView.height+10, Screen_Width, 44)];
    UIImageView *countImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 20, 24)];
    countImageView.image = [UIImage imageNamed:@"person_icon"];
    [countView addSubview:countImageView];
    countView.backgroundColor = [UIColor whiteColor];
    countTextFiled = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(countImageView.frame)+10, 0, 200, 44)];
    countTextFiled.placeholder = @"请输入用户名";
    [countView addSubview:countTextFiled];
    [self.view addSubview:countView];
    
    /** 密码*/
    UIView *passwordView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(countView.frame)+1, Screen_Width, 44)];
    UIImageView *passwordImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 20, 24)];
    passwordImageView.image = [UIImage imageNamed:@"lock_icon"];
    [passwordView addSubview:passwordImageView];
    passwordView.backgroundColor = [UIColor whiteColor];
    passwordTextField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(passwordImageView.frame)+10, 0, 200, 44)];
    passwordTextField.placeholder = @"密码";
    passwordTextField.secureTextEntry = YES;
    [passwordView addSubview:passwordTextField];
    [self.view addSubview:passwordView];
    
    /** 登录*/
    UIButton *loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(14, GetMaxY(passwordView.frame)+10, Screen_Width - 28, 44)];
    loginBtn.layer.cornerRadius = 4.0f;
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setBackgroundColor:FYColor(0, 111, 194)];
    [loginBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    /** 忘记密码*/
    UIButton *forgetBtn = [[UIButton alloc]init];
    NSString *forgetBtnName = @"忘记密码";
    CGSize forgetSize = [forgetBtnName sizeWithFont:[UIFont systemFontOfSize:12]];
    [forgetBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [forgetBtn setTitle:forgetBtnName forState:UIControlStateNormal];
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [forgetBtn setFrame:CGRectMake(Screen_Width*0.5-forgetSize.width-10, CGRectGetMaxY(loginBtn.frame)+20, forgetSize.width, forgetSize.height)];
    [forgetBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetBtn];
    
    /** 分割线*/
    UIView *speView = [[UIView alloc]initWithFrame:CGRectMake(Screen_Width*0.5, CGRectGetMaxY(loginBtn.frame)+20, 1, forgetSize.height)];
    [speView setBackgroundColor:FYColor(0, 111, 194)];
    [self.view addSubview:speView];
    
    /** 立即注册*/
    UIButton *registBtn = [[UIButton alloc]init];
    NSString *registBtnName = @"立即注册";
    CGSize registSize = [registBtnName sizeWithFont:[UIFont systemFontOfSize:12]];
    [registBtn setTitle:registBtnName forState:UIControlStateNormal];
    [registBtn setTitleColor:FYColor(0, 111, 194) forState:UIControlStateNormal];
    registBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [registBtn setFrame:CGRectMake(Screen_Width*0.5 + 10, CGRectGetMaxY(loginBtn.frame)+20, registSize.width, registSize.height)];
    [registBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registBtn];
}


#pragma mark 按钮点击事件
- (void)clickBtn:(UIButton *)button
{
    if ([button.titleLabel.text isEqualToString:@"登录"]) {
        [ComUnit Login_userName:countTextFiled.text Password:passwordTextField.text clientId:[GeTuiSdk clientId] Callback:^(NSString *IM_Token, NSString *userID, NSString * User_Token, NSString *name, NSString *ImageUrl, NSString *courtId, NSString *Info, BOOL succeed) {
            if (succeed) {
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:courtId forKey:@"courtId"];
                [defaults setObject:userID forKey:@"user_id"];
                [defaults setObject:name forKey:@"userName"];
                if(![NSString isBlankString:ImageUrl])
                {
                    [defaults setObject:ImageUrl forKey:@"image"];
                }
                
                [defaults setObject:User_Token forKey:@"token"];
                [defaults setObject:name forKey:@"nikeName"];
                [defaults synchronize];
                
                [Helper setIM_Token:IM_Token];
                [Helper setUserID:userID];
                [Helper setPassword:passwordTextField.text];
                [Helper setUser_Token:User_Token];
                [Helper setNickname:name];
                [Helper setUserName:countTextFiled.text];
                if (![ImageUrl isKindOfClass:[NSNull class]]) {
                    [Helper setImageUrl:ImageUrl];
                }
                NSLog(@"%@", userID);
                [[UCSTcpClient sharedTcpClientManager] login_uninitWithFlag:NO];
                [[UCSTcpClient sharedTcpClientManager] login_connect:[Helper getIM_Token] success:^(NSString *userId) {
                    [MBProgressHUD showSuccess:@"登陆成功"];
                    [Helper setStatus:YES];
                    [self.navigationController popViewControllerAnimated:YES];
                } failure:^(UCSError *error) {
                    [MBProgressHUD showError:@"登陆失败"];
                }];
            } else {
                [MBProgressHUD showError:Info];
            }
        }];

    }else if ([button.titleLabel.text isEqualToString:@"忘记密码"])
    {
        [MBProgressHUD showSuccess:@"敬请期待"];
    }else if ([button.titleLabel.text isEqualToString:@"立即注册"])
    {
        RegistViewController *registVC = [[RegistViewController alloc]init];
        [self.navigationController pushViewController:registVC animated:YES];
    }
}


#pragma mark 登录
- (void)requestLogin
{
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"userName"] = self.countTextFiled.text;
//    params[@"password"] = self.passwordTextField.text;
//    params[@"clientId"] = @"123456";
//    params[@"osId"] = @2;
//    [FSHttpTool post:@"app/user!loginAjax.action" params:params success:^(id json) {
//        NSDictionary *result = (NSDictionary *)json;
//        NSLog(@"返回来的结果%@",result);
//        if([[result objectForKey:@"status"] intValue] == 1)
//        {
//            NSString *message = [result objectForKey:@"message"];
//            [MBProgressHUD showError:message];
//        }else
//        {
//            NSDictionary *dic = [result objectForKey:@"attach"];
//            NSLog(@"dic is%@",dic);
//            NSLog(@"id is %@",[dic objectForKey:@"id"]);
//            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//            [defaults setObject:[dic objectForKey:@"clientId"] forKey:@"clientId"];
//            [defaults setObject:[dic objectForKey:@"clientNumber"] forKey:@"clientNumber"];
//            [defaults setObject:[dic objectForKey:@"courtId"] forKey:@"courtId"];
//            [defaults setObject:[dic objectForKey:@"id"] forKey:@"user_id"];
//            [defaults setObject:[dic objectForKey:@"userName"] forKey:@"userName"];
//            NSLog(@"----image%@",[result objectForKey:@"image"]);
//            if(![NSString isBlankString:[dic objectForKey:@"image"]])
//            {
//                [defaults setObject:[dic objectForKey:@"image"] forKey:@"image"];
//            }
//        
//            [defaults setObject:[dic objectForKey:@"token"] forKey:@"token"];
//             [defaults setObject:[dic objectForKey:@"nikeName"] forKey:@"nikeName"];
//            [defaults synchronize];
//            //            NSString *userId = [dic objectForKey:@"id"];
//            //
//            //            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//            //            [defaults setObject:userId forKey:@"user_id"];
//            //            [defaults synchronize];
//            //            //保存用户信息
//            //         //   [[FYModelFactory shareInstance]initDataWithObject:dic andId:[dic objectForKey:@"id"]];
//            //            [[FYModelFactory shareInstance] initDataWithObject:dic andId:userId];
//            //            //调到登录页面
////            [self.navigationController popToRootViewControllerAnimated:YES];
//            [self.navigationController popViewControllerAnimated:YES];
//            
//        }
//        
//    } failure:^(NSError *error) {
//        NSLog(@"错误信息%@",error);
//    }];
}


@end
