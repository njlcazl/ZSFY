//
//  MultiSelectTableViewCell.h
//  UC_Demo_1.0.0
//
//  Created by Barry on 15/5/11.
//  Copyright (c) 2015年 Barry. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, MultiSelectTableViewSelectState) {
    MultiSelectTableViewSelectStateNoSelected = 0,
    MultiSelectTableViewSelectStateSelected,
    MultiSelectTableViewSelectStateDisabled,
};

@interface MultiSelectTableViewCell : UITableViewCell


@property (strong, nonatomic) UIImageView *cellImageView;//头像

@property (strong, nonatomic) UILabel     *label;//名字

@property (strong, nonatomic) UILabel     *phoneLabel;

@property (strong, nonatomic) UILabel     *testLabel;//显示测试账号的label


@property (nonatomic, assign) MultiSelectTableViewSelectState selectState;


@end
