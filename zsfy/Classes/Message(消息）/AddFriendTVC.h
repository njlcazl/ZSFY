//
//  AddFriendTVC.h
//  zsfy
//
//  Created by 曾祺植 on 11/23/15.
//  Copyright © 2015 wzy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QueryFriendModel;

@interface AddFriendTVC : UITableViewCell

@property (nonatomic, strong) QueryFriendModel *QueryInfo;

- (void)setInfo;

@end
