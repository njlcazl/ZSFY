//
//  LetterIndexNavigationView.h
//  UC_Demo_1.0.0
//
//  Created by Barry on 15/5/11.
//  Copyright (c) 2015年 Barry. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LetterIndexNavigationView;

@protocol LetterIndexNavigationViewDelegate <NSObject>

-(void)LetterIndexNavigationView:(LetterIndexNavigationView *)LetterIndexNavigationView didSelectIndex:(NSInteger)index;


@optional
/**
 *  开始触摸索引
 *
 *  @param tableViewIndex 触发tableViewIndexTouchesBegan对象
 */
- (void)tableViewIndexTouchesBegan:(LetterIndexNavigationView *)tableViewIndex;
/**
 *  触摸索引结束
 *
 *  @param tableViewIndex
 */
- (void)tableViewIndexTouchesEnd:(LetterIndexNavigationView *)tableViewIndex;


@end

@interface LetterIndexNavigationView : UIView

@property (nonatomic, strong) NSArray *keys; //即为sections
@property (nonatomic, weak) id<LetterIndexNavigationViewDelegate> delegate;

//如果加了搜索栏的话，加上一个搜索图标可能会比较好。如果不需要，就不用加。
//需要搜索图标显示的话，delegate返回的index要注意下。搜索图标index为0。
@property (nonatomic, assign) BOOL isNeedSearchIcon;

@end