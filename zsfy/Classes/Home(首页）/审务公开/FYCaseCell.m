//
//  FYCaseCell.m
//  zsfy
//
//  Created by eshore_it on 15-11-24.
//  Copyright (c) 2015年 wzy. All rights reserved.
//

#import "FYCaseCell.h"
#define CellHeight 70
@interface FYCaseCell ()


@end
@implementation FYCaseCell

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
    self.lblTitle = [[UILabel alloc]init];
    self.lblTitle.numberOfLines = 0;
    [self addSubview:self.lblTitle];
    
    self.lblTime = [[UILabel alloc]init];
    self.lblTime.font = [UIFont systemFontOfSize:12];
    self.lblTime.textAlignment = NSTextAlignmentRight;
    self.lblTime.textColor = [UIColor grayColor];
    [self addSubview:self.lblTime];

}
- (void)setTitle:(NSString *)title
{
    _title = title;
    self.lblTitle.text = title;
}
- (void)setTime:(NSString *)time
{
    _time = time;
    self.lblTime.text = time;
}

@end
