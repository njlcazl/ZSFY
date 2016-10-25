//
//  BNMainCell.m
//  BNHrManager
//
//  Created by benniuMAC on 15/8/12.
//  Copyright (c) 2015年 BN. All rights reserved.
//

#import "BNMainCell.h"

@implementation BNMainCell

- (void)awakeFromNib {
//    self.iconImgView.frame = CGRectZero;
    
    self.iconImgView = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self addSubview:self.iconImgView];
}

@end
