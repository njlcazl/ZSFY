//
//  FYChangePasswordViewController.m
//  zsfy
//
//  Created by pyj on 15/11/17.
//  Copyright (c) 2015年 wzy. All rights reserved.
//

#import "FYChangePasswordViewController.h"
#import "FYTableViewCell.h"

@interface FYChangePasswordViewController ()
@property (nonatomic,strong)UITextField *currentPw;
@property (nonatomic,strong)UITextField *xPw;
@property (nonatomic,strong)UITextField *sureNewPw;


@end

@implementation FYChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"修改密码";
    self.view.backgroundColor = FYColor(233, 233, 240);
    
    //创建右侧按钮
    [self createRightBtn];
    
    self.tableView.tableFooterView = [self footView];
    
}

- (UIView *)footView
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 200)];
    view.backgroundColor = FYColor(233, 233, 240);
    return view;
}

#pragma mark 创建右侧按钮
- (void)createRightBtn
{
    
    self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem  alloc]initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(clickButtonItem)];
    
}

- (void)clickButtonItem
{
    if ([NSString isBlankString:self.currentPw.text]) {
        [MBProgressHUD showError:@"当前密码不能为空"];
    }else if ([NSString isBlankString:self.xPw.text]) {
        [MBProgressHUD showError:@"新密码不能为空"];
    }else if (self.xPw.text.length < 6)
    {
        [MBProgressHUD showError:@"密码不能少于6位"];
    }else if ([NSString isBlankString:self.sureNewPw.text]) {
        [MBProgressHUD showError:@"确认新密码不能为空"];
    }else if  (![self.sureNewPw.text isEqualToString:self.xPw.text]) {
        [MBProgressHUD showError:@"新密码和确认新密码输入不一致"];
    }else
    {
        [self changePasswordRequest];
    }




}

- (void)changePasswordRequest
{
    [MBProgressHUD showMessage:@""];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   NSString *token =  [defaults objectForKey:@"token"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"token"] = token;
    params[@"password"] = self.currentPw.text;
    params[@"newPassword"] = self.xPw.text;
    params[@"repeatPassword"] = self.sureNewPw.text;
    [FSHttpTool post:@"app/userInfo!changePwdAjax.action" params:params success:^(id json) {
        [MBProgressHUD hideHUD];
        NSDictionary *result = (NSDictionary *)json;
        if([[result objectForKey:@"status"] intValue] == 1)
        {
            NSString *message = [result objectForKey:@"message"];
            [MBProgressHUD showError:message];
        }else
        {
            [MBProgressHUD showSuccess:@"修改密码成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    } failure:^(NSError *error) {
        NSLog(@"错误信息%@",error);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    FYTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[FYTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if(indexPath.row == 0)
    {
        cell.textLabel.text = @"当前密码";
        UITextField *nowPw = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, Screen_Width*0.5, 30)];
        nowPw.secureTextEntry = YES;
        nowPw.placeholder = @"输入当前密码";
        nowPw.textAlignment = NSTextAlignmentRight;
        self.currentPw = nowPw;
        cell.accessoryView = self.currentPw;
        
    }else if (indexPath.row == 1)
    {
        cell.textLabel.text = @"新密码";
        UITextField *newPw = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, Screen_Width*0.5, 30)];
        newPw.secureTextEntry = YES;
        newPw.placeholder = @"输入新密码";
        newPw.textAlignment = NSTextAlignmentRight;
        self.xPw = newPw;
        cell.accessoryView = self.xPw;
    }else
    {
        cell.textLabel.text = @"确认新密码";
        UITextField *sureNewPw = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, Screen_Width*0.5, 30)];
        sureNewPw.secureTextEntry = YES;
        sureNewPw.placeholder  = @"输入确认新密码";
        sureNewPw.textAlignment = NSTextAlignmentRight;
        self.sureNewPw = sureNewPw;
        cell.accessoryView = self.sureNewPw;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
    
}



@end
