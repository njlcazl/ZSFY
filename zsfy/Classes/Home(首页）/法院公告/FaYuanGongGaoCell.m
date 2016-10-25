//
//  FaYuanGongGaoCell.m
//  zsfy
//
//  Created by Apple on 16/2/26.
//  Copyright © 2016年 wzy. All rights reserved.
//

#import "FaYuanGongGaoCell.h"

@implementation FaYuanGongGaoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initWithFrameView];
    }
    return self;
    
}

- (void)initWithFrameView
{
    self.lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, Screen_Width-20, 44)];
    self.lblTitle.numberOfLines = 0;
    [self addSubview:self.lblTitle];
    
    self.lblTime = [[UILabel alloc]initWithFrame:CGRectMake(10, 54, Screen_Width-20, 20)];
    self.lblTime.font = [UIFont systemFontOfSize:12];
    self.lblTime.textAlignment = NSTextAlignmentRight;
    self.lblTime.textColor = [UIColor grayColor];
    [self addSubview:self.lblTime];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
