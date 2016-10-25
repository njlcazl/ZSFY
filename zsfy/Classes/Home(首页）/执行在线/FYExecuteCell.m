//
//  FYExecuteCell.m
//  zsfy
//
//  Created by eshore_it on 15-11-24.
//  Copyright (c) 2015年 wzy. All rights reserved.
//

#import "FYExecuteCell.h"
@interface FYExecuteCell()

@end

@implementation FYExecuteCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initWithView];
    }
    return self;
    
}

- (void)initWithView
{
    
//    self.lblTitle = [[UILabel alloc]initWithFrame:CGRectZero];
    self.lblTitle = [[UILabel alloc]init];
    self.lblTitle.numberOfLines = 0;
    [self addSubview:self.lblTitle];
    
    self.lblTime = [[UILabel alloc]init];
//    self.lblTime = [[UILabel alloc]initWithFrame:CGRectZero];
    self.lblTime.font = [UIFont systemFontOfSize:12];
    self.lblTime.textAlignment = NSTextAlignmentRight;
    self.lblTime.textColor = [UIColor grayColor];
    [self addSubview:self.lblTime];
}

- (void)setTitle:(NSString *)Title
{
    _Title = Title;
    self.lblTitle.text = Title;
}
- (void)setTime:(NSString *)Time
{
    _Time = Time;
    self.lblTime.text = Time;
}


@end
