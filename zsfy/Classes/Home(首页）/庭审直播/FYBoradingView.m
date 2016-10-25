//
//  FYBoradingView.m
//  zsfy
//
//  Created by pyj on 15/11/18.
//  Copyright (c) 2015年 wzy. All rights reserved.
//

#import "FYBoradingView.h"
#define bgViewHight 100
@interface FYBoradingView()
/** 案件名称 */
@property (nonatomic,strong)UILabel *nameLb;
/** 案号 */
@property (nonatomic,strong)UILabel *ahLb;
/** 审理法院 */
@property (nonatomic,strong)UILabel *slfyLb;
/** 主审法官 */
@property (nonatomic,strong)UILabel *zsfgLb;
/** 开庭时间 */
@property (nonatomic,strong)UILabel *ktsjLb;
/** 开庭地点 */
@property (nonatomic,strong)UILabel *ktddLb;


@end


@implementation FYBoradingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    
    return self;
}


- (void)createView
{
   UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(14,0,Screen_Width - 28 , bgViewHight)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 4.0f;
    
    self.nameLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, bgView.width - 20, bgViewHight/6)];
    self.nameLb.text = @"案件名称：";
    self.nameLb.font = [UIFont systemFontOfSize:11];
    [bgView addSubview:self.nameLb];
    
    self.ahLb = [[UILabel alloc]initWithFrame:CGRectMake(10, bgViewHight/6, bgView.width - 20, bgViewHight/6)];
    self.ahLb.text = @"案件号：";
    self.ahLb.font = [UIFont systemFontOfSize:11];
    [bgView addSubview:self.ahLb];
    
    self.slfyLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 2*bgViewHight/6, bgView.width - 20, bgViewHight/6)];
    self.slfyLb.text = @"审理法院：";
    self.slfyLb.font = [UIFont systemFontOfSize:11];
    [bgView addSubview:self.slfyLb];
    
    self.zsfgLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 3*bgViewHight/6, bgView.width - 20, bgViewHight/6)];
    self.zsfgLb.text = @"主审法官：";
    self.zsfgLb.font = [UIFont systemFontOfSize:11];
    [bgView addSubview:self.zsfgLb];
    
    self.ktsjLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 4*bgViewHight/6, bgView.width - 20, bgViewHight/6)];
    self.ktsjLb.text = @"开庭时间：";
    self.ktsjLb.font = [UIFont systemFontOfSize:11];
    [bgView addSubview:self.ktsjLb];
    
    self.ktddLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 5*bgViewHight/6, bgView.width - 20, bgViewHight/6)];
    self.ktddLb.text = @"开庭地点：";
    self.ktddLb.font = [UIFont systemFontOfSize:11];
    [bgView addSubview:self.ktddLb];
    
    
    
    
    [self addSubview:bgView];
}

- (void)setAttach:(Attach *)attach
{
    _attach = attach;
    self.nameLb.text = [NSString stringWithFormat:@"案件名称：%@",attach.name];
    self.ahLb.text =[NSString stringWithFormat:@"案件号：%@",attach.ah];
    self.slfyLb.text =[NSString stringWithFormat: @"审理法院：%@",attach.slfy];
    self.zsfgLb.text =[NSString stringWithFormat:@"主审法官：%@",attach.zsfg] ;
    self.ktsjLb.text = [NSString stringWithFormat:@"开庭时间：%@",attach.ktsj];
    self.ktddLb.text =[NSString stringWithFormat:@"开庭地点：%@",attach.ktdd];
    
}
@end
