//
//  RegistViewController.m
//  zsfy
//
//  Created by pyj on 15/11/11.
//  Copyright (c) 2015年 wzy. All rights reserved.
//

#import "RegistViewController.h"
#import "ComUnit.h"
#import "Helper.h"
#import "GeTuiSdk.h"
#import "ZHBAuthCodeView.h"
#define authCodeViewWIDTH 100
#define RefreshBtnWIDTH  44

@interface RegistViewController ()
@property (strong, nonatomic) RETableViewManager *manager;
@property (strong, nonatomic) RETableViewSection *basicControlsSection;
/** 类型*/
@property (strong, nonatomic) REPickerItem *pickerType;
/** 用户名*/
@property (strong, nonatomic) RETextItem *userName;
/** 密码*/
@property (strong, nonatomic) RETextItem *password;
/** 确认密码*/
@property (strong, nonatomic) RETextItem *surePassword;

@property (strong, readwrite, nonatomic) RETableViewSection *creditCardSection;
/** 确认密码*/
@property (strong, nonatomic) RETableViewItem *codeView;
/** 验证码*/
@property (strong, nonatomic) ZHBAuthCodeView *authCodeView;
/** 验证码文本框*/
@property (strong, nonatomic) UITextField *authCodeTf;

/** 刷新按钮*/
@property (strong,nonatomic)UIButton *refreshBtn;

@property (strong,nonatomic)NSString *selectType;

@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"注册";
    self.view.backgroundColor = [UIColor whiteColor];
 
    // Create manager
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView delegate:self];
    self.manager.style.backgroundImageMargin = 10.0;
    self.manager.style.cellHeight = 42.0;
    self.basicControlsSection = [self addBasicControls];
    
   
    self.tableView.tableFooterView = [self footView];
    
}

#pragma mark FootView
- (UIView *)footView
{
    UIView *footView=  [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 200)];
    footView.backgroundColor = [UIColor whiteColor];
    
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(14, 10, Screen_Width - 28, 44)];
    backgroundView.backgroundColor = [UIColor whiteColor];

    self.authCodeView = [[ZHBAuthCodeView alloc]initWithFrame:CGRectMake(backgroundView.width - authCodeViewWIDTH - RefreshBtnWIDTH, 0, authCodeViewWIDTH, 44)];
    [backgroundView addSubview:self.authCodeView];
    backgroundView.userInteractionEnabled = YES;
    backgroundView.layer.cornerRadius = 4.0f;
    backgroundView.layer.borderWidth = 1.0f;
    backgroundView.layer.borderColor = [[UIColor grayColor]CGColor];
    
    self.refreshBtn = [[UIButton alloc]initWithFrame:CGRectMake(backgroundView.width - 37*0.5 - 10, (44 - 37*0.5)*0.5, 33*0.5, 37*0.5)];
    [self.refreshBtn addTarget:self action:@selector(clickRefreshBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.refreshBtn setImage:[UIImage imageNamed:@"default_ptr_rotate"] forState:UIControlStateNormal];
    [backgroundView addSubview:self.refreshBtn];
    

    self.authCodeTf = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, Screen_Width-160, 44)];
    self.authCodeTf.borderStyle =  UITextBorderStyleNone;
    self.authCodeTf.placeholder = @"右侧验证码";
    [backgroundView addSubview:self.authCodeTf];
    
    UIButton *registBtn = [[UIButton alloc]initWithFrame:CGRectMake(14, CGRectGetMaxY(backgroundView.frame)+20, Screen_Width - 28, 44)];
    registBtn.layer.cornerRadius = 4.0f;
    [registBtn setBackgroundColor:FYColor(0, 111, 194)];
    [registBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *tipLb = [[UILabel alloc]initWithFrame:CGRectMake(14, CGRectGetMaxY(registBtn.frame)+10, Screen_Width - 20, 44)];
    tipLb.text = @"注册即视为同意审务通服务协议，系统将同步为您创建审务通账号";
    tipLb.font = [UIFont systemFontOfSize:11];
    tipLb.numberOfLines = 0;
    [footView addSubview:tipLb];
    
    
    [footView addSubview:backgroundView];
    [footView addSubview:registBtn];
    return footView;
}
#pragma mark ButtonEvent
- (void)clickRefreshBtn
{
    [self.authCodeView changeAuthCode];
}
- (void)clickBtn:(UIButton *)button
{
    if(!self.userName.value)
    {
        [MBProgressHUD showError:@"用户名不能为空"];
    }else if (!self.password.value)
    {
         [MBProgressHUD showError:@"密码不能为空"];
    }else if(self.password.value.length < 6)
    {
         [MBProgressHUD showError:@"密码至少6位"];
    }
    else if (!self.surePassword.value)
    {
        [MBProgressHUD showError:@"确认密码不能为空"];
    }else if (![self.password.value isEqualToString:self.surePassword.value])
    {
        [MBProgressHUD showError:@"密码不一致，请重新输入"];
    }else if ([self.authCodeView isCorrectAuthCode:self.authCodeTf.text]) {
        [self RegistRequest];
    } else {
         [MBProgressHUD showSuccess:@"验证码输入有误"];
         [self.authCodeView changeAuthCode];
    }
    NSLog(@"正确的验证码:%@", self.authCodeView.authCode);
    
}

#pragma mark 注册请求
- (void)RegistRequest
{
    int userType;
    if([self.selectType isEqualToString:@"律师"])
    {
        userType = 1;
    }else
    {
        userType = 0;
    }
    [ComUnit Register_countID:1 userType:userType userName:self.userName.value Password:self.password.value clientId:[GeTuiSdk clientId] Callback:^(NSString *IM_Token, NSString *userID, NSString *User_Token, NSString *name, NSString *ImageUrl, NSString *courtId, NSString *Info, BOOL succeed) {
        if (succeed) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:courtId forKey:@"courtId"];
            [defaults setObject:userID forKey:@"user_id"];
            [defaults setObject:name forKey:@"userName"];
            if(![NSString isBlankString:ImageUrl]) {
                [defaults setObject:ImageUrl forKey:@"image"];
            }
            
            [defaults setObject:User_Token forKey:@"token"];
            [defaults setObject:name forKey:@"nikeName"];
            [defaults synchronize];

            [Helper setIM_Token:IM_Token];
            [Helper setUserID:userID];
            [Helper setUser_Token:User_Token];
            [Helper setNickname:name];
            [Helper setPassword:self.password.value];
            if (![ImageUrl isKindOfClass:[NSNull class]]) {
                [Helper setImageUrl:ImageUrl];
            }
            [[UCSTcpClient sharedTcpClientManager] login_connect:[Helper getIM_Token] success:^(NSString *userId) {
                [MBProgressHUD showSuccess:@"登陆成功"];
                [Helper setStatus:YES];
                [self.navigationController popToRootViewControllerAnimated:YES];
            } failure:^(UCSError *error) {
                [MBProgressHUD showError:@"登陆失败"];
            }];

        } else {
            [MBProgressHUD showError:Info];
        }
    }];
//    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *countId = [defaults objectForKey:@"countId"];
//    if ([NSString isBlankString:countId]) {
//        countId = @"0";
//    }
//    int needCountId = [countId intValue] + 1;
//    
//    paras[@"courtId"] = @(needCountId);
//    if([self.selectType isEqualToString:@"律师"])
//    {
//        paras[@"userType"] = @1;
//    }else
//    {
//        paras[@"userType"] = @0;
//    }
//    paras[@"nikeName"] = self.userName.value;
//    paras[@"userName"] = self.userName.value;
//    paras[@"password"] = self.password.value;
//    paras[@"repeatPassword"] = self.password.value;
//    paras[@"clientId"] = @"123456";
//    paras[@"osId"] = @2;
//    
//    NSLog(@"参数:%@",paras);
//    
//  [FSHttpTool post:@"app/user!registerAjax.action" params:paras success:^(id json) {
//      NSLog(@"%@",json);
//      NSDictionary *result = (NSDictionary *)json;
//      if([[result objectForKey:@"status"] intValue] == 1)
//      {
//          NSString *message = [result objectForKey:@"message"];
//          [MBProgressHUD showError:message];
//      }else
//      {
//          NSDictionary *dic = [result objectForKey:@"attach"];
//          //保存用户信息
//          NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//          [defaults setObject:[dic objectForKey:@"clientId"] forKey:@"clientId"];
//          [defaults setObject:[dic objectForKey:@"clientNumber"] forKey:@"clientNumber"];
//          [defaults setObject:[dic objectForKey:@"courtId"] forKey:@"courtId"];
//          [defaults setObject:[dic objectForKey:@"id"] forKey:@"user_id"];
//          [defaults setObject:[dic objectForKey:@"userName"] forKey:@"userName"];
//          [defaults setObject:[dic objectForKey:@"image"] forKey:@"image"];
//          [defaults setObject:[dic objectForKey:@"token"] forKey:@"token"];
//          [defaults setObject:[dic objectForKey:@"nikeName"] forKey:@"nikeName"];
//          [defaults synchronize];          //调到登录页面
//          [self.navigationController popToRootViewControllerAnimated:YES];
//          
//          
//      }
//  } failure:^(NSError *error) {
//      NSLog(@"报错信息%@",error);
//  }];
    
}


#pragma mark Basic Controls
- (RETableViewSection *)addBasicControls
{
    
    RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@""];
   [self.manager addSection:section];
    
    //注册类型
    self.pickerType = [REPickerItem itemWithTitle:@"注册类型" value:@[@"当事人"] placeholder:nil options:@[@[@"当事人", @"律师"]]];
    self.pickerType.onChange = ^(REPickerItem *item){
        NSLog(@"Value: %@", item.value);
        self.selectType = item.value[0];
    };
    // Use inline picker in iOS 7
    self.pickerType.inlinePicker = YES;
    [section addItem:self.pickerType];
    
     //用户名
    self.userName = [RETextItem itemWithTitle:@"用户名" value:nil placeholder:@"输入用户名"];
    [section addItem:self.userName];
    
    //密码
    self.password = [RETextItem itemWithTitle:@"密码" value:nil placeholder:@"输入密码"];
    self.password.secureTextEntry = YES;
    [section addItem:self.password];
    
    //确认密码
    self.surePassword = [RETextItem itemWithTitle:@"确认密码" value:nil placeholder:@"输入确认密码"];
    self.surePassword.secureTextEntry = YES;
    [section addItem:self.surePassword];
 

    
    return section;
}




#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.textLabel.highlightedTextColor = [UIColor whiteColor];
    
    for (UIView *view in cell.contentView.subviews) {
        if ([view isKindOfClass:[UILabel class]] || [view isKindOfClass:[UITextField class]] || [view isKindOfClass:[UITextView class]])
            ((UILabel *)view).font = [UIFont fontWithName:@"Avenir-Medium" size:16];
    }
    
    if ([cell isKindOfClass:[RETableViewCreditCardCell class]]) {
        RETableViewCreditCardCell *ccCell = (RETableViewCreditCardCell *)cell;
        ccCell.creditCardField.font = [UIFont fontWithName:@"Avenir-Medium" size:16];
        ccCell.expirationDateField.font = [UIFont fontWithName:@"Avenir-Medium" size:16];
        ccCell.cvvField.font = [UIFont fontWithName:@"Avenir-Medium" size:16];
    }
}

@end
