//
//  ZYYyxfViewController.m
//  zsfy
//
//  Created by eshore_it on 15/12/17.
//  Copyright © 2015年 wzy. All rights reserved.
//  预约信访

#import "ZYYyxfViewController.h"
#import "HawkManyFormsNoDateUIView.h"
#import "FYHawkCommens.h"

@interface ZYYyxfViewController ()
{
    HawkManyFormsNoDateUIView * formView1;
}
@property(nonatomic,strong)UIView * logOutView;

@end

@implementation ZYYyxfViewController

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
    self.navigationItem.title = @"预约信访";
    self.view.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.logOutView];

    
    formView1 = [[HawkManyFormsNoDateUIView alloc] initWithFrame:self.view.bounds withType:SubView_Type_Vedio withNav:self.navigationController submitBlock:^(NSMutableDictionary * dic){
        NSLog(@"联系发给 = %@ \n",dic);
        [self submitVisit:dic];
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
    [self.view addSubview:self.logOutView];

    
}

//拜访
- (void)submitVisit:(NSDictionary *)params{
    NSLog(@"请求参数:%@",params);
    [MBProgressHUD showMessage:@""];
    [FSHttpTool post:@"app/applicationFrom!xfyyAjax.action" params:params success:^(id json) {
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
