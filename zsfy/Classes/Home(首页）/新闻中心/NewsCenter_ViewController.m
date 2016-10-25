//
//  NewsCenter_ViewController.m
//  zsfy
//
//  Created by tiannuo on 15/11/11.
//  Copyright (c) 2015年 wzy. All rights reserved.
//

#import "NewsCenter_ViewController.h"
#import "CTB.h"
#import "NewsCenter_Cell.h"

@interface NewsCenter_ViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    int newPageNo;
    int newSumPage;
    int skinPageNo;
    int skinSumPage;
    int InfoPageNo;
    int InfoSumPage;
    
    UIScrollView *btnScrollView;
}
@property (nonatomic,strong)NSMutableArray *listNews; //法院动态数组
@property (nonatomic,strong)NSMutableArray *listSkin;//图片数组;
@property (nonatomic, strong) NSMutableArray *listLawInfo;
@end

@implementation NewsCenter_ViewController
{
    UIScrollView *ScrollView;
    UIView *Baseline;
    UITableView *myTableView;//新闻动态
    UITableView *tableViewSkin;//白皮
    UITableView *tableViewLawInfo;
}

- (NSMutableArray *)listSkin
{
    if (!_listSkin) {
        self.listSkin = [NSMutableArray array];
    }
    return _listSkin;;
}
- (NSMutableArray *)listNews
{
    if (!_listNews) {
        self.listNews = [NSMutableArray array];
    }
    return _listNews;;
}

- (NSMutableArray *)listLawInfo
{
    if (!_listLawInfo) {
        self.listLawInfo = [NSMutableArray array];
    }
    return _listLawInfo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新闻中心";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initWithView];
    // Do any additional setup after loading the view.
}


-(void)initWithView
{
    NSArray *listBtn = [NSArray arrayWithObjects:@"法院动态", @"图片新闻", @"司法时讯", nil];
    
    btnScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 32)];
    btnScrollView.showsHorizontalScrollIndicator = NO;
    // 设置UIScrollView的滚动范围（内容大小）
    btnScrollView.bounces = NO;
    btnScrollView.delegate = self;
    // btnScrollView.backgroundColor = [CTB colorWithHexString:@"EAEAEA"];
    [self.view addSubview:btnScrollView];
    btnScrollView.contentSize = CGSizeMake((Screen_Width/3)*listBtn.count, 32);

    
    for (int i = 0; i<listBtn.count; i++) {
        UIButton *btn = [CTB buttonType:UIButtonTypeCustom delegate:self to:btnScrollView tag:i+1 title:[listBtn objectAtIndex:i] img:@""];
        btn.frame = CGRectMake((Screen_Width/3)*i, 0, (Screen_Width/3), 30);
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:FYColor(196, 196, 196)];
        [btnScrollView addSubview:btn];
    }
    
    Baseline = [[UIView alloc] initWithFrame:CGRectMake(0, 28, (Screen_Width/3), 2)];
    Baseline.backgroundColor = FYBlueColor;
    [btnScrollView addSubview:Baseline];
    
    ScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 30, Screen_Width, Screen_Height-64-30)];
    //翻页效果
    ScrollView.pagingEnabled = YES;
    ScrollView.showsHorizontalScrollIndicator = NO;
    // 设置UIScrollView的滚动范围（内容大小）
    ScrollView.bounces = YES;
    ScrollView.delegate = self;
    [self.view addSubview:ScrollView];
    ScrollView.contentSize = CGSizeMake(Screen_Width*3, Screen_Height-64-30);
    
    //法院动态的列表
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -1, Screen_Width, Screen_Height-64-30) style:UITableViewStylePlain];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.hidden = YES;
    //    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [ScrollView addSubview:myTableView];
    myTableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(addMore)];
    
    myTableView.tableFooterView = [[UIView alloc] init];
    
    tableViewSkin = [[UITableView alloc] initWithFrame:CGRectMake(Screen_Width, -1, Screen_Width, Screen_Height-64-30) style:UITableViewStylePlain];
    tableViewSkin.delegate = self;
    tableViewSkin.dataSource = self;
    tableViewSkin.hidden = YES;
    //    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [ScrollView addSubview:tableViewSkin];
    tableViewSkin.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(addMoreSkin)];
    tableViewSkin.tableFooterView = [[UIView alloc] init];
    
    tableViewLawInfo = [[UITableView alloc] initWithFrame:CGRectMake(Screen_Width * 2, -1, Screen_Width, Screen_Height-64-30) style:UITableViewStylePlain];
    tableViewLawInfo.delegate = self;
    tableViewLawInfo.dataSource = self;
    tableViewLawInfo.hidden = YES;
    //    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [ScrollView addSubview:tableViewLawInfo];
    tableViewLawInfo.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(addMoreInfo)];
    tableViewLawInfo.tableFooterView = [[UIView alloc] init];

    
    
    newPageNo = 1;
    [self NewsCenter:1 subCategoryId:101 AndPageNo:newPageNo];
}

-(void)NewsCenter:(int)categoryId subCategoryId:(int)subCategoryId AndPageNo:(int)pageNo
{
    [MBProgressHUD showMessage:@""];
    NSDictionary *paras = [NSDictionary dictionary];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *countId = [defaults objectForKey:@"countId"];
    int needCountId;
    if ([NSString isBlankString:countId]) {
        countId = @"0";
        needCountId = [countId intValue] + 1;
        
    } else {
        needCountId = [countId intValue];
    }
    
    paras = @{@"courtId":@(needCountId),@"categoryId":@(categoryId),
              @"subCategoryId":@(subCategoryId),@"pageNo":@(pageNo),@"rowSize":@(8)
              };
    
    NSLog(@"请求的参数参数:%@",paras);
    if (subCategoryId == 101) {
        [FSHttpTool post:@"app/article!paginationAjax.action" params:paras success:^(id json) {
            NSLog(@"%@",json);
            [myTableView.footer endRefreshing];
            [MBProgressHUD hideHUD];
            NSDictionary *result = (NSDictionary *)json;
            if([result objectForKey:@"attach"] != nil)
            {
                NSDictionary *attachResult = [result objectForKey:@"attach"];
                if([attachResult isKindOfClass:[NSDictionary class]])
                {
                    if([attachResult objectForKey:@"list"] != nil)
                    {
                        NSArray *NewsArr = [attachResult objectForKey:@"list"];
                        if (self.listNews.count == 0) {
                            newSumPage = [[attachResult objectForKey:@"pageCount"] intValue];
                        }
                        for (NSDictionary *dic in NewsArr) {
                            [self.listNews addObject:dic];
                        }
                    }
                    
                }
            }
            myTableView.hidden = NO;
            [myTableView reloadData];

        } failure:^(NSError *error) {
            [MBProgressHUD showError:@"请求数据失败"];
        }];
    } else if(subCategoryId == 102) {
        [FSHttpTool post:@"app/article!paginationAjax.action" params:paras success:^(id json) {
            NSLog(@"%@",json);
            [tableViewSkin.footer endRefreshing];
            [MBProgressHUD hideHUD];
            NSDictionary *result = (NSDictionary *)json;
            if([result objectForKey:@"attach"] != nil)
            {
                NSDictionary *attachResult = [result objectForKey:@"attach"];
                if([attachResult isKindOfClass:[NSDictionary class]])
                {
                    if([attachResult objectForKey:@"list"] != nil)
                    {
                        NSArray *SkinArr = [attachResult objectForKey:@"list"];
                        if (self.listSkin.count == 0) {
                           skinSumPage = [[attachResult objectForKey:@"pageCount"] intValue];
                        }
                        for (NSDictionary *dic in SkinArr) {
                            [self.listSkin addObject:dic];
                        }
                    }
                    
                }
            }
            tableViewSkin.hidden = NO;
            [tableViewSkin reloadData];
            
        } failure:^(NSError *error) {
            [MBProgressHUD showError:@"请求数据失败"];
        }];

    } else if(subCategoryId == 103) {
        [FSHttpTool post:@"app/article!paginationAjax.action" params:paras success:^(id json) {
            NSLog(@"%@",json);
            [tableViewLawInfo.footer endRefreshing];
            [MBProgressHUD hideHUD];
            NSDictionary *result = (NSDictionary *)json;
            if([result objectForKey:@"attach"] != nil)
            {
                NSDictionary *attachResult = [result objectForKey:@"attach"];
                if([attachResult isKindOfClass:[NSDictionary class]])
                {
                    if([attachResult objectForKey:@"list"] != nil)
                    {
                        NSArray *InfoArr = [attachResult objectForKey:@"list"];
                        if (self.listLawInfo.count == 0) {
                            InfoSumPage = [[attachResult objectForKey:@"pageCount"] intValue];
                        }
                        for (NSDictionary *dic in InfoArr) {
                            [self.listLawInfo addObject:dic];
                        }
                    }
                    
                }
            }
            tableViewLawInfo.hidden = NO;
            [tableViewLawInfo reloadData];
            
        } failure:^(NSError *error) {
            [MBProgressHUD showError:@"请求数据失败"];
        }];

    }
}

- (void)addMore
{
    newPageNo ++;
    if (newPageNo > newSumPage) {
        [MBProgressHUD showError:@"没有更多数据了" toView:myTableView];
        [myTableView.footer endRefreshing];
    }else
    {
        [self NewsCenter:1 subCategoryId:101 AndPageNo:newPageNo];
    }
}

- (void)addMoreSkin
{
    skinPageNo ++;
    if (skinPageNo > skinSumPage) {
        [MBProgressHUD showError:@"没有更多数据了" toView:tableViewSkin];
        [tableViewSkin.footer endRefreshing];
    }else
    {
        [self NewsCenter:1 subCategoryId:102 AndPageNo:skinPageNo];
    }
}

- (void)addMoreInfo
{
    InfoPageNo ++;
    if (InfoPageNo > InfoSumPage) {
        [MBProgressHUD showError:@"没有更多数据了" toView:tableViewLawInfo];
        [tableViewLawInfo.footer endRefreshing];
    }else
    {
        [self NewsCenter:1 subCategoryId:103 AndPageNo:InfoPageNo];
    }

    
}


#pragma mark -========tableView====================
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:myTableView]) {
        return _listNews.count;
    }
    else if ([tableView isEqual:tableViewSkin]) {
        return _listSkin.count;
    } else if([tableView isEqual:tableViewLawInfo]) {
        return _listLawInfo.count;
    }
    return 0;
}

#pragma mark设置每一个cell的行高（有多少行，就走多少次）
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = nil;
    if(tableView == myTableView)
    {
        dic = [_listNews objectAtIndex:indexPath.row];
        CGFloat H = [CTB heightOfString:[dic objectForKey:@"title"] font:[UIFont systemFontOfSize:17] width:Screen_Width-20];
        if([[dic objectForKey:@"description"] isEqualToString:@""])
        {
            return 10 + H + 8 + 30;
        }
        else
        {
            return 10 + H + 8 + 45;
        }
    }
    else if(tableView == tableViewSkin)
    {
        dic = [_listSkin objectAtIndex:indexPath.row];
        CGFloat H = [CTB heightOfString:[dic objectForKey:@"title"] font:[UIFont systemFontOfSize:17] width:Screen_Width-20];
        return 10 + H + 8 + 30;
    } else if(tableView == tableViewLawInfo) {
        dic = [_listLawInfo objectAtIndex:indexPath.row];
        CGFloat H = [CTB heightOfString:[dic objectForKey:@"title"] font:[UIFont systemFontOfSize:17] width:Screen_Width-20];
        return 10 + H + 8 + 30;
    }
    return 0;
}


/**
 *  分割线并未补全,添加以下方法，解决分隔线不从最左端开始的问题
 */
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
    {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [NSString stringWithFormat:@"%d/%d/Cell",(int)indexPath.section,(int)indexPath.row];
    NewsCenter_Cell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == NULL) {
        cell = [[NewsCenter_Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSDictionary *dic = nil;
    if ([tableView isEqual:myTableView]) {
        if(_listNews.count > indexPath.row)
        {
            dic = [_listNews objectAtIndex:indexPath.row];
        }
    }else if ([tableView isEqual:tableViewSkin]) {
        if(_listSkin.count > indexPath.row)
        {
            dic = [_listSkin objectAtIndex:indexPath.row];
        }
    } else if([tableView isEqual:tableViewLawInfo]) {
        if (_listLawInfo.count > indexPath.row) {
            dic = [_listLawInfo objectAtIndex:indexPath.row];
        }
    }

    
    if(tableView == tableViewSkin || tableView == tableViewLawInfo)
    {
        CGFloat H = [CTB heightOfString:[dic objectForKey:@"title"] font:[UIFont systemFontOfSize:17] width:Screen_Width-20];
        cell.lblTitle.frame = CGRectMake(10, 10, Screen_Width-20, H);
        cell.lblTime.frame = CGRectMake(10, cell.lblTitle.frame.origin.y + H + 8, Screen_Width-30, 20);
        if([dic objectForKey:@"title"] != nil && [dic objectForKey:@"publishTime"])
        {
            cell.lblTitle.text = [dic objectForKey:@"title"];
            cell.lblTime.text = [dic objectForKey:@"publishTime"];
        }
    }
    else if(tableView == myTableView)
    {
        CGFloat H = [CTB heightOfString:[dic objectForKey:@"title"] font:[UIFont systemFontOfSize:17] width:Screen_Width-20];
        cell.lblTitle.frame = CGRectMake(10, 10, Screen_Width-20, H);
        if([[dic objectForKey:@"description"] isEqualToString:@""])
        {
            cell.lblContent.frame = CGRectMake(10, cell.lblTitle.frame.origin.y + H + 8, Screen_Width-20, 0);
        }
        else
        {
            cell.lblContent.frame = CGRectMake(10, cell.lblTitle.frame.origin.y + H + 8, Screen_Width-20, 20);
        }
        cell.lblTime.frame = CGRectMake(10, cell.lblContent.frame.origin.y + cell.lblContent.frame.size.height + 8, Screen_Width-30, 20);
        if([dic objectForKey:@"title"] != nil && [dic objectForKey:@"publishTime"])
        {
            cell.lblTitle.text = [dic objectForKey:@"title"];
            cell.lblContent.text = [dic objectForKey:@"description"];
            cell.lblTime.text = [dic objectForKey:@"publishTime"];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
    NSDictionary *dic = nil;
    if([tableView isEqual:myTableView])
    {
        dic = [_listNews objectAtIndex:indexPath.row];
    }else if([tableView isEqual:tableViewSkin])
    {
        dic = [_listSkin objectAtIndex:indexPath.row];
    } else if([tableView isEqual:tableViewLawInfo]) {
        dic = [_listLawInfo objectAtIndex:indexPath.row];
    }
    
    FYWebViewController *webView = [[FYWebViewController alloc]init];
    if([dic objectForKey:@"title"] != nil && [dic objectForKey:@"url"] != nil)
    {
        webView.Title = [dic objectForKey:@"title"];
        webView.url = [dic objectForKey:@"url"];
    }
    
    [self.navigationController pushViewController:webView animated:YES];
    
}
//scrollview的委托方法，当滚动时执行
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;      // called when scroll view grinds to a halt
{
    int page = ScrollView.contentOffset.x/GetVWidth(ScrollView);
    [UIView animateWithDuration:0.3 animations:^{
        Baseline.frame = CGRectMake(Screen_Width/3*page, 28, Screen_Width/3, 2);
        ScrollView.contentOffset = CGPointMake(Screen_Width*page, 0);
    }];
    if (page == 0) {
        if(_listNews.count == 0) {
            newPageNo = 1;
            [self NewsCenter:1 subCategoryId:101 AndPageNo:newPageNo];
        }
    } else if (page == 1) {
        if (_listSkin.count == 0) {
            skinPageNo = 1;
            [self NewsCenter:1 subCategoryId:102 AndPageNo:skinPageNo];
        }
    } else if(page == 2) {
        if (_listLawInfo.count <= 0) {
            InfoPageNo = 1;
            [self NewsCenter:1 subCategoryId:103 AndPageNo:InfoPageNo];
        }
    }

    if ([scrollView isEqual:scrollView]) {
        int page = scrollView.contentOffset.x/GetVWidth(scrollView);
        
        if (page >= 2) {
            
            btnScrollView.contentOffset = CGPointMake((Screen_Width / 3) * (page - 2), 0);
            
        }
        if (page == 0) {
            
            btnScrollView.contentOffset = CGPointZero;
        }
        
        if (page != 0) {
           // [MySearch resignFirstResponder];
        }
        
        NSLog(@"pad = %d",page);
    }
    
}


#pragma mark - ====ButtonEvents==============
-(void)ButtonEvents:(UIButton *)button
{

    if (button.tag <= 3) {
        //动画下划线的滑动
        [UIView animateWithDuration:0.3 animations:^{
            Baseline.frame = CGRectMake(Screen_Width/3*(button.tag-1), 28, Screen_Width/3, 2);
            ScrollView.contentOffset = CGPointMake(Screen_Width*(button.tag-1), 0);
        }];
        
    }
    if (button.tag == 1) {
        if(_listNews.count <= 0)
        {
            newPageNo = 1;
            [self NewsCenter:1 subCategoryId:101 AndPageNo:newPageNo];
        }
    }else if (button.tag == 2)
    {
        if (_listSkin.count <= 0) {
            skinPageNo = 1;
            [self NewsCenter:1 subCategoryId:102 AndPageNo:skinPageNo];
        }
    }else if (button.tag == 3)
    {
//        if (_listLawInfo.count <= 0) {
//            InfoPageNo = 1;
//            [self NewsCenter:1 subCategoryId:103 AndPageNo:InfoPageNo];
//        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
