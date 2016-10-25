//
//  RegistViewController.h
//  zsfy
//
//  Created by pyj on 15/11/11.
//  Copyright (c) 2015年 wzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RETableViewManager.h"
#import "RETableViewOptionsController.h"
@interface RegistViewController : UITableViewController<RETableViewManagerDelegate>
@property (strong, readonly, nonatomic) RETableViewSection *accessoriesSection;
@end
