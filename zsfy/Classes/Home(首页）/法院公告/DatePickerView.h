//
//  TZDatePickerView.h
//  ZM_MiniSupply
//
//  Created by 谭真 on 15/11/21.
//  Copyright © 2015年 上海千叶网络科技有限公司. All rights reserved.
//  时间选择器（开始时间和结束时间）

#import <UIKit/UIKit.h>


typedef void (^senderBlock)(id);


@interface DatePickerView : UIView

@property (nonatomic,copy) senderBlock btBlock;

/** 显示 */
- (void)show;
/** 隐藏 */
- (void)hide;

//返回选择的时间
@property (nonatomic, copy) void(^gotoSrceenOrderBlock)(NSString *);

- (void)setDatePicker:(UIDatePicker *)datePicker withString:(NSString *)str;

@end
