//
//  FYZSTableViewController.h
//  zsfy
//
//  Created by eshore_it on 15-11-24.
//  Copyright (c) 2015年 wzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FYZSTableViewController : UIViewController
@property (nonatomic,strong)NSString *Title;
@property (nonatomic,strong)NSString *zsId;

@property (nonatomic,assign) NSInteger tags;

@property (nonatomic,strong) UITableView *tableView;


@property (nonatomic,assign) NSInteger selects;

@end
