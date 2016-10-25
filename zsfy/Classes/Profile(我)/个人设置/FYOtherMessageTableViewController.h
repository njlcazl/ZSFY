//
//  FYOtherMessageTableViewController.h
//  zsfy
//
//  Created by pyj on 15/11/17.
//  Copyright (c) 2015年 wzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RETableViewManager.h"
#import "RETableViewOptionsController.h"
@interface FYOtherMessageTableViewController : UITableViewController<RETableViewManagerDelegate>

@property (nonatomic,assign) int idTypeH;
@property (nonatomic,strong) NSString *idCardH;
@property (nonatomic,assign) int ageH;
@property (nonatomic,assign) int sexH;

@end
