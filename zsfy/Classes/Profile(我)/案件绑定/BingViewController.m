//
//  BingViewController.m
//  zsfy
//
//  Created by pyj on 15/11/14.
//  Copyright (c) 2015年 wzy. All rights reserved.
//

#import "BingViewController.h"
#import "LawSelectViewController.h"
#import "FYTableViewCell.h"
#import "MMPickerView.h"
@interface BingViewController () <UITextFieldDelegate>
{
  UITableView *bingTableView;
}

@property (nonatomic,strong)UIView *loginView;

@property (nonatomic,strong)UIView *logOutView;



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

///** 手机号码部分 */
//@property (strong, nonatomic) RETableViewSection *phoneSection;
///** 手机号码部分 */
//@property (strong, nonatomic) RETextItem *phoneItem;

/** 法律 */
@property (nonatomic,strong)NSArray *lowArray;

@property (nonatomic, strong) NSMutableArray *yearArr;

@property (nonatomic,strong)NSString *saveLow;

@end

@implementation BingViewController

- (void)viewWillAppear:(BOOL)animated
{
    if (bingTableView) {
        [bingTableView reloadData];
    }
}
- (UIView *)loginView
{
    if (_loginView == nil) {
        self.loginView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height - 64)];
        
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

- (NSArray *)lowArray
{
    if (_lowArray == nil) {
//        self.lowArray =@[@"穗中法",@"穗海法",@"穗荔法",@"穗天法",@"穗云法",@"穗黄法",@"穗花法",@"穗番法",@"穗南法",@"穗越法",@"穗从法",@"穗增法"];
         self.lowArray = @[@"广铁中法",@"广铁法",@"肇铁法"];
    }
    return _lowArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self pickerInitData];
    self.navigationItem.title = @"案件绑定";
    self.view.backgroundColor = [UIColor whiteColor];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *userId  =  [userDefault objectForKey:@"user_id"];
    if(userId.length > 0 )
    {
        UILabel *ajh = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, Screen_Width - 20, 20)];
        ajh.text = @"案件号";
        ajh.textColor = FYBlueColor;
        ajh.font = [UIFont systemFontOfSize:17];
        [self.loginView addSubview:ajh];
        bingTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(ajh.frame)+5, Screen_Width - 20, 160)];
        bingTableView.layer.cornerRadius = 4.0f;
        bingTableView.delegate = self;
        bingTableView.dataSource = self;
        bingTableView.scrollEnabled = NO;
        [self.loginView addSubview:bingTableView];
        
        self.loginView.backgroundColor = FYBackgroundColor;
        
        
        UILabel *cxmm = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(bingTableView.frame)+10, Screen_Width - 20, 20)];
        cxmm.text = @"查询密码";
        cxmm.textColor = FYBlueColor;
        cxmm.font = [UIFont systemFontOfSize:17];
        [self.loginView addSubview:cxmm];
        
        UIView *txtFieldBg = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(cxmm.frame)+5, Screen_Width - 20, 40 )];
        txtFieldBg.backgroundColor = [UIColor whiteColor];
        txtFieldBg.layer.cornerRadius = 4.0f;
        [self.loginView addSubview:txtFieldBg];
        
        self.checkPasswordItem = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, txtFieldBg.width - 10, 40)];
        self.checkPasswordItem.placeholder = @"请输入您的密码";
        self.checkPasswordItem.textAlignment = NSTextAlignmentRight;
        [txtFieldBg addSubview:self.checkPasswordItem];
        
        UIButton *checkBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(txtFieldBg.frame)+ 10, Screen_Width - 20, 44)];
        checkBtn.layer.cornerRadius = 4.0f;
        [checkBtn setTitle:@"绑定" forState:UIControlStateNormal];
        [checkBtn setBackgroundColor:FYBlueColor];
        [checkBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *tipLb = [[UILabel alloc]init];
        tipLb.text = @"   提示:\n   查询过程如有疑问，请在【消息】中联系客服。\n   在【个人中心】进行案件绑定后，可接收案件节点消息自动告知。\n   在【消息】中可添加法官进行即时对话。";
        tipLb.font = [UIFont systemFontOfSize:14];
        tipLb.numberOfLines = 0;
        [tipLb setFrame:CGRectMake(14, CGRectGetMaxY(checkBtn.frame)+5, Screen_Width - 28 , 120)];
        [self.loginView addSubview:tipLb];
        
        
        [self.loginView addSubview:checkBtn];

        [self.view bringSubviewToFront:self.loginView];
    }else
    {
        [self.view bringSubviewToFront:self.logOutView];
       
    }
    
}
//#pragma mark FootView
//- (UIView *)footView
//{
//    UIView *footView=  [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 64)];
//    footView.backgroundColor = [UIColor whiteColor];
//    UIButton *bingBtn = [[UIButton alloc]initWithFrame:CGRectMake(14, 10, Screen_Width - 28, 44)];
//    bingBtn.layer.cornerRadius = 4.0f;
//    [bingBtn setBackgroundColor:FYColor(0, 111, 194)];
//    [bingBtn setTitle:@"绑定" forState:UIControlStateNormal];
//    [bingBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [footView addSubview:bingBtn];
//    
//    return footView;
//}


- (void)clickBtn:(UIButton *)button
{


    if([NSString isBlankString:self.caseYear.text])
    {
        [MBProgressHUD showError:@"案件年号不能为空"];
    }else if([NSString isBlankString:self.caseTextItem.text])
    {
        [MBProgressHUD showError:@"案件字号不能为空"];

    }else if([NSString isBlankString:self.caseNumItem.text])
    {
        [MBProgressHUD showError:@"案件编号不能为空"];
        
    }else if ([NSString isBlankString:self.checkPasswordItem.text])
    {
        [MBProgressHUD showError:@"查询密码不能为空"];

    }else if (self.checkPasswordItem.text.length < 6)
    {
        [MBProgressHUD showError:@"查询密码不能小于6位"];
    }else
    {
        [self bingRequest];
    }
    
}

- (void)bingRequest
{
    [MBProgressHUD showMessage:@""];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token =  [defaults objectForKey:@"token"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"token"] = token;
    params[@"ajnh"] = self.caseYear.text;
    params[@"fyjc"] = self.lowItem;
    params[@"ajzh"] = self.caseTextItem.text;
    params[@"ajbh"] = self.caseNumItem.text;
    params[@"cxmm"] = self.checkPasswordItem.text;
    NSLog(@"请求参数:%@",params);
    [FSHttpTool post:@"app/ajBidding!biddingAjax.action" params:params success:^(id json) {
        [MBProgressHUD hideHUD];
        NSDictionary *result = (NSDictionary *)json;
        if([[result objectForKey:@"status"] intValue] == 1)
        {
            NSString *message = [result objectForKey:@"message"];
            [MBProgressHUD showError:message];
        }else
        {
            [MBProgressHUD showSuccess:@"绑定案件成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        NSLog(@"错误信息%@",error);
    }];

}

#pragma mark -========tableView====================
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  
        return 4;
  
}
#pragma mark设置每一个cell的行高（有多少行，就走多少次）
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
        return 40;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
    if (indexPath.row == 1) {
            LawSelectViewController *lawSelectVC = [[LawSelectViewController alloc] init];
            lawSelectVC.year = [self.caseYear.text intValue];
            [self.navigationController pushViewController:lawSelectVC animated:YES];
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
        [bingTableView reloadData];
    }];
    return NO;
}


@end
