//
//  Questionnaire_ViewController.m
//  zsfy
//
//  Created by tiannuo on 15/11/11.
//  Copyright (c) 2015年 wzy. All rights reserved.
//

#import "Questionnaire_ViewController.h"
#import "CTB.h"
#import "PickerView.h"

@interface Questionnaire_ViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSMutableArray *listPicker;
    PickerView *picker;
    NSString *strBtn;//按钮标示
    UILabel *lblType;//穗中法
    UILabel *lblWord;//穗中法大概
    NSString *strPicker;
}

@end

@implementation Questionnaire_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"网上阅卷";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initWithView];
}

-(void)initWithView
{
    listPicker = [NSMutableArray arrayWithObjects:@"水电费",@"娃儿",@"阿强",@"恢诡谲怪",@"阿哥",@"阿德萨",@"我而然的",@"转正",@"过任务",@"小鳄龟",@"瑞特", nil];
    
    UIScrollView *ScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    ScrollView.showsHorizontalScrollIndicator = NO;
    // 设置UIScrollView的滚动范围（内容大小）
    ScrollView.bounces = YES;
    [self.view addSubview:ScrollView];
    
    //案件号
    UILabel *lblNumber = [CTB labelTag:1 toView:ScrollView text:@"  案件号" wordSize:15];
    lblNumber.backgroundColor = [CTB colorWithHexString:@"EAEAEA"];
    lblNumber.frame = CGRectMake(-1, -1, Screen_Width+2, 41);
    lblNumber.textColor = [CTB colorWithHexString:@"60070E"];
    
    UITextField *txtYear = [CTB textFieldTag:1 holderTxt:@"年" V:ScrollView delegate:self];
    txtYear.font = [UIFont systemFontOfSize:13];
    txtYear.textAlignment = NSTextAlignmentRight;
    txtYear.frame = CGRectMake(10, GetVMaxY(lblNumber), Screen_Width-20, 35);
    
    UIView *vType = [[UIView alloc] initWithFrame:CGRectMake(-1, GetVMaxY(txtYear), Screen_Width+2, 40)];
    [ScrollView addSubview:vType];
    
    UIImageView *imgType = [[UIImageView alloc] initWithFrame:CGRectMake(Screen_Width-20, 5, 15, 30)];
    imgType.backgroundColor = [UIColor yellowColor];
    [vType addSubview:imgType];
    
    UIButton *btnType = [CTB buttonType:UIButtonTypeCustom delegate:self to:vType tag:1 title:@"" img:@""];
    btnType.frame = CGRectMake(Screen_Width-80, 5, 60, 30);
    btnType.layer.cornerRadius = 3;
    btnType.layer.masksToBounds = YES;
    
    lblType = [CTB labelTag:1 toView:btnType text:@"穗中法" wordSize:13];
    lblType.textAlignment = NSTextAlignmentCenter;
    lblType.frame = CGRectMake(0, 0, 45, 30);
    
    UIImageView *imgArrow = [[UIImageView alloc] initWithFrame:CGRectMake(45, 0, 15, 30)];
    imgArrow.backgroundColor = [CTB colorWithHexString:@"0D0D0D"];
    [btnType addSubview:imgArrow];
    
    UIView *vWord = [[UIView alloc] initWithFrame:CGRectMake(-1, GetVMaxY(vType), Screen_Width+2, 40)];
    [ScrollView addSubview:vWord];
    
    UIImageView *imgWord = [[UIImageView alloc] initWithFrame:CGRectMake(Screen_Width-20, 5, 15, 30)];
    imgWord.backgroundColor = [UIColor orangeColor];
    [vWord addSubview:imgWord];
    
    UIButton *btnWord = [CTB buttonType:UIButtonTypeCustom delegate:self to:vWord tag:2 title:@"" img:@""];
    btnWord.frame = CGRectMake(Screen_Width-110, 5, 90, 30);
    btnWord.layer.cornerRadius = 3;
    btnWord.layer.masksToBounds = YES;
    
    lblWord = [CTB labelTag:1 toView:btnWord text:@"穗中法大概" wordSize:13];
    lblWord.textAlignment = NSTextAlignmentCenter;
    lblWord.frame = CGRectMake(0, 0, 75, 30);
    
    UIImageView *imgArrow1 = [[UIImageView alloc] initWithFrame:CGRectMake(75, 0, 15, 30)];
    imgArrow1.backgroundColor = [CTB colorWithHexString:@"0D0D0D"];
    [btnWord addSubview:imgArrow1];
    
    UIView*vNumber = [[UIView alloc] initWithFrame:CGRectMake(-1, GetVMaxY(vWord), Screen_Width+2, 40)];
    [ScrollView addSubview:vNumber];
    
    UITextField *txtNumber = [CTB textFieldTag:1 holderTxt:@"号" V:vNumber delegate:self];
    txtNumber.font = [UIFont systemFontOfSize:13];
    txtNumber.textAlignment = NSTextAlignmentRight;
    txtNumber.frame = CGRectMake(10, 0, Screen_Width-20, 40);
    
    //查询密码
    UILabel *lblPassword = [CTB labelTag:1 toView:ScrollView text:@"  查询密码" wordSize:15];
    lblPassword.frame = CGRectMake(-1, GetVMaxY(vNumber), Screen_Width+2, 40);
    lblPassword.backgroundColor = [CTB colorWithHexString:@"EAEAEA"];
    lblPassword.textColor = [CTB colorWithHexString:@"60070E"];

    UIView *vPassword = [[UIView alloc] initWithFrame:CGRectMake(-1, GetVMaxY(lblPassword), Screen_Width+2, 40)];
    [ScrollView addSubview:vPassword];
    
    UITextField *txtPassword = [CTB textFieldTag:1 holderTxt:@"● ● ● ●" V:vPassword delegate:self];
    txtPassword.font = [UIFont systemFontOfSize:13];
    txtPassword.textAlignment = NSTextAlignmentLeft;
    txtPassword.frame = CGRectMake(10, 0, Screen_Width-20, 40);
    
    //验证码
    UIView *vCode = [[UIView alloc] initWithFrame:CGRectMake(-1, GetVMaxY(vPassword)-1, Screen_Width+2, 40)];
    [ScrollView addSubview:vCode];
    
    UITextField *txtCode = [CTB textFieldTag:1 holderTxt:@"右侧验证码" V:vCode delegate:self];
    txtCode.font = [UIFont systemFontOfSize:13];
    txtCode.textAlignment = NSTextAlignmentLeft;
    txtCode.frame = CGRectMake(10, 0, Screen_Width/2-10, 40);
    
    [CTB setBorderWidth:0.3 View:lblNumber,vType,btnType,btnWord,vPassword,vCode,vNumber, nil];
    
    //提交
    UIButton *btnSubmit = [CTB buttonType:UIButtonTypeCustom delegate:self to:ScrollView tag:3 title:@"提交" img:@""];
    btnSubmit.frame = CGRectMake(30, GetVMaxY(vCode)+15, Screen_Width/2-40, 40);
    btnSubmit.backgroundColor = [CTB colorWithHexString:@"60070E"];
    [btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnSubmit.layer.cornerRadius = 3;
    
    //重置
    UIButton *btnReset = [CTB buttonType:UIButtonTypeCustom delegate:self to:ScrollView tag:4 title:@"重置" img:@""];
    btnReset.frame = CGRectMake(Screen_Width/2+10, GetVMaxY(vCode)+15, Screen_Width/2-40, 40);
    btnReset.backgroundColor = [CTB colorWithHexString:@"60070E"];
    [btnReset setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnReset.layer.cornerRadius = 3;
    
    picker = [[PickerView alloc] initWithFrame:CGRectMake(0, Screen_Height+10, Screen_Width, 200)];
    picker.btnFinish.tag = 12;
    picker.delegate = self;
    picker.picker.delegate = self;
    picker.picker.dataSource = self;
    [self.view addSubview:picker];

}

-(void)ButtonEvents:(UIButton *)button
{
    if (button.tag == 1) {
        strBtn = @"穗中法";
        [UIView animateWithDuration:0.3 animations:^{
            picker.frame = CGRectMake(0, Screen_Height-150-48-64, Screen_Width, 200);
        }];
    }else if (button.tag == 2) {
        strBtn = @"穗中法大概";
        [UIView animateWithDuration:0.3 animations:^{
            picker.frame = CGRectMake(0, Screen_Height-150-48-64, Screen_Width, 200);
        }];
    }
    else if (button.tag == 12) {
        //完成按钮
        [UIView animateWithDuration:0.3 animations:^{
            picker.frame = CGRectMake(0, Screen_Height+10, Screen_Width, 200);
        }];
        if (strPicker.length>0) {
            if ([strBtn isEqualToString:@"穗中法"]) {
                lblType.text = strPicker;
            }else{
                lblWord.text = strPicker;
            }
        }
    }
}

#pragma mark -========pickerView==========================================
// pickerView 列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// pickerView 每列个数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //    if (component == 0) {
    //        return listYear.count;
    //    }
    //    return listMonth.count;
    return [listPicker count];
}

// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    
    return Screen_Width/2-30;
}

-(NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSAttributedString *PickerStr = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",listPicker[row]]];
    return PickerStr;

}

// 返回选中的行
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //获取对应列，对应行的数据
    strPicker = [NSString stringWithFormat:@"%@",listPicker[row]];
    NSLog(@"str = %@",strPicker);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
