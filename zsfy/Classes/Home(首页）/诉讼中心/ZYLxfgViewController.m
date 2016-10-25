//
//  ZYLxfgViewController.m
//  zsfy
//
//  Created by eshore_it on 15/12/17.
//  Copyright © 2015年 wzy. All rights reserved.
//  联系法官

#import "ZYLxfgViewController.h"
#import "Litigation_ViewController.h"
#import "Litigation_Cell.h"
#import "FBI_Cell.h"
#import "RETableViewManager.h"
#import "RETableViewOptionsController.h"
#import "FYZSTableViewController.h"
#import "FYHawkCommens.h"
#import "UIView+ChangeSize.h"
#import "IQKeyboardManager.h"
#import "FYTableViewCell.h"
#import "HawkManyFormsNoDateUIView.h"


@interface ZYLxfgViewController ()
{
    /**
     *  大量表单提交
     */
    HawkManyFormsNoDateUIView * formView1;
}


//未登录
@property(nonatomic,strong)UIView * logOutView;


@end

@implementation ZYLxfgViewController
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
    self.navigationItem.title = @"联系法官";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.logOutView];

    
    formView1 = [[HawkManyFormsNoDateUIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height - 64) withType:SubView_Type_Vedio withNav:self.navigationController submitBlock:^(NSMutableDictionary * dic){
        NSLog(@"联系发给 = %@ \n",dic);
        [self submitContact:dic];
    }];
    
    //创建联系法官页面
    [self.view addSubview: formView1];
    if (![FYHawkCommens checkIfLogin:self.navigationController]) {
        formView1.hidden = YES;
        self.logOutView.hidden = NO;
        
        return;
    }
    else{
        formView1.hidden = NO;
    }
}

- (void)submitContact:(NSDictionary *)params{
    [MBProgressHUD showMessage:@""];
    [FSHttpTool post:@"app/applicationFrom!lxfgAjax.action" params:params success:^(id json) {
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

        [MBProgressHUD showError:[NSString stringWithFormat:@"%@",error] ];
    }];
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
