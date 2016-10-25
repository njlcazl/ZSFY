//
//  MultiSelectViewController.h
//  UC_Demo_1.0.0
//
//  Created by Barry on 15/5/11.
//  Copyright (c) 2015年 Barry. All rights reserved.
//

#import "BaseViewController.h"

typedef enum {
    UCSelectTypeCreate,
    UCSelectTypeAdd,
} UCSelectType;  // 类型，是创建群，还是添加成员

@interface MultiSelectViewController : BaseViewController

@property (nonatomic, strong) NSArray *items;

- (instancetype)initWithType:(UCSelectType)type targetId:(NSString *) targetId;

@end
