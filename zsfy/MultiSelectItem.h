//
//  MultiSelectItem.h
//  UC_Demo_1.0.0
//
//  Created by Barry on 15/5/11.
//  Copyright (c) 2015年 Barry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MultiSelectItem : NSObject

@property (nonatomic, strong) NSURL    *imageURL;//图片地址
@property (nonatomic, copy  ) NSString *name;//名字
@property (nonatomic, assign) BOOL     disabled;//是否不让选择
@property (nonatomic, assign) BOOL     selected;//是否已经被选择

@property (nonatomic, strong) UIImage  * placeHolderImage;//占位图

@property (nonatomic, copy  ) NSString * userId; 

@end
