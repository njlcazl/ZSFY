//
//  FYMyCaseViewController.m
//  zsfy
//
//  Created by pyj on 15/11/14.
//  Copyright (c) 2015年 wzy. All rights reserved.
//

#import "FYMyCaseViewController.h"
#import "FYExecuteCell.h"
#import "FYMyCaseDetailTableViewController.h"
#import "FaYuanGongGaoCell.h"

@interface FYMyCaseViewController ()<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic,strong)UIView *logOutView;

@property (nonatomic,strong)UITableView *loginView;
@property (nonatomic,strong)NSMutableArray *castArr;

@end

@implementation FYMyCaseViewController
- (NSMutableArray *)castArr
{
    if (_castArr ==nil) {
        self.castArr = [NSMutableArray array];
    }
    return _castArr;
}
- (UITableView *)loginView
{
    if (_loginView == nil) {
        self.loginView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height )];
        self.loginView.delegate = self;
        self.loginView.dataSource = self;
        self.loginView.backgroundColor = FYBackgroundColor;
        self.loginView.tableFooterView = [[UIView alloc]init];
        
        [self.loginView registerClass:[FaYuanGongGaoCell class] forCellReuseIdentifier:@"FaYuanGongGaoCell"];
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
    self.navigationItem.title = @"我的案件";
    self.view.backgroundColor = [UIColor whiteColor];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *userId  =  [userDefault objectForKey:@"user_id"];
      if(userId.length > 0 )
      {
          [self.view bringSubviewToFront:self.loginView];
          //请求数据
          [self requestData];
          
      }else
      {
           [self.view bringSubviewToFront:self.logOutView];
      }
}
- (void)requestData
{
    [MBProgressHUD showMessage:@""];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token =  [defaults objectForKey:@"token"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"token"] = token;
    NSLog(@"请求参数:%@",params);
    [FSHttpTool post:@"app/ajBidding!listAjax.action" params:params success:^(id json) {
        [MBProgressHUD hideHUD];
        NSDictionary *result = (NSDictionary *)json;
        NSLog(@"=====>案件：%@",json);
        if([[result objectForKey:@"status"] intValue] == 1)
        {
            NSString *message = [result objectForKey:@"message"];
            [MBProgressHUD showError:message];
        }else if ([[result objectForKey:@"status"] intValue] == 2 )
        {
            [MBProgressHUD showError:@"登录失效，请重新登录"];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:@"" forKey:@"user_id"];

        }else
        {
            NSDictionary *result = (NSDictionary *)json;
            NSLog(@"获取列表的数据:%@",result);
            NSArray *resultArr =[result objectForKey:@"attach"];
            for (int i = 0; i < resultArr.count; i ++) {
                [self.castArr addObject:resultArr[i]];
            }
            
            [self.loginView reloadData];
            
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        NSLog(@"错误信息%@",error);
    }];

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.castArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *identify = @"Cell";
    //听证公告
    FaYuanGongGaoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FaYuanGongGaoCell"];
    if (cell == nil) {
        cell = [[FaYuanGongGaoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FaYuanGongGaoCell"];
    }
    NSDictionary *dic = [self.castArr objectAtIndex:indexPath.row];
    NSLog(@"字典信息%@",dic);
    
    cell.lblTitle.text = [dic objectForKey:@"ah"];
    cell.lblTime.text = [dic objectForKey:@"publishTime"];
    
    return cell;

}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FYMyCaseDetailTableViewController *detailVC = [[FYMyCaseDetailTableViewController alloc]init];
    NSDictionary *dic = self.castArr[indexPath.row];
    detailVC.url = [dic objectForKey:@"id"];
    [self.navigationController pushViewController:detailVC animated:YES];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"解绑";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [MBProgressHUD showMessage:@""];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token =  [defaults objectForKey:@"token"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSDictionary *dic = [self.castArr objectAtIndex:indexPath.row];
    params[@"token"] = token;
    params[@"id"] = [dic objectForKey:@"id"];
    NSLog(@"请求参数:%@",params);
    [FSHttpTool post:@"app/ajBidding!unBiddingAjax.action" params:params success:^(id json) {
        [MBProgressHUD hideHUD];
        NSDictionary *result = (NSDictionary *)json;
        if([[result objectForKey:@"status"] intValue] == 0)
        {
            //删除成功
        
            [self.castArr removeObjectAtIndex:indexPath.row];
            [self.loginView reloadData];
            
        }else
        {
            NSString *message = [result objectForKey:@"message"];
            [MBProgressHUD showError:message];
        
    }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        NSLog(@"错误信息%@",error);
    }];
 

}

@end
