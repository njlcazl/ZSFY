//
//  ContactTVC.h
//  zsfy
//
//  Created by 曾祺植 on 11/18/15.
//  Copyright © 2015 wzy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FriendModel;

@interface ContactTVC : UITableViewCell

- (void)HideBadgeView;
- (void)setInfo1:(NSString *)ApplyCount;
- (void)setInfo2:(NSString *)ApplyCount Word:(NSString *)word Image:(UIImage *)image;
- (void)setInfo3:(FriendModel *)item;

@end
