//
//  ZYYslxViewController.m
//  zsfy
//
//  Created by eshore_it on 15/12/17.
//  Copyright © 2015年 wzy. All rights reserved.
//  调阅庭审录像

#import "ZYYslxViewController.h"
#import "HawkManyFormsUIView.h"
#import "FYHawkCommens.h"

@interface ZYYslxViewController ()
{
    HawkManyFormsUIView * formView1;
}
@property(nonatomic,strong)UIView * logOutView;

@end

@implementation ZYYslxViewController
- (UIView *)logOutView
{
    if (_logOutView == nil) {
        self.logOutView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height - 64)];
        UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, Screen_Height * 0.5 - 64, Screen_Width, 15)];
        tipLabel.text = @"请先登录或者注册";
        tipLabel.textAlignment = NSTextAlignmentCenter;
        [self.logOutView addSubview:tipLabel];
        self.logOutView.hidden = YES;
    }
    
    return _logOutView;
}

- (void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *userId  =  [userDefault objectForKey:@"user_id"];
    NSLog(@"userId  is %@",userId);
    if(![NSString isBlankString:userId] )
    {
        formView1.hidden = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"调阅庭审录像";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.logOutView];

    
    // 庭审录像调阅
    formView1 = [[HawkManyFormsUIView alloc] initWithFrame:self.view.bounds withType:SubView_Type_Vedio withNav:self.navigationController submitBlock:^(NSMutableDictionary * dic){
        NSLog(@"Luxiang = %@\n",dic);
        [self submitApplicationVideo:dic];
    }];
    [self.view addSubview:formView1];
    if (![FYHawkCommens checkIfLogin:self.navigationController]) {
        formView1.hidden = YES;
        self.logOutView.hidden = NO;
        
        return;
    }
    else{
        formView1.hidden = NO;
    }
    [self.view addSubview:self.logOutView];

}
//看看录像
- (void)submitApplicationVideo:(NSDictionary *)params{
    NSLog(@"请求参数:%@",params);
    [MBProgressHUD showMessage:@""];
    [FSHttpTool post:@"app/applicationFrom!lxsqAjax.action" params:params success:^(id json) {
        if ([[json valueForKey:@"status"] intValue] == 0) {
            [MBProgressHUD hideHUD];
            
            [MBProgressHUD showSuccess:@"提交成功！"];
            
            [formView1 resetAll];
            
        } else {
            NSString *info = [json valueForKey:@"message"];
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:info];
        }


    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:[NSString stringWithFormat:@"%@",error]];

    }];
    
}



@end
