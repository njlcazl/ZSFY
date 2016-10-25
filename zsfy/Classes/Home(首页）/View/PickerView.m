//
//  PickerView.m
//  zsfy
//
//  Created by tiannuo on 15/11/12.
//  Copyright (c) 2015年 wzy. All rights reserved.
//

#import "PickerView.h"

@implementation PickerView

@synthesize delegate,btnFinish,picker;

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initCapacity];
    }
    
    return self;
}

-(void)initCapacity
{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 40)];
    v.backgroundColor = [CTB colorWithHexString:@"EFEFEF"];
    [self addSubview:v];
    
    btnFinish = [CTB buttonType:UIButtonTypeCustom delegate:self to:v tag:1 title:@"完成" img:@""];
    btnFinish.frame = CGRectMake(Screen_Width-50, 0, 40, 40);
    [btnFinish setTitleColor:[CTB colorWithHexString:@"2662C5"] forState:UIControlStateNormal];
    btnFinish.titleLabel.font = [UIFont systemFontOfSize:15];
    
    picker  =[[UIPickerView alloc] initWithFrame:GetRect(0, 40, Screen_Width, self.frame.size.height-40)];
    picker.backgroundColor = [CTB colorWithHexString:@"C9CED1"];
    [self addSubview:picker];
}

-(void)ButtonEvents:(UIButton *)button
{
    if ([delegate respondsToSelector:select(ButtonEvents:)]) {
        [delegate ButtonEvents:button];
    }
}

@end
