//
//  ZYGbLitigationViewController.m
//  zsfy
//
//  Created by eshore_it on 15/12/17.
//  Copyright © 2015年 wzy. All rights reserved.
//

#import "ZYGbLitigationViewController.h"
#import "FYTrialBroadcast_ViewController.h"
#import "FYWebViewController.h"
#import "ZYSSZNViewController.h"
#import "ZYLxfgViewController.h"
#import "ZYYyxfViewController.h"
#import "ZYYslxViewController.h"
@interface ZYGbLitigationViewController ()

@end

@implementation ZYGbLitigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"诉讼中心";
    self.view.backgroundColor = FYBlueColor;
        self.automaticallyAdjustsScrollViewInsets = NO;
        // 透明状态栏的延伸
        self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    self.navigationController.navigationBar.translucent = NO;

    [self createView];
}

- (void)createView
{
    
    UIImageView *canFindIV = [[UIImageView alloc]initWithFrame:CGRectMake((Screen_Width - 132)*0.5, 20, 132, 27)];
    canFindIV.image = [UIImage imageNamed:@"你能找到"];
    [self.view addSubview:canFindIV];
    
    for (int i= 0 ; i < 3; i ++) {
        UIButton *button = [[UIButton alloc]init];
        CGFloat btnWith = 60;
        CGFloat margin = (Screen_Width - 3*60 - 40)/2;
        [button setFrame:CGRectMake(i*(btnWith+margin)+20, CGRectGetMaxY(canFindIV.frame)+40, btnWith, btnWith)];
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn%d",i+1]] forState:UIControlStateNormal];
        button.tag = i;
        if (i == 0) {
            UILabel *label = [[UILabel alloc]init];
            label.text = @"12368";
            [label setFrame:CGRectMake(0, CGRectGetMaxY(button.frame)+10, Screen_Width/3, 20)];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor  = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:14];
            [self.view addSubview:label];
        }else if(i == 1)
        {
            UILabel *label = [[UILabel alloc]init];
            label.text = @"诉讼指南";
            [label setFrame:CGRectMake(Screen_Width/3, CGRectGetMaxY(button.frame)+10, Screen_Width/3, 20)];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor  = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:14];
             [self.view addSubview:label];
        }else if(i == 2)
        {
            UILabel *label = [[UILabel alloc]init];
            label.text = @"诉讼费用计算器";
            [label setFrame:CGRectMake(2*Screen_Width/3, CGRectGetMaxY(button.frame)+10, Screen_Width/3, 20)];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor  = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:14];
             [self.view addSubview:label];
        }
        [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
    
    UIImageView *canAlsoIV = [[UIImageView alloc]initWithFrame:CGRectMake((Screen_Width - 132)*0.5, 0.4*Screen_Height, 132, 27)];
    canAlsoIV.image = [UIImage imageNamed:@"你还可以"];
    [self.view addSubview:canAlsoIV];
    
    for (int i= 0 ; i < 3; i ++) {
        UIButton *button = [[UIButton alloc]init];
        CGFloat btnWith = 60;
        CGFloat margin = (Screen_Width - 3*60 - 40)/2;
        [button setFrame:CGRectMake(i*(btnWith+margin)+20, CGRectGetMaxY(canAlsoIV.frame)+40, btnWith, btnWith)];
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn%d",i+4]] forState:UIControlStateNormal];
        button.tag = i+3;
        if (i == 0) {
            UILabel *label = [[UILabel alloc]init];
            label.text = @"联系法官";
            [label setFrame:CGRectMake(0, CGRectGetMaxY(button.frame)+10, Screen_Width/3, 20)];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor  = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:14];
            [self.view addSubview:label];
        }else if(i == 1)
        {
            UILabel *label = [[UILabel alloc]init];
            label.text = @"预约信访";
            [label setFrame:CGRectMake(Screen_Width/3, CGRectGetMaxY(button.frame)+10, Screen_Width/3, 20)];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor  = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:14];
            [self.view addSubview:label];
        }else if(i == 2)
        {
            UILabel *label = [[UILabel alloc]init];
            label.text = @"调阅庭审录像";
            [label setFrame:CGRectMake(2*Screen_Width/3, CGRectGetMaxY(button.frame)+10, Screen_Width/3, 20)];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor  = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:14];
            [self.view addSubview:label];
        }
        [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }

    
    
    
    
    
    UIView *bottonView = [[UIView alloc]initWithFrame:CGRectMake(0, Screen_Height - 64 - 0.15*Screen_Height, Screen_Width, 0.15*Screen_Height)];
    [self.view addSubview:bottonView];
    bottonView.backgroundColor = [UIColor whiteColor];
    
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, Screen_Width - 40, 20)];
    tipLabel.text = @"提示 ：";
    tipLabel.font = [UIFont boldSystemFontOfSize:17];
    [bottonView addSubview:tipLabel];
    
    UILabel *contentLb = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(tipLabel.frame), Screen_Width - 40, 40)];
    contentLb.text = @"点击确认拨打12368热线电话，按3，进入人工服务。";
    contentLb.numberOfLines = 0;
    contentLb.font = [UIFont systemFontOfSize:14];
    [bottonView addSubview:contentLb];

}


- (void)clickBtn:(UIButton *)btn
{
   
    if(btn.tag == 0)
    {
        NSString *number = @"12368";// 此处读入电话号码
        
        // NSString *num = [[NSString alloc] initWithFormat:@"tel://%@",number]; //number为号码字符串 如果使用这个方法 结束电话之后会进入联系人列
        
        NSString *num = [[NSString alloc] initWithFormat:@"telprompt://%@",number]; //而这个方法则打电话前先弹框  是否打电话 然后打完电话之后回到程序中 网上说这个方法可能不合法 无法通过审核
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]]; //拨号
        

    }
    if(btn.tag == 1)
    {
        //诉讼指南
        ZYSSZNViewController *ssznVC = [[ZYSSZNViewController alloc]init];
        [self.navigationController pushViewController:ssznVC animated:YES];
        
        
    }
    if(btn.tag == 2)
    {
        //诉讼费用计算器
        FYWebViewController *ssfyVC = [[FYWebViewController alloc]init];
        ssfyVC.Title = @"诉讼费用计算器";
        ssfyVC.url = [NSString stringWithFormat:@"%@/counter/counter.html",baseUrl];
        [self.navigationController pushViewController:ssfyVC animated:YES];
        
    }
    if (btn.tag == 3) {
        //联系法官
        ZYLxfgViewController *lxfgVC = [[ZYLxfgViewController alloc]init];
        [self.navigationController pushViewController:lxfgVC animated:YES];
    }
    
    if (btn.tag == 4) {
        //预约信访
        ZYYyxfViewController *yyxfVC = [[ZYYyxfViewController alloc]init];
        [self.navigationController pushViewController:yyxfVC animated:YES];
    }
    
    if (btn.tag == 5) {
        //庭审录像
        ZYYslxViewController *tszb = [[ZYYslxViewController alloc]init];
        [self.navigationController pushViewController:tszb animated:YES];
    }
}

@end
