//
//  CourtBook_ViewController.m
//  zsfy
//
//  Created by tiannuo on 15/11/10.
//  Copyright (c) 2015年 wzy. All rights reserved.
//

#import "CourtBook_ViewController.h"
#import "CTB.h"
#import "CourtBook_Cell.h"
#import "pdws.h"


@interface CourtBook_ViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>

{
    UITableView *myTableView;
   
    
}
@property (nonatomic,strong)pdws *Pdws;
/** 记录最大的页数*/
@property (nonatomic,assign)int SumPage;
@property (nonatomic,assign)int pageNo;
@property (nonatomic,strong)NSMutableArray *list;
@property (nonatomic,strong)UISearchBar *mySearchBar;
@property (nonatomic,strong)NSString *save;
@end

@implementation CourtBook_ViewController
- (NSMutableArray *)list
{
    if (!_list) {
        _list = [NSMutableArray array];
    }
    return _list;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"裁判文书";
    self.view.backgroundColor = [UIColor whiteColor];
    self.pageNo = 1;
    [self initWithView];
    UISearchBar *MySearch = [[UISearchBar alloc]init];
    MySearch.placeholder = @"案件号/案由/当事人";
    MySearch.frame = CGRectMake(0, 0, Screen_Width, 44);
    MySearch.delegate = self;
    [self.view addSubview:MySearch];

    
}


-(void)backVc
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initWithView
{
//    [self.view addSubview:MySearch];
    
    
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, Screen_Width, Screen_Height-64-44) style:UITableViewStylePlain];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.tableFooterView = [[UIView alloc]init];
    myTableView.hidden = YES;
    myTableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(addMore)];
    [self.view addSubview:myTableView];
    [self getCourtBookWithPage:1 ];
}
- (void)addMore
{
    self.pageNo ++;
    if (self.pageNo > self.SumPage) {
        [MBProgressHUD showError:@"没有更多数据了" toView:myTableView];
        [myTableView.footer endRefreshing];
    }else
    {
        if (self.save) {
            [self getCourtBookWithPage:self.pageNo AndText:self.save];
        }else
        {
        
        [self getCourtBookWithPage:self.pageNo];
        }
    }

   
}
-(void)getCourtBookWithPage:(int)pageNoo
{
    [MBProgressHUD showMessage:@""];
    NSDictionary *paras = [NSDictionary dictionary];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *countId;
    if([defaults objectForKey:@"countId"] != nil)
    {
        countId = [defaults objectForKey:@"countId"];
    }
    else
    {
        countId = @"1";
    }
    
    NSInteger countIDS = [countId integerValue];
    
    if ([NSString isBlankString:countId]) {
        countId = @"0";
    }
    int needCountId = [countId intValue] + 1;
    /*
    paras = @{@"courtId":@(needCountId),
                  @"pageNo":@(pageNoo),
                  @"rowSize":@(10)};
     */
    
    NSLog(@"法院ID======>%ld",countIDS);
    
     paras = @{@"courtId":@(countIDS),
              @"pageNo":@(pageNoo),
              @"rowSize":@(10)};
  
    NSLog(@"参数:%@",paras);
    [FSHttpTool post:@"app/cpws!listAjax.action" params:paras success:^(id json) {
        [myTableView.footer endRefreshing];
        [MBProgressHUD hideHUD];
        NSLog(@"%@",json);
        NSDictionary *result = (NSDictionary *)json;
        NSDictionary *attach = [result objectForKey:@"attach"];
        self.SumPage = (int)[attach objectForKey:@"pageCount"];
        NSArray *arr = [attach objectForKey:@"list"];
        for (NSDictionary *dic in arr) {
            [self.list addObject:dic];
        }
        myTableView.hidden = NO;
        [myTableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        NSLog(@"报错信息%@",error);
    }];
    
}

#pragma mark -========tableView====================
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.list.count;
}

#pragma mark设置每一个cell的行高（有多少行，就走多少次）
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [NSString stringWithFormat:@"%d/%d/Cell",(int)indexPath.section,(int)indexPath.row];
    CourtBook_Cell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == NULL) {
        cell = [[CourtBook_Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSDictionary *dic = [self.list objectAtIndex:indexPath.row];
    
    cell.lblTitle.text = [NSString stringWithFormat:@"案号:%@",[dic objectForKey:@"ah"]];
    cell.lblType.text = [NSString stringWithFormat:@"类型:%@",[dic objectForKey:@"ajlb"]];
    cell.lblCase.text = [NSString stringWithFormat:@"案由:%@",[dic objectForKey:@"ay"]];
    cell.lblParty.text = [NSString stringWithFormat:@"当事人:%@",[dic objectForKey:@"dsr"]];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    

    //申请裁判文书的链接
    NSDictionary *dict  = self.list[indexPath.row];
   // [MBProgressHUD showError:[dict objectForKey:@"wsid"]];
    
    [MBProgressHUD showMessage:@""];
    NSDictionary *paras = [NSDictionary dictionary];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *countId;
    if([defaults objectForKey:@"countId"] != nil)
    {
        countId = [defaults objectForKey:@"countId"];
    }
    else
    {
        countId = @"1";
    }
    
    if ([NSString isBlankString:countId]) {
        countId = @"0";
    }
    int needCountId = [countId intValue] + 1;
    
    NSInteger coundIDS = [countId integerValue];
    
    paras = @{@"courtId":@(coundIDS),
              @"id":[dict objectForKey:@"wsid"]};
        [FSHttpTool post:@"app/cpws!detailAjax.action" params:paras success:^(id json) {
            [MBProgressHUD hideHUD];
            NSDictionary *result = (NSDictionary *)json;
            NSLog(@"点击案件结果%@",result);
            NSDictionary *attachResult = [result objectForKey:@"attach"];
            if ((int)[attachResult objectForKey:@"type"] == 1) {
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"是否下载判文书" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续", nil];
                    alertView.tag = indexPath.row;
                    [alertView show];
            }else
            {
                FYWebViewController *webView = [[FYWebViewController alloc]init];
                webView.Title = [dict objectForKey:@"ah"];
                webView.url = [attachResult objectForKey:@"url"];
                [self.navigationController pushViewController:webView animated:YES];
            }

            
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUD];
            NSLog(@"报错信息%@",error);
        }];
    

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSString *name = [NSString stringWithFormat:@"下载%ld个",(long)alertView.tag];
        [MBProgressHUD showError:name];
    }
}

//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
//{
//    NSLog(@"%@",searchText);
//    self.pageNo = 1;
//    [self.list removeAllObjects];
//    [self getCourtBookWithPage:self.pageNo AndText:searchText];
//}


-(void)getCourtBookWithPage:(int)pageNoo AndText:(NSString *)text;
{
    [MBProgressHUD showMessage:@""];
    NSDictionary *paras = [NSDictionary dictionary];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *countId;
    if([defaults objectForKey:@"countId"] != nil)
    {
        countId = [defaults objectForKey:@"countId"];
    }
    else
    {
        countId = @"1";
    }

    
    if ([NSString isBlankString:countId]) {
        countId = @"0";
    }
    int needCountId = [countId intValue] + 1;
    
    NSInteger countIDS = [countId integerValue];
    
    
    paras = @{@"courtId":@(countIDS),
              @"pageNo":@(pageNoo),
              @"rowSize":@(10),@"ah":text,@"ay":text,@"dsrmc":text};
    NSLog(@"参数:%@",paras);
    [FSHttpTool post:@"app/cpws!listAjax.action" params:paras success:^(id json) {
        [myTableView.footer endRefreshing];
        [MBProgressHUD hideHUD];
        NSLog(@"%@",json);
        NSDictionary *result = (NSDictionary *)json;
        NSDictionary *attach = [result objectForKey:@"attach"];
        self.SumPage = (int)[attach objectForKey:@"pageCount"];
        NSArray *arr = [attach objectForKey:@"list"];
        for (NSDictionary *dic in arr) {
            [self.list addObject:dic];
        }
        myTableView.hidden = NO;
        
        [myTableView reloadData];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        NSLog(@"报错信息%@",error);
    }];
    
}



- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.pageNo = 1;
    [self.list removeAllObjects];
    self.save = searchBar.text;
    [searchBar resignFirstResponder];
    [self getCourtBookWithPage:self.pageNo AndText:searchBar.text];
}
@end
