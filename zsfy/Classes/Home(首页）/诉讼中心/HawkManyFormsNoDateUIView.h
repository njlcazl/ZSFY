//
//  HawkManyFormsUIView.h
//  zsfy
//
//  Created by QYQ-Hawk on 15/12/6.
//  Copyright © 2015年 wzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWTextView.h"
#import "HawkPickerView.h"


typedef void(^SubmitBlock)(NSMutableDictionary * allDetailDic);

@interface HawkManyFormsNoDateUIView : UIView

// SubView_Type =  SubView_Type_Normal 第一种请求 
- (id)initWithFrame:(CGRect)frame withType:(SubView_Type)type withNav:(UINavigationController *)nav submitBlock:(SubmitBlock)block;


/** 姓名部分 */
@property (strong, nonatomic) UITextField *nameItem;
/** 手机号码部分 */
@property (strong, nonatomic) UITextField *phoneNumItem;
/** 性别部分 */
@property (strong, nonatomic) UISegmentedControl *sexItem;
/** 职业部分 */
@property (strong, nonatomic) UITextField *jobItem;
/** 单位部分 */
@property (strong, nonatomic) UITextField *workItem;
/** 地址部分 */
@property (strong, nonatomic) UITextField *addressItem;
/** 固话部分 */
@property (strong, nonatomic) UITextField *callItem;
/** 证件部分 */
@property (strong, nonatomic) UITextField *cardItem;
/** 邮箱部分 */
@property (strong, nonatomic) UITextField *emailItem;
/** 与案关系 */
@property (strong, nonatomic) HawkPickerView *pickerType;
/** 写出您的建议*/
@property (strong, nonatomic) HWTextView *longTextItem;
/** 日期    */
@property (strong, nonatomic) UIDatePicker * datePicker1;
/** 角色类型*/
@property NSInteger itemSel;
/** 案件年号*/
@property (strong, nonatomic) UITextField *caseYear;
/** 发条*/
@property (strong, nonatomic) NSString *lowItem;
/** 案件字号*/
@property (strong, nonatomic) UITextField *caseTextItem;
/** 案件编号*/
@property (strong, nonatomic) UITextField *caseNumItem;

- (void)resetAll;

@end
