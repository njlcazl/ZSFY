//
//  FYCourtViewController.m
//  FYXZDemo
//
//  Created by eshore_it on 15/12/25.
//  Copyright © 2015年 广东亿迅科技有限公司. All rights reserved.
//

#import "FYCourtViewController.h"
#import "UIColor+Hex.h"



@interface FYCourtViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;

@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UILabel *lab2;
@property (weak, nonatomic) IBOutlet UILabel *lab3;


@end

@implementation FYCourtViewController


- (void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger current  = [[userDefaults objectForKey:@"countId"] integerValue];
    
    NSLog(@"======================>%ld",current);
    
    if (current == 1) {
        self.btn1.selected = YES;
        self.btn2.selected = NO;
        self.btn3.selected = NO;
//        self.lab1.textColor = [UIColor colorWithRed:109/255.0 green:178/255.0 blue:210/255.0 alpha:1];
        
        self.lab1.textColor = [UIColor hexStringToColor:@"#287ABF"];
        self.lab2.textColor = [UIColor blackColor];
        self.lab3.textColor = [UIColor blackColor];
    }
    
    else if(current == 2)
    {
        self.btn1.selected = NO;
        self.btn2.selected = YES;
        self.btn3.selected = NO;
//        self.lab2.textColor = [UIColor colorWithRed:109/255.0 green:178/255.0 blue:210/255.0 alpha:1];
        
        self.lab2.textColor = [UIColor hexStringToColor:@"#287ABF"];
        
        self.lab1.textColor = [UIColor blackColor];
        self.lab3.textColor = [UIColor blackColor];
        
    }
    
    else if(current == 3)
    {
        self.btn1.selected = NO;
        self.btn2.selected = NO;
        self.btn3.selected = YES;
//        self.lab3.textColor = [UIColor colorWithRed:109/255.0 green:178/255.0 blue:210/255.0 alpha:1];
        
        self.lab3.textColor = [UIColor hexStringToColor:@"#287ABF"];
        
        self.lab1.textColor = [UIColor blackColor];
        self.lab2.textColor = [UIColor blackColor];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgView.backgroundColor = [UIColor hexStringToColor:@"#287ABF"];
    self.navigationController.navigationBarHidden = YES;
    self.btn1.selected = YES;
//    self.lab1.textColor = [UIColor colorWithRed:109/255.0 green:178/255.0 blue:210/255.0 alpha:1];
    
    self.lab1.textColor = [UIColor hexStringToColor:@"#287ABF"];
    
}
- (IBAction)clickBtn1:(id)sender {
    self.btn1.selected = YES;
    self.btn2.selected = NO;
    self.btn3.selected = NO;
//    self.lab1.textColor = [UIColor colorWithRed:109/255.0 green:178/255.0 blue:210/255.0 alpha:1];
    
    self.lab1.textColor = [UIColor hexStringToColor:@"#287ABF"];
    
    self.lab2.textColor = [UIColor blackColor];
    self.lab3.textColor = [UIColor blackColor];
    NSUserDefaults *userDefalts = [NSUserDefaults standardUserDefaults];
    [userDefalts setObject:[NSString stringWithFormat:@"%d",1] forKey:@"countId"];
    [userDefalts synchronize];
    NSString *userId  =  [userDefalts objectForKey:@"user_id"];
    NSLog(@"userId  is %@",userId);
    if(![NSString isBlankString:userId] )
    {
        [self changeCourtRequestWithCurrtId:1];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.tabBarController.selectedIndex = 1;
        
    });
}
- (IBAction)clickBtn2:(id)sender {
    self.btn1.selected = NO;
    self.btn2.selected = YES;
    self.btn3.selected = NO;
//    self.lab2.textColor = [UIColor colorWithRed:109/255.0 green:178/255.0 blue:210/255.0 alpha:1];
    
    self.lab2.textColor = [UIColor hexStringToColor:@"#287ABF"];
    
    self.lab1.textColor = [UIColor blackColor];
    self.lab3.textColor = [UIColor blackColor];
    NSUserDefaults *userDefalts = [NSUserDefaults standardUserDefaults];
    [userDefalts setObject:[NSString stringWithFormat:@"%d",2] forKey:@"countId"];
    [userDefalts synchronize];
    
    NSString *userId  =  [userDefalts objectForKey:@"user_id"];
    NSLog(@"userId  is %@",userId);
    if(![NSString isBlankString:userId] )
    {
        [self changeCourtRequestWithCurrtId:2];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.tabBarController.selectedIndex = 1;
        
    });
}
- (IBAction)clickBtn3:(id)sender {
    self.btn1.selected = NO;
    self.btn2.selected = NO;
    self.btn3.selected = YES;
//    self.lab3.textColor = [UIColor colorWithRed:109/255.0 green:178/255.0 blue:210/255.0 alpha:1];
    
    self.lab3.textColor = [UIColor hexStringToColor:@"#287ABF"];
    
    self.lab1.textColor = [UIColor blackColor];
    self.lab2.textColor = [UIColor blackColor];
    NSUserDefaults *userDefalts = [NSUserDefaults standardUserDefaults];
    [userDefalts setObject:[NSString stringWithFormat:@"%d",3] forKey:@"countId"];
    [userDefalts synchronize];
    NSString *userId  =  [userDefalts objectForKey:@"user_id"];
    NSLog(@"userId  is %@",userId);
    if(![NSString isBlankString:userId] )
    {
        [self changeCourtRequestWithCurrtId:3];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.tabBarController.selectedIndex = 1;
        
    });
}


- (void)changeCourtRequestWithCurrtId:(int)current
{
    //调用切换法院接口
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token =  [defaults objectForKey:@"token"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"token"] = token;
    params[@"courtId"] = @(current);
    NSLog(@"请求参数:%@",params);
    [FSHttpTool post:@"app/userInfo!updateCourtAjax.action" params:params success:^(id json) {
        if([json isKindOfClass:[NSDictionary class]])
        {
            if([json[@"status"] integerValue] == 0)
            {
                [MBProgressHUD showSuccess:@"切换成功"];
            } 
        }
        else
        {
            [MBProgressHUD showError:@"切换失败"];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        NSLog(@"错误信息%@",error);
    }];

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
