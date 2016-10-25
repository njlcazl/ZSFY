//
//  FYPhoneViewController.m
//  zsfy
//
//  Created by pyj on 15/11/17.
//  Copyright (c) 2015年 wzy. All rights reserved.
//

#import "FYPhoneViewController.h"

@interface FYPhoneViewController ()
@property (nonatomic,strong)UITextField *myTextField;

@end

@implementation FYPhoneViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = FYColor(233, 233, 240);
    
    //创建右侧按钮
    [self createRightBtn];
    
    self.navigationItem.title = @"手机号码";
    
    [self initWithView];
    
}


#pragma mark 创建右侧按钮
- (void)createRightBtn
{
    
    self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem  alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(clickButtonItem)];
    
}

- (void)clickButtonItem
{
    if([NSString isBlankString:self.myTextField.text])
    {
        [MBProgressHUD showError:@"手机号码不能为空"];
    }else if(self.myTextField.text.length != 11)
    {
        [MBProgressHUD showError:@"手机号码必须为11位"];
    }else
    {
        [self changePasswordRequest];
        
    }
    //    [MBProgressHUD showError:@"点击保存"];
}

- (void)changePasswordRequest
{
    [MBProgressHUD showMessage:@""];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token =  [defaults objectForKey:@"token"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"token"] = token;
    params[@"phone"] = self.myTextField.text;
    [FSHttpTool post:@"app/userInfo!updatePhoneAjax.action" params:params success:^(id json) {
        [MBProgressHUD hideHUD];
        NSDictionary *result = (NSDictionary *)json;
        if([[result objectForKey:@"status"] intValue] == 1)
        {
            NSString *message = [result objectForKey:@"message"];
            [MBProgressHUD showError:message];
        }else
        {
            [MBProgressHUD showSuccess:@"修改手机成功"];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:self.myTextField.text forKey:@"phoneNumber"];
            [userDefaults synchronize];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    } failure:^(NSError *error) {
        NSLog(@"错误信息%@",error);
    }];
}


- (void)initWithView
{
    
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString *myText= [userDefaults objectForKey:@"phoneNumber"];
//    NSLog(@"nameText is %@",myText);

    self.myTextField = [[UITextField alloc]initWithFrame:CGRectMake(14, 10, Screen_Width - 28, 30)];
    [self.view addSubview:self.myTextField];
    self.myTextField.layer.cornerRadius = 4.0f;
    self.myTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.myTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.myTextField.backgroundColor = [UIColor whiteColor];
    self.myTextField.layer.borderColor = [[UIColor grayColor]CGColor];
    self.myTextField.layer.borderWidth = 1.0f;
//    self.myTextField.text = myText;
    if(_phone != nil)
    {
        self.myTextField.text = _phone;
    }
    
    UILabel *textLb = [[UILabel alloc]init];
    textLb.text = @"请输入您的新的手机号码";
    textLb.font = [UIFont systemFontOfSize:12];
    [textLb setFrame:CGRectMake(14, CGRectGetMaxY(self.myTextField.frame)+5, Screen_Width - 28, 40)];
    [self.view addSubview:textLb];
}



@end
