//
//  HawkManyFormsUIView.m
//  zsfy
//
//  Created by QYQ-Hawk on 15/12/6.
//  Copyright © 2015年 wzy. All rights reserved.
//

#import "HawkManyFormsNoDateUIView.h"
#import "FYTableViewCell.h"
#import "LawSelectViewController.h"
#import "ComUnit.h"
#import "UserDetailModel.h"
#import "MMPickerView.h"

#define QYQHEXCOLOR_ALPHA(c, a) [UIColor colorWithHexValue:c alpha:a]


@interface HawkManyFormsNoDateUIView()<UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate>{
    
    SubView_Type kType;
    
    UITableView * ajCheackTableView;
    
    UITableView * tableViewConnect;
    
    UITableView * ajCheackTableView1;
    
    UINavigationController * kNav;
    
    UIView * pickerBGView;
    
    BOOL isExpandPicker;
    
    NSInteger selectedSegmentIndex;
    
    NSString *name;
    NSString *phone;
    int sex;
    NSString *address;
    NSString *idCard;
    NSString *email;
}
/** 点击回调*/
@property (strong, nonatomic) SubmitBlock kSubmitBlock;

@property (nonatomic, strong) NSMutableArray *yearArr;

@end

@implementation HawkManyFormsNoDateUIView

- (id)initWithFrame:(CGRect)frame withType:(SubView_Type)type withNav:(UINavigationController *)nav submitBlock:(SubmitBlock)block{
    
    if (self = [super initWithFrame:frame]) {
        
        [self getUserDetailInfo];
        
        kType = type;
        
        kNav = nav;
        
        self.itemSel = 3;

        
        selectedSegmentIndex = 0;
        
        [self setupViews];
        
        self.kSubmitBlock = block;
        
        isExpandPicker = NO;
        
        return self;
    }
    return nil;
}


#pragma mark - 获取用户的详细信息
- (void)getUserDetailInfo
{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    [MBProgressHUD showMessage:@"加载中.." toView:self];
    [ComUnit getPersonInfoDetail:token success:^(id data) {
        
        if([data isKindOfClass:[NSDictionary class]])
        {
            if([data[@"status"] intValue] == 0)
            {
                NSDictionary *dic = data[@"attach"];
                UserDetailModel *userInfo = [[UserDetailModel alloc]init];
                [userInfo setValuesForKeysWithDictionary:dic];
                
                name = userInfo.userName;
                phone = userInfo.phone;
                sex = [userInfo.gender intValue];
                address = userInfo.adress;
                email = userInfo.email;
                idCard = userInfo.idNumber;
                
                NSLog(@"用户信息：%@-%@-%d-%@-%@-%@",name,phone,sex,address,email,idCard);
            }
            else
            {
                [MBProgressHUD showError:@"获取用户信息失败"];
            }
        }
        
        [MBProgressHUD hideAllHUDsForView:self animated:YES];
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"请求失败"];
    }];
}


- (void)setupViews{
    
    [self createCaseCheckView:self];
    
}

#pragma mark 案件查询
- (void)createCaseCheckView:(UIView *)view
{
    [self pickerInitData];
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height - 64)];
    bgView.backgroundColor = FYBackgroundColor;
    [view addSubview:bgView];
    ajCheackTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, Screen_Width-20, Screen_Height - 64) style:UITableViewStyleGrouped];
    
    ajCheackTableView.layer.cornerRadius = 4.0f;
    
    ajCheackTableView.delegate = self;
    
    ajCheackTableView.dataSource= self;
    
    [bgView addSubview:ajCheackTableView];
    
    ajCheackTableView.backgroundColor = FYBackgroundColor;
    
    view.backgroundColor = FYBackgroundColor;
    
    ajCheackTableView.tableFooterView = [self FootView];
}


- (UIView *)FootView
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width - 20, 64)];
    
    view.backgroundColor = FYBackgroundColor;
    
    UIButton *checkBtn = [[UIButton alloc]initWithFrame:CGRectMake(14, 10,[view width] - 28, 44)];
    
    checkBtn.layer.cornerRadius = 4.0f;
    
    [checkBtn setTitle:@"提交" forState:UIControlStateNormal];
    
    [checkBtn setBackgroundColor:FYColor(0, 111, 194)];
    
    [checkBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:checkBtn];
    
    return view;
}

#pragma mark设置每一个cell的行高（有多少行，就走多少次）
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 40;
    }
    else{
        if (isExpandPicker) {
            if (indexPath.row == 11) {
                return 120;
            }
            if(indexPath.row == 10){
                return 120;
            }
            else{
                return 40;
            }
        }
        else{
            if (indexPath.row == 10) {
                return 120;
            }
            else{
                return 40;
            }
        }
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    
    if (indexPath.section == 0) {
        static NSString *identifier = @"CheckCell";
        
        FYTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath]; //根据indexPath准确地取出一行，而不是从cell重用队列中取出
        if (cell == NULL) {
            cell = [[FYTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
            
        }
        if (indexPath.row == 0) {
            
            if (!self.caseYear) {
                self.caseYear = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, Screen_Width - 30, 40)];
                self.caseYear.text = self.yearArr[0];
                self.caseYear.delegate = self;

            }
            self.caseYear.textAlignment = NSTextAlignmentRight;
            self.caseYear.placeholder = @"案件年号";
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, Screen_Width - 20, 40) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = CGRectMake(0, 0, Screen_Width - 20, 40);
            maskLayer.path = maskPath.CGPath;
            cell.layer.mask = maskLayer;
            [cell.layer setMasksToBounds:YES];
            [cell.contentView addSubview:self.caseYear];
            
        }else if (indexPath.row == 1)
        {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *textSelect = [userDefaults objectForKey:@"lowSelect"];
            if (textSelect == nil) {
                int year = [self.caseYear.text intValue];
                if(year >= 2016) {
                    cell.detailTextLabel.text = @"粤71";
                    self.lowItem = @"粤71";
                } else {
                    cell.detailTextLabel.text = @"广铁中法";
                    self.lowItem = @"广铁中法";
                }
                cell.detailTextLabel.textColor = [UIColor blackColor];
                
            }else
            {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",textSelect];
                self.lowItem = textSelect;
                
            }
            cell.detailTextLabel.textColor = [UIColor blackColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        else if (indexPath.row == 2)
        {
            if (!self.caseTextItem) {
                self.caseTextItem = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, Screen_Width - 30, 40)];
            }
            self.caseTextItem.textAlignment = NSTextAlignmentRight;
            self.caseTextItem.placeholder = @"案件字号";
            [cell.contentView addSubview:self.caseTextItem];
            
            
        }else if (indexPath.row == 3)
        {
            if (!self.caseNumItem) {
                self.caseNumItem = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, Screen_Width - 30, 40)];
                
            }
            self.caseNumItem.textAlignment = NSTextAlignmentRight;
            self.caseNumItem.placeholder = @"案件编号";
            [cell.contentView addSubview:self.caseNumItem];
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, Screen_Width - 20, 40) byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = CGRectMake(0, 0, Screen_Width - 20, 40);
            maskLayer.path = maskPath.CGPath;
            cell.layer.mask = maskLayer;
            [cell.layer setMasksToBounds:YES];
            
            
        }
        cell.backgroundColor = [UIColor whiteColor];
        
        return cell;
    }
    else{
        static NSString *identifier = @"CheckCellBottom";
        
        FYTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath]; //根据indexPath准确地取出一行，而不是从cell重用队列中取出
        if (cell == NULL) {
            cell = [[FYTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
            
        }
        if (isExpandPicker) {
            if (indexPath.row == 0) {
                
                UILabel *ajh1 = [[UILabel alloc]initWithFrame:CGRectMake(5, 0,95 , 40)];
                
                ajh1.text = @"姓名*";
                
                ajh1.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
                
                ajh1.font = [UIFont systemFontOfSize:17];
                
                [cell.contentView addSubview:ajh1];
                
                if (!self.nameItem) {
                    self.nameItem = [[UITextField alloc]initWithFrame:CGRectMake(100, 0, Screen_Width - 130, 40)];
                    self.nameItem.text = [FYHawkCommens fetchUserInfoByKey:@"userName"];
                }

                
                self.nameItem.textAlignment = NSTextAlignmentLeft;
                
                [cell.contentView addSubview:self.nameItem];
                
                UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, Screen_Width - 20, 40) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
                CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
                maskLayer.frame = CGRectMake(0, 0, Screen_Width - 20, 40);
                maskLayer.path = maskPath.CGPath;
                cell.layer.mask = maskLayer;
                [cell.layer setMasksToBounds:YES];

                
            }else if (indexPath.row == 1)
            {
                UILabel *ajh1 = [[UILabel alloc]initWithFrame:CGRectMake(5, 0,95 , 40)];
                
                ajh1.text = @"手机号码*";
                
                ajh1.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
                
                
                ajh1.font = [UIFont systemFontOfSize:17];
                
                [cell.contentView addSubview:ajh1];
                
                if (!self.phoneNumItem) {
                    self.phoneNumItem = [[UITextField alloc]initWithFrame:CGRectMake(100, 0, Screen_Width - 130, 40)];
                    self.phoneNumItem.text = phone;
                }
                
                self.phoneNumItem.textAlignment = NSTextAlignmentLeft;
                
                [cell.contentView addSubview:self.phoneNumItem];
            }
            
            else if (indexPath.row == 2)
            {
                UILabel *ajh1 = [[UILabel alloc]initWithFrame:CGRectMake(5, 0,95 , 40)];
                
                ajh1.text = @"性别*";
                
                ajh1.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
                
                
                ajh1.font = [UIFont systemFontOfSize:17];
                
                [cell.contentView addSubview:ajh1];
                
                
                UILabel *ajh2 = [[UILabel alloc]initWithFrame:CGRectMake(5, 0,95 , 40)];
                ajh2 = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, Screen_Width - 130, 40)];
                [cell.contentView addSubview:ajh2];
                if(sex == 0)
                {
                    ajh2.text = @"男";
                }
                else if(sex == 1)
                {
                    ajh2.text = @"女";
                }
                
                if (!self.sexItem) {
                    self.sexItem = [[UISegmentedControl alloc] initWithItems:@[@"男",@"女"]];
                    //添加委托方法
                    [self.sexItem addTarget:self action:@selector(segmentAction:)forControlEvents:UIControlEventValueChanged];
                    self.sexItem.selectedSegmentIndex = selectedSegmentIndex;
                }
                self.sexItem.frame = CGRectMake(Screen_Width - 100 - 30, 5, 100, 30);
                
                
                [cell.contentView addSubview:self.sexItem];
                
            }else if (indexPath.row == 3)
            {
                UILabel *ajh1 = [[UILabel alloc]initWithFrame:CGRectMake(5, 0,95 , 40)];
                
                ajh1.text = @"职业";
                
                ajh1.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
                
                
                ajh1.font = [UIFont systemFontOfSize:17];
                
                [cell.contentView addSubview:ajh1];
                
                if (!self.jobItem) {
                    self.jobItem = [[UITextField alloc]initWithFrame:CGRectMake(100, 0, Screen_Width - 130, 40)];
                }
                
                
                [cell.contentView addSubview:self.jobItem];
                
            }
            else if (indexPath.row == 4)
            {
                UILabel *ajh1 = [[UILabel alloc]initWithFrame:CGRectMake(5, 0,95 , 40)];
                
                ajh1.text = @"单位";
                
                ajh1.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
                
                
                ajh1.font = [UIFont systemFontOfSize:17];
                
                [cell.contentView addSubview:ajh1];
                
                if (!self.workItem) {
                    self.workItem = [[UITextField alloc]initWithFrame:CGRectMake(100, 0, Screen_Width - 130, 40)];
                }
                
                
                self.workItem.textAlignment = NSTextAlignmentLeft;
                
                [cell.contentView addSubview:self.workItem];
                
            }
            else if (indexPath.row == 5)
            {
                UILabel *ajh1 = [[UILabel alloc]initWithFrame:CGRectMake(5, 0,95 , 40)];
                
                ajh1.text = @"联系地址";
                
                ajh1.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
                
                
                ajh1.font = [UIFont systemFontOfSize:17];
                
                [cell.contentView addSubview:ajh1];
                
                if (!self.addressItem) {
                    self.addressItem = [[UITextField alloc]initWithFrame:CGRectMake(100, 0, Screen_Width - 130, 40)];
                    self.addressItem.text = address;
                }
                
                
                self.addressItem.textAlignment = NSTextAlignmentLeft;
                
                [cell.contentView addSubview:self.addressItem];
                
            }
            else if (indexPath.row == 6)
            {
                UILabel *ajh1 = [[UILabel alloc]initWithFrame:CGRectMake(5, 0,95 , 40)];
                
                ajh1.text = @"固定电话";
                
                ajh1.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
                
                
                ajh1.font = [UIFont systemFontOfSize:17];
                
                [cell.contentView addSubview:ajh1];
                
                if (!self.callItem) {
                    self.callItem = [[UITextField alloc]initWithFrame:CGRectMake(100, 0, Screen_Width - 130, 40)];
                }
                
                
                self.callItem.textAlignment = NSTextAlignmentLeft;
                
                [cell.contentView addSubview:self.callItem];
                
            }
            else if (indexPath.row == 7)
            {
                UILabel *ajh1 = [[UILabel alloc]initWithFrame:CGRectMake(5, 0,95 , 40)];
                
                ajh1.text = @"证件号码*";
                
                ajh1.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
                
                
                ajh1.font = [UIFont systemFontOfSize:17];
                
                [cell.contentView addSubview:ajh1];
                
                if (!self.cardItem) {
                    self.cardItem = [[UITextField alloc]initWithFrame:CGRectMake(100, 0, Screen_Width - 130, 40)];
                    self.cardItem.text = idCard;
                    
                }
                
                self.cardItem.textAlignment = NSTextAlignmentLeft;
                
                [cell.contentView addSubview:self.cardItem];
                
            }
            
            else if (indexPath.row == 8)
            {
                UILabel *ajh1 = [[UILabel alloc]initWithFrame:CGRectMake(5, 0,95 , 40)];
                
                ajh1.text = @"邮箱地址";
                
                ajh1.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
                
                
                ajh1.font = [UIFont systemFontOfSize:17];
                
                [cell.contentView addSubview:ajh1];
                
                if (!self.emailItem) {
                    self.emailItem = [[UITextField alloc]initWithFrame:CGRectMake(100, 0, Screen_Width - 130, 40)];
                    self.emailItem.text = email;
                    
                }
                
                self.emailItem.textAlignment = NSTextAlignmentLeft;
                
                [cell.contentView addSubview:self.emailItem];
                
            }
            else if (indexPath.row == 9)
            {
                UILabel *ajh1 = [[UILabel alloc]initWithFrame:CGRectMake(5, 0,95 , 40)];
                
                ajh1.text = @"与案关系*";
                
                ajh1.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
                
                ajh1.font = [UIFont systemFontOfSize:17];
                
                [cell.contentView addSubview:ajh1];
                
                NSArray *  dataArray = @[@"代理人", @"监护人",@"律师",@"当事人"];
                
                cell.detailTextLabel.text = [dataArray objectAtIndex:self.itemSel];
                
            }
            else if (indexPath.row == 10)
            {
                if (!self.pickerType) {
                    self.pickerType = [[HawkPickerView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width - 20, 120)];
                }
                __weak typeof (HawkManyFormsNoDateUIView *)__weakSelf = self;
                self.pickerType.SelectType = ^(NSInteger type){
                    __weakSelf.itemSel = type;
                    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:9 inSection:1];
                    [tableView reloadRowsAtIndexPaths:[[NSArray alloc] initWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
                };
                
                [cell.contentView addSubview:self.pickerType];
                
            }
            else
            {
                
                if (!self.longTextItem) {
                    self.longTextItem = [[HWTextView alloc] initWithFrame:CGRectMake(10, 10, Screen_Width - 40, 80)];
                    
                }
                
                self.longTextItem.font = [UIFont systemFontOfSize:17];
                
                self.longTextItem.placeholder = @"申请内容*";
                
                self.longTextItem.layer.borderWidth = 1;
                
                self.longTextItem.layer.borderColor = FYColor(221, 221, 221).CGColor;
                
                self.longTextItem.layer.cornerRadius = 5;
                
                [cell.contentView addSubview:self.longTextItem];
                
                
                UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, Screen_Width - 20, 100) byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
                CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
                maskLayer.frame = CGRectMake(0, 0, Screen_Width - 20, 100);
                maskLayer.path = maskPath.CGPath;
                cell.layer.mask = maskLayer;
                [cell.layer setMasksToBounds:YES];
                
            }
            
        }
        else{
            if (indexPath.row == 0) {
                
                UILabel *ajh1 = [[UILabel alloc]initWithFrame:CGRectMake(5, 0,95 , 40)];
                
                ajh1.text = @"姓名*";
                
                ajh1.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
                
                ajh1.font = [UIFont systemFontOfSize:17];
                
                [cell.contentView addSubview:ajh1];
                
                if (!self.nameItem) {
                    self.nameItem = [[UITextField alloc]initWithFrame:CGRectMake(100, 0, Screen_Width - 130, 40)];
                    self.nameItem.text = [FYHawkCommens fetchUserInfoByKey:@"userName"];

                }

                
                self.nameItem.textAlignment = NSTextAlignmentLeft;
                
                [cell.contentView addSubview:self.nameItem];
                
                UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, Screen_Width - 20, 40) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
                CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
                maskLayer.frame = CGRectMake(0, 0, Screen_Width - 20, 40);
                maskLayer.path = maskPath.CGPath;
                cell.layer.mask = maskLayer;
                [cell.layer setMasksToBounds:YES];
                
                
            }else if (indexPath.row == 1)
            {
                UILabel *ajh1 = [[UILabel alloc]initWithFrame:CGRectMake(5, 0,95 , 40)];
                
                ajh1.text = @"手机号码*";
                
                ajh1.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
                
                
                ajh1.font = [UIFont systemFontOfSize:17];
                
                [cell.contentView addSubview:ajh1];
                
                if (!self.phoneNumItem) {
                    self.phoneNumItem = [[UITextField alloc]initWithFrame:CGRectMake(100, 0, Screen_Width - 130, 40)];
                     self.phoneNumItem.text = phone;
                }
                
                self.phoneNumItem.textAlignment = NSTextAlignmentLeft;
                
                [cell.contentView addSubview:self.phoneNumItem];
            }
            
            else if (indexPath.row == 2)
            {
                UILabel *ajh1 = [[UILabel alloc]initWithFrame:CGRectMake(5, 0,95 , 40)];
                
                ajh1.text = @"性别*";
                
                ajh1.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
                
                
                ajh1.font = [UIFont systemFontOfSize:17];
                
                [cell.contentView addSubview:ajh1];
                
                UILabel *ajh2 = [[UILabel alloc]initWithFrame:CGRectMake(5, 0,95 , 40)];
                ajh2 = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, Screen_Width - 130, 40)];
                [cell.contentView addSubview:ajh2];
                if(sex == 0 )
                {
                    ajh2.text = @"男";
                }
                else if(sex == 1)
                {
                    ajh2.text = @"女";
                }

                
                if (!self.sexItem) {
                    self.sexItem = [[UISegmentedControl alloc] initWithItems:@[@"男",@"女"]];
                    //添加委托方法
                    [self.sexItem addTarget:self action:@selector(segmentAction:)forControlEvents:UIControlEventValueChanged];
                    self.sexItem.selectedSegmentIndex = selectedSegmentIndex;
                }
                self.sexItem.frame = CGRectMake(Screen_Width - 100 - 30, 5, 100, 30);
                
                
                [cell.contentView addSubview:self.sexItem];
                
            }else if (indexPath.row == 3)
            {
                UILabel *ajh1 = [[UILabel alloc]initWithFrame:CGRectMake(5, 0,95 , 40)];
                
                ajh1.text = @"职业";
                
                ajh1.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
                
                
                ajh1.font = [UIFont systemFontOfSize:17];
                
                [cell.contentView addSubview:ajh1];
                
                if (!self.jobItem) {
                    self.jobItem = [[UITextField alloc]initWithFrame:CGRectMake(100, 0, Screen_Width - 130, 40)];
                }
                
                self.jobItem.textAlignment = NSTextAlignmentLeft;
                
                [cell.contentView addSubview:self.jobItem];
                
            }
            else if (indexPath.row == 4)
            {
                UILabel *ajh1 = [[UILabel alloc]initWithFrame:CGRectMake(5, 0,95 , 40)];
                
                ajh1.text = @"单位";
                
                ajh1.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
                
                
                ajh1.font = [UIFont systemFontOfSize:17];
                
                [cell.contentView addSubview:ajh1];
                
                if (!self.workItem) {
                    self.workItem = [[UITextField alloc]initWithFrame:CGRectMake(100, 0, Screen_Width - 130, 40)];
                }
                
                
                self.workItem.textAlignment = NSTextAlignmentLeft;
                
                [cell.contentView addSubview:self.workItem];
                
            }
            else if (indexPath.row == 5)
            {
                UILabel *ajh1 = [[UILabel alloc]initWithFrame:CGRectMake(5, 0,95 , 40)];
                
                ajh1.text = @"联系地址";
                
                ajh1.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
                
                
                ajh1.font = [UIFont systemFontOfSize:17];
                
                [cell.contentView addSubview:ajh1];
                
                if (!self.addressItem) {
                    self.addressItem = [[UITextField alloc]initWithFrame:CGRectMake(100, 0, Screen_Width - 130, 40)];
                    self.addressItem.text = address;
                }
                
                
                self.addressItem.textAlignment = NSTextAlignmentLeft;
                
                [cell.contentView addSubview:self.addressItem];
                
            }
            else if (indexPath.row == 6)
            {
                UILabel *ajh1 = [[UILabel alloc]initWithFrame:CGRectMake(5, 0,95 , 40)];
                
                ajh1.text = @"固定电话";
                
                ajh1.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
                
                
                ajh1.font = [UIFont systemFontOfSize:17];
                
                [cell.contentView addSubview:ajh1];
                
                if (!self.callItem) {
                    self.callItem = [[UITextField alloc]initWithFrame:CGRectMake(100, 0, Screen_Width - 130, 40)];
                }
                
                
                self.callItem.textAlignment = NSTextAlignmentLeft;
                
                [cell.contentView addSubview:self.callItem];
                
            }
            else if (indexPath.row == 7)
            {
                UILabel *ajh1 = [[UILabel alloc]initWithFrame:CGRectMake(5, 0,95 , 40)];
                
                ajh1.text = @"证件号码*";
                
                ajh1.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
                
                
                ajh1.font = [UIFont systemFontOfSize:17];
                
                [cell.contentView addSubview:ajh1];
                
                if (!self.cardItem) {
                    self.cardItem = [[UITextField alloc]initWithFrame:CGRectMake(100, 0, Screen_Width - 130, 40)];
                    self.cardItem.text = idCard;
                    
                }
                
                self.cardItem.textAlignment = NSTextAlignmentLeft;
                
                [cell.contentView addSubview:self.cardItem];
                
            }
            
            else if (indexPath.row == 8)
            {
                UILabel *ajh1 = [[UILabel alloc]initWithFrame:CGRectMake(5, 0,95 , 40)];
                
                ajh1.text = @"邮箱地址";
                
                ajh1.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
                
                
                ajh1.font = [UIFont systemFontOfSize:17];
                
                [cell.contentView addSubview:ajh1];
                
                if (!self.emailItem) {
                    self.emailItem = [[UITextField alloc]initWithFrame:CGRectMake(100, 0, Screen_Width - 130, 40)];
                    self.emailItem.text = email;
                    
                }
                
                self.emailItem.textAlignment = NSTextAlignmentLeft;
                
                [cell.contentView addSubview:self.emailItem];
                
            }
            else if (indexPath.row == 9)
            {
                UILabel *ajh1 = [[UILabel alloc]initWithFrame:CGRectMake(5, 0,95 , 40)];
                
                ajh1.text = @"与案关系*";
                
                ajh1.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
                
                
                ajh1.font = [UIFont systemFontOfSize:17];
                
                [cell.contentView addSubview:ajh1];
                
              NSArray *  dataArray = @[@"代理人", @"监护人",@"律师",@"当事人"];

                cell.detailTextLabel.text = [dataArray objectAtIndex:self.itemSel];
            }
            else
            {
                
                if (!self.longTextItem) {
                    self.longTextItem = [[HWTextView alloc] initWithFrame:CGRectMake(10, 10, Screen_Width - 40, 80)];
                    
                }
                
                self.longTextItem.font = [UIFont systemFontOfSize:17];
                
                self.longTextItem.placeholder = @"申请内容*";
                
                self.longTextItem.layer.borderWidth = 1;
                
                self.longTextItem.layer.borderColor = FYColor(221, 221, 221).CGColor;
                
                self.longTextItem.layer.cornerRadius = 5;
                
                [cell.contentView addSubview:self.longTextItem];
                
                
                UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, Screen_Width - 20, 100) byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
                CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
                maskLayer.frame = CGRectMake(0, 0, Screen_Width - 20, 100);
                maskLayer.path = maskPath.CGPath;
                cell.layer.mask = maskLayer;
                [cell.layer setMasksToBounds:YES];
                
            }
        }
        cell.backgroundColor = [UIColor whiteColor];
        
        
        return cell;
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        if (indexPath.row == 1) {
            LawSelectViewController *lawSelectVC = [[LawSelectViewController alloc] init];
            lawSelectVC.year = [self.caseYear.text intValue];
            lawSelectVC.selLow = ^(){
                NSIndexPath * indexRoload = [NSIndexPath indexPathForRow:1 inSection:0];
                [tableView reloadRowsAtIndexPaths:[[NSArray alloc] initWithObjects:indexRoload, nil] withRowAnimation:UITableViewRowAnimationNone];
                [ajCheackTableView reloadData];
            };
            [kNav pushViewController:lawSelectVC animated:YES];
        }
    }
    else{
        if (indexPath.row == 9) {
            isExpandPicker = !isExpandPicker;
            NSIndexPath * indexRoload = [NSIndexPath indexPathForRow:10 inSection:1];
            if (isExpandPicker) {
                [tableView reloadData];
            }
            else{
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexRoload,nil] withRowAnimation:UITableViewRowAnimationTop];
            }
        }
        else{
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }
    else{
        if (isExpandPicker) {
            return 12;
        }
        else{
            return 11;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UILabel *ajh = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, Screen_Width - 20, 20)];
        
        ajh.text = @"相案件号*";
        
        ajh.textColor = FYBlueColor;
        
        ajh.font = [UIFont systemFontOfSize:17];
        
        ajh.backgroundColor = FYBackgroundColor;
        
        return ajh;
    }
    else{
        UILabel *ajh = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, Screen_Width - 20, 20)];
        
        ajh.text = @"查询人信息";
        
        ajh.textColor = FYBlueColor;
        
        ajh.font = [UIFont systemFontOfSize:17];
        
        ajh.backgroundColor = FYBackgroundColor;
        
        
        return ajh;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1;
    }
    else{
        return 0.1;
    }
}



#pragma mark - 判断是否为电话号码
- (BOOL)isPhoneNumber:(NSString *)phoneNumber {
    //手机号正则表达式
    NSString *phoneRegex = @"^1[0-9]{1}[0-9]{9}$";
    
    NSPredicate *phoneAuth =
    [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    BOOL auth = [phoneAuth evaluateWithObject:phoneNumber];
    return auth;
}

- (void)submit{
    if (self.caseYear.text.length <= 0 ) {
        [MBProgressHUD showError:@"案件年号不正确"];
        return;
    }
    if (self.lowItem.length <= 0 ) {
        [MBProgressHUD showError:@"法律条文不能为空"];
        return;
        
    }
    if (self.caseTextItem.text.length <= 0 ) {
        [MBProgressHUD showError:@"案件字号不能为空"];
        return;
        
    }
    if (self.caseNumItem.text.length <= 0 ) {
        [MBProgressHUD showError:@"案件编号不能为空"];
        return;
        
    }
    if (self.nameItem.text.length <= 0 ) {
        [MBProgressHUD showError:@"姓名不能为空"];
        return;
        
    }
    if (self.phoneNumItem.text.length <= 0 ) {
        [MBProgressHUD showError:@"手机号不能为空"];
        return;
        
    }
    if (self.cardItem.text.length <= 0 ) {
        [MBProgressHUD showError:@"证件号不能为空"];
        return;
        
    }
    if (self.longTextItem.text.length <= 0) {
        [MBProgressHUD showError:@"申请不能为空"];
        return;
    }
    
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *token =  [defaults objectForKey:@"token"];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"token"] = token;
        params[@"ajnh"] = self.caseYear.text;
        params[@"fyjc"] = self.lowItem;
        params[@"ajzh"] = self.caseTextItem.text;
        params[@"ajbh"] = self.caseNumItem.text;
        params[@"name"] = self.nameItem.text;
        params[@"phone"] = self.phoneNumItem.text;
        params[@"gender"] = [NSString stringWithFormat:@"%ld",(long)self.sexItem.selectedSegmentIndex];
        if (self.jobItem.text) {
            params[@"occupation"] = self.jobItem.text;
        }
        if (self.workItem.text) {
            params[@"company"] = self.workItem.text;
        }
        if (self.addressItem.text) {
            params[@"address"] = self.addressItem.text;
        }
        if (self.callItem.text) {
            params[@"telephone"] = self.callItem.text;
        }
        if (self.emailItem.text) {
            params[@"email"] = self.emailItem.text;
        }
        params[@"idNumber"] = self.cardItem.text;
        params[@"caseRelationship"] = [NSString stringWithFormat:@"%ld",self.itemSel];
        params[@"content"] = self.longTextItem.text;
    
    self.kSubmitBlock(params);
}


#pragma mark - 性别选择按钮
- (void)segmentAction:(UISegmentedControl *)Seg
{
    NSInteger Index = Seg.selectedSegmentIndex;
    if(Index == 0)
    {
        sex = 0;
    }
    else
    {
        sex = 1;
    }
    [ajCheackTableView reloadData];
}



- (void)resetAll{
    self.caseYear.text = @"";
    self.caseTextItem.text = @"";
    self.caseNumItem.text = @"";
    self.nameItem.text = @"";
    self.phoneNumItem.text = @"";
    self.sexItem.selectedSegmentIndex = 0;
    self.jobItem.text = @"";
    self.workItem.text = @"";
    self.addressItem.text = @"";
    self.callItem.text = @"";
    self.emailItem.text = @"";
    self.cardItem.text = @"";
    self.itemSel = 0;
    self.longTextItem.text = @"";
    
    [ajCheackTableView reloadData];
}

- (void)pickerInitData
{
    if(!self.yearArr) {
        self.yearArr = [[NSMutableArray alloc] init];
    }
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
    int year = (int)[dateComponent year];
    for (int i = year; i >= 1940; i--) {
        [self.yearArr addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return NO;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [MMPickerView showPickerViewInView:self withStrings:[self.yearArr copy] withOptions:nil completion:^(NSString *selectedString) {
        self.caseYear.text = selectedString;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:nil forKey:@"lowSelect"];
        [ajCheackTableView reloadData];
    }];
    return NO;
}

@end
