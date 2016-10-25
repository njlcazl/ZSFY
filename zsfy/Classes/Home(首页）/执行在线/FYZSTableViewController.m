//
//  FYZSTableViewController.m
//  zsfy
//
//  Created by eshore_it on 15-11-24.
//  Copyright (c) 2015年 wzy. All rights reserved.
//

#import "FYZSTableViewController.h"
#import "FYExecuteCell.h"
@interface FYZSTableViewController ()<UITableViewDataSource,UITableViewDelegate>

{
    int pageNo;
    int SumPage;
}

/** 记录最大的页数*/
@property (nonatomic,strong)NSMutableArray *list;
@end

@implementation FYZSTableViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    if(self.list.count)
//    {
//        [self.list removeAllObjects];
//    }
}


- (id)init
{
    self = [super init];
    if(self)
    {
        pageNo = 1;
        self.list = [NSMutableArray array];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
//    [self requestData:pageNo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.Title;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[FYExecuteCell class] forCellReuseIdentifier:@"Identifier"];
    
    self.tableView.tableFooterView = [[UIView alloc ]init];
    //    pageNo = 1;
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(addTZMore)];
    [self requestData:pageNo];
    
}
- (void)addTZMore
{
    //    NSLog(@"当前页数%d,总页数%d",self.pageNo,self.SumPage);
    pageNo ++;
    if (pageNo > SumPage) {
        [MBProgressHUD showError:@"没有更多数据了" toView:self.tableView];
        [self.tableView.footer endRefreshing];
    }else
    {
        [self requestData:pageNo];
    }
    
}
- (void) requestData:(int)pageNoo
{
    [MBProgressHUD showMessage:@""];
    
    NSDictionary *paras = [NSDictionary dictionary];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *countId = [defaults objectForKey:@"countId"];
    
    int needCountId;
    
    if ([NSString isBlankString:countId]) {
        countId = @"0";
        needCountId = [countId intValue] + 1;
    }
    else
    {
        needCountId = [countId intValue];
    }
    
    if(pageNoo == 1)
    {
        [self.list removeAllObjects];
    }
    
    if(self.tags == 9)
    {
        paras = @{@"courtId":@(needCountId),
                  @"categoryId":@(9), @"subCategoryId":@([self.zsId integerValue]),@"pageNo":@(pageNoo),
                  @"rowSize":@(8)};
    }
    else
    {
        paras = @{@"courtId":@(needCountId),
                  @"categoryId":@(10), @"subCategoryId":@([self.zsId integerValue]),@"pageNo":@(pageNoo),
                  @"rowSize":@(8)};
    }
    
    [FSHttpTool post:@"app/article!paginationAjax.action" params:paras success:^(id json) {
        [self.tableView.footer endRefreshing];
        [MBProgressHUD hideHUD];
        NSLog(@"获取回来的信息%@",json);
        NSDictionary *dataResult = (NSDictionary *)json;
        NSDictionary *attach = [dataResult objectForKey:@"attach"];
        SumPage = [[attach objectForKey:@"pageCount"] intValue];
        NSArray *arr = [attach objectForKey:@"list"];
        for (NSDictionary *dic in arr) {
            [self.list addObject:dic];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        NSLog(@"错误信息%@",error);
    }];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FYExecuteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Identifier"];
    if (cell == nil) {
        cell = [[FYExecuteCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Identifier"];
    }
    
    NSDictionary *dic;
    if(self.list.count > indexPath.row)
    {
        dic =  self.list[indexPath.row];
    }
    NSLog(@"时间 %@, 标题 %@",[dic objectForKey:@"publishTime"],[dic objectForKey:@"title"]);
    
    CGFloat H = [CTB heightOfString:[dic objectForKey:@"title"] font:[UIFont systemFontOfSize:17] width:Screen_Width-20];
    cell.lblTitle.frame = CGRectMake(10, 10, Screen_Width-20, H);
    cell.lblTime.frame = CGRectMake(10, cell.lblTitle.frame.origin.y + cell.lblTitle.frame.size.height + 5, Screen_Width-30, 20);
    cell.lblTitle.text = [dic objectForKey:@"title"];
    cell.lblTime.text = [dic objectForKey:@"publishTime"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = nil;
    if(self.list.count > indexPath.row)
    {
        dic =  self.list[indexPath.row];
    }
    CGFloat H = [CTB heightOfString:[dic objectForKey:@"title"] font:[UIFont systemFontOfSize:17] width:Screen_Width-20];
    
    return 10 + H + 20 + 8;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    FYWebViewController *webView = [[FYWebViewController alloc]init];
    if(self.list.count > indexPath.row)
    {
        if([self.list[indexPath.row] isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dic =  self.list[indexPath.row];
            
            NSLog(@"------%@-----",dic);
            
            self.selects = 0;
            
            if(dic != nil)
            {
                webView.Title = [dic objectForKey:@"title"];
                webView.url = [dic objectForKey:@"url"];
            }
        }
    }
    
    [self.navigationController pushViewController:webView animated:YES];
}

@end
