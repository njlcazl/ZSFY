//
//  MultiSelectTableViewCell.m
//  UC_Demo_1.0.0
//
//  Created by Barry on 15/5/11.
//  Copyright (c) 2015年 Barry. All rights reserved.
//

#import "MultiSelectTableViewCell.h"

@interface MultiSelectTableViewCell()

@property (strong, nonatomic)  UIImageView *selectImageView; //选择view

@end

@implementation MultiSelectTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //头像
        _cellImageView = [[UIImageView alloc] init];
        _cellImageView.contentMode = UIViewContentModeScaleToFill;
        _cellImageView.layer.cornerRadius = 0.5 * self.cellImageView.frame.size.width;
        [self.contentView addSubview:_cellImageView];
        
        //名字
        _label = [[UILabel alloc] init];
        _label.font = [UIFont systemFontOfSize:17.0f];
        [self.contentView addSubview:_label];
        
        //电话号码
        _phoneLabel = [[UILabel alloc] init];
        _phoneLabel.textColor = [UIColor lightGrayColor];
        _phoneLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_phoneLabel];
        
        //选择view
        _selectImageView = [[UIImageView alloc] init];
        _selectImageView.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:_selectImageView];
        
        //显示测试账号的label
        _testLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_testLabel];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self reset];
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    _selectImageView.frame = CGRectMake(8, 5, 43, 45);
    _cellImageView.frame = CGRectMake(59, 5, 43, 43);
    _label.frame = CGRectMake(110, 5, 115, 21);
    _phoneLabel.frame = CGRectMake(110, 34, 164, 14);
    _testLabel.frame = CGRectMake(110, 0, 200, 55.0f);
}

- (void)reset
{
    self.selectState = MultiSelectTableViewSelectStateNoSelected;
    self.cellImageView.image = nil;
    self.label.text = @" ";
    self.phoneLabel.text = @" ";
    self.testLabel.text = @" ";
}

- (void)setSelectState:(MultiSelectTableViewSelectState)selectState
{
    _selectState = selectState;
    
    switch (selectState) {
        case MultiSelectTableViewSelectStateNoSelected:
            self.selectImageView.image = [UIImage imageNamed:@"未选中"];
            break;
        case MultiSelectTableViewSelectStateSelected:
            self.selectImageView.image = [UIImage imageNamed:@"选中"];
            break;
        case MultiSelectTableViewSelectStateDisabled:
            self.selectImageView.image = [UIImage imageNamed:@"不可选"];
            break;
        default:
            break;
    }
}

@end
