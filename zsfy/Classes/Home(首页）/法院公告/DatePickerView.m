//
//  TZDatePickerView.m
//  ZM_MiniSupply
//
//  Created by 谭真 on 15/11/21.
//  Copyright © 2015年 上海千叶网络科技有限公司. All rights reserved.
//  时间选择器（开始时间和结束时间）

/* 写该控件时的应用场景是：用户选择起始时间去筛选订单，故一些命名与筛选订单有关 */

#import "DatePickerView.h"

#define mScreenWidth   ([UIScreen mainScreen].bounds.size.width)
#define mScreenHeight  ([UIScreen mainScreen].bounds.size.height)
#define mBlueColor [UIColor colorWithRed:50.0/255.0 green:162.0/255.0 blue:248.0/255.0 alpha:1.0]
#define mGrayColor [UIColor colorWithRed:165/255.0 green:165/255.0 blue:165/255.0 alpha:1.0]

@interface DatePickerView ()
@property (nonatomic, strong) UIView *bgView;

/** datePicker */
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
/** 时间格式转换器 */
@property (nonatomic, strong) NSDateFormatter *formatter;
/** 去筛选订单按钮 */
//@property (weak, nonatomic) IBOutlet UIButton *okBtnToSrceenOrder;

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;


@end

@implementation DatePickerView

#pragma mark 配置视图


- (void)setDatePicker:(UIDatePicker *)datePicker withString:(NSString *)str
{
    [self.datePicker setDate:[self.formatter dateFromString:str] animated:YES];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"DatePickerView" owner:self options:nil] lastObject];
        // 初始化设置
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        self.frame = CGRectMake(0, mScreenHeight, mScreenWidth, 280);
        [window addSubview:self.bgView];
        [window addSubview:self];
    }
    return self;
}


- (UIView *)bgView {
    if (_bgView == nil) {
        _bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        _bgView.hidden = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        [_bgView addGestureRecognizer:tap];
    }
    return _bgView;
}

- (void)awakeFromNib {
    // 设置时间格式转换器
    self.formatter = [[NSDateFormatter alloc] init];
    self.formatter.dateFormat = @"yyyy-MM-dd";
   
    // 配置DatePicker
//    self.datePicker.maximumDate = [NSDate date];
    CGRect newFrame = self.datePicker.frame;
    newFrame.size.width = Screen_Width;
    self.datePicker.frame = newFrame;
}

/** 选择时间 */
- (IBAction)beginDateBtnClick:(id)sender
{
    [self hide];
    
    if(self.btBlock)
    {
        self.btBlock([self.formatter stringFromDate:self.datePicker.date]);
    }
//    if (self.gotoSrceenOrderBlock) {
//        self.gotoSrceenOrderBlock([self.formatter stringFromDate:self.datePicker.date]);
//    }
}


/** 显示 */
- (void)show {
    [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.bgView.hidden = NO;
        
        CGRect newFrame = self.frame;
        newFrame.origin.y = mScreenHeight - self.frame.size.height;
        self.frame = newFrame;
    } completion:nil];
}

/** 隐藏 */
- (void)hide {
    [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:0 animations:^{
        self.bgView.hidden = YES;
        
        CGRect newFrame = self.frame;
        newFrame.origin.y = mScreenHeight;
        self.frame = newFrame;
    } completion:nil];
}


/** 用颜色生成一张图片 */
- (UIImage *)createImageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
