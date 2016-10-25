//
//  FYMyFileViewController.m
//  zsfy
//
//  Created by pyj on 15/11/14.
//  Copyright (c) 2015年 wzy. All rights reserved.
//

#import "FYMyFileViewController.h"

@interface FYMyFileViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation FYMyFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的文件";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initWithView];

}


- (void)initWithView
{
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 88)];
    for (int i = 0; i < 2; i ++) {
        UIView *speView = [[UIView alloc]initWithFrame:CGRectMake(0, 44*(i+1), Screen_Width, 1)];
        speView.backgroundColor = [UIColor grayColor];
        [topView addSubview:speView];
    }
    
    NSString *shareFilelbText = @"共享文件";
    UILabel *shareFilelb = [[UILabel alloc]init];
    shareFilelb.text = shareFilelbText;
    shareFilelb.font = [UIFont systemFontOfSize:14];
    CGSize shareFileSize = [shareFilelbText sizeWithFont:shareFilelb.font];
    [shareFilelb setFrame:CGRectMake(14, 0, shareFileSize.width, 44)];
    [topView addSubview:shareFilelb];
    
    UISwitch *switchBtn = [[UISwitch alloc]initWithFrame:CGRectMake(Screen_Width - 60, 5, 40, 40)];
    [topView addSubview:switchBtn];
    
    NSString *findFilelbText = @"访问地址：";
    UILabel *findFilelb = [[UILabel alloc]init];
    findFilelb.text = findFilelbText;
    findFilelb.font = [UIFont systemFontOfSize:14];
    findFilelb.textColor = [UIColor grayColor];
    CGSize findFileSize = [findFilelbText sizeWithFont:findFilelb.font];
    [findFilelb setFrame:CGRectMake(14, 44, findFileSize.width, 44)];
    [topView addSubview:findFilelb];
    
    NSString *tipFilelbText = @"请在浏览器中访问共享地址";
    UILabel *tipFilelb = [[UILabel alloc]init];
    tipFilelb.text = tipFilelbText;
    tipFilelb.font = [UIFont systemFontOfSize:17];
    [tipFilelb setFrame:CGRectMake(CGRectGetMaxX(findFilelb.frame)+5, 44, Screen_Width - CGRectGetMaxX(findFilelb.frame) - 5, 44)];
    [topView addSubview:tipFilelb];
    
    [self.view addSubview:topView];
    
    
    UITableView *bottonView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame), Screen_Width, Screen_Height - topView.height) style:UITableViewStyleGrouped];
    bottonView.delegate = self;
    bottonView.dataSource = self;
    [self.view addSubview:bottonView];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"(2015)穗增法刑初字第00779号.doc";
    }else
    {
        cell.textLabel.text = @"(2015)穗增法刑初字第00961号.doc";
    }
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}


@end
