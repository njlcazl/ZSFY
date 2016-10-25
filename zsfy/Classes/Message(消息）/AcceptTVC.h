//
//  AcceptTVC.h
//  zsfy
//
//  Created by 曾祺植 on 11/30/15.
//  Copyright © 2015 wzy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AcceptTVC;

@protocol AcceptCellDelegate<NSObject>

// 通知cell被点击，执行删除操作
- (void) SwitchTouched:(AcceptTVC *)unitCell;

@end

@interface AcceptTVC : UITableViewCell

@property (nonatomic, assign) id<AcceptCellDelegate>delegate;

@property (nonatomic, strong) NSString *targetId;
@property (assign) int type;

- (void)setInfo:(NSString *)textInfo Type:(int)type;
- (void)setEnable:(BOOL)flag;
- (BOOL)getState;
- (void)setOn;
- (void)setOff;

@end
