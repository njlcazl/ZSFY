//
//  MianView.h
//  MyDemos
//
//  Created by Apple on 16/1/29.
//  Copyright © 2016年 DJS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^senderBlock)(id);

@interface MianView : UIView

//按钮block
@property (nonatomic, copy) senderBlock btBlock;
/**
 *  banner
 */
@property (nonatomic, strong) UIImageView *bannerImgView;
/**
 *  表格
 */
@property (nonatomic, strong) UICollectionView *collectionView;
/**
 *  banner滚动视图
 */
@property (nonatomic, strong) UIScrollView *bannerScrollView;
/**
 *  banner  UIPageControl
 */
@property (nonatomic, strong) UIPageControl *pageControl;
/**
 *  定时器
 */
@property (nonatomic, strong) NSTimer *timer;


@end
