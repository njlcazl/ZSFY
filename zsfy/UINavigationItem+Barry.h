//
//  UINavigationItem+Barry.h
//  UC_Demo_1.0.0
//
//  Created by Barry on 15/5/5.
//  Copyright (c) 2015年 Barry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationItem (Barry)

//- (void)setLeftBarButtonItem:(UIBarButtonItem *)_leftBarButtonItem;
//- (void)setRightBarButtonItem:(UIBarButtonItem *)_rightBarButtonItem;


- (void)setCustomLeftBarButtonItem:(UIBarButtonItem *) leftBarButtonItem;
- (void)setCustomRightBarButtonItem:(UIBarButtonItem *) rightBarButtonItem;

@end
