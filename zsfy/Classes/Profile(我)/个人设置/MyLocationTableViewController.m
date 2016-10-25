//
//  MyLocationTableViewController.m
//  zsfy
//
//  Created by eshore_it on 15-11-28.
//  Copyright (c) 2015年 wzy. All rights reserved.
//

#import "MyLocationTableViewController.h"
#import "FYTableViewCell.h"

@interface MyLocationTableViewController ()
{
    NSInteger current;
}
@property (nonatomic,strong)NSArray *locationArr;
@end

@implementation MyLocationTableViewController
- (NSArray *)locationArr
{
    if (_locationArr == nil) {
        self.locationArr = @[@"广州铁路运输中级法院",@"广州铁路运输第一法院",@"广州铁路运输第二法院"];
    }
    return _locationArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的位置";
    self.tableView.tableFooterView = [[UIView alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.locationArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    static NSString *identifier = @"Cell";
    FYTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[FYTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = self.locationArr[indexPath.row];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    current  = [[userDefaults objectForKey:@"countId"] integerValue];
    NSInteger j;
    if(current == 1)
    {
        j = current - 1;
    }
    else if (current == 3)
    {
        j = current - 2;
    }
    else if (current == 2)
    {
        j = current;
    }

    if (j == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row == 0)
    {
        current = 1;
    }
    else if (indexPath.row == 1)
    {
        current = 3;
    }
    else if (indexPath.row == 2)
    {
        current = 2;
    }
    
    NSUserDefaults *userDefalts = [NSUserDefaults standardUserDefaults];
    [userDefalts setObject:[NSString stringWithFormat:@"%ld",current] forKey:@"countId"];
    [userDefalts synchronize];
    
    NSLog(@"选择的是第%ld行",(long)indexPath.row);
    [tableView reloadData];
    
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
//                [MBProgressHUD showSuccess:@"修改地址成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
            }
        }
        else
        {
//            [MBProgressHUD showError:@"修改失败"];
        }
        
//        NSDictionary *result = (NSDictionary *)json;
//        if([[result objectForKey:@"status"] intValue] == 1)
//        {
//            NSString *message = [result objectForKey:@"message"];
//            [MBProgressHUD showError:message];
//        }else
//        {
//            [MBProgressHUD showSuccess:@"修改地址成功"];
//            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//            [userDefaults setObject:self.addressTV.text forKey:@"address"];
//            [userDefaults synchronize];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self.navigationController popViewControllerAnimated:YES];
//            });
//        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        NSLog(@"错误信息%@",error);
    }];
}




@end
