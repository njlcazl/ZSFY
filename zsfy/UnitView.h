//
//  GroupSettingsVC.m
//  ucpaas_IM
//
//  Created by 曾祺植 on 9/4/15.
//  Copyright (c) 2015 曾祺植. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UnitCell.h"
@protocol UnitViewDelegate<NSObject>

// 通知cell被点击，执行删除操作
- (void) deleteCell:(UnitCell *)unitCell;

@end

@interface UnitView : UIView


@property (nonatomic, assign) id<UnitViewDelegate>delegate;

/*
    添加一个成员
    icon：成员头像
    name：成员名字
 */
- (void) addNewUnit:(NSString *)icon withName:(NSString *)name Info:(FriendModel *)item;




@end
