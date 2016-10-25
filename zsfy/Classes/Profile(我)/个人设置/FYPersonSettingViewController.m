//
//  FYPersonSettingViewController.m
//  zsfy
//
//  Created by pyj on 15/11/14.
//  Copyright (c) 2015年 wzy. All rights reserved.
//

#import "FYPersonSettingViewController.h"
#import "AlertSettingVC.h"
#import "FYPhoneViewController.h"
#import "Helper.h"
#import "FYChangePasswordViewController.h"
#import "FYBingEmailViewController.h"
#import "FYAddressViewController.h"
#import "FYOtherMessageTableViewController.h"
#import "MyLocationTableViewController.h"
#import "FYNickNameViewController.h"
#import "FYTableViewCell.h"
#import "ComUnit.h"
#import "UserDetailModel.h"

#import "ItemInfo.h"
#import "DBManager.h"

//如果当前系统版本小于v返回YES，否则返回no
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
//判断当前的系统是否小于IOS8  !SYSTEM_VERSION_LESS_THAN(@"8.0")意思是当前版本大于8.0
#define isIOS8 !SYSTEM_VERSION_LESS_THAN(@"8.0")

@interface FYPersonSettingViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSString *userNameStr;
    NSString *phoneStr;
    NSString *emailStr;
    NSString *addressStr;
    int idTypeH;
    NSString *idCardStr;
    int sexH;
    int ageH;
}

@property (nonatomic,strong)UITableView *loginView;

@property (nonatomic,strong)UIView *logOutView;

@end

@implementation FYPersonSettingViewController

- (void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *userId  =  [userDefault objectForKey:@"user_id"];
    NSLog(@"userId  is %@",userId);
    if(![NSString isBlankString:userId] )
    {
        [self getUserDetailInfo];
        [self.view bringSubviewToFront:self.loginView];
            if (self.loginView) {
                [self.loginView reloadData];
            }
    }else
    {
        [self.view bringSubviewToFront:self.logOutView];
    }
}
- (UITableView *)loginView
{
    if (_loginView == nil) {
        self.loginView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height - 64) style:UITableViewStyleGrouped];
        self.loginView.delegate = self;
        self.loginView.dataSource = self;
        self.loginView.tableFooterView = [self footView];
        [self.view addSubview:self.loginView];
      
    }
    
    return _loginView;
}

- (UIView *)logOutView
{
    if (_logOutView == nil) {
        self.logOutView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height - 64)];
        UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, Screen_Height * 0.5 - 64, Screen_Width, 15)];
        tipLabel.text = @"请先登录或者注册";
        tipLabel.textAlignment = NSTextAlignmentCenter;
        [self.logOutView addSubview:tipLabel];
        [self.view addSubview:self.logOutView];
    }
    
    
    return _logOutView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = FYColor(233, 233, 240);
    self.navigationItem.title = @"个人设置";
    self.view.backgroundColor = [UIColor whiteColor];
      // [self initWithView];
}

//- (void)initWithView
//{
//    UITableView *personV = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
//  
//}


#pragma mark FootView
- (UIView *)footView
{
    UIView *footView=  [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 64)];
    footView.backgroundColor = [UIColor clearColor];
    UIButton *logOutBtn = [[UIButton alloc]initWithFrame:CGRectMake(14, 10, Screen_Width - 28, 44)];
    logOutBtn.layer.cornerRadius = 4.0f;
    [logOutBtn setBackgroundColor:FYColor(0, 111, 194)];
    [logOutBtn setTitle:@"退出当前账户" forState:UIControlStateNormal];
    [logOutBtn addTarget:self action:@selector(clickSigOutBtn) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:logOutBtn];
    
    return footView;
}




- (void)clickSigOutBtn
{
    if(isIOS8)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要退出登录吗" preferredStyle:UIAlertControllerStyleAlert];
        //显示弹出窗
        [self presentViewController:alertController animated:YES completion:nil];
        
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
        {
            BOOL success = [ComUnit UserLogout:[Helper getUser_Token]];
            if (success) {
                NSLog(@"退出登录");
            }
            NSUserDefaults *userDefalts = [NSUserDefaults standardUserDefaults];
            [userDefalts setObject:@"" forKey:@"countId"];
            [userDefalts synchronize];
            
            [[FYModelFactory shareInstance] cancelLoginId];
            [self.tabBarController.viewControllers[0].tabBarItem setBadgeValue:nil];
            [Helper setStatus:NO];
            
            [self.navigationController popViewControllerAnimated:YES];
            
            if([[DBManager sharedInstace] deleteModel:[[ItemInfo alloc] init] andIsWhereId:NO])
            {
                
            }
        }];
        
        [alertController addAction:sureAction];
        [alertController addAction:cancelAction];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定要退出登录吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        [alertView show];
    }
}


#pragma mark --- make out all Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        NSUserDefaults *userDefalts = [NSUserDefaults standardUserDefaults];
        [userDefalts setObject:@"" forKey:@"countId"];
        [userDefalts synchronize];
        
        [[FYModelFactory shareInstance] cancelLoginId];
        [self.tabBarController.viewControllers[0].tabBarItem setBadgeValue:nil];
        [Helper setStatus:NO];
//        SettingsViewController *set = [[SettingsViewController alloc]init];
//        [set logoutAction];
        [self.navigationController popViewControllerAnimated:YES];
        
        if([[DBManager sharedInstace] deleteModel:[[ItemInfo alloc] init] andIsWhereId:NO])
        {
            
        }
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 7;
    }else
    {
        return 1;
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"账号设置";
    }else
    {
        return @"位置信息";
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    FYTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[FYTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"设置昵称";

        }else if (indexPath.row == 1) {
            cell.textLabel.text = @"手机号码";
        }else if (indexPath.row == 2)
        {
             cell.textLabel.text = @"登录密码";
            cell.detailTextLabel.text = @"修改";
        }else if (indexPath.row == 3)
        {
            cell.textLabel.text = @"绑定邮箱";
        }
        else if (indexPath.row == 4)
        {
            cell.textLabel.text = @"联系地址";
        }else if (indexPath.row == 5)
        {
            cell.textLabel.text = @"其他信息";
        }else if (indexPath.row  == 6)
        {
            cell.textLabel.text = @"消息提醒设置";
        }
    }
    
    else
    {
        NSUserDefaults *userdefauls = [NSUserDefaults standardUserDefaults];
        NSString *location = [userdefauls objectForKey:@"countId"];
        NSInteger locationValue = [location integerValue];
        
        if ([NSString isBlankString:location]) {
            cell.textLabel.text = @"广州铁路运输中级法院";
        }else
        {
            if (locationValue == 1) {
               cell.textLabel.text = @"广州铁路运输中级法院";
            }else if(locationValue == 3)
            {
                cell.textLabel.text = @"广州铁路第一法院";
            }else if(locationValue == 2)
            {
                   cell.textLabel.text = @"广州铁路第二法院";
            }
            
        }
        
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
#pragma mark 点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            FYNickNameViewController *nickVC = [[FYNickNameViewController alloc]init];
            nickVC.userName = userNameStr;
            [self.navigationController pushViewController:nickVC animated:YES];
        }else if (indexPath.row == 1) {
            FYPhoneViewController *phoneVC = [[FYPhoneViewController alloc]init];
            phoneVC.phone = phoneStr;
            [self.navigationController pushViewController:phoneVC animated:YES];
        }else if (indexPath.row == 2)
        {
            FYChangePasswordViewController *changPasswordVC = [[FYChangePasswordViewController alloc]init];
            [self.navigationController pushViewController:changPasswordVC animated:YES];
        }else if (indexPath.row == 3)
        {
            FYBingEmailViewController *bingEmailVC = [[FYBingEmailViewController alloc]init];
            bingEmailVC.email = emailStr;
            [self.navigationController pushViewController:bingEmailVC animated:YES];
        }else if (indexPath.row == 4)
        {
            FYAddressViewController *addressVC = [[FYAddressViewController alloc]init];
            addressVC.addressStr = addressStr;
            [self.navigationController pushViewController:addressVC animated:YES];
        }else if (indexPath.row == 5)
        {
            FYOtherMessageTableViewController *otherMessageVC = [[FYOtherMessageTableViewController alloc]init];
            otherMessageVC.ageH = ageH;
            otherMessageVC.idTypeH = idTypeH;
            otherMessageVC.idCardH = idCardStr;
            otherMessageVC.sexH = sexH;
            [self.navigationController pushViewController:otherMessageVC animated:YES];
        }else if (indexPath.row == 6)
        {
            AlertSettingVC *desVC = [[AlertSettingVC alloc] initWithNibName:@"AlertSettingVC" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:desVC animated:YES];
        }
    }
    
    
    //位置信息
    else
    {
        MyLocationTableViewController *myLVC = [[MyLocationTableViewController alloc]init];
        [self.navigationController pushViewController:myLVC animated:YES];
    }
}

#pragma mark - 获取用户的详细信息
- (void)getUserDetailInfo
{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    [MBProgressHUD showMessage:@"加载中.." toView:self.view];
    [ComUnit getPersonInfoDetail:token success:^(id data) {
        
        if([data isKindOfClass:[NSDictionary class]])
        {
            if([data[@"status"] intValue] == 0)
            {
                NSDictionary *dic = data[@"attach"];
                UserDetailModel *userInfo = [[UserDetailModel alloc]init];
                [userInfo setValuesForKeysWithDictionary:dic];
                
                userNameStr = userInfo.nikeName;
                phoneStr = userInfo.phone;
                sexH = [userInfo.gender intValue];
                addressStr = userInfo.adress;
                emailStr = userInfo.email;
                idCardStr = userInfo.idNumber;
                idTypeH = [userInfo.idType intValue];
                ageH = [userInfo.age intValue];
                
                NSLog(@"用户信息：%@-%@-%d-%@-%@-%@-%d-%d",userNameStr,phoneStr,sexH,addressStr,emailStr,idCardStr,idTypeH,ageH);
            }
            else
            {
                [MBProgressHUD showError:@"获取用户信息失败"];
            }
        }
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"请求失败"];
    }];
}








@end
