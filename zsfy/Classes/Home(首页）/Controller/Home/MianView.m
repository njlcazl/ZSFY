//
//  MianView.m
//  MyDemos
//
//  Created by Apple on 16/1/29.
//  Copyright © 2016年 DJS. All rights reserved.
//

#import "MianView.h"
//设备屏幕的高度、宽度
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
//首页banner图的宽高比例

@implementation MianView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self createUI];
    }
    return self;
}


- (void)createUI
{
    //表格
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_collectionView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
