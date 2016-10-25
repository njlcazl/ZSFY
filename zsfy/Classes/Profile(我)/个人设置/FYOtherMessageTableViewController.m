//
//  FYOtherMessageTableViewController.m
//  zsfy
//
//  Created by pyj on 15/11/17.
//  Copyright (c) 2015年 wzy. All rights reserved.
//

#import "FYOtherMessageTableViewController.h"

@interface FYOtherMessageTableViewController ()
{
    
}
@property (strong, nonatomic) RETableViewManager *manager;
@property (strong, nonatomic) RETableViewSection *basicControlsSection;
/** 证件类型*/
@property (strong, nonatomic) REPickerItem *pickerType;
/** 证件号*/
@property (strong, nonatomic) RETextItem *cardNum;
/** 性别*/
@property (strong, readwrite, nonatomic) RESegmentedItem *segmentItem;
/** 年龄*/
@property (strong, nonatomic) RETextItem *age;

@property (strong,nonatomic)NSString *saveType;
@property (strong,nonatomic)NSString *saveSegment;

@end

@implementation FYOtherMessageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"详细信息";
    self.view.backgroundColor = FYColor(233, 233, 240);
    
    // Create manager
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView delegate:self];
    self.manager.style.backgroundImageMargin = 10.0;
    self.manager.style.cellHeight = 42.0;
    self.basicControlsSection = [self addBasicControls];
    
    //创建右侧按钮
    [self createRightBtn];

    
    self.tableView.tableFooterView = [self footView];
    
}
#pragma mark 创建右侧按钮
- (void)createRightBtn
{
    self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem  alloc]initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(clickButtonItem)];
}

- (void)clickButtonItem
{
    if ([NSString isBlankString:self.cardNum.value]) {
        NSLog(@"证件号码：%@",self.cardNum.value);
        [MBProgressHUD showError:@"证件号不能为空"];
    }else if ([NSString isBlankString:self.age.value])
    {
        [MBProgressHUD showError:@"年龄不能为空"];
    }else
    {
        if ([NSString isBlankString:self.saveType]) {
            self.saveType = @"1";
        }
        if ([NSString isBlankString:self.saveSegment])
        {
            self.saveSegment = @"1";
        }
        NSLog(@"证件类型:%@ 性别:%@" , self.saveType , self.saveSegment);
        [self OtherMessageRequest];
    }
    
}
- (void)OtherMessageRequest
{
    [MBProgressHUD showMessage:@""];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token =  [defaults objectForKey:@"token"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"token"] = token;
    params[@"idType"] = self.saveType;
    params[@"idNumber"] = self.cardNum.value;
    params[@"gender"] = self.saveSegment;
    params[@"age"] = self.age.value;

    

    NSLog(@"请求参数:%@",params);
    [FSHttpTool post:@"app/userInfo!updateOtherInfoAjax.action" params:params success:^(id json) {
        [MBProgressHUD hideHUD];
        NSDictionary *result = (NSDictionary *)json;
        if([[result objectForKey:@"status"] intValue] == 1)
        {
            NSString *message = [result objectForKey:@"message"];
            [MBProgressHUD showError:message];
        }else
        {
            [MBProgressHUD showSuccess:@"用户信息保存成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        NSLog(@"错误信息%@",error);
    }];
    
}


#pragma mark Basic Controls
- (RETableViewSection *)addBasicControls
{
    
    RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@""];
    [self.manager addSection:section];
    
    //注册类型
    NSString *idTypeStrs;
    if(_idTypeH == 1)
    {
        idTypeStrs = @"身份证";
    }
    else if (_idTypeH == 2)
    {
        idTypeStrs = @"军官证";
    }
    else if (_idTypeH == 3)
    {
        idTypeStrs = @"护照";
    }
    else if (_idTypeH == 4)
    {
        idTypeStrs = @"其他";
    }
    
    self.pickerType = [REPickerItem itemWithTitle:@"证件类型" value:@[idTypeStrs] placeholder:nil options:@[@[@"身份证", @"军官证",@"护照",@"其他"]]];
//    self.pickerType = [REPickerItem itemWithTitle:@"证件类型" value:@[@"身份证"] placeholder:nil options:@[@[@"身份证", @"军官证",@"护照",@"其他"]]];
    __weak typeof(self)weakSelf = self;
    self.pickerType.onChange = ^(REPickerItem *item){
        NSLog(@"Value: %@", item.value);
        if ([item.value[0] isEqualToString:@"身份证"]) {
            weakSelf.saveType = @"1";
        }else if([item.value[0] isEqualToString:@"军官证"]) {
            weakSelf.saveType = @"2";
        }else if([item.value[0] isEqualToString:@"护照"]) {
            weakSelf.saveType = @"3";
        }else if([item.value[0] isEqualToString:@"其他"]) {
            weakSelf.saveType = @"4";
        }
    };
//    // Use inline picker in iOS 7
    self.pickerType.inlinePicker = YES;
    [section addItem:self.pickerType];

    //证件号
    if(_idCardH != nil)
    {
        self.cardNum = [RETextItem itemWithTitle:@"证件号" value:_idCardH placeholder:nil];
    }
    else
    {
        self.cardNum = [RETextItem itemWithTitle:@"证件号" value:nil placeholder:@"证件号"];
    }
    
    self.cardNum.keyboardType = UIKeyboardTypeNumberPad;
    [section addItem:self.cardNum];
    
    
    self.segmentItem = [RESegmentedItem itemWithTitle:@"性别" segmentedControlTitles:@[@"男", @"女"] value:_sexH switchValueChangeHandler:^(RESegmentedItem *item) {
        NSLog(@"Value: %li", (long)item.value);
        
        weakSelf.saveSegment = [NSString stringWithFormat:@"%ld",(long)item.value];
    }];
    [section addItem:self.segmentItem];

    //年龄
    if(_ageH > 0)
    {
        self.age = [RETextItem itemWithTitle:@"年龄" value:[NSString stringWithFormat:@"%d",_ageH] placeholder:nil];
    }
    else
    {
        self.age = [RETextItem itemWithTitle:@"年龄" value:nil placeholder:@"输入年龄"];
    }
   
    self.age.keyboardType = UIKeyboardTypeNumberPad;
    [section addItem:self.age];
    
    
    
    return section;
}


- (UIView *)footView
{
   UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Height, 100)];
    view.backgroundColor = FYColor(233, 233, 240);
    return view;
}




@end
