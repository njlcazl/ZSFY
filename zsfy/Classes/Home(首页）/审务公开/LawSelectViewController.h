//
//  LawSelectViewController.h
//  zsfy
//
//  Created by eshore_it on 15-12-2.
//  Copyright (c) 2015年 wzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LawSelectViewController : UITableViewController

@property (nonatomic,strong)void(^selLow)(void);

@property (assign) int year;

@end
