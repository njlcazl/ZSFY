//
//  FYProfileHeadView.h
//  zsfy
//
//  Created by pyj on 15/11/10.
//  Copyright (c) 2015年 wzy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FYProfileHeadView;
@protocol ProfileHeadViewDelegate <NSObject>
- (void)ProfileHeadView:(FYProfileHeadView *)profileHeadView clickHeadViewBtn:(UIButton *)button;
@end

@interface FYProfileHeadView : UIView
@property (nonatomic,weak)id<ProfileHeadViewDelegate>delegate;
+ (UIView *)proFileHeadView;

@end
