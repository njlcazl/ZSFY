//
//  Execute_ViewController.m
//  zsfy
//
//  Created by IT on 15/11/21.
//  Copyright © 2015年 wzy. All rights reserved.
//

#import "Execute_ViewController.h"
#import "CTB.h"
#import "TrialOpenType_ViewController.h"
#import "RETableViewManager.h"
#import "RETableViewOptionsController.h"
#import "FYTableViewCell.h"
#import "FYWebViewController.h"
#import "FYExecuteCell.h"
#import "FYZSTableViewController.h"
#import "FYMyCaseDetailTableViewController.h"
#import "LawSelectViewController.h"
#import "MMPickerView.h"

@interface Execute_ViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,RETableViewManagerDelegate>
{
    UITableView *tableViewProfile;//法院概况
    NSArray *listProfile;//法院慨况的数组
    UITableView *tableViewCase;//参考案例
    NSArray *listCase;//曝光台的数组
    UIScrollView *myScrollView;
    UIView *Baseline;
    
     UITableView *ajCheackTableView; //案件查询
}

/** 案件年号*/
@property (strong, nonatomic) UITextField *caseYear;
/** 发条*/
@property (strong, nonatomic) NSString *lowItem;
/** 案件字号*/
@property (strong, nonatomic) UITextField *caseTextItem;
/** 案件编号*/
@property (strong, nonatomic) UITextField *caseNumItem;
/** 查询密码部分 */
@property (strong, nonatomic) UITextField *checkPasswordItem;
/** 法律 */
@property (nonatomic,strong)NSArray *lowArray;
@property (nonatomic,strong)NSMutableArray *listCase;

@property (nonatomic, strong) NSMutableArray *yearArr;
@end

@implementation Execute_ViewController

- (NSArray *)lowArray
{
    if (_lowArray == nil) {
        // self.lowArray =@[@"穗中法",@"穗海法",@"穗荔法",@"穗天法",@"穗云法",@"穗黄法",@"穗花法",@"穗番法",@"穗南法",@"穗越法",@"穗从法",@"穗增法"];
        self.lowArray = @[@"广铁中法",@"广铁法",@"肇铁法"];
    }
    return _lowArray;
}
- (NSMutableArray *)listCase
{
    if (_listCase == nil) {
        self.listCase = [NSMutableArray array];
    }
    return _listCase;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"执行在线";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initWithView];
    [self pickerInitData];
}
- (void)viewWillAppear:(BOOL)animated
{
    if (ajCheackTableView) {
        [ajCheackTableView reloadData];
    }
}
-(void)initWithView
{
    listProfile = [NSArray array];
    listCase = [NSArray array];
    
    NSArray *listBtn = [NSArray arrayWithObjects:@"执行查询",@"执行指引",@"曝光台", nil];
    for (int i = 0; i<listBtn.count; i++) {
        UIButton *btn = [CTB buttonType:UIButtonTypeCustom delegate:self to:self.view tag:i+1 title:[listBtn objectAtIndex:i] img:@""];
        btn.frame = CGRectMake(Screen_Width/3*i, 0, Screen_Width/3, 32);
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn setBackgroundColor:FYColor(196, 196, 196)];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.view addSubview:btn];
    }
    
    Baseline = [[UIView alloc] initWithFrame:CGRectMake(0, 30, Screen_Width/3, 2)];
    Baseline.backgroundColor = FYBlueColor;
    [self.view addSubview:Baseline];
    
    myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 32, Screen_Width, Screen_Height-64-32)];
    //翻页效果
    myScrollView.pagingEnabled = YES;
    myScrollView.showsHorizontalScrollIndicator = NO;
    // 设置UIScrollView的滚动范围（内容大小）
    myScrollView.bounces = YES;
    myScrollView.delegate = self;
    [self.view addSubview:myScrollView];
    myScrollView.contentSize = CGSizeMake(Screen_Width*3, Screen_Height-64-32);
    for (int i = 0; i<3; i++) {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(Screen_Width*i, 0, Screen_Width, Screen_Height-64-34)];
        if (i == 1) {
            tableViewProfile = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-64-34) style:UITableViewStylePlain];
            tableViewProfile.delegate = self;
            tableViewProfile.dataSource = self;
            tableViewProfile.hidden = YES;
            //    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            tableViewProfile.tableFooterView = [[UIView alloc] init];
            [v addSubview:tableViewProfile];
            [self getProfile:10];
        }
        else if (i == 0) {
            //创建案件查询页面
            [self createCaseCheckView:v];
        }
        else if (i == 2) {
            tableViewCase = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-64-34) style:UITableViewStylePlain];
            tableViewCase.delegate = self;
            tableViewCase.dataSource = self;
            tableViewCase.hidden = NO;
            //    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            tableViewCase.tableFooterView = [[UIView alloc] init];

            [v addSubview:tableViewCase];
        }
        [myScrollView addSubview:v];
    }
}

#pragma mark 案件查询
- (void)createCaseCheckView:(UIView *)view
{
//    UITableView *caseTV = [[UITableView alloc] initWithFrame:view.bounds];
//    // Create manager
//    self.manager = [[RETableViewManager alloc] initWithTableView:caseTV delegate:self];
//    self.manager.style.backgroundImageMargin = 10.0;
//    self.manager.style.cellHeight = 42.0;
//    /** 案件号部分 */
//    self.caseNumSection = [self addCaseControls:caseTV];
//    /** 查询密码部分 */
//    self.checkPasswordSection = [self addCheckPasswordSection];
//    [view addSubview:caseTV];
//    
//    caseTV.tableFooterView = [self FootView];
    if (ajCheackTableView) {
        return;
    }
    //    UITableView *ajtableView = [[UITableView alloc]init];
    //    [view addSubview:ajtableView];
    //    ajtableView.tableHeaderView = [self ajHeadView];
    //    [ajtableView setFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
    UIScrollView *myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height - 64)];
    [view addSubview:myScrollView];
    UILabel *ajh = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, Screen_Width - 20, 20)];
    ajh.text = @"案件号";
    ajh.textColor = FYBlueColor;
    ajh.font = [UIFont systemFontOfSize:17];
    [myScrollView addSubview:ajh];
    
    ajCheackTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(ajh.frame)+5, Screen_Width - 20, 160)];
    ajCheackTableView.layer.cornerRadius = 4.0f;
    ajCheackTableView.delegate = self;
    ajCheackTableView.dataSource= self;
    ajCheackTableView.scrollEnabled = NO;
    [view addSubview:ajCheackTableView];
    
    view.backgroundColor = FYBackgroundColor;
    
    
    UILabel *cxmm = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(ajCheackTableView.frame)+10, Screen_Width - 20, 20)];
    cxmm.text = @"查询密码";
    cxmm.textColor = FYBlueColor;
    cxmm.font = [UIFont systemFontOfSize:17];
    [myScrollView addSubview:cxmm];
    
    UIView *txtFieldBg = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(cxmm.frame)+5, Screen_Width - 20, 40 )];
    txtFieldBg.backgroundColor = [UIColor whiteColor];
    txtFieldBg.layer.cornerRadius = 4.0f;
    [myScrollView addSubview:txtFieldBg];
    
    self.checkPasswordItem = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, txtFieldBg.width - 10, 40)];
    self.checkPasswordItem.placeholder = @"请输入您的密码";
    self.checkPasswordItem.textAlignment = NSTextAlignmentRight;
    [txtFieldBg addSubview:self.checkPasswordItem];
    
    UIButton *checkBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(txtFieldBg.frame)+ 10, Screen_Width - 20, 44)];
    checkBtn.layer.cornerRadius = 4.0f;
    [checkBtn setTitle:@"查询" forState:UIControlStateNormal];
    [checkBtn setBackgroundColor:FYBlueColor];
    [checkBtn addTarget:self action:@selector(clickCheckBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:checkBtn];
    
    UILabel *tipLb = [[UILabel alloc]init];
    tipLb.text = @"   提示:\n   查询过程如有疑问，请在【消息】中联系客服。\n   在【个人中心】进行案件绑定后，可接收案件节点消息自动告知。\n   在【消息】中可添加法官进行即时对话。";
    tipLb.font = [UIFont systemFontOfSize:14];
    tipLb.numberOfLines = 0;
    [tipLb setFrame:CGRectMake(14, CGRectGetMaxY(checkBtn.frame)+5, Screen_Width - 28 , 120)];
    [view addSubview:tipLb];
    
    [myScrollView setContentSize:CGSizeMake(Screen_Width, CGRectGetMaxY(tipLb.frame))];
    
    
    
    [myScrollView addSubview:ajCheackTableView];

}

//- (UIView *)FootView
//{
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height * 0.5)];
//    view.backgroundColor = FYColor(245, 245, 245);
//    
//    UIButton *checkBtn = [[UIButton alloc]initWithFrame:CGRectMake(14, 10, Screen_Width - 28, 44)];
//    checkBtn.layer.cornerRadius = 4.0f;
//    [checkBtn setTitle:@"查询" forState:UIControlStateNormal];
//    [checkBtn setBackgroundColor:FYColor(0, 111, 194)];
//    [checkBtn addTarget:self action:@selector(clickCheckBtn) forControlEvents:UIControlEventTouchUpInside];
//    [view addSubview:checkBtn];
//    
//    UILabel *tipLb = [[UILabel alloc]init];
//    tipLb.text = @"提示:\n查询过程中如有疑问，请在【诉讼中心】中联系12368客服。\n在个人中心进行案件绑定后，可接受案件节点信息自动告知。";
//    tipLb.font = [UIFont systemFontOfSize:14];
//    tipLb.numberOfLines = 0;
//    [tipLb setFrame:CGRectMake(14, CGRectGetMaxY(checkBtn.frame)+5, Screen_Width - 28 , 100)];
//    [view addSubview:tipLb];
//    
//    
//    return view;
//}

- (void)clickCheckBtn
{if ([NSString isBlankString: self.caseYear.text]) {
    [MBProgressHUD showError:@"案件年号不能为空"];
}else  if ([NSString isBlankString: self.caseTextItem.text]) {
    [MBProgressHUD showError:@"案件字号不能为空"];
}else  if ([NSString isBlankString: self.caseNumItem.text]) {
    [MBProgressHUD showError:@"案件编号号不能为空"];
}else  if ([NSString isBlankString: self.checkPasswordItem.text]) {
    [MBProgressHUD showError:@"查询密码不能为空"];
}else
{
    [self getCheckRequest];
    
}

}

- (void)getCheckRequest
{
    [MBProgressHUD showMessage:@""];
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    paras[@"ajnh"] = self.caseYear.text;
    paras[@"fyjc"] = self.lowItem;
    paras[@"ajzh"] = self.caseTextItem.text;
    paras[@"ajbh"] =self.caseNumItem.text;
    paras[@"cxmm"] = self.checkPasswordItem.text;
    NSLog(@"参数:%@",paras);
    [FSHttpTool post:@"app/aj!queryAjax.action" params:paras success:^(id json) {
        [MBProgressHUD hideHUD];
        NSLog(@"%@",json);
        NSDictionary *result = (NSDictionary *)json;
        if(![NSString isBlankString:[result objectForKey:@"message"]])
        {
            [MBProgressHUD showError:[result objectForKey:@"message"]];
        }else
        {
            FYMyCaseDetailTableViewController *caseDetailVC = [[FYMyCaseDetailTableViewController alloc]init];
            caseDetailVC.attach = (NSDictionary *)json;
            [self.navigationController pushViewController:caseDetailVC animated:YES];
        }
        
        //        NSDictionary *attach = [result objectForKey:@"attach"];
        //        listholdCourt = [attach objectForKey:@"list"];
        //        [tableViewHoldCourt reloadData];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        
        FYLog(@"报错信息%@",error);
    }];
    
}




#pragma mark -======执行指引和曝光台 接口===================
-(void)getProfile:(int)categoryId
{
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

    paras = @{@"courtId":@(needCountId),
              @"categoryId":@(categoryId)};
    FYLog(@"参数:%@",paras);
    
    //执行指引
    if(categoryId == 10)
    {
        [MBProgressHUD showMessage:@""];

        [FSHttpTool post:@"app/article!getSubCategoryListAjax.action" params:paras success:^(id json) {
            NSLog(@"执行指引结果%@",json);
            [MBProgressHUD hideHUD];
            NSDictionary *result = (NSDictionary *)json;

            listProfile = [result objectForKey:@"attach"];
            tableViewProfile.hidden = NO;
            [tableViewProfile reloadData];
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUD];
            NSLog(@"报错信息%@",error);
        }];
    }
    //曝光台
    else if(categoryId == 5)
    {
         [MBProgressHUD showMessage:@""];
        [FSHttpTool post:@"app/article!paginationAjax.action" params:paras success:^(id json) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD hideHUD];
            NSLog(@"曝光台结果%@",json);
            NSDictionary *result = (NSDictionary *)json;
            
           NSDictionary *attachResut = [result objectForKey:@"attach"];
            listCase = [attachResut objectForKey:@"list"];
            tableViewCase.hidden = NO;
            [tableViewCase reloadData];
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUD];
            NSLog(@"报错信息%@",error);
        }];
    }
}

//scrollview的委托方法，当滚动时执行
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:myScrollView]) {
        int page = myScrollView.contentOffset.x/GetVWidth(myScrollView);
        [UIView animateWithDuration:0.3 animations:^{
            Baseline.frame = CGRectMake(Screen_Width/3*page, 30, Screen_Width/3, 2);
        }];
        if (page == 2) {
            if (listCase.count<= 0) {
                [self getProfile:5];
            }
        }
    }
}

//左右按钮  tag = 1 左  tag = 2 右
-(void)ButtonEvents:(UIButton *)button
{
    if (button.tag <=3) {
        //动画下划线的滑动
        [UIView animateWithDuration:0.3 animations:^{
            Baseline.frame = CGRectMake(Screen_Width/3*(button.tag-1), 32, Screen_Width/3, 2);
        }];
        
    }
    if (button.tag == 1) {
        //动画下划线的滑动
        [UIView animateWithDuration:0.3 animations:^{
            myScrollView.contentOffset = CGPointMake(0, 0);
        }];
        
    }
    else if (button.tag == 2) {
        //动画下划线的滑动
        [UIView animateWithDuration:0.3 animations:^{
            myScrollView.contentOffset = CGPointMake(Screen_Width, 0);
        }];
    }
    else if (button.tag == 3) {
        //动画下划线的滑动
        [UIView animateWithDuration:0.3 animations:^{
            myScrollView.contentOffset = CGPointMake(Screen_Width*2, 0);
        }];
        if (listCase.count<= 0) {
            [self getProfile:5];
            
        }
        
    }else if (button.tag == 4) {
        TrialOpenType_ViewController *trial = [[TrialOpenType_ViewController alloc] init];
        [self.navigationController pushViewController:trial animated:YES];
    }
    //
    //    if ([_delegate respondsToSelector:select(doDirection:)]) {
    //        [_delegate doDirection:button];
    //    }
}

#pragma mark -========tableView====================
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:tableViewProfile]) {
        return listProfile.count;
    }
    else if ([tableView isEqual:tableViewCase]) {
        return listCase.count;
    }else if ([tableView isEqual:ajCheackTableView])
    {
        return 4;
    }
    return 0;
}

#pragma mark设置每一个cell的行高（有多少行，就走多少次）
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:tableViewCase]) {
        NSDictionary *dic = nil;
        if(listCase.count > indexPath.row)
        {
            dic = [listCase objectAtIndex:indexPath.row];
        }
        
        CGFloat H = [CTB heightOfString:[dic objectForKey:@"title"] font:[UIFont systemFontOfSize:17] width:Screen_Width-20];
        
        return 10 + H + 10 + 20;
    }else if ([tableView isEqual:ajCheackTableView])
    {
        return 40;
    }
    return 36;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:tableViewProfile]) {
        NSString *identifier = @"zhixingCell";
        FYTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == NULL) {
            cell = [[FYTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        NSDictionary *dic = [listProfile objectAtIndex:indexPath.row];
        NSLog(@"获取回来的字典是:%@",dic);
        cell.textLabel.text = [dic objectForKey:@"title"];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        return cell;
    }else if([tableView isEqual:tableViewCase])
    {
        NSString *identifier = @"ListCell1";
        FYExecuteCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == NULL) {
            cell = [[FYExecuteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
       
        NSLog(@"list is :%@",listCase);
        NSDictionary  *dic = nil;
        if(listCase.count > indexPath.row)
        {
            dic = [listCase objectAtIndex:indexPath.row];
        }
        
        NSLog(@"dic is %@  %@  %@",dic,[dic objectForKey:@"title"],[dic objectForKey:@"publishTime"] );
        
        CGFloat H = [CTB heightOfString:[dic objectForKey:@"title"] font:[UIFont systemFontOfSize:17] width:Screen_Width-20];
        cell.lblTitle.frame = CGRectMake(10, 10, Screen_Width-20, H);
        cell.lblTime.frame = CGRectMake(10, cell.lblTitle.frame.origin.y + cell.lblTitle.frame.size.height + 8, Screen_Width-30, 20);
        
        cell.Title = [dic objectForKey:@"title"];
        cell.Time = [dic objectForKey:@"publishTime"];
        return cell;

    }else if ([tableView isEqual:ajCheackTableView])
    {
        NSString *identifier = @"CheckCell";
        
        FYTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == NULL) {
            cell = [[FYTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
            
        }
        if (indexPath.row == 0) {
            if(!self.caseYear)
            {
                self.caseYear = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, Screen_Width - 30, 40)];
                self.caseYear.textAlignment = NSTextAlignmentRight;
                self.caseYear.placeholder = @"案件年号";
                self.caseYear.text = self.yearArr[0];
                self.caseYear.delegate = self;
                [cell.contentView addSubview:self.caseYear];
                
            }
        }else if (indexPath.row == 1)
        {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *textSelect = [userDefaults objectForKey:@"lowSelect"];
            if (textSelect == nil) {
                int year = [self.caseYear.text intValue];
                if(year >= 2016) {
                    cell.detailTextLabel.text = @"粤71";
                    self.lowItem = @"粤71";
                } else {
                    cell.detailTextLabel.text = @"广铁中法";
                    self.lowItem = @"广铁中法";
                }
                cell.detailTextLabel.textColor = [UIColor blackColor];
            }else
            {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",textSelect];
                self.lowItem = textSelect;
                
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        else if (indexPath.row == 2)
        {
            if (!self.caseTextItem) {
                self.caseTextItem = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, Screen_Width - 30, 40)];
                self.caseTextItem.textAlignment = NSTextAlignmentRight;
                self.caseTextItem.placeholder = @"案件字号";
                [cell.contentView addSubview:self.caseTextItem];
                
            }
            
        }else if (indexPath.row == 3)
        {
            if (!self.caseNumItem) {
                self.caseNumItem = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, Screen_Width - 30, 40)];
                self.caseNumItem.textAlignment = NSTextAlignmentRight;
                self.caseNumItem.placeholder = @"案件编号";
                [cell.contentView addSubview:self.caseNumItem];
                
            }
            
        }
        
        
        return cell;
    }
    return [[UITableViewCell alloc]init];
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = nil;
    //执行指引
    if ([tableView isEqual:tableViewProfile]) {
        dic = [listProfile objectAtIndex:indexPath.row];
        FYZSTableViewController *zstv  = [[FYZSTableViewController alloc]init];
        zstv.selects = 1;
        zstv.Title = [dic objectForKey:@"title"];
        zstv.zsId = [dic objectForKey:@"id"];
        [self.navigationController pushViewController:zstv animated:YES];
        
    }else if ([tableView isEqual:tableViewCase]) {
        dic = [listCase objectAtIndex:indexPath.row];
        FYWebViewController *webView =[[FYWebViewController alloc] init];
        webView.Title = [dic objectForKey:@"title"];
        webView.url = [dic objectForKey:@"url"];
        [self.navigationController pushViewController:webView animated:YES];
        
    }else if ([tableView isEqual:ajCheackTableView])
    {
        if (indexPath.row == 1) {
            LawSelectViewController *lawSelectVC = [[LawSelectViewController alloc] init];
            lawSelectVC.year = [self.caseYear.text intValue];
            [self.navigationController pushViewController:lawSelectVC animated:YES];
        }
    }

    
    else
    {
        return;
    }
   
    
}

- (void)pickerInitData
{
    if(!self.yearArr) {
        self.yearArr = [[NSMutableArray alloc] init];
    }
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
    int year = (int)[dateComponent year];
    for (int i = year; i >= 1940; i--) {
        [self.yearArr addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return NO;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [MMPickerView showPickerViewInView:self.view withStrings:[self.yearArr copy] withOptions:nil completion:^(NSString *selectedString) {
        self.caseYear.text = selectedString;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:nil forKey:@"lowSelect"];
        [ajCheackTableView reloadData];
    }];
    return NO;
}

@end
