//
//  FYAddressViewController.m
//  zsfy
//
//  Created by pyj on 15/11/17.
//  Copyright (c) 2015年 wzy. All rights reserved.
//

#import "FYAddressViewController.h"
#import "HWTextView.h"
#import "TSLocateView.h"
#import "ComUnit.h"

@interface FYAddressViewController ()<UIActionSheetDelegate>
@property (nonatomic,strong)UILabel *selectAddress;
@property (nonatomic,strong)HWTextView *addressTV;
@end

@implementation FYAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = FYColor(233, 233, 240);
    
    //创建右侧按钮
    [self createRightBtn];
    self.navigationItem.title = @"联系地址";
    [self initWithView];
}

#pragma mark 创建右侧按钮
- (void)createRightBtn
{
    self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem  alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(clickButtonItem)];
    
}

- (void)clickButtonItem
{
    if ([self.selectAddress.text isEqualToString:@"选择地址"]) {
        [MBProgressHUD showError:@"请点击选择地址"];
    }
    else if ([NSString isBlankString:self.addressTV.text])
    {
        [MBProgressHUD showError:@"请输入您的详细地址"];
    }else
    {
        [self checkInfo];
    }
}

- (void)checkInfo
{
    if([self.addressTV.text isEqualToString:@""])
    {
        [MBProgressHUD showError:@"请输入地址"];
        return;
    }
    else
    {
        [self updateAddress];
    }
}

#pragma mark - 修改地址
- (void)updateAddress
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token =  [defaults objectForKey:@"token"];
    [ComUnit updateAddress:token address:self.addressTV.text success:^(id data) {
        if([data isKindOfClass:[NSDictionary class]])
        {
            if([[data[@"status"] stringValue] isEqualToString:@"0"])
            {
                [MBProgressHUD showSuccess:@"修改地址成功"];
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:self.addressTV.text forKey:@"address"];
                [userDefaults synchronize];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
            else if ([[data[@"status"] stringValue] isEqualToString:@"1"] || [[data[@"status"] stringValue] isEqualToString:@"2"])
            {
                if(data[@"message"])
                {
                    [MBProgressHUD showError:data[@"message"]];
                }
            }
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"请求失败"];
    }];
}


/*
 - (void)saveAddressRequest
 {
 [MBProgressHUD showMessage:@""];
 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
 NSString *token =  [defaults objectForKey:@"token"];
 NSMutableDictionary *params = [NSMutableDictionary dictionary];
 
 params[@"token"] = token;
 if(![self.addressTV.text isEqualToString:@""])
 {
 params[@"address"] = self.addressTV.text;
 }
 NSLog(@"请求参数:%@",params);
 [FSHttpTool post:@"app/userInfo!updateAdressAjax.action" params:params success:^(id json) {
 [MBProgressHUD hideHUD];
 NSDictionary *result = (NSDictionary *)json;
 if([[result objectForKey:@"status"] intValue] == 1)
 {
 NSString *message = [result objectForKey:@"message"];
 [MBProgressHUD showError:message];
 }
 
 else
 {
 [MBProgressHUD showSuccess:@"修改地址成功"];
 NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
 [userDefaults setObject:self.addressTV.text forKey:@"address"];
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
 */

- (void)initWithView
{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height - 44)];
    scrollView.scrollEnabled = YES;
    [self.view addSubview:scrollView];
    
    
    //    UILabel *seletLb = [[UILabel alloc]init];
    //    seletLb.text = @"点击选择地址";
    //    seletLb.textAlignment = NSTextAlignmentLeft;
    //    seletLb.textColor = [UIColor grayColor];
    //    seletLb.font = [UIFont systemFontOfSize:14];
    //    CGSize seletSize = [seletLb.text sizeWithFont:seletLb.font];
    //    [seletLb setFrame:CGRectMake(14, 10, Screen_Width - 28, seletSize.height)];
    //    [scrollView addSubview:seletLb];
    //
    //    UIView *seletBV = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(seletLb.frame)+5, Screen_Width- 20, 44)];
    //    seletBV.backgroundColor = [UIColor whiteColor];
    //    seletBV.layer.cornerRadius = 4.0f;
    //    [scrollView addSubview:seletBV];
    //
    //    UITapGestureRecognizer *tapGgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAddress)];
    //    [seletBV addGestureRecognizer:tapGgr];
    //
    //    UILabel *seletAddress = [[UILabel alloc]init];
    //    seletAddress.text = @"选择地址";
    //    seletAddress.textAlignment = NSTextAlignmentLeft;
    //    [seletAddress setFrame:CGRectMake(5, 0, seletBV.width - 10,44)];
    //    self.selectAddress = seletAddress;
    //    [seletBV addSubview:self.selectAddress];
    
    //    UILabel *addressLb = [[UILabel alloc]init];
    //    addressLb.text = @"街道地址";
    //    addressLb.textAlignment = NSTextAlignmentLeft;
    //    addressLb.textColor = [UIColor grayColor];
    //    addressLb.font = [UIFont systemFontOfSize:14];
    //    CGSize addressSize = [addressLb.text sizeWithFont:addressLb.font];
    //    [addressLb setFrame:CGRectMake(14, 20, Screen_Width - 28, addressSize.height)];
    //    [scrollView addSubview:addressLb];
    
    
    //    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //    NSString *nameText= [userDefaults objectForKey:@"address"];
    //    NSLog(@"nameText is %@",nameText);
    
    UIView *addressBV = [[UIView alloc]initWithFrame:CGRectMake(10,10, Screen_Width- 20, 88)];
    addressBV.backgroundColor = [UIColor whiteColor];
    addressBV.layer.cornerRadius = 4.0f;
    [scrollView addSubview:addressBV];
    
    HWTextView *addressTV = [[HWTextView alloc]initWithFrame:CGRectMake(5, 5, addressBV.width - 10, addressBV.height - 10)];
    addressTV.placeholder = @"填输入您的地址";
    addressTV.font = [UIFont systemFontOfSize:17];
    self.addressTV = addressTV;
    //    self.addressTV.text = nameText;
    self.addressTV.text = _addressStr;
    [addressBV addSubview:self.addressTV];
}

- (void)clickAddress
{
    TSLocateView *locateView = [[TSLocateView alloc] initWithTitle:@"选择城市" delegate:self];
    [locateView showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    TSLocateView *locateView = (TSLocateView *)actionSheet;
    TSLocation *location = locateView.locate;
    
    NSLog(@"p:%@ city:%@ lat:%f lon:%f", location.country, location.city, location.latitude, location.longitude);
    
    //You can uses location to your application.
    if(buttonIndex == 0) {
        NSLog(@"Cancel");
        //  self.selectAddress.text = @"点击选择地址";
    }else {
        NSLog(@"Select");
        self.selectAddress.text = location.city;
    }
}
@end
