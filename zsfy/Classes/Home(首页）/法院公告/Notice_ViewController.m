//
//  Notice_ViewController.m
//  zsfy
//
//  Created by eshore_it on 15-11-14.
//  Copyright (c) 2015年 wzy. All rights reserved.
//

#import "Notice_ViewController.h"
#import "Notice_Cell.h"
#import "UUDatePicker.h"
#import "FYExecuteCell.h"
#import "DatePickerView.h"
#import "DatePickerView1.h"
#import "FaYuanGongGaoCell.h"
#import "BNProgressHUD.h"


@interface Notice_ViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    UIScrollView *myScrollView;
    UIView *Baseline;//按钮横线
    NSMutableArray *listTitle;//按钮数组
    UIScrollView *btnScrollView;//按钮的UIScrollView
    NSMutableArray *listholdCourt;//开庭公告
    NSArray *listIntermediary;//委托中介
    UITableView *tableViewHoldCourt;//开庭公告
    UITableView *tableViewTzgg;//听证公告
    NSMutableArray *listTzgg;
    
    UITableView *tableViewSdtg;//送达公告
    NSMutableArray *listSdtg;//送达列表
    
    UITableView *tableViewBmtg;//拍卖变卖公告
    NSMutableArray *listBmt;//拍卖变卖公告
    
    UITableView *tableViewQt;//其他公告
    NSMutableArray *listQt;//其他公告
    
    int sdPageNo;
    int sdSumPage;
    
    int tzPageNo;
    int tzSumPage;
    
    int bmPageNo;
    int bmSumPage;
    
    int qtPageNo;
    int qtSumPage;
    
    BOOL isExpandDatePicker;
    
    BOOL isStart;
    
    int firstPageNo;
    int firstSumPage;
    
    NSString * ah;
    NSString * ay;
    NSString * dsrmc;
    UISearchBar *MySearch;
}

/** 日期选择器 */
@property (nonatomic, strong) DatePickerView *datePicker;

/** 时间格式转换器 */
@property (nonatomic, strong) NSDateFormatter *formatter;
/** 开始时间 */
@property (strong, nonatomic) UILabel *startTime;
/** 结束时间 */
@property (strong, nonatomic) UILabel *overTime;
/** 当前选择的日期 */
@property (strong, nonatomic) NSString * currentDateString;

/** 日期选择器 */
@property (nonatomic, strong) DatePickerView1 *datePicker1;
/** 当前选择的日期 */
@property (strong, nonatomic) NSString * currentDateString1;

@end

@implementation Notice_ViewController

/*
 之前是用懒加载的方式初始化inputView和datePicker，发现会有一定时间的延迟，约60ms，故将初始化方法在这里调用，这样则一点击按钮控件就能弹出来。
 */
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!_datePicker) self.datePicker = [[DatePickerView alloc] init];
    if (!_datePicker1) self.datePicker1 = [[DatePickerView1 alloc] init];
}

/** 一定要记得在这里移除，因为是加在window上的，否则会造成内存泄露  */
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (_datePicker) [self.datePicker removeFromSuperview];
    if (_datePicker1) [self.datePicker1 removeFromSuperview];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    isStart = YES;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    self.currentDateString = [dateFormatter stringFromDate:[[NSDate alloc] init]];
    
    self.currentDateString1 = [dateFormatter stringFromDate:[[NSDate alloc] init]];
    
    firstPageNo = 1;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"法院公告";
    [self initWithView];
    //请求开庭公告
    [self holdCourt];
}

- (id)init
{
    self = [super init];
    if(self)
    {
        self.startTime = [[UILabel alloc]init];
        self.overTime = [[UILabel alloc]init];
        _currentDateString = [NSString copy];
        _currentDateString1 = [NSString copy];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //开庭公告
    //    [self holdCourt];
}


#pragma mark datePicker相关

/* tip: datePicker的回调block，返回的数据，分别是用户选择的开始时间、结束时间。*/

/** 显示时间选择器 */
- (void)showDatePicker {
    
    [self.datePicker show];
    __weak typeof(self) weakSelf = self;
    
    self.datePicker.btBlock = ^(NSString *DateStr)
    {
        _currentDateString = DateStr;
        weakSelf.startTime.text = DateStr;
        [weakSelf.datePicker hide];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf holdCourt];
        });
    };
}

/** 显示时间选择器 */
- (void)showDatePicker1 {
    
    [self.datePicker1 show];
    __weak typeof(self) weakSelf = self;
    self.datePicker1.btBlock = ^(NSString *DateStr)
    {
        _currentDateString1 = DateStr;
        weakSelf.overTime.text = DateStr;
        [weakSelf.datePicker1 hide];
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf holdCourt];
        });
    };
}


-(void)initWithView
{
    NSArray *colorArray = @[[UIColor cyanColor],[UIColor blueColor],[UIColor greenColor],[UIColor yellowColor],[UIColor purpleColor]];
    
    //按钮标题
    listTitle = [NSMutableArray arrayWithObjects:@"开庭公告",@"听证公告",@"送达公告",@"拍卖变卖公告",@"其他公告", nil];
    
    //委托中介数组
    listIntermediary = [NSArray array];
    
    //开庭公告数据
    listholdCourt = [NSMutableArray array];
    
    btnScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 32)];
    btnScrollView.showsHorizontalScrollIndicator = NO;
    // 设置UIScrollView的滚动范围（内容大小）
    btnScrollView.bounces = NO;
    btnScrollView.delegate = self;
    // btnScrollView.backgroundColor = [CTB colorWithHexString:@"EAEAEA"];
    [self.view addSubview:btnScrollView];
    btnScrollView.contentSize = CGSizeMake((Screen_Width/3-10)*listTitle.count, 32);
    
    for (int i = 0; i<listTitle.count; i++) {
        UIButton *btn = [CTB buttonType:UIButtonTypeCustom delegate:self to:btnScrollView tag:i+1 title:[listTitle objectAtIndex:i] img:@""];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        btn.backgroundColor = FYColor(196, 196, 196);
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.frame = CGRectMake((Screen_Width/3-10)*i, 0, (Screen_Width/3-10), 30);
    }
    //横线
    Baseline = [[UIView alloc] initWithFrame:CGRectMake(0, 28, (Screen_Width/3-10), 2)];
    Baseline.backgroundColor = FYBlueColor;
    [btnScrollView addSubview:Baseline];
    
    myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 30, Screen_Width, Screen_Height-64-30)];
    //翻页效果
    myScrollView.pagingEnabled = YES;
    myScrollView.showsHorizontalScrollIndicator = NO;
    // 设置UIScrollView的滚动范围（内容大小）
    myScrollView.bounces = YES;
    myScrollView.delegate = self;
    [self.view addSubview:myScrollView];
    myScrollView.contentSize = CGSizeMake(Screen_Width*listTitle.count, Screen_Height-64-30);
    
    for (int i = 0; i<listTitle.count; i++) {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(Screen_Width*i, 0, Screen_Width, Screen_Height-64-33)];
        v.backgroundColor = [colorArray objectAtIndex:i];
        if (i == 0) {
            //开庭公告
            MySearch = [[UISearchBar alloc]init];
            MySearch.placeholder = @"案件号/案由/当事人";
            MySearch.frame = CGRectMake(0, 0, Screen_Width, 44);
            MySearch.delegate = self;
            [v addSubview:MySearch];
            
            UIButton *btnStart = [CTB buttonType:UIButtonTypeCustom delegate:self to:v tag:11 title:@"" img:@""];
            btnStart.frame = CGRectMake(-1, 44, Screen_Width+2, 40);
            [btnStart setBackgroundColor:[UIColor whiteColor]];
            [btnStart addTarget:self action:@selector(clickStartBtn) forControlEvents:UIControlEventTouchUpInside];
            UILabel *lblStart = [CTB labelTag:1 toView:btnStart text:@"开始时间" wordSize:13];
            lblStart.frame = CGRectMake(15, 10, Screen_Width/2-15, 20);
            
            self.startTime.frame = CGRectMake(Screen_Width/2, 10, Screen_Width/2-15, 20);
            self.startTime.textAlignment = NSTextAlignmentRight;
            self.startTime.font = [UIFont systemFontOfSize:13];
            self.startTime.text = _currentDateString;
            [btnStart addSubview:self.startTime];
            
            //结束时间
            UIButton *btnEnd = [CTB buttonType:UIButtonTypeCustom delegate:self to:v tag:12 title:@"" img:@""];
            btnEnd.frame = CGRectMake(-1, 84, Screen_Width+2, 40);
            [CTB setBorderWidth:0.5 View:btnEnd, nil];
            btnEnd.backgroundColor = [UIColor whiteColor];
            [btnEnd addTarget:self action:@selector(clickEndBtn) forControlEvents:UIControlEventTouchUpInside];
            UILabel *lblEnd = [CTB labelTag:1 toView:btnEnd text:@"结束时间" wordSize:13];
            lblEnd.frame = CGRectMake(15, 10, Screen_Width/2-15, 20);
            
            
            self.overTime.frame = CGRectMake(Screen_Width/2, 10, Screen_Width/2-15, 20);
            self.overTime.textAlignment = NSTextAlignmentRight;
            self.overTime.font = [UIFont systemFontOfSize:13];
            self.overTime.text = _currentDateString1;
            [btnEnd addSubview:self.overTime];
            
            
            tableViewHoldCourt = [[UITableView alloc] initWithFrame:CGRectMake(0, 124, Screen_Width, Screen_Height-64-33-124) style:UITableViewStylePlain];
            tableViewHoldCourt.delegate = self;
            tableViewHoldCourt.dataSource = self;
            tableViewHoldCourt.tableFooterView = [[UIView alloc] init];
            
            tableViewHoldCourt.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(addFirst)];
            [v addSubview:tableViewHoldCourt];
        }else if(i == 1)
        {
            tableViewTzgg = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height - 64 - 33) style:UITableViewStylePlain];
            tableViewTzgg.delegate = self;
            tableViewTzgg.dataSource = self;
            [v addSubview:tableViewTzgg];
            tableViewTzgg.tableFooterView = [[UIView alloc]init];
            tableViewTzgg.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(addTZMore)];
        }else if (i == 2)
        {
            tableViewSdtg = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height - 64 - 33) style:UITableViewStylePlain];
            tableViewSdtg.delegate = self;
            tableViewSdtg.dataSource = self;
            [v addSubview:tableViewSdtg];
            tableViewSdtg.tableFooterView = [[UIView alloc]init];
            tableViewSdtg.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(addSDMore)];
        }else if(i == 3)
        {
            tableViewBmtg = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height - 64 - 33) style:UITableViewStylePlain];
            tableViewBmtg.delegate = self;
            tableViewBmtg.dataSource = self;
            [v addSubview:tableViewBmtg];
            tableViewBmtg.tableFooterView = [[UIView alloc]init];
            tableViewBmtg.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(addBmMore)];
        }else if(i == 4)
        {
            tableViewQt = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height - 64 - 33) style:UITableViewStylePlain];
            tableViewQt.delegate = self;
            tableViewQt.dataSource = self;
            
            [tableViewQt registerClass:[FaYuanGongGaoCell class] forCellReuseIdentifier:@"QTIdentifierCell"];
            
            [v addSubview:tableViewQt];
            
            tableViewQt.tableFooterView = [[UIView alloc]init];
            tableViewQt.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(addQtMore)];
        }
        
        [myScrollView addSubview:v];
    }
}


#pragma mark -========tableView====================
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:tableViewHoldCourt]) {
        
        return listholdCourt.count;
        
    }else if(tableView == tableViewTzgg)
    {
        return listTzgg.count;
    }else if(tableView == tableViewSdtg)
    {
        return listSdtg.count;
    }else if(tableView == tableViewBmtg)
    {
        return listBmt.count;
    }else if(tableView == tableViewQt)
    {
        return listQt.count;
    }
    return 0;
}


#pragma mark设置每一个cell的行高（有多少行，就走多少次）
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:tableViewHoldCourt]) {
        
        return 140;
    }
    else
    {
        NSDictionary *dic;
        if([tableView isEqual:tableViewQt])
        {
            if(listQt.count > indexPath.row)
            {
                dic = [listQt objectAtIndex:indexPath.row];
            }
        }
        else if ([tableView  isEqual:tableViewTzgg])
        {
            if(listTzgg.count > indexPath.row)
            {
                dic = [listTzgg objectAtIndex:indexPath.row];
            }
        }
        else if ([tableView  isEqual:tableViewBmtg])
        {
            if(listBmt.count > indexPath.row)
            {
                dic = [listBmt objectAtIndex:indexPath.row];
            }
        }
        else if ([tableView  isEqual:tableViewSdtg])
        {
            if(listSdtg.count > indexPath.row)
            {
                dic = [listSdtg objectAtIndex:indexPath.row];
            }
        }
        
        CGFloat H = [CTB heightOfString:[dic objectForKey:@"title"] font:[UIFont systemFontOfSize:17] width:Screen_Width-20];
        return 10 + H + 8 + 20;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //开庭公告
    if ([tableView isEqual:tableViewHoldCourt]) {
        static NSString *identifier = @"Cell";
        Notice_Cell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == NULL) {
            cell = [[Notice_Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        NSDictionary *dic;
        if(listholdCourt.count > indexPath.row)
        {
            dic = [listholdCourt objectAtIndex:indexPath.row];
        }
        cell.lblTitle.text = [NSString stringWithFormat:@"案号:%@",[dic objectForKey:@"ah"]];
        cell.lblCourt.text = [NSString stringWithFormat:@"审理法院:%@",[dic objectForKey:@"slfy"]];
        cell.lblTheCourt.text = [NSString stringWithFormat:@"审理法庭:%@",[dic objectForKey:@"ktdd"]];
        cell.lblAction.text = [NSString stringWithFormat:@"案由:%@",[dic objectForKey:@"ay"]];
        cell.lblJudge.text = [NSString stringWithFormat:@"主审法官:%@",[dic objectForKey:@"zsfg"]];
        cell.lblTime.text = [NSString stringWithFormat:@"开庭时间:%@",[dic objectForKey:@"ktsj"]];
        return cell;
        
    }
    //听证公告
    else if(tableView  == tableViewTzgg)
    {
        static NSString *Tzgg = @"Tzgg";
        FYExecuteCell *cell = [tableView dequeueReusableCellWithIdentifier:Tzgg];
        if (cell == nil) {
            cell = [[FYExecuteCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Tzgg];
        }
        NSDictionary *dic;
        if(listTzgg.count > indexPath.row)
        {
            dic = [listTzgg objectAtIndex:indexPath.row];
        }
        CGFloat H = [CTB heightOfString:[dic objectForKey:@"title"] font:[UIFont systemFontOfSize:17] width:Screen_Width-20];
        cell.lblTitle.frame = CGRectMake(10, 10, Screen_Width-20, H);
        cell.lblTime.frame = CGRectMake(10, cell.lblTitle.frame.origin.y + cell.lblTitle.frame.size.height + 8, Screen_Width-30, 20);
        cell.Title= [dic objectForKey:@"title"];
        cell.Time = [dic objectForKey:@"publishTime"];
        return cell;
    }
    
    //送达公告
    else if(tableView  == tableViewSdtg)
    {
        static NSString *Sdgg = @"Sdgg";
        FYExecuteCell *cell = [tableView dequeueReusableCellWithIdentifier:Sdgg];
        if (cell == nil) {
            cell = [[FYExecuteCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Sdgg];
        }
        
        NSDictionary *dic = nil;
        if(listSdtg.count > indexPath.row)
        {
            dic = [listSdtg objectAtIndex:indexPath.row];
        }
        CGFloat H = [CTB heightOfString:[dic objectForKey:@"title"] font:[UIFont systemFontOfSize:17] width:Screen_Width-20];
        cell.lblTitle.frame = CGRectMake(10, 10, Screen_Width-20, H);
        cell.lblTime.frame = CGRectMake(10, cell.lblTitle.frame.origin.y + cell.lblTitle.frame.size.height + 8, Screen_Width-30, 20);
        cell.lblTitle.text = [dic objectForKey:@"title"];
        cell.lblTime.text = [dic objectForKey:@"publishTime"];
        
        return cell;
    }
    //变卖通告
    else if(tableView  == tableViewBmtg)
    {
        static NSString *Bmtg = @"bmtg";
        FYExecuteCell *cell = [tableView dequeueReusableCellWithIdentifier:Bmtg];
        if (cell == nil) {
            cell = [[FYExecuteCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Bmtg];
            
        }
        
        NSDictionary *dic;
        if(listBmt.count > indexPath.row)
        {
            dic = [listBmt objectAtIndex:indexPath.row];
        }
        CGFloat H = [CTB heightOfString:[dic objectForKey:@"title"] font:[UIFont systemFontOfSize:17] width:Screen_Width-20];
        cell.lblTitle.frame = CGRectMake(10, 10, Screen_Width-20, H);
        cell.lblTime.frame = CGRectMake(10, cell.lblTitle.frame.origin.y + cell.lblTitle.frame.size.height + 8, Screen_Width-30, 20);
        cell.Title= [dic objectForKey:@"title"];
        cell.Time = [dic objectForKey:@"publishTime"];
        
        return cell;
    }
    //其他公告
    else if(tableView  == tableViewQt)
    {
        FaYuanGongGaoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QTIdentifierCell"];
        if(cell == nil)
        {
            cell = [[FaYuanGongGaoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QTIdentifierCell"];
        }
        
        NSDictionary *dic;
        if(listQt.count > indexPath.row)
        {
            dic = [listQt objectAtIndex:indexPath.row];
        }
        
        CGFloat H = [CTB heightOfString:[dic objectForKey:@"title"] font:[UIFont systemFontOfSize:17] width:Screen_Width-20];
        cell.lblTitle.frame = CGRectMake(10, 10, Screen_Width-20, H);
        cell.lblTime.frame = CGRectMake(10, cell.lblTitle.frame.origin.y + cell.lblTitle.frame.size.height + 8, Screen_Width-30, 20);
        cell.lblTitle.text = [dic objectForKey:@"title"];
        cell.lblTime.text = [dic objectForKey:@"publishTime"];
        return cell;
    }
    return nil;
}

/**
 *  分割线并未补全,添加以下方法，解决分隔线不从最左端开始的问题
 */
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == tableViewQt)
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
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if([tableView isEqual:tableViewTzgg])
    {
        FYWebViewController *webView = [[FYWebViewController alloc]init];
        
        NSDictionary *dic = listTzgg[indexPath.row];
        webView.Title = [dic objectForKey:@"title"];
        NSLog(@"%@%@",[dic objectForKey:@"titile"],[dic objectForKey:@"url"]);
        webView.url = [dic objectForKey:@"url"];
        [self.navigationController pushViewController:webView animated:YES];
    }else if([tableView isEqual:tableViewSdtg])
    {
        FYWebViewController *webView = [[FYWebViewController alloc]init];
        
        NSDictionary *dic = listSdtg[indexPath.row];
        webView.Title = [dic objectForKey:@"title"];
        NSLog(@"%@%@",[dic objectForKey:@"titile"],[dic objectForKey:@"url"]);
        webView.url = [dic objectForKey:@"url"];
        [self.navigationController pushViewController:webView animated:YES];
    }else if([tableView isEqual:tableViewBmtg])
    {
        FYWebViewController *webView = [[FYWebViewController alloc]init];
        
        NSDictionary *dic = listBmt[indexPath.row];
        webView.Title = [dic objectForKey:@"title"];
        NSLog(@"%@%@",[dic objectForKey:@"titile"],[dic objectForKey:@"url"]);
        webView.url = [dic objectForKey:@"url"];
        [self.navigationController pushViewController:webView animated:YES];
    }else if ([tableView isEqual:tableViewQt])
    {
        FYWebViewController *webView = [[FYWebViewController alloc]init];
        NSDictionary *dic = listQt[indexPath.row];
        webView.Title = [dic objectForKey:@"title"];
        NSLog(@"%@%@",[dic objectForKey:@"titile"],[dic objectForKey:@"url"]);
        webView.url = [dic objectForKey:@"url"];
        [self.navigationController pushViewController:webView animated:YES];
    }
}


//滚动结束代理,只走一次
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;      // called when scroll view grinds to a halt
{
    if ([scrollView isEqual:myScrollView]) {
        int page = myScrollView.contentOffset.x/GetVWidth(myScrollView);
        
        if (page >= 3) {
            
            btnScrollView.contentOffset = CGPointMake((Screen_Width / 3 - 30) * (page - 2), 0);
            
        }
        if (page == 0) {
            
            btnScrollView.contentOffset = CGPointZero;
        }
        
        if (page != 0) {
            [MySearch resignFirstResponder];
        }
        
        NSLog(@"pad = %d",page);
    }
    
}

//scrollview的委托方法，当滚动时执行
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:myScrollView]) {
        
        int page = myScrollView.contentOffset.x/GetVWidth(myScrollView);
        
        [UIView animateWithDuration:0.3 animations:^{
            
            Baseline.frame = CGRectMake((Screen_Width/3-10)*page, 28, (Screen_Width/3-10), 2);
            
        }];
        
        if (page == 1)
        {
            if(listTzgg.count <= 0)
            {
                tzPageNo = 1;
                [self getReuqest:4 AndSub:402 ageNo:tzPageNo];
            }
        }
        
        else if (page == 2)
        {
            if (listSdtg.count <= 0) {
                sdPageNo = 1;
                [self getReuqest:4 AndSub:403 ageNo:sdPageNo];
            }
        }else if (page == 3)
        {
            if (listBmt.count <= 0) {
                bmPageNo = 1;
                [self getReuqest:4 AndSub:404 ageNo:bmPageNo];
            }
        }else if (page == 4)
        {
            if (listQt.count <= 0) {
                qtPageNo = 1;
                [self getReuqest:4 AndSub:405 ageNo:qtPageNo];
            }
        }
    }
}

#pragma mark -====== 接口===================
-(void)getReuqest:(int)categoryId AndSub:(int)subCategoryId ageNo:(int)ageNo
{
    NSLog(@"cid ============== %d",categoryId);
    NSDictionary *paras = [NSDictionary dictionary];
    
    NSString  *countID = [[NSUserDefaults standardUserDefaults] objectForKey:@"countId"];
    
    NSLog(@"courtId ============== %@",countID);
    
    paras = @{@"courtId":countID,
              @"categoryId":@(categoryId),@"subCategoryId":@(subCategoryId),@"ageNo":@(ageNo),@"rowSize":@(8)};
    
    NSLog(@"参数:%@",paras);
    
    
    if(subCategoryId == 402)
    {
//        [MBProgressHUD showMessage:@""];
        [BNProgressHUD createHUDWithSupView:self.view andTitle:@""];
        
        [FSHttpTool post:@"app/article!paginationAjax.action" params:paras success:^(id json) {
            [BNProgressHUD hidHUD];
            NSLog(@"听证公告 %@",json);
            NSDictionary *result = (NSDictionary *)json;
            NSDictionary *attachResult = [result objectForKey:@"attach"];
            //听证公告
            if (attachResult != nil && ![attachResult isKindOfClass:[NSNull class]]) {
                listTzgg = [attachResult objectForKey:@"list"];
                [tableViewTzgg.footer endRefreshing];
                [tableViewTzgg reloadData];

            }
        } failure:^(NSError *error) {
            [BNProgressHUD hidHUD];
            NSLog(@"报错信息%@",error);
            [tableViewTzgg.footer endRefreshing];
            
        }];
    }
    
    //送达公告数据请求/////////////////////////////////////////////////////
    else if(subCategoryId == 403)
    {
//        [MBProgressHUD showMessage:@""];
        [BNProgressHUD createHUDWithSupView:self.view andTitle:@""];
        [FSHttpTool post:@"app/article!paginationAjax.action" params:paras success:^(id json) {
            NSLog(@"送达公告 %@",json);
            [BNProgressHUD hidHUD];
            
            NSDictionary *result = (NSDictionary *)json;
            NSDictionary *attachResult = [result objectForKey:@"attach"];
            //送达公告
            if (attachResult != nil && ![attachResult isKindOfClass:[NSNull class]]) {
                listSdtg = [attachResult objectForKey:@"list"];
                [tableViewSdtg reloadData];
                [tableViewSdtg.footer endRefreshing];
            }
            
        } failure:^(NSError *error) {
            [BNProgressHUD hidHUD];
            NSLog(@"报错信息%@",error);
            [tableViewSdtg.footer endRefreshing];
            
        }];
        
    }else if(subCategoryId == 404)
    {
//        [MBProgressHUD showMessage:@""];
        [BNProgressHUD createHUDWithSupView:self.view andTitle:@""];
        [FSHttpTool post:@"app/article!paginationAjax.action" params:paras success:^(id json) {
            NSLog(@"拍卖变卖公告 %@",json);
            [BNProgressHUD hidHUD];
            NSDictionary *result = (NSDictionary *)json;
            NSDictionary *attachResult = [result objectForKey:@"attach"];
            if (attachResult != nil && ![attachResult isKindOfClass:[NSNull class]]) {
                listBmt = [attachResult objectForKey:@"list"];
                [tableViewBmtg reloadData];
                [tableViewBmtg.footer endRefreshing];
            }
            
            
        } failure:^(NSError *error) {
            [BNProgressHUD hidHUD];
            [tableViewBmtg.footer endRefreshing];
            
            NSLog(@"报错信息%@",error);
        }];
    }else if(subCategoryId == 405)
    {
//        [MBProgressHUD showMessage:@""];
        [BNProgressHUD createHUDWithSupView:self.view andTitle:@""];
        [FSHttpTool post:@"app/article!paginationAjax.action" params:paras success:^(id json) {
            NSLog(@"其他公告 %@",json);
            [BNProgressHUD hidHUD];
            NSDictionary *result = (NSDictionary *)json;
            NSDictionary *attachResult = [result objectForKey:@"attach"];
            //送达公告
            if (attachResult != nil && ![attachResult isKindOfClass:[NSNull class]]) {
                listQt = [attachResult objectForKey:@"list"];
                [tableViewQt reloadData];
                [tableViewQt.footer endRefreshing];
            }
        } failure:^(NSError *error) {
            [BNProgressHUD hidHUD];
            [tableViewQt.footer endRefreshing];
            NSLog(@"报错信息%@",error);
        }];
    }
    else{
        return;
    }
}

- (void)addTZMore
{
    tzPageNo ++;
    if (tzPageNo > tzSumPage) {
        [MBProgressHUD showError:@"没有更多数据了" toView:tableViewTzgg];
        [tableViewTzgg.footer endRefreshing];
    }else
    {
        [self getReuqest:4 AndSub:402 ageNo:tzPageNo];
    }
}


- (void)addSDMore
{
    sdPageNo ++;
    if (sdPageNo > sdSumPage) {
        [MBProgressHUD showError:@"没有更多数据了" toView:tableViewSdtg];
        [tableViewSdtg.footer endRefreshing];
    }else
    {
        [self getReuqest:4 AndSub:403 ageNo:sdPageNo];
    }
}

- (void)addBmMore
{
    bmPageNo ++;
    if (bmPageNo > bmSumPage) {
        [MBProgressHUD showError:@"没有更多数据了" toView:tableViewBmtg];
        [tableViewBmtg.footer endRefreshing];
    }else
    {
        [self getReuqest:4 AndSub:404 ageNo:bmPageNo];
    }
    
}
- (void)addQtMore
{
    qtPageNo ++;
    if (qtPageNo > qtSumPage) {
        [MBProgressHUD showError:@"没有更多数据了" toView:tableViewQt];
        [tableViewQt.footer endRefreshing];
    }else
    {
        [self getReuqest:4 AndSub:405 ageNo:qtSumPage];
    }
    
}

- (void)addFirst
{
    firstPageNo ++;
    if (firstPageNo > firstSumPage) {
        [MBProgressHUD showError:@"没有更多数据了" toView:tableViewHoldCourt];
        [tableViewHoldCourt.footer endRefreshing];
    }else
    {
        [self holdCourt];
    }
}


-(void)ButtonEvents:(UIButton *)button
{
    if (button.tag <= listTitle.count) {
        //动画下划线的滑动
        [UIView animateWithDuration:0.3 animations:^{
            Baseline.frame = CGRectMake((Screen_Width/3-10)*(button.tag-1), 30, (Screen_Width/3-10), 2);
            myScrollView.contentOffset = CGPointMake(Screen_Width*(button.tag-1), 0);
        }];
    }
    if (button.tag == 1) {
        if(listTzgg.count <= 0)
        {
            tzPageNo = 1;
            [self getReuqest:4 AndSub:402 ageNo:tzPageNo];
        }
    }else if (button.tag == 2)
    {
        if (listSdtg.count <= 0) {
            sdPageNo = 1;
            [self getReuqest:4 AndSub:403 ageNo:sdPageNo];
        }
    }else if (button.tag == 3)
    {
        if (listBmt.count <= 0) {
            bmPageNo = 1;
            [self getReuqest:4 AndSub:404 ageNo:bmPageNo];
        }
    }else if (button.tag == 4)
    {
        if(listQt.count <= 0 )
        {
            qtPageNo = 1;
            [self getReuqest:4 AndSub:405 ageNo:qtPageNo];
        }
    }
    if (button.tag != 0) {
        [MySearch resignFirstResponder];
    }
    
}

#pragma mark 开始日期
- (void)clickStartBtn
{
    [self showDatePicker];
    [self.datePicker setDatePicker:(UIDatePicker *)self.datePicker withString:self.startTime.text];
}


#pragma mark - 结束日期
- (void)clickEndBtn
{
    [self showDatePicker1];
    [self.datePicker1 setDatePicker:(UIDatePicker *)self.datePicker1 withString:self.overTime.text];
}


#pragma mark -========开庭公告请求====================
-(void)holdCourt
{
    NSLog(@"======`````````````========%@",self.startTime.text);
    NSLog(@"======`````````````========%@",self.overTime.text);
    NSInteger courtIDS;
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"countId"] != nil)
    {
        courtIDS = [[[NSUserDefaults standardUserDefaults] objectForKey:@"countId"] integerValue];
    }
    else
    {
        courtIDS = 1;
    }
   
    paras[@"courtId"] = @(courtIDS);
    paras[@"pageNo"] = @(firstPageNo);
    paras[@"rowSize"] = @10;
    paras[@"beginTime"] = self.startTime.text;
    paras[@"endTime"] =self.overTime.text;
    if (ah) {
        paras[@"ah"] =ah;
    }
    if (ay) {
        paras[@"ay"] =ay;
    }
    if (dsrmc) {
        paras[@"dsrmc"] =dsrmc;
    }
    
    FYLog(@"参数:%@",paras);
    
//    [MBProgressHUD showMessage:@""];
    [BNProgressHUD createHUDWithSupView:self.view andTitle:@""];
    [FSHttpTool post:@"app/ggxx!ktxxListAjax.action" params:paras success:^(id json) {
        if(json != nil)
        {
            [BNProgressHUD hidHUD];
        }
        [tableViewHoldCourt.footer endRefreshing];
        NSLog(@"sdfsfsdf--\n %@",json);
        NSDictionary *result = (NSDictionary *)json;
        
        NSDictionary *attach = [result objectForKey:@"attach"];
        NSArray *temp =[attach objectForKey:@"list"];
        firstSumPage = [[attach objectForKey:@"pageCount"]intValue];
        if (firstPageNo == 1) {
            [listholdCourt removeAllObjects];
        }
        for (int i = 0; i < temp.count; i ++) {
            [listholdCourt addObject:temp[i]];
        }
        firstSumPage = [[attach objectForKey:@"rowCount"] intValue];
        [tableViewHoldCourt reloadData];
        
    } failure:^(NSError *error) {
        [tableViewHoldCourt.footer endRefreshing];
        [BNProgressHUD hidHUD];
        FYLog(@"报错信息%@",error);
    }];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;                     // called when keyboard search button pressed
{
    ah = searchBar.text;
    ay = searchBar.text;
    dsrmc = searchBar.text;
    [searchBar resignFirstResponder];
    firstPageNo = 1;
    [self holdCourt];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar;                       // called when text ends editing
{
    if ([searchBar.text isEqualToString: @""]) {
        ah = nil;
        ay = nil;
        dsrmc = nil;
    }
    firstPageNo = 1;
    [self holdCourt];
}



@end
