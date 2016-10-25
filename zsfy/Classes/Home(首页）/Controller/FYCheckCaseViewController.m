//
//  FYCheckCaseViewController.m
//  zsfy
//
//  Created by eshore_it on 15-12-2.
//  Copyright (c) 2015年 wzy. All rights reserved.
//

#import "FYCheckCaseViewController.h"
#import "FYMyCaseDetailTableViewController.h"

@interface FYCheckCaseViewController ()
{
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
@end

@implementation FYCheckCaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];

}
- (void)initView
{
    UIScrollView *myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height - 64)];
    [self.view addSubview:myScrollView];
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
    [self.view addSubview:ajCheackTableView];
    
    self.view.backgroundColor = FYBackgroundColor;
    
    
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
    
    [self.view addSubview:checkBtn];
    
    UILabel *tipLb = [[UILabel alloc]init];
    tipLb.text =  @"   提示:\n   查询过程如有疑问，请在【消息】中联系客服。\n   在【个人中心】进行案件绑定后，可接收案件节点消息自动告知。\n   在【消息】中可添加法官进行即时对话。";
    tipLb.font = [UIFont systemFontOfSize:14];
    tipLb.numberOfLines = 0;
    [tipLb setFrame:CGRectMake(14, CGRectGetMaxY(checkBtn.frame)+5, Screen_Width - 28 , 120)];
    [self.view addSubview:tipLb];
    
    [myScrollView setContentSize:CGSizeMake(Screen_Width, CGRectGetMaxY(tipLb.frame))];
    
    
    
    [myScrollView addSubview:ajCheackTableView];

}

- (void)clickCheckBtn
{
    if ([NSString isBlankString: self.caseYear.text]) {
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
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        
        FYLog(@"报错信息%@",error);
    }];
    
}


@end
