//
//  GroupSettingsVC.m
//  ucpaas_IM
//
//  Created by 曾祺植 on 9/4/15.
//  Copyright (c) 2015 曾祺植. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UnitCell;
@class FriendModel;

@protocol UnitCellDelegate<NSObject>

// 通知cell被点击，执行删除操作
- (void) unitCellTouched:(UnitCell *)unitCell;

@end

@interface UnitCell : UIButton

@property (nonatomic, assign) id<UnitCellDelegate>delegate;

@property (nonatomic, strong) NSString *icon;

// user的名称
@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) FriendModel *Info;

/*
    method：初始化函数
    frame:坐标
    icon：成员头像
    name：成员名字
 */
- (id)initWithFrame:(CGRect)frame andIcon:(NSString *)icon andName:(NSString *)name;

@end
