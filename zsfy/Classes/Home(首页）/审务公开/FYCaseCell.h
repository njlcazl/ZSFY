//
//  FYCaseCell.h
//  zsfy
//
//  Created by eshore_it on 15-11-24.
//  Copyright (c) 2015年 wzy. All rights reserved.
//

#import "FYTableViewCell.h"

@interface FYCaseCell : FYTableViewCell
@property(nonatomic,strong) NSString *title;//标题
@property(nonatomic,strong) NSString *time;//时间

@property(nonatomic,strong) UILabel *lblTitle;//标题
@property(nonatomic,strong) UILabel *lblTime;//时间

@end
