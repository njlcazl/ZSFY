//
//  DatePickerView1.h
//  zsfy
//
//  Created by Apple on 16/2/26.
//  Copyright © 2016年 wzy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^senderBlock)(id);

@interface DatePickerView1 : UIView

@property (nonatomic,copy) senderBlock btBlock;

/** 显示 */
- (void)show;
/** 隐藏 */
- (void)hide;

//返回选择的时间
@property (nonatomic, copy) void(^gotoSrceenOrderBlock)(NSString *);

- (void)setDatePicker:(UIDatePicker *)datePicker withString:(NSString *)str;

@end
