//
//  FYMyCaseDetailTableViewController.m
//  zsfy
//
//  Created by eshore_it on 15-11-28.
//  Copyright (c) 2015年 wzy. All rights reserved.
//

#import "FYMyCaseDetailTableViewController.h"
#import "FYSearchTitle_View.h"
@interface FYMyCaseDetailTableViewController ()
@property (nonatomic,strong)UIScrollView *myScrollerView;
@property (nonatomic,strong)UILabel *larqlb;
@property (nonatomic,strong)UILabel *cbbmlb;
@property (nonatomic,strong)UILabel *bdjelb;
@property (nonatomic,strong)UILabel *ajjdlb;
@property (nonatomic,strong)UILabel *aydlb;
@property (nonatomic,strong)UILabel *dsrxx;

@property (nonatomic,strong)UILabel *spzlb;
@property (nonatomic,strong)UILabel *cbrlb;
@property (nonatomic,strong)UILabel *sjylb;
@property (nonatomic,strong)UILabel *sjdhlb;
@property (nonatomic,strong)UILabel *hytcylb;


@property (nonatomic,strong)UILabel *ajmc;
@property (nonatomic,strong)UILabel *ajh;
@property (nonatomic,strong)UILabel *zsfg;
@property (nonatomic,strong)UILabel *ktsj;
@property (nonatomic,strong)UILabel *ktdd;


@end

@implementation FYMyCaseDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"案例查询";
    self.view.backgroundColor = FYBackgroundColor;
    self.myScrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
    [self.view addSubview:self.myScrollerView];
    
    [self initView];
    
    
    
}


- (void)initView
{
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height/3)];
    view1.backgroundColor = FYBackgroundColor;
    UIView *title1 = [FYSearchTitle_View initWithTitle:@"案件基本信息" TipImage:@"arrow_right"];
    [view1 addSubview:title1];
    UIView *bgView1 = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(title1.frame), Screen_Width - 20, Screen_Height/3 - 30)];
    bgView1.backgroundColor = [UIColor whiteColor];
    bgView1.layer.cornerRadius = 4.0f;
    [view1 addSubview:bgView1];
    
    self.larqlb = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, Screen_Width*0.5-10, 20)];
    self.larqlb.text = @"立案日期：";
    self.larqlb.font = [UIFont systemFontOfSize:14];
    [bgView1 addSubview:self.larqlb];
    
    
    self.cbbmlb = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.larqlb.frame), 10, Screen_Width*0.5-10, 20)];
    self.cbbmlb.text = @"承办部门：";
    self.cbbmlb.font = [UIFont systemFontOfSize:14];
    [bgView1 addSubview:self.cbbmlb];
    
    
    self.bdjelb = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.larqlb.frame), Screen_Width*0.5-10, 20)];
    self.bdjelb.text = @"标的金额：";
    self.bdjelb.font = [UIFont systemFontOfSize:14];
    [bgView1 addSubview:self.bdjelb];
    
    self.ajjdlb = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.bdjelb.frame), CGRectGetMaxY(self.cbbmlb.frame), Screen_Width*0.5-10, 20)];
    self.ajjdlb.text = @"案件进度：";
    self.ajjdlb.font = [UIFont systemFontOfSize:14];
    [bgView1 addSubview:self.ajjdlb];

    self.aydlb = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.ajjdlb.frame), Screen_Width-20, 20)];
    self.aydlb.textAlignment = NSTextAlignmentCenter;
    self.aydlb.text = @"案由：";
    self.aydlb.font = [UIFont systemFontOfSize:14];
    [bgView1 addSubview:self.aydlb];

    self.dsrxx = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.aydlb.frame), Screen_Width -40, bgView1.height - CGRectGetMaxY(self.aydlb.frame))];
    self.dsrxx.text = @"当事人信息 ";
    self.dsrxx.numberOfLines = 0;
    self.dsrxx.font = [UIFont systemFontOfSize:14];
    [bgView1 addSubview:self.dsrxx];
    
    [self.myScrollerView addSubview:view1];
    
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(view1.frame), Screen_Width, 110)];
    view2.backgroundColor = FYBackgroundColor;
    UIView *title2 = [FYSearchTitle_View initWithTitle:@"合议庭信息" TipImage:@"arrow_right"];
    [view2 addSubview:title2];
    UIView *bgView2 = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(title2.frame), Screen_Width - 20, 80 )];
    bgView2.backgroundColor = [UIColor whiteColor];
    bgView2.layer.cornerRadius = 4.0f;
    [view2 addSubview:bgView2];
    
    
    self.spzlb = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, Screen_Width*0.5-10, 20)];
    self.spzlb.text = @"审判长：";
    self.spzlb.font = [UIFont systemFontOfSize:14];
    [bgView2 addSubview:self.spzlb];
    
    
    self.cbrlb = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.spzlb.frame), 10, Screen_Width*0.5-10, 20)];
    self.cbrlb.text = @"承办人：";
    self.cbrlb.font = [UIFont systemFontOfSize:14];
    [bgView2 addSubview:self.cbrlb];
    
    
    self.sjylb = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.spzlb.frame), Screen_Width*0.5-10, 20)];
    self.sjylb.text = @"书记员：";
    self.sjylb.font = [UIFont systemFontOfSize:14];
    [bgView2 addSubview:self.sjylb];
    
    self.sjdhlb = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.sjylb.frame), CGRectGetMaxY(self.cbrlb.frame), Screen_Width*0.5-10, 20)];
    self.sjdhlb.text = @"书记电话：";
    self.sjdhlb.font = [UIFont systemFontOfSize:14];
    [bgView2 addSubview:self.sjdhlb];
    
    self.hytcylb = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.sjdhlb.frame), Screen_Width-40, 20)];
    self.hytcylb.textAlignment = NSTextAlignmentLeft;
    self.hytcylb.text = @"合议庭成员：";
    self.hytcylb.font = [UIFont systemFontOfSize:14];
    [bgView2 addSubview:self.hytcylb];
    
    [self.myScrollerView addSubview:view2];

    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(view2.frame), Screen_Width, 130)];
    view3.backgroundColor = FYBackgroundColor;
    UIView *title3 = [FYSearchTitle_View initWithTitle:@"开庭信息" TipImage:@"arrow_right"];
    [view3 addSubview:title3];
    [self.myScrollerView addSubview:view3];
    
    UIView *bgView3 = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(title3.frame), Screen_Width - 20, 130 )];
    bgView3.backgroundColor = [UIColor whiteColor];
    bgView3.layer.cornerRadius = 4.0f;
    [view3 addSubview:bgView3];

    self.ajmc = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, Screen_Width- 40, 20)];
    self.ajmc.text = @"案件名称：";
    self.ajmc.font = [UIFont systemFontOfSize:14];
    [bgView3 addSubview:self.ajmc];
    
    
    self.ajh = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.ajmc.frame), Screen_Width-40, 20)];
    self.ajh.text = @"案件号：";
    self.ajh.font = [UIFont systemFontOfSize:14];
    [bgView3 addSubview:self.ajh];
    
    
    self.zsfg = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.ajh.frame), Screen_Width-40, 20)];
    self.zsfg.text = @"主审法官：";
    self.zsfg.font = [UIFont systemFontOfSize:14];
    [bgView3 addSubview:self.zsfg];

    self.ktsj = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.zsfg.frame), Screen_Width-40, 20)];
    self.ktsj.text = @"开庭时间：";
    self.ktsj.font = [UIFont systemFontOfSize:14];
    [bgView3 addSubview:self.ktsj];
    
    self.ktdd = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.ktsj.frame), Screen_Width-40, 20)];
    self.ktdd.text = @"开庭地点：";
    self.ktdd.font = [UIFont systemFontOfSize:14];
    [bgView3 addSubview:self.ktdd];

    [self.myScrollerView setContentSize:CGSizeMake(Screen_Width, CGRectGetMaxY(view3.frame))];
    
    [self requestData];

}

- (void)requestData
{
    if (self.attach) {
        NSLog(@"=====  %@",self.attach);
        NSDictionary *attach = [self.attach objectForKey:@"attach"];
        NSDictionary *ajxxDic = [attach objectForKey:@"ajxx"];
        NSMutableArray *dsrxxArr = [attach objectForKey:@"dsrxx"];
        self.larqlb.text = [NSString stringWithFormat:@"立案日期：%@",[ajxxDic objectForKey:@"larq"]];
        self.cbbmlb.text = [NSString stringWithFormat:@"承办部门：%@",[ajxxDic objectForKey:@"cbbm"]];
        self.bdjelb.text = [NSString stringWithFormat:@"标的金额：%@",[ajxxDic objectForKey:@"ssbd"]];
        self.ajjdlb.text = [NSString stringWithFormat:@"案件进度：%@",[ajxxDic objectForKey:@"ajzt"]];
        self.aydlb.text = [NSString stringWithFormat:@"案由：%@",[ajxxDic objectForKey:@"ay"]];
        
        NSString *text = @"当事人信息  ";
        for (int i = 0; i < dsrxxArr.count; i ++) {
            NSDictionary *dic = dsrxxArr[i];
            
            NSString *appenStr = [NSString stringWithFormat:@"  %@ :%@",[dic objectForKey:@"ssdw"],[dic objectForKey:@"dsrmc"] ];
            text = [NSString stringWithFormat:@"%@%@",text,appenStr];
        }
        NSLog(@"text%@",text);
        self.dsrxx.text = text;
        
        
        self.spzlb.text = [NSString stringWithFormat:@"审判长：%@",[ajxxDic objectForKey:@"spz"]];
        self.cbrlb.text = [NSString stringWithFormat:@"承办人：%@",[ajxxDic objectForKey:@"zsfg"]];
        self.cbrlb.text = [NSString stringWithFormat:@"书记员：%@",[ajxxDic objectForKey:@"sjy"]];
        //            self.sjdhlb.text = [NSString stringWithFormat:@"书记电话：%@",[ajxxDic objectForKey:@"sjy"]];
        self.hytcylb.text = [NSString stringWithFormat:@"合议庭成员：%@",[ajxxDic objectForKey:@"hytcy"]];
    }else
    {
    [MBProgressHUD showMessage:@""];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token =  [defaults objectForKey:@"token"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"token"] = token;
    params[@"id"] = self.url;

    [FSHttpTool post:@"app/app/ajBidding!getAjDetail.action" params:params success:^(id json) {
        [MBProgressHUD hideHUD];
        NSDictionary *result = (NSDictionary *)json;
        if([[result objectForKey:@"status"] intValue]!=0)
        {
            NSString *message = [result objectForKey:@"message"];
            [MBProgressHUD showError:message];
        }else
        {
            NSLog(@"%@",json);
            NSDictionary *result = (NSDictionary *)json;
            NSDictionary *resultAttach = [result objectForKey:@"attach"];
            NSDictionary *ajxxDic = [resultAttach objectForKey:@"ajxx"];
            NSMutableArray *dsrxxArr = [resultAttach objectForKey:@"dsrxx"];
            self.larqlb.text = [NSString stringWithFormat:@"立案日期：%@",[ajxxDic objectForKey:@"larq"]];
            self.cbbmlb.text = [NSString stringWithFormat:@"承办部门：%@",[ajxxDic objectForKey:@"cbbm"]];
            self.bdjelb.text = [NSString stringWithFormat:@"标的金额：%@",[ajxxDic objectForKey:@"ssbd"]];
            self.ajjdlb.text = [NSString stringWithFormat:@"案件进度：%@",[ajxxDic objectForKey:@"ajzt"]];
            self.aydlb.text = [NSString stringWithFormat:@"案由：%@",[ajxxDic objectForKey:@"ay"]];

            NSString *text = @"当事人信息  ";
            for (int i = 0; i < dsrxxArr.count; i ++) {
                NSDictionary *dic = dsrxxArr[i];
                
                NSString *appenStr = [NSString stringWithFormat:@"  %@ :%@",[dic objectForKey:@"ssdw"],[dic objectForKey:@"dsrmc"] ];
                text = [NSString stringWithFormat:@"%@%@",text,appenStr];
            }
            NSLog(@"text%@",text);
            self.dsrxx.text = text;
            
            
            self.spzlb.text = [NSString stringWithFormat:@"审判长：%@",[ajxxDic objectForKey:@"spz"]];
            self.cbrlb.text = [NSString stringWithFormat:@"承办人：%@",[ajxxDic objectForKey:@"zsfg"]];
            self.cbrlb.text = [NSString stringWithFormat:@"书记员：%@",[ajxxDic objectForKey:@"sjy"]];
//            self.sjdhlb.text = [NSString stringWithFormat:@"书记电话：%@",[ajxxDic objectForKey:@"sjy"]];
            self.hytcylb.text = [NSString stringWithFormat:@"合议庭成员：%@",[ajxxDic objectForKey:@"hytcy"]];
            
            
//            self.ajmc.text = [NSString stringWithFormat:@"审判长：%@",[ajxxDic objectForKey:@"spz"]];
//            self.cbrlb.text = [NSString stringWithFormat:@"承办人：%@",[ajxxDic objectForKey:@"zsfg"]];
//            self.cbrlb.text = [NSString stringWithFormat:@"书记员：%@",[ajxxDic objectForKey:@"sjy"]];
//            //            self.sjdhlb.text = [NSString stringWithFormat:@"书记电话：%@",[ajxxDic objectForKey:@"sjy"]];
//            self.hytcylb.text = [NSString stringWithFormat:@"合议庭成员：%@",[ajxxDic objectForKey:@"hytcy"]];

            
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        NSLog(@"错误信息%@",error);
    }];
        
    }

}



@end
