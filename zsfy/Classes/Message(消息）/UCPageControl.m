//
//  UCPageControl.m
//  UC_Demo_1.0.0
//
//  Created by Barry on 15/5/7.
//  Copyright (c) 2015年 Barry. All rights reserved.
//

#import "UCPageControl.h"


@interface UCPageControl(private)  // 声明一个私有方法, 该方法不允许对象直接使用

- (void)updateDots;
@end
@implementation UCPageControl  // 实现部分
@synthesize imagePageStateNormal;
@synthesize imagePageStateHighlighted;
- (id)initWithFrame:(CGRect)frame { // 初始化
    self = [super initWithFrame:frame];
    self.currentPageIndicatorTintColor = [UIColor clearColor];
    self.pageIndicatorTintColor = [UIColor clearColor];
    return self;
}
- (void)setImagePageStateNormal:(UIImage *)image {  // 设置正常状态点按钮的图片
    imagePageStateNormal = image;
//    [self updateDots];
}
- (void)setImagePageStateHighlighted:(UIImage *)image { // 设置高亮状态点按钮图片
    imagePageStateHighlighted = image;
    [self updateDots];
}
- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event { // 点击事件
    [super endTrackingWithTouch:touch withEvent:event];
    [self updateDots];
}
- (void)updateDots { // 更新显示所有的点按钮
    

    if (imagePageStateNormal || imagePageStateHighlighted)
    {
        NSArray *subview = self.subviews;  // 获取所有子视图
        for (NSInteger i = 0; i < [subview count]; i++)
        {
            UIView *dot = [subview objectAtIndex:i];  
            dot.backgroundColor = [UIColor clearColor];
            UIImageView * imgView = [[UIImageView alloc] initWithFrame:dot.bounds];
            [dot addSubview:imgView];
            imgView.contentMode = UIViewContentModeScaleAspectFit;
            imgView.image = self.currentPage == i ? imagePageStateNormal : imagePageStateHighlighted;
            
        }
    }
}

@end