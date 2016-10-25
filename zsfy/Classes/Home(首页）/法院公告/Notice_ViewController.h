//
//  Notice_ViewController.h
//  zsfy
//
//  Created by eshore_it on 15-11-14.
//  Copyright (c) 2015年 wzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Notice_ViewController : UIViewController

//返回选择的时间
@property (nonatomic, copy) void(^goBackBlock)(NSString *);

@end
