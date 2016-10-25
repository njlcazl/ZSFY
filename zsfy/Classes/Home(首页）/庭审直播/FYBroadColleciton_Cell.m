//
//  FYBroadColleciton_Cell.m
//  zsfy
//
//  Created by pyj on 15/11/16.
//  Copyright (c) 2015年 wzy. All rights reserved.
//

#import "FYBroadColleciton_Cell.h"

#define CellWidth self.frame.size.width
#define CellHeight self.frame.size.height

@interface FYBroadColleciton_Cell()
/** 图片*/
@property(nonatomic, strong) UIImageView *videoImg;
/** 案件类别 */
 @property(nonatomic, strong) UILabel *ajlbLb;
/** 标题*/
@property(nonatomic, strong) UILabel *titleLb;
/** 内容*/
@property(nonatomic, strong) UILabel *textLb;

@end
@implementation FYBroadColleciton_Cell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //创建视频页面
        [self createCollectionView];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)createCollectionView
{
    self.videoImg = [[UIImageView alloc]init];
    self.videoImg.image = [UIImage imageNamed:@"video_2"];
    [self.videoImg setFrame:CGRectMake(0, 0, CellWidth, CellHeight * 0.55)];
    [self addSubview:self.videoImg];
    
    UIView *speView = [[UIView alloc]initWithFrame:CGRectMake(0, self.videoImg.height - 20, self.videoImg.width, 20)];
    speView.backgroundColor = [UIColor blackColor];
    speView.alpha = 0.3;
    [self.videoImg addSubview:speView];
    
    self.ajlbLb  = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, speView.width, speView.height)];
    self.ajlbLb.font = [UIFont systemFontOfSize:12];
    self.ajlbLb.textColor = [UIColor whiteColor];
    self.ajlbLb.text = @"";
    [speView addSubview:self.ajlbLb];
    
    
    self.titleLb = [[UILabel alloc]initWithFrame:CGRectMake(10, GetMaxY(self.videoImg.frame)+5, CellWidth-10, 20)];
    self.titleLb.textAlignment = NSTextAlignmentLeft;
    self.titleLb.text = @"暂无回顾";
    self.titleLb.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.titleLb];
    
    self.textLb = [[UILabel alloc]initWithFrame:CGRectMake(10, GetMaxY(self.titleLb.frame)+5, CellWidth*0.7, 30)];
    self.textLb.numberOfLines = 0;
    self.textLb.textAlignment = NSTextAlignmentLeft;
    self.textLb.font = [UIFont systemFontOfSize:12];
    self.textLb.text = @"";
    [self addSubview:self.textLb];

    
}

- (void)setAttach:(Attach *)attach
{
    _attach = attach;
    [self.videoImg sd_setImageWithURL:[NSURL URLWithString:attach.image]];
    self.ajlbLb.text = attach.ajlb;
    self.titleLb.text = attach.name;
    self.textLb.text = attach.ah;
    
}

@end
