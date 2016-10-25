//
//  ZYSSZNViewController.m
//  zsfy
//
//  Created by eshore_it on 15/12/17.
//  Copyright © 2015年 wzy. All rights reserved.
//  诉讼指南

#import "ZYSSZNViewController.h"
#import "FYZSTableViewController.h"

@interface ZYSSZNViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *listGuide;//诉讼指南数组

}

@property (nonatomic,strong)UITableView *tableViewGuide;

@end

@implementation ZYSSZNViewController
- (UITableView *)tableViewGuide
{
    if (_tableViewGuide == nil) {
        //诉讼指南
        _tableViewGuide = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-64)];
        _tableViewGuide.delegate = self;
        _tableViewGuide.dataSource = self;
      
//        _tableViewGuide.backgroundColor = [UIColor redColor];
        _tableViewGuide.tableFooterView = [[UIView alloc] init];
        //    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableViewGuide];
        
    }
    
    return _tableViewGuide;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"诉讼指南";
    //诉讼指南数组
    listGuide = [NSArray array];
    
    
    [self getGuide:9];

    self.view.backgroundColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view.
}

#pragma mark -======诉讼指南 接口===================
-(void)getGuide:(int)categoryId
{
    [MBProgressHUD showMessage:@""];
    NSDictionary *paras = [NSDictionary dictionary];
    paras = @{@"courtId":@(1),
              @"categoryId":@(categoryId)};
    
    NSLog(@"参数:%@",paras);

        [FSHttpTool post:@"app/article!getSubCategoryListAjax.action" params:paras success:^(id json) {
            [MBProgressHUD hideHUD];
            NSLog(@"诉讼指南的数据 %@",json);
            NSDictionary *result = (NSDictionary *)json;
            //        NSDictionary *attachResult = [result objectForKey:@"attach"];
            //诉讼指南
            listGuide = [result objectForKey:@"attach"];
            //            listGuide = [guideDic objectForKey:@"list"];
            
            [self.tableViewGuide reloadData];
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUD];
            NSLog(@"报错信息%@",error);
        }];
    
    
}

#pragma mark -========tableView====================
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return listGuide.count;
}

#pragma mark设置每一个cell的行高（有多少行，就走多少次）
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 36;
}

-(FYTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"Cell";
   
        FYTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[FYTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        NSDictionary *dic = [listGuide objectAtIndex:indexPath.row];
        NSLog(@"字典is %@",dic);
        cell.textLabel.text = [dic objectForKey:@"title"];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        //        FYWebViewController *webView  = [[FYWebViewController alloc]init];
        NSDictionary *dic = [listGuide objectAtIndex:indexPath.row];
        //        webView.Title = [dic objectForKey:@"title"];
        //        webView.url = [dic objectForKey:@"url"];
        FYZSTableViewController *zstVC = [[FYZSTableViewController alloc]init];
        zstVC.tags = 9;
        zstVC.zsId = [dic objectForKey:@"id"];
        zstVC.Title = [dic objectForKey:@"title"];
        [self.navigationController pushViewController:zstVC animated:YES];
}

@end
