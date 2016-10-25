//
//  FYProfileViewController.m
//  zsfy
//
//  Created by pyj on 15/11/9.
//  Copyright (c) 2015年 wzy. All rights reserved.
//

#import "FYProfileViewController.h"
#import "ComUnit.h"
#import "Helper.h"
#import "GeTuiSdk.h"
#import "FYProfileHeadView.h"
#import "FYLoginViewController.h"
#import "BingViewController.h"
#import "FYMyCaseViewController.h"
#import "FYMyFileViewController.h"
#import "FYPersonSettingViewController.h"
#import "FYTechnologyViewController.h"
#import "FYTableViewCell.h"
#import "UIImageView+WebCache.h"

#define HeadHeightRow 150

@interface FYProfileViewController ()<UITableViewDataSource,UITableViewDelegate,ProfileHeadViewDelegate>

/** 头像*/
@property (nonatomic,strong)UIImageView *headImage;

/** 文件名*/
@property (nonatomic,strong)UILabel *nameLabel;

@property (nonatomic,weak)UITableView *profileView;
@property (nonatomic,strong)FYProfileHeadView *headView;

@property (nonatomic,strong)UIView *headViewBg;
@property (nonatomic,strong)NSDictionary *dict;
@property (nonatomic,strong)NSString *userId;

@property (nonatomic,strong)NSUserDefaults *defaults;
@end

@implementation FYProfileViewController

- (void)viewWillAppear:(BOOL)animated
{
   self.defaults = [NSUserDefaults standardUserDefaults];
   self.userId =  [self.defaults objectForKey:@"user_id"];
    NSLog(@"有无ID %@",self.userId);
    [self isLogin];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人中心";
    [self creatProfileView];
    
}


- (void)isLogin{
  
    BOOL isLogin = self.userId.length > 0;
    
    if (isLogin) {
        if (![Helper getStatus]) {
            [ComUnit Login_userName:[Helper getUserName] Password:[Helper getPassword] clientId:[GeTuiSdk clientId] Callback:^(NSString *IM_Token, NSString *userID, NSString * User_Token, NSString *name, NSString *ImageUrl, NSString *courtId, NSString *Info, BOOL succeed) {
                if (succeed) {
                    [Helper setIM_Token:IM_Token];
                    [Helper setUserID:userID];
                    [Helper setUser_Token:User_Token];
                    [Helper setNickname:name];
                    
                    [[UCSTcpClient sharedTcpClientManager] login_connect:[Helper getIM_Token] success:^(NSString *userId) {
                        [Helper setStatus:YES];
                    } failure:^(UCSError *error) {
                        [MBProgressHUD showError:@"登陆失败"];
                    }];
                } else {
                    [MBProgressHUD showError:Info];
                }
            }];

        }
        //登录
        self.nameLabel.text = [self.defaults objectForKey:@"nikeName"];
        NSLog(@"名字是:%@",self.nameLabel.text);
        NSString *imageName =  [self.defaults objectForKey:@"image"];
        NSLog(@"图片名是：%@",imageName);

        if(![NSString isBlankString:[self.defaults objectForKey:@"image"]])
        {
            NSLog(@"头像url%@",[self.defaults objectForKey:@"image"]);
            [self.headImage sd_setImageWithURL:[self.defaults objectForKey:@"image"] placeholderImage:[UIImage imageNamed:@"person_head"]];
            
        
        }
        self.headViewBg.userInteractionEnabled = NO;
    }else
    {
        //没登录
        self.headViewBg.userInteractionEnabled = YES;
        self.nameLabel.text = @"点击登录";
        self.headImage.image = [UIImage imageNamed:@"person_head"];
    }
}

- (void)creatProfileView
{
    UITableView *profileView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    profileView.delegate = self;
    profileView.dataSource = self;
    self.profileView = profileView;
    [self.view addSubview:self.profileView];
    
    // 头
    self.profileView.tableHeaderView = [self HeadView];
}


- (UIView *)HeadView
{
    
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, HeadHeightRow)];
    
    view.backgroundColor = FYBackgroundColor;
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake((Screen_Width - 100)*0.5, 30, 100, 100)];
    bgView.backgroundColor = FYBackgroundColor;
    self.headViewBg = bgView;
    
    [view addSubview:self.headViewBg];
    
    
    UITapGestureRecognizer *tapGgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickTagGgr)];
    [self.headViewBg addGestureRecognizer:tapGgr];
    
    
    self.headImage = [[UIImageView alloc]initWithFrame:CGRectMake((bgView.width - 60)*0.5, -10, 60, 60)];
    self.headImage.image = [UIImage imageNamed:@"person_head"];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headImage.frame), 100 , 44)];
    self.nameLabel.text = @"点击登录";
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    
    
     [self.headViewBg addSubview:self.headImage];
     [self.headViewBg addSubview:self.nameLabel];
    
    return view;
    
}

- (void)clickTagGgr
{
    FYLoginViewController *loginVC = [[FYLoginViewController alloc]init];
    [self.navigationController pushViewController:loginVC animated:YES];
}

#pragma mark tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1)
    {
        return 1;
    }else if (section == 2)
    {
        return 2;
    }else if (section == 3)
    {
        return 1;
    }else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    FYTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[FYTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    if (indexPath.section == 0) {
        cell.textLabel.text = @"案件绑定";
         cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if(indexPath.section == 1)
    {
//        if (indexPath.row == 0) {
            cell.textLabel.text = @"我的案件";
             cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        }else
//        {
//            cell.textLabel.text = @"我的文件";
//             cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        }
    }else if(indexPath.section == 2)
    {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"个人设置";
             cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else
        {
            cell.textLabel.text = @"技术支持";
             cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }else
    {
        cell.textLabel.text = @"软件版本";
        cell.detailTextLabel.text = @"1.0";
    }
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

#pragma mark tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        BingViewController *bingVC = [[BingViewController alloc]init];
        [self.navigationController pushViewController:bingVC animated:YES];
    }else if (indexPath.section == 1)
    {
        if (indexPath.row == 0) {
            FYMyCaseViewController *caseVC = [[FYMyCaseViewController alloc]init];
            [self.navigationController pushViewController:caseVC animated:YES];
        }else
        {
            FYMyFileViewController *fileVC = [[FYMyFileViewController alloc]init];
            [self.navigationController pushViewController:fileVC animated:YES];
            
        }
    }else if (indexPath.section == 2)
    {
        if (indexPath.row == 0) {
            FYPersonSettingViewController *personSettingVC = [[FYPersonSettingViewController alloc]init];
            [self.navigationController pushViewController:personSettingVC animated:YES];
        }else
        {
            FYTechnologyViewController *technologyVC = [[FYTechnologyViewController alloc]init];
            [self.navigationController pushViewController:technologyVC animated:YES];
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

#pragma mark 点击头像代理事件
- (void)ProfileHeadView:(FYProfileHeadView *)profileHeadView clickHeadViewBtn:(UIButton *)button
{
    FYLoginViewController *loginVC = [[FYLoginViewController alloc]init];
    //    FYNavigationController *nav = [[FYNavigationController alloc]initWithRootViewController:loginVC];
    [self.navigationController pushViewController:loginVC animated:YES];
}



@end
