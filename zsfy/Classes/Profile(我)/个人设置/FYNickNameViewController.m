//
//  FYNickNameViewController.m
//  zsfy
//
//  Created by eshore_it on 15-11-29.
//  Copyright (c) 2015年 wzy. All rights reserved.
//

#import "FYNickNameViewController.h"

@interface FYNickNameViewController ()
@property (nonatomic,strong)UITextField *myTextField;
@end

@implementation FYNickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置昵称";
    
    self.view.backgroundColor = FYBackgroundColor;
    //创建右侧按钮
    [self createRightBtn];
    
    [self initWithView];

}

#pragma mark 创建右侧按钮
- (void)createRightBtn
{
    self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem  alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(clickButtonItem)];
}

- (void)clickButtonItem
{
    if ([NSString isBlankString:self.myTextField.text]) {
        [MBProgressHUD showError:@"昵称不能为空"];
    }
    else
    {
        [self requestChangeNickName];
    }
}


- (void)requestChangeNickName
{
    
    [MBProgressHUD showMessage:@""];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token =  [defaults objectForKey:@"token"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"token"] = token;
    params[@"nikeName"] = self.myTextField.text;
    NSLog(@"请求参数:%@",params);
    [FSHttpTool post:@"app/userInfo!updateNikeNameAjax.action" params:params success:^(id json) {
        [MBProgressHUD hideHUD];
        NSDictionary *result = (NSDictionary *)json;
        if([[result objectForKey:@"status"] intValue] == 1)
        {
            NSString *message = [result objectForKey:@"message"];
            [MBProgressHUD showError:message];
        }else
        {
            [MBProgressHUD showSuccess:@"保存昵称成功"];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:self.myTextField.text forKey:@"nikeName"];
            [userDefaults synchronize];

            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        NSLog(@"错误信息%@",error);
    }];
    
    
}
- (void)initWithView
{
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString *nameText= [userDefaults objectForKey:@"nikeName"];
//    NSLog(@"nameText is %@",nameText);
    self.myTextField = [[UITextField alloc]initWithFrame:CGRectMake(14, 10, Screen_Width - 28, 30)];
    self.myTextField.backgroundColor = [UIColor whiteColor];
    self.myTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:self.myTextField];
    self.myTextField.layer.cornerRadius = 4.0f;
    self.myTextField.layer.borderColor = [[UIColor grayColor]CGColor];
    self.myTextField.layer.borderWidth = 1.0f;
//    self.myTextField.text = nameText;
    if(_userName != nil)
    {
        self.myTextField.text = _userName;
    }
    
    UILabel *textLb = [[UILabel alloc]init];
    textLb.text = @"请输入您的昵称";
    textLb.font = [UIFont systemFontOfSize:12];
    [textLb setFrame:CGRectMake(14, CGRectGetMaxY(self.myTextField.frame)+5, Screen_Width - 28, 40)];
    [self.view addSubview:textLb];
}



@end
