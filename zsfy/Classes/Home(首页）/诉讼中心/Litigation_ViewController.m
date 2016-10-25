//
//  Litigation_ViewController.m
//  zsfy
//
//  Created by tiannuo on 15/11/12.
//  Copyright (c) 2015年 wzy. All rights reserved.
//

#import "Litigation_ViewController.h"
#import "Litigation_Cell.h"
#import "FBI_Cell.h"
#import "RETableViewManager.h"
#import "RETableViewOptionsController.h"
#import "FYZSTableViewController.h"
#import "FYHawkCommens.h"
#import "UIView+ChangeSize.h"
#import "IQKeyboardManager.h"
#import "HawkManyFormsNoDateUIView.h"
#import "HawkManyFormsUIView.h"
#import "FYTableViewCell.h"


@interface Litigation_ViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,RETableViewManagerDelegate>
{
    UIScrollView *myScrollView;
    UIView *Baseline;
    NSMutableArray *listTitle;//按钮数组
    UIScrollView *btnScrollView;//按钮的UIScrollView
    UITableView *tableViewCustomer;//在线客服
    UITableView *tableViewGuide;//诉讼指南
    UITableView *tableViewConnect;//联系法官
    UITableView *tableViewFBI;//诉前联调
    
    UITableView *tableViewVideo;//庭审录像调阅申请
    
    UITableView *tableViewYY;//信访预约
    
    NSArray *listGuide;//诉讼指南数组
    NSMutableArray *listFBI;//诉前联调数组
    
    //当前页面
    int currentPage;
    
    //选中的是哪个
    NSInteger itemSel;
    NSInteger itemSel1;
    NSInteger itemSel2;
    
    //当前选择日期
    NSString * currentDateString;
    
    //年号
    UITextField * yearTextField;
    //字号
    UITextField * wordTextField;
    //编号
    UITextField * numberTextField;
    
    /**
     *  大量表单提交
     */
    UIView * formView1;
    
    UIView * formView2;
    
    UIView * formView3;

    
    

    
}

@property (strong, nonatomic) RETableViewManager *manager;
@property (strong, nonatomic) RETableViewSection *caseNumSection;
/** 案件年号*/
@property (strong, nonatomic) RETextItem *caseYear;
/** 发条*/
@property (strong, readwrite, nonatomic) RERadioItem *lowItem;
/** 案件字号*/
@property (strong, nonatomic) RETextItem *caseTextItem;
/** 案件编号*/
@property (strong, nonatomic) RETextItem *caseNumItem;
/** 咨询人信息部分 */
@property (strong, nonatomic) RETableViewSection *personSection;
/** 姓名部分 */
@property (strong, nonatomic) RETextItem *nameItem;
/** 手机号码部分 */
@property (strong, nonatomic) RETextItem *phoneNumItem;
/** 性别部分 */
@property (strong, nonatomic) RESegmentedItem *sexItem;
/** 职业部分 */
@property (strong, nonatomic) RETextItem *jobItem;
/** 单位部分 */
@property (strong, nonatomic) RETextItem *workItem;
/** 地址部分 */
@property (strong, nonatomic) RETextItem *addressItem;
/** 固话部分 */
@property (strong, nonatomic) RETextItem *callItem;
/** 证件部分 */
@property (strong, nonatomic) RETextItem *cardItem;
/** 邮箱部分 */
@property (strong, nonatomic) RETextItem *emailItem;
/** 与案关系 */
@property (strong, nonatomic) REPickerItem *pickerType;
/** 写出您的建议*/
@property (strong, readwrite, nonatomic) RELongTextItem *longTextItem;




@property (strong, nonatomic) RETableViewManager *manager1;
@property (strong, nonatomic) RETableViewSection *caseNumSection1;
/** 案件年号*/
@property (strong, nonatomic) RETextItem *caseYear1;
/** 发条*/
@property (strong, readwrite, nonatomic) RERadioItem *lowItem1;
/** 案件字号*/
@property (strong, nonatomic) RETextItem *caseTextItem1;
/** 案件编号*/
@property (strong, nonatomic) RETextItem *caseNumItem1;
/** 咨询人信息部分 */
@property (strong, nonatomic) RETableViewSection *personSection1;
/** 姓名部分 */
@property (strong, nonatomic) RETextItem *nameItem1;
/** 手机号码部分 */
@property (strong, nonatomic) RETextItem *phoneNumItem1;
/** 性别部分 */
@property (strong, nonatomic) RESegmentedItem *sexItem1;
/** 职业部分 */
@property (strong, nonatomic) RETextItem *jobItem1;
/** 单位部分 */
@property (strong, nonatomic) RETextItem *workItem1;
/** 地址部分 */
@property (strong, nonatomic) RETextItem *addressItem1;
/** 固话部分 */
@property (strong, nonatomic) RETextItem *callItem1;
/** 证件部分 */
@property (strong, nonatomic) RETextItem *cardItem1;
/** 邮箱部分 */
@property (strong, nonatomic) RETextItem *emailItem1;
/** 与案关系 */
@property (strong, nonatomic) REPickerItem *pickerType1;
/** 日期    */
@property (strong, nonatomic) REDateTimeItem * datePicker1;
/** 写出您的建议*/
@property (strong, readwrite, nonatomic) RELongTextItem *longTextItem1;

@property (strong, nonatomic) RETableViewManager *manager2;
@property (strong, nonatomic) RETableViewSection *caseNumSection2;
/** 案件年号*/
@property (strong, nonatomic) RETextItem *caseYear2;
/** 发条*/
@property (strong, readwrite, nonatomic) RERadioItem *lowItem2;
/** 案件字号*/
@property (strong, nonatomic) RETextItem *caseTextItem2;
/** 案件编号*/
@property (strong, nonatomic) RETextItem *caseNumItem2;
/** 咨询人信息部分 */
@property (strong, nonatomic) RETableViewSection *personSection2;
/** 姓名部分 */
@property (strong, nonatomic) RETextItem *nameItem2;
/** 手机号码部分 */
@property (strong, nonatomic) RETextItem *phoneNumItem2;
/** 性别部分 */
@property (strong, nonatomic) RESegmentedItem *sexItem2;
/** 职业部分 */
@property (strong, nonatomic) RETextItem *jobItem2;
/** 单位部分 */
@property (strong, nonatomic) RETextItem *workItem2;
/** 地址部分 */
@property (strong, nonatomic) RETextItem *addressItem2;
/** 固话部分 */
@property (strong, nonatomic) RETextItem *callItem2;
/** 证件部分 */
@property (strong, nonatomic) RETextItem *cardItem2;
/** 邮箱部分 */
@property (strong, nonatomic) RETextItem *emailItem2;
/** 与案关系 */
@property (strong, nonatomic) REPickerItem *pickerType2;
/** 写出您的建议*/
@property (strong, readwrite, nonatomic) RELongTextItem *longTextItem2;

/** 法律 */
@property (nonatomic,strong)NSArray *lowArray;

//未登录
@property(nonatomic,strong)UIView * logOutView;
@property(nonatomic,strong)UIView * logOutView1;
@property(nonatomic,strong)UIView * logOutView2;

@end

@implementation Litigation_ViewController

- (UIView *)logOutView
{
    if (_logOutView == nil) {
        self.logOutView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height - 64)];
        UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, Screen_Height * 0.5 - 64, Screen_Width, 15)];
        tipLabel.text = @"请先登录或者注册";
        tipLabel.textAlignment = NSTextAlignmentCenter;
        [self.logOutView addSubview:tipLabel];
        self.logOutView.hidden = YES;
    }
    
    return _logOutView;
}

- (UIView *)logOutView1
{
    if (_logOutView1 == nil) {
        self.logOutView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height - 64)];
        UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, Screen_Height * 0.5 - 64, Screen_Width, 15)];
        tipLabel.text = @"请先登录或者注册";
        tipLabel.textAlignment = NSTextAlignmentCenter;
        [self.logOutView1 addSubview:tipLabel];
        self.logOutView1.hidden = YES;
    }
    
    return _logOutView1;
}

- (UIView *)logOutView2
{
    if (_logOutView2 == nil) {
        self.logOutView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height - 64)];
        UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, Screen_Height * 0.5 - 64, Screen_Width, 15)];
        tipLabel.text = @"请先登录或者注册";
        tipLabel.textAlignment = NSTextAlignmentCenter;
        [self.logOutView2 addSubview:tipLabel];
        self.logOutView2.hidden = YES;
    }
    
    return _logOutView2;
}

- (NSArray *)lowArray
{
    if (_lowArray == nil) {
        self.lowArray = @[@"广铁中法",@"广铁法",@"肇铁法"];
    }
    return _lowArray;
}

//登录进来刷新视图
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *userId  =  [userDefault objectForKey:@"user_id"];
    NSLog(@"userId  is %@",userId);
    if(![NSString isBlankString:userId] )
    {
        formView1.hidden = NO;
        formView2.hidden = NO;
        formView3.hidden = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [IQKeyboardManager sharedManager].enable = YES;

    
    self.view.backgroundColor = FYBackgroundColor;
    
    self.navigationItem.title = @"诉讼中心";
    
    [self initWithView];
}

-(void)initWithView
{
    NSArray *colorArray = @[FYBackgroundColor,FYBackgroundColor,FYBackgroundColor,FYBackgroundColor,FYBackgroundColor,FYBackgroundColor];
    
    //按钮标题
    //    listTitle = [NSMutableArray arrayWithObjects:@"在线客服",@"诉讼指南",@"联系法官",@"电子送达邮箱",@"诉前联调",@"庭审录像调阅申请",@"信访预约", nil];
    listTitle = [NSMutableArray arrayWithObjects:@"诉讼指南",@"联系法官",@"电子送达邮箱",@"诉前联调",@"庭审录像调阅申请",@"信访预约", nil];
    //诉讼指南数组
    listGuide = [NSArray array];
    
    listFBI = [NSMutableArray array];
    
    btnScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 32)];
    btnScrollView.showsHorizontalScrollIndicator = NO;
    // 设置UIScrollView的滚动范围（内容大小）
    btnScrollView.bounces = NO;
    btnScrollView.delegate = self;
    btnScrollView.backgroundColor = FYBackgroundColor;
    [self.view addSubview:btnScrollView];
    btnScrollView.contentSize = CGSizeMake((Screen_Width/3-10)*listTitle.count, 32);
    
    for (int i = 0; i<listTitle.count; i++) {
        UIButton *btn = [CTB buttonType:UIButtonTypeCustom delegate:self to:btnScrollView tag:i+1 title:[listTitle objectAtIndex:i] img:@""];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.frame = CGRectMake((Screen_Width/3-10)*i, 0, (Screen_Width/3-10), 30);
    }
    //横线
    Baseline = [[UIView alloc] initWithFrame:CGRectMake(0, 30, (Screen_Width/3-10), 2)];
    Baseline.backgroundColor = FYBlueColor;
    [btnScrollView addSubview:Baseline];
    
    myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 33, Screen_Width, Screen_Height-64-33)];
    //翻页效果
    myScrollView.pagingEnabled = YES;
    myScrollView.showsHorizontalScrollIndicator = NO;
    // 设置UIScrollView的滚动范围（内容大小）
    myScrollView.bounces = YES;
    myScrollView.delegate = self;
    [self.view addSubview:myScrollView];
    myScrollView.contentSize = CGSizeMake(Screen_Width*listTitle.count, Screen_Height-64-33);
    for (int i = 0; i<listTitle.count; i++) {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(Screen_Width*i, 0, Screen_Width, Screen_Height-64-33)];
        v.backgroundColor = [colorArray objectAtIndex:i];
        
        if (i == 0) {
            //创建诉讼指南界面
            [self createGuideView:v];
            
        }else if (i == 1)
        {
            [v addSubview:self.logOutView];
            formView1 = [[HawkManyFormsNoDateUIView alloc] initWithFrame:self.view.bounds withType:SubView_Type_Vedio withNav:self.navigationController submitBlock:^(NSMutableDictionary * dic){
                NSLog(@"联系发给 = %@ \n",dic);
                [self submitContact:dic];
            }];
            //创建联系法官页面
            [v addSubview: formView1];
//            tableViewConnect  = [[UITableView alloc]initWithFrame:v.bounds];
//            [self createConnect:v];
        }else if (i == 2)
        {
            //创建电子送达邮箱页面
            [self createEmail:v];
        }
        else if (i == 3) {
            // 诉前联调
            
            [self createFBI:v];
        }else if(i == 4)
        {
            [v addSubview:self.logOutView1];

            // 庭审录像调阅
        formView2 = [[HawkManyFormsUIView alloc] initWithFrame:self.view.bounds withType:SubView_Type_Vedio withNav:self.navigationController submitBlock:^(NSMutableDictionary * dic){
                NSLog(@"Luxiang = %@\n",dic);
            [self submitApplicationVideo:dic];
            }];
            [v addSubview:formView2];
//            tableViewVideo  = [[UITableView alloc]initWithFrame:v.bounds];
//            [self createView:v];
        }else if(i == 5)
        {
            // 信访预约
            [v addSubview:self.logOutView2];

            formView3 = [[HawkManyFormsNoDateUIView alloc] initWithFrame:self.view.bounds withType:SubView_Type_Vedio withNav:self.navigationController submitBlock:^(NSMutableDictionary * dic){
                NSLog(@"visit = %@ \n",dic);
                [self submitVisit:dic];
            }];
            [v addSubview:formView3];
//            tableViewYY  = [[UITableView alloc]initWithFrame:v.bounds];
//            [self createYYView:v];
        }
        [myScrollView addSubview:v];
    }
    
    if (listGuide.count<= 0) {
        [self getGuide:9];
    }
}
#pragma mark 信访预约
- (void)createYYView:(UIView *)view
{
    // Create manager
    self.manager2 = [[RETableViewManager alloc]initWithTableView:tableViewYY];
    self.manager2.style.backgroundImageMargin = 10.0;
    self.manager2.style.cellHeight = 42.0;
    
    /** 案件号部分 */
    self.caseNumSection2 = [self addCaseControls2];
    
    // /** 查询密码部分 */
    self.personSection2= [self addPersonSection2];
    
    tableViewYY.tableFooterView = [self FootView2];
    
    [view addSubview:tableViewYY];
}

- (UIView *)FootView2
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height * 0.5)];
    view.backgroundColor = FYColor(245, 245, 245);
    
    UIButton *checkBtn = [[UIButton alloc]initWithFrame:CGRectMake(14, 10, Screen_Width - 28, 44)];
    checkBtn.layer.cornerRadius = 4.0f;
    [checkBtn setTitle:@"提交" forState:UIControlStateNormal];
    [checkBtn addTarget:self action:@selector(checkButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [checkBtn setBackgroundColor:FYColor(0, 111, 194)];
    [view addSubview:checkBtn];
    
    
    return view;
}
- (RETableViewSection *)addPersonSection2
{
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIView setWidth:100], 0, Screen_Width, 45)];
    titleLabel.backgroundColor = [UIColor colorWithRed:247 / 255.0 green:247 / 255.0 blue:247 / 255.0 alpha:1];
    titleLabel.text = @"   咨询人信息*";
    titleLabel.textColor = FYBlueColor;
    RETableViewSection *section = [RETableViewSection sectionWithHeaderView:titleLabel];
    [self.manager2 addSection:section];
    self.nameItem2 = [[RETextItem alloc]initWithTitle:@"姓名*" value:[FYHawkCommens fetchUserInfoByKey:@"userName"] placeholder:nil];
    [section addItem:self.nameItem2];
    self.phoneNumItem2 = [[RETextItem alloc]initWithTitle:@"手机号码*" value:nil placeholder:nil];
    [section addItem:self.phoneNumItem2];
    self.sexItem2 = [RESegmentedItem itemWithTitle:@"性别*" segmentedControlTitles:@[@"男", @"女"] value:1 switchValueChangeHandler:^(RESegmentedItem *item) {
        NSLog(@"Value: %li", (long)item.value);
    }];
    [section addItem:self.sexItem2];
    self.jobItem2 = [[RETextItem alloc]initWithTitle:@"职业" value:nil placeholder:nil];
    [section addItem:self.jobItem2];
    self.workItem2 = [[RETextItem alloc]initWithTitle:@"单位" value:nil placeholder:nil];
    [section addItem:self.workItem2];
    self.addressItem2 = [[RETextItem alloc]initWithTitle:@"联系地址" value:nil placeholder:nil];
    [section addItem:self.addressItem2];
    self.callItem2 = [[RETextItem alloc]initWithTitle:@"固定电话" value:nil placeholder:nil];
    [section addItem:self.callItem2];
    self.cardItem2 = [[RETextItem alloc]initWithTitle:@"证件号码*" value:nil placeholder:nil];
    [section addItem:self.cardItem2];
    self.emailItem2 = [[RETextItem alloc]initWithTitle:@"邮箱地址" value:nil placeholder:nil];
    [section addItem:self.emailItem2];
    
    //注册类型
    self.pickerType2 = [REPickerItem itemWithTitle:@"与案关系*" value:@[@"当事人"] placeholder:nil options:@[@[@"代理人", @"监护人",@"律师",@"当事人"]]];
    self.pickerType2.onChange = ^(REPickerItem *item){
        NSArray * arr = @[@"代理人", @"监护人",@"律师",@"当事人"];
        itemSel2 = [arr indexOfObject:item.value];
        NSLog(@"Value: %@", item.value);
    };
    // Use inline picker in iOS 7
    self.pickerType2.inlinePicker = YES;
    [section addItem:self.pickerType2];
    
    
    self.longTextItem2 = [RELongTextItem itemWithValue:nil placeholder:@"申请内容*"];
    [section addItem:self.longTextItem2];
    self.longTextItem2.cellHeight = 120;
    
    
    return section;
}


- (RETableViewSection *) addCaseControls2
{
    
    
    __typeof (&*self) __weak weakSelf = self;
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIView setWidth:100], 0, Screen_Width, 45)];
    titleLabel.backgroundColor = [UIColor colorWithRed:247 / 255.0 green:247 / 255.0 blue:247 / 255.0 alpha:1];
    titleLabel.text = @"   相关案号*";
    titleLabel.textColor = FYBlueColor;
    
    RETableViewSection *section = [RETableViewSection sectionWithHeaderView:titleLabel];
    [self.manager2 addSection:section];

    
    //案件年号
    self.caseYear2 = [RETextItem itemWithTitle:nil value:nil placeholder:nil];
    self.caseYear2.detailLabelText = @"年号";
    self.caseYear2.style = UITableViewCellStyleValue1;
    self.caseYear2.keyboardType = UIKeyboardTypeNumberPad;
    self.caseYear2.textAlignment = NSTextAlignmentRight;
    [section addItem:self.caseYear2];
    
    
    self.lowItem2 = [[RERadioItem alloc] initWithTitle:nil value:@"广铁中法" selectionHandler:^(RERadioItem *item) {
        
        [item deselectRowAnimated:YES];
        
        NSMutableArray *options = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < self.lowArray.count; i++)
            [options addObject:self.lowArray[i]];
        
        // Present options controller
        //
        RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:options multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem){
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
            [item reloadRowWithAnimation:UITableViewRowAnimationNone]; // same as [weakSelf.tableView reloadRowsAtIndexPaths:@[item.indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
        
        //         Adjust styles
        
        optionsController.delegate = weakSelf;
        optionsController.style = section.style;
        if (tableViewYY.backgroundView == nil) {
            optionsController.tableView.backgroundColor = tableViewYY.backgroundColor;
            optionsController.tableView.backgroundView = nil;
        }
        
        //         Push the options controller
        
        [weakSelf.navigationController pushViewController:optionsController animated:YES];
        
    }];
    [section addItem:self.lowItem2];
    
    self.caseTextItem2 = [RETextItem itemWithTitle:nil value:nil placeholder:nil];
    self.caseTextItem2.style = UITableViewCellStyleValue1;
    self.caseTextItem2.detailLabelText = @"案件字号";
    [section addItem:self.caseTextItem2];
    
    self.caseNumItem2 = [RETextItem itemWithTitle:nil value:nil placeholder:nil];
    self.caseNumItem2.style = UITableViewCellStyleValue1;
    self.caseNumItem2.detailLabelText = @"案件编号";
    [section addItem:self.caseNumItem2];
    
    
    return section;
}

#pragma mark 庭审录像调阅
- (void)createView:(UIView *)view
{
    // Create manager
    self.manager1 = [[RETableViewManager alloc]initWithTableView:tableViewVideo];
    self.manager1.style.backgroundImageMargin = 10.0;
    self.manager1.style.cellHeight = 42.0;
    
    
    //  tableViewConnect.tableFooterView = [self FootView];
    
    /** 案件号部分 */
    self.caseNumSection1 = [self addCaseControls1];
    
    // /** 查询密码部分 */
    self.personSection1= [self addPersonSection1];
    
    tableViewVideo.tableFooterView = [self FootView1];
    
    [view addSubview:tableViewVideo];
    
}

- (UIView *)FootView1
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height * 0.5)];
    view.backgroundColor = FYColor(245, 245, 245);
    
    UIButton *checkBtn = [[UIButton alloc]initWithFrame:CGRectMake(14, 10, Screen_Width - 28, 44)];
    checkBtn.layer.cornerRadius = 4.0f;
    [checkBtn setTitle:@"提交" forState:UIControlStateNormal];
    [checkBtn setBackgroundColor:FYColor(0, 111, 194)];
    [view addSubview:checkBtn];
    
    
    return view;
}
- (RETableViewSection *)addPersonSection1
{
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIView setWidth:100], 0, Screen_Width, 45)];
    titleLabel.backgroundColor = [UIColor colorWithRed:247 / 255.0 green:247 / 255.0 blue:247 / 255.0 alpha:1];
    titleLabel.text = @"   咨询人信息*";
    titleLabel.textColor = FYBlueColor;
    RETableViewSection *section = [RETableViewSection sectionWithHeaderView:titleLabel];
    [self.manager1 addSection:section];
    self.nameItem1 = [[RETextItem alloc]initWithTitle:@"姓名*" value:[FYHawkCommens fetchUserInfoByKey:@"userName"] placeholder:nil];
    [section addItem:self.nameItem1];
    
    self.phoneNumItem1 = [[RETextItem alloc]initWithTitle:@"手机号码*" value:nil placeholder:nil];
    [section addItem:self.phoneNumItem1];
    self.sexItem1 = [RESegmentedItem itemWithTitle:@"性别*" segmentedControlTitles:@[@"男", @"女"] value:1 switchValueChangeHandler:^(RESegmentedItem *item) {
        NSLog(@"Value: %li", (long)item.value);
    }];
    [section addItem:self.sexItem1];
    self.jobItem1 = [[RETextItem alloc]initWithTitle:@"职业" value:nil placeholder:nil];
    [section addItem:self.jobItem1];
    self.workItem1 = [[RETextItem alloc]initWithTitle:@"单位" value:nil placeholder:nil];
    [section addItem:self.workItem1];
    self.addressItem1 = [[RETextItem alloc]initWithTitle:@"联系地址" value:nil placeholder:nil];
    [section addItem:self.addressItem1];
    self.callItem1 = [[RETextItem alloc]initWithTitle:@"固定电话" value:nil placeholder:nil];
    [section addItem:self.callItem1];
    self.cardItem1 = [[RETextItem alloc]initWithTitle:@"证件号码*" value:nil placeholder:nil];
    [section addItem:self.cardItem1];
    self.emailItem1 = [[RETextItem alloc]initWithTitle:@"邮箱地址" value:nil placeholder:nil];
    [section addItem:self.emailItem1];
    
    //注册类型
    self.pickerType1 = [REPickerItem itemWithTitle:@"与案关系*" value:@[@"当事人"] placeholder:nil options:@[@[@"代理人", @"监护人",@"律师",@"当事人"]]];
    self.pickerType1.onChange = ^(REPickerItem *item){
        NSArray * arr = @[@"代理人", @"监护人",@"律师",@"当事人"];
        itemSel1 = [arr indexOfObject:item.value];
        NSLog(@"Value: %@", item.value);
    };
    // Use inline picker in iOS 7
    self.pickerType1.inlinePicker = YES;
    [section addItem:self.pickerType1];
    
    
    self.longTextItem1 = [RELongTextItem itemWithValue:nil placeholder:@"申请内容*"];
    [section addItem:self.longTextItem];
    self.longTextItem1.cellHeight = 120;
    
    return section;
}


- (RETableViewSection *) addCaseControls1
{
    
    
    __typeof (&*self) __weak weakSelf = self;
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIView setWidth:100], 0, Screen_Width, 45)];
    titleLabel.backgroundColor = [UIColor colorWithRed:247 / 255.0 green:247 / 255.0 blue:247 / 255.0 alpha:1];
    titleLabel.text = @"   相关案号*";
    titleLabel.textColor = FYBlueColor;
    RETableViewSection *section = [RETableViewSection sectionWithHeaderView:titleLabel];
    [self.manager1 addSection:section];
    
    //案件年号
    self.caseYear1 = [RETextItem itemWithTitle:nil value:nil placeholder:@"年号"];
    self.caseYear1.keyboardType = UIKeyboardTypeNumberPad;
    [section addItem:self.caseYear1];
    
    
    
    
    self.lowItem1 = [[RERadioItem alloc]initWithTitle:nil value:@"广铁中法" selectionHandler:^(RERadioItem *item) {
        
        [item deselectRowAnimated:YES];
        
        NSMutableArray *options = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < self.lowArray.count; i++)
            [options addObject:self.lowArray[i]];
        
        // Present options controller
        //
        RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:options multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem){
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
            [item reloadRowWithAnimation:UITableViewRowAnimationNone]; // same as [weakSelf.tableView reloadRowsAtIndexPaths:@[item.indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
        
        //         Adjust styles
        
        optionsController.delegate = weakSelf;
        optionsController.style = section.style;
        if (tableViewVideo.backgroundView == nil) {
            optionsController.tableView.backgroundColor = tableViewVideo.backgroundColor;
            optionsController.tableView.backgroundView = nil;
        }
        
        //         Push the options controller
        
        [weakSelf.navigationController pushViewController:optionsController animated:YES];
        
    }];
    [section addItem:self.lowItem];
    
    self.caseTextItem1 = [[RETextItem alloc]initWithTitle:nil value:nil placeholder:@"案件字号"];
    [section addItem:self.caseTextItem];
    
    self.caseNumItem1 = [[RETextItem alloc]initWithTitle:nil value:nil placeholder:@"案件编号"];
    [section addItem:self.caseNumItem];
    return section;
}
#pragma mark 电子送达邮箱
-(void)createEmail:(UIView *)view
{
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height - 64-33)];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
    [view addSubview:webView];
    
}
#pragma mark 诉前联调
- (void)createFBI:(UIView *)view
{
    tableViewFBI = [[UITableView alloc] initWithFrame:view.bounds];
    tableViewFBI.delegate = self;
    tableViewFBI.dataSource = self;
    tableViewFBI.hidden = YES;
    tableViewFBI.tableFooterView = [[UIView alloc] init];
    tableViewFBI.separatorStyle = UITableViewCellSeparatorStyleNone;
    [view addSubview:tableViewFBI];
    tableViewFBI.tableFooterView = [[UIView alloc] init];
}
#pragma mark 诉讼指南
- (void)createGuideView:(UIView *)view
{
    //诉讼指南
    tableViewGuide = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-64-33) style:UITableViewStylePlain];
    tableViewGuide.delegate = self;
    tableViewGuide.dataSource = self;
    tableViewGuide.hidden = YES;
    tableViewGuide.tableFooterView = [[UIView alloc] init];
    //    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [view addSubview:tableViewGuide];
    
    tableViewGuide.tableFooterView = [[UIView alloc] init];
}


#pragma mark 联系法官页面
- (void)createConnect:(UIView *)v
{
    
    
    // Create manager
    self.manager = [[RETableViewManager alloc]initWithTableView:tableViewConnect];
    self.manager.style.backgroundImageMargin = 10.0;
    self.manager.style.cellHeight = 42.0;
    
    
    //  tableViewConnect.tableFooterView = [self FootView];
    
    /** 案件号部分 */
    self.caseNumSection = [self addCaseControls];
    
    // /** 查询密码部分 */
    self.personSection = [self addPersonSection];
    
    tableViewConnect.tableFooterView = [self FootView];
    
    [v addSubview:tableViewConnect];
}

- (UIView *)FootView
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height * 0.5)];
    view.backgroundColor = FYColor(245, 245, 245);
    
    UIButton *checkBtn = [[UIButton alloc]initWithFrame:CGRectMake(14, 10, Screen_Width - 28, 44)];
    checkBtn.layer.cornerRadius = 4.0f;
    [checkBtn setTitle:@"提交" forState:UIControlStateNormal];
    [checkBtn setBackgroundColor:FYColor(0, 111, 194)];
    [view addSubview:checkBtn];
    
    
    return view;
}
- (RETableViewSection *)addPersonSection
{
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIView setWidth:100], 0, Screen_Width, 45)];
    titleLabel.backgroundColor = [UIColor colorWithRed:247 / 255.0 green:247 / 255.0 blue:247 / 255.0 alpha:1];
    titleLabel.text = @"   咨询人信息*";
    titleLabel.textColor = FYBlueColor;
    RETableViewSection *section = [RETableViewSection sectionWithHeaderView:titleLabel];
    [self.manager addSection:section];
    
    self.nameItem = [[RETextItem alloc]initWithTitle:@"姓名*" value:[FYHawkCommens fetchUserInfoByKey:@"userName"] placeholder:nil];
    [section addItem:self.nameItem];
    self.phoneNumItem = [[RETextItem alloc]initWithTitle:@"手机号码*" value:nil placeholder:nil];
    [section addItem:self.phoneNumItem];
    self.sexItem = [RESegmentedItem itemWithTitle:@"性别*" segmentedControlTitles:@[@"男", @"女"] value:1 switchValueChangeHandler:^(RESegmentedItem *item) {
        NSLog(@"Value: %li", (long)item.value);
    }];
    [section addItem:self.sexItem];
    self.jobItem = [[RETextItem alloc]initWithTitle:@"职业" value:nil placeholder:nil];
    [section addItem:self.jobItem];
    self.workItem = [[RETextItem alloc]initWithTitle:@"单位" value:nil placeholder:nil];
    [section addItem:self.workItem];
    self.addressItem = [[RETextItem alloc]initWithTitle:@"联系地址" value:nil placeholder:nil];
    [section addItem:self.addressItem];
    self.callItem = [[RETextItem alloc]initWithTitle:@"固定电话" value:nil placeholder:nil];
    [section addItem:self.callItem];
    self.cardItem = [[RETextItem alloc]initWithTitle:@"证件号码*" value:nil placeholder:nil];
    [section addItem:self.cardItem];
    self.emailItem = [[RETextItem alloc]initWithTitle:@"邮箱地址" value:nil placeholder:nil];
    [section addItem:self.emailItem];
    
    //注册类型
    self.pickerType = [REPickerItem itemWithTitle:@"与案关系*" value:@[@"当事人"] placeholder:nil options:@[@[@"代理人", @"监护人",@"律师",@"当事人"]]];
    self.pickerType.onChange = ^(REPickerItem *item){
        
        NSArray * arr = @[@"代理人", @"监护人",@"律师",@"当事人"];
        itemSel = [arr indexOfObject:item.value];
    };
    // Use inline picker in iOS 7
    self.pickerType.inlinePicker = YES;
    [section addItem:self.pickerType];
    
    self.longTextItem = [RELongTextItem itemWithValue:nil placeholder:@"申请内容*"];
    [section addItem:self.longTextItem];
    self.longTextItem.cellHeight = 120;
    
    return section;
}


- (RETableViewSection *) addCaseControls
{
    
    
    __typeof (&*self) __weak weakSelf = self;
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIView setWidth:100], 0, Screen_Width, 45)];
    titleLabel.backgroundColor = [UIColor colorWithRed:247 / 255.0 green:247 / 255.0 blue:247 / 255.0 alpha:1];
    titleLabel.text = @"   相关案号*";
    titleLabel.textColor = FYBlueColor;
    RETableViewSection *section = [RETableViewSection sectionWithHeaderView:titleLabel];
    [self.manager addSection:section];
    
    //案件年号
    self.caseYear = [RETextItem itemWithTitle:nil value:nil placeholder:@"年号"];
    self.caseYear = [[RETextItem alloc] initWithTitle:nil value:nil placeholder:@"年号"];
    self.caseYear.keyboardType = UIKeyboardTypeNumberPad;
    self.caseYear.textAlignment = NSTextAlignmentRight;
    [section addItem:self.caseYear];
    
        
    
    
    self.lowItem = [[RERadioItem alloc] initWithTitle:nil value:@"广铁中法" selectionHandler:^(RERadioItem *item) {
        
        [item deselectRowAnimated:YES];
        
        NSMutableArray *options = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < self.lowArray.count; i++)
            [options addObject:self.lowArray[i]];
        
        // Present options controller
        //
        RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:options multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem){
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
            [item reloadRowWithAnimation:UITableViewRowAnimationNone]; // same as [weakSelf.tableView reloadRowsAtIndexPaths:@[item.indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
        
        //         Adjust styles
        
        optionsController.delegate = weakSelf;
        optionsController.style = section.style;
        if (tableViewConnect.backgroundView == nil) {
            optionsController.tableView.backgroundColor = tableViewConnect.backgroundColor;
            optionsController.tableView.backgroundView = nil;
        }
        
        //         Push the options controller
        
        [weakSelf.navigationController pushViewController:optionsController animated:YES];
        
    }];
    [section addItem:self.lowItem];
    
    self.caseTextItem = [[RETextItem alloc]initWithTitle:nil value:nil placeholder:@"案件字号"];
    
    [section addItem:self.caseTextItem];
    
    self.caseNumItem = [[RETextItem alloc]initWithTitle:nil value:nil placeholder:@"案件编号"];
    [section addItem:self.caseNumItem];
    return section;
}



#pragma mark -======诉讼指南 接口===================
-(void)getGuide:(int)categoryId
{
    NSDictionary *paras = [NSDictionary dictionary];
    paras = @{@"courtId":@(1),
              @"categoryId":@(categoryId)};
    
    NSLog(@"参数:%@",paras);
    if(categoryId == 9)
    {
        [FSHttpTool post:@"app/article!getSubCategoryListAjax.action" params:paras success:^(id json) {
            NSLog(@"诉讼指南的数据 %@",json);
            NSDictionary *result = (NSDictionary *)json;
            //        NSDictionary *attachResult = [result objectForKey:@"attach"];
            //诉讼指南
            listGuide = [result objectForKey:@"attach"];
            //            listGuide = [guideDic objectForKey:@"list"];
            tableViewGuide.hidden = NO;
            [tableViewGuide reloadData];
        } failure:^(NSError *error) {
            NSLog(@"报错信息%@",error);
        }];
    }else if (categoryId == 11) { //app/article!listAjax.action
        
        [FSHttpTool post:@"app/article!listAjax.action" params:paras success:^(id json) {
            NSLog(@"诉讼指南的数据 %@",json);
            NSDictionary *result = (NSDictionary *)json;
            //        NSDictionary *attachResult = [result objectForKey:@"attach"];
            //诉前联调
            listFBI = [result objectForKey:@"attach"];
            tableViewFBI.hidden = NO;
            [tableViewFBI reloadData];
        } failure:^(NSError *error) {
            NSLog(@"报错信息%@",error);
        }];
        
    }
    
    
}

#pragma mark -========tableView====================
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:tableViewCustomer]) {
        return 2;
    }
    else if ([tableView isEqual:tableViewGuide]) {
        return listGuide.count;
    }
    else if ([tableView isEqual:tableViewFBI]) {
        return listFBI.count;
    }
    return 0;
}

#pragma mark设置每一个cell的行高（有多少行，就走多少次）
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:tableViewCustomer]) {
        return 140;
    }else if ([tableView isEqual:tableViewGuide]) {
        return 36;
    }
    else if ([tableView isEqual:tableViewFBI]) {
        return 65;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [NSString stringWithFormat:@"%d/%d/Cell",(int)indexPath.section,(int)indexPath.row];
    if ([tableView isEqual:tableViewCustomer]) {
        Litigation_Cell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == NULL) {
            cell = [[Litigation_Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        return cell;
    }
    else if ([tableView isEqual:tableViewGuide]) {
        FYTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == NULL) {
            cell = [[FYTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        NSDictionary *dic = [listGuide objectAtIndex:indexPath.row];
        NSLog(@"字典is %@",dic);
        cell.textLabel.text = [dic objectForKey:@"title"];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        return cell;
    }
    else if ([tableView isEqual:tableViewFBI]) {
        FBI_Cell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == NULL) {
            cell = [[FBI_Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        NSDictionary *dic = [listFBI objectAtIndex:indexPath.row];
        cell.lblTitle.text = [dic objectForKey:@"title"];
        cell.lblTime.text = [dic objectForKey:@"publishTime"];
        return cell;
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:tableViewGuide]) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        //        FYWebViewController *webView  = [[FYWebViewController alloc]init];
        NSDictionary *dic = [listGuide objectAtIndex:indexPath.row];
        //        webView.Title = [dic objectForKey:@"title"];
        //        webView.url = [dic objectForKey:@"url"];
        FYZSTableViewController *zstVC = [[FYZSTableViewController alloc]init];
        zstVC.zsId = [dic objectForKey:@"id"];
        zstVC.Title = [dic objectForKey:@"title"];
        [self.navigationController pushViewController:zstVC animated:YES];
    }else if ([tableView isEqual:tableViewFBI]) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        FYWebViewController *webView  = [[FYWebViewController alloc]init];
        NSDictionary *dic = [listFBI objectAtIndex:indexPath.row];
        webView.Title = [dic objectForKey:@"title"];
        webView.url = [dic objectForKey:@"url"];
        [self.navigationController pushViewController:webView animated:YES];
    }
}

//滚动结束代理,只走一次
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;      // called when scroll view grinds to a halt
{
    
    
    if ([scrollView isEqual:myScrollView]) {
        
        
        int page = myScrollView.contentOffset.x/GetVWidth(myScrollView);
        NSLog(@"end");
        if (page + 1 == 2) {
            if (![FYHawkCommens checkIfLogin:self.navigationController]) {
                formView1.hidden = YES;
                self.logOutView.hidden = NO;
                return;
            }
            else{
                formView1.hidden = NO;
            }
            if (listGuide.count <= 0) {
                [self getGuide:9];
            }
        }
        else if(page + 1 == 5){
            if (![FYHawkCommens checkIfLogin:self.navigationController]) {
                formView2.hidden = YES;
                self.logOutView1.hidden = NO;

                return;
            }
            else{
                formView2.hidden = NO;
            }
            if (listFBI.count <= 0) {
                [self getGuide:11];
            }
        }
        else if(page + 1 == 6){
            if (![FYHawkCommens checkIfLogin:self.navigationController]) {
                formView3.hidden = YES;
                self.logOutView2.hidden = NO;

                return;
            }
            else{
                formView3.hidden = NO;
            }
        }
        if (page + 1 == 2 || page + 1 == 5 || page + 1 == 6) {
            currentPage = page + 1;
        }
    }
}

//scrollview的委托方法，当滚动时执行
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:myScrollView]) {
        
        //滚动时先隐藏,然后再加载出来 begin
        tableViewConnect.hidden = YES;
        tableViewYY.hidden = YES;
        tableViewVideo.hidden = YES;
        //end
        
        int page = myScrollView.contentOffset.x/GetVWidth(myScrollView);
        
        [UIView animateWithDuration:0.3 animations:^{
            Baseline.frame = CGRectMake((Screen_Width/3-10)*page, 30, (Screen_Width/3-10), 2);
        }];
        
        if (page == 3) {
            if (listFBI.count<= 0) {
                [self getGuide:11];
            }
        }
        
        if (page >= listTitle.count-2 || page <= 2) {
            if (page <=2) {
                [UIView animateWithDuration:0.3 animations:^{
                    btnScrollView.contentOffset = CGPointMake(0, 0);
                }];
            }else{
                [UIView animateWithDuration:0.3 animations:^{
                    btnScrollView.contentOffset = CGPointMake(Screen_Width - 60, 0);
                }];
            }
            //            if (page == 1) {
            //                if (listGuide.count<= 0) {
            //                    [self getGuide:9];
            //                }
            //            }
        }
        else{
            [UIView animateWithDuration:0.3 animations:^{
                btnScrollView.contentOffset = CGPointMake((Screen_Width/3-10)*(page-1), 0);
            }];
        }
        
        NSLog(@"page = %d",page);
        
        
    }
}

-(void)ButtonEvents:(UIButton *)button
{
    self.editing = NO;
    if (button.tag <= listTitle.count) {
        //动画下划线的滑动
        [UIView animateWithDuration:0.3 animations:^{
            Baseline.frame = CGRectMake((Screen_Width/3-10)*(button.tag-1), 30, (Screen_Width/3-10), 2);
            myScrollView.contentOffset = CGPointMake(Screen_Width*(button.tag-1), 0);
        }];
        if (button.tag >= listTitle.count-2 || button.tag <= 2) {
            if (button.tag <=2) {
                [UIView animateWithDuration:0.3 animations:^{
                    btnScrollView.contentOffset = CGPointMake(0, 0);
                }];
            }else{
                [UIView animateWithDuration:0.3 animations:^{
                    btnScrollView.contentOffset = CGPointMake(Screen_Width - 60, 0);
                }];
            }
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                btnScrollView.contentOffset = CGPointMake((Screen_Width/3-10)*(button.tag-2), 0);
            }];
            
        }
    }
    if (button.tag == 2) {
        if (![FYHawkCommens checkIfLogin:self.navigationController]) {
            formView1.hidden = YES;
            self.logOutView.hidden = NO;

            return;
        }
        else{
            formView1.hidden = NO;
        }
        currentPage = 2;
        if (listGuide.count <= 0) {
            [self getGuide:9];
        }
    }
    else if (button.tag == 5) {
        if (![FYHawkCommens checkIfLogin:self.navigationController]) {
            formView2.hidden = YES;
            self.logOutView1.hidden = NO;

            return;
        }
        else{
            formView2.hidden = NO;
        }
        currentPage = 5;
        
        if (listFBI.count <= 0) {
            [self getGuide:11];
        }
    }
    else if(button.tag == 6){
        if (![FYHawkCommens checkIfLogin:self.navigationController]) {
            formView3.hidden = YES;
            self.logOutView2.hidden = NO;

            return;
        }
        else{
            formView3.hidden = NO;
        }
        currentPage = 6;
        
    }
}


#pragma mark ==
#pragma mark == Server API

- (void)checkButtonAction{
    
    if (currentPage == 2) {
        if([NSString isBlankString:self.caseYear.value])
        {
            [MBProgressHUD showError:@"案件年号不能为空"];
        }else if([NSString isBlankString:self.caseTextItem.value])
        {
            [MBProgressHUD showError:@"案件字号不能为空"];
            
        }else if([NSString isBlankString:self.caseNumItem.value])
        {
            [MBProgressHUD showError:@"案件编号不能为空"];
            
        }else if ([NSString isBlankString:self.nameItem.value])
        {
            [MBProgressHUD showError:@"姓名不能为空"];
            
        }
        else if ([NSString isBlankString:self.phoneNumItem.value])
        {
            [MBProgressHUD showError:@"手机号码不能为空"];
            
        }
        else if ([NSString isBlankString:self.cardItem.value])
        {
            [MBProgressHUD showError:@"与案关系不能为空"];
            
        }
        else if ([NSString isBlankString:self.longTextItem.value])
        {
            [MBProgressHUD showError:@"申请内容不能为空*"];
            
        }
        else
        {
            
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *token =  [defaults objectForKey:@"token"];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"token"] = token;
            params[@"ajnh"] = self.caseYear.value;
            params[@"fyjc"] = self.lowItem.value;
            params[@"ajzh"] = self.caseTextItem.value;
            params[@"ajbh"] = self.caseNumItem.value;
            params[@"name"] = self.nameItem.value;
            params[@"phone"] = self.phoneNumItem.value;
            params[@"gender"] = [NSString stringWithFormat:@"%ld",(long)self.sexItem.value];
            if (self.jobItem.value) {
                params[@"occupation"] = self.jobItem.value;
            }
            if (self.workItem.value) {
                params[@"company"] = self.workItem.value;
            }
            if (self.addressItem.value) {
                params[@"address"] = self.addressItem.value;
            }
            if (self.callItem.value) {
                params[@"telephone "] = self.callItem.value;
            }
            if (self.emailItem.value) {
                params[@"email"] = self.emailItem.value;
            }
            params[@"idNumber"] = self.cardItem.value;
            params[@"caseRelationship"] = [NSString stringWithFormat:@"%ld",itemSel];
            params[@"content"] = self.longTextItem.value;
            
            [self submitContact:params];
        }
    }
    if (currentPage == 5) {
        if([NSString isBlankString:self.caseYear1.value])
        {
            [MBProgressHUD showError:@"案件年号不能为空"];
        }else if([NSString isBlankString:self.caseTextItem1.value])
        {
            [MBProgressHUD showError:@"案件字号不能为空"];
            
        }else if([NSString isBlankString:self.caseNumItem1.value])
        {
            [MBProgressHUD showError:@"案件编号不能为空"];
            
        }else if ([NSString isBlankString:self.nameItem1.value])
        {
            [MBProgressHUD showError:@"姓名不能为空"];
            
        }
        else if ([NSString isBlankString:self.phoneNumItem1.value])
        {
            [MBProgressHUD showError:@"手机号码不能为空"];
            
        }
        else if ([NSString isBlankString:self.cardItem1.value])
        {
            [MBProgressHUD showError:@"与案关系不能为空"];
            
        }
        else if([NSString isBlankString:currentDateString]){
            [MBProgressHUD showError:@"录像时间选择不能为空"];
        }
        else if ([NSString isBlankString:self.longTextItem1.value])
        {
            [MBProgressHUD showError:@"申请内容不能为空"];
        }
        else
        {
            
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *token =  [defaults objectForKey:@"token"];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"token"] = token;
            params[@"ajnh"] = self.caseYear1.value;
            params[@"fyjc"] = self.lowItem1.value;
            params[@"ajzh"] = self.caseTextItem1.value;
            params[@"ajbh"] = self.caseNumItem1.value;
            params[@"name"] = self.nameItem1.value;
            params[@"phone"] = self.phoneNumItem1.value;
            params[@"gender"] = [NSString stringWithFormat:@"%ld",(long)self.sexItem1.value];
            if (self.jobItem1.value) {
                params[@"occupation"] = self.jobItem1.value;
            }
            if (self.workItem1.value) {
                params[@"company"] = self.workItem1.value;
            }
            if (self.addressItem1.value) {
                params[@"address"] = self.addressItem1.value;
            }
            if (self.callItem1.value) {
                params[@"telephone "] = self.callItem1.value;
            }
            if (self.emailItem1.value) {
                params[@"email"] = self.emailItem1.value;
            }
            params[@"idNumber"] = self.cardItem1.value;
            params[@"caseRelationship"] = [NSString stringWithFormat:@"%ld",itemSel1];
            params[@"movieDate"] = currentDateString;
            params[@"content"] = self.longTextItem1.value;
            
            [self submitApplicationVideo:params];
        }
    }
    if (currentPage == 6) {
        if([NSString isBlankString:self.caseYear2.value])
        {
            [MBProgressHUD showError:@"案件年号不能为空"];
        }else if([NSString isBlankString:self.caseTextItem2.value])
        {
            [MBProgressHUD showError:@"案件字号不能为空"];
            
        }else if([NSString isBlankString:self.caseNumItem2.value])
        {
            [MBProgressHUD showError:@"案件编号不能为空"];
            
        }else if ([NSString isBlankString:self.nameItem2.value])
        {
            [MBProgressHUD showError:@"姓名不能为空"];
            
        }
        else if ([NSString isBlankString:self.phoneNumItem2.value])
        {
            [MBProgressHUD showError:@"手机号码不能为空"];
            
        }
        else if ([NSString isBlankString:self.cardItem2.value])
        {
            [MBProgressHUD showError:@"与案关系不能为空"];
            
        }
        else if ([NSString isBlankString:self.longTextItem2.value])
        {
            [MBProgressHUD showError:@"申请内容不能为空"];
            
        }
        else
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *token =  [defaults objectForKey:@"token"];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"token"] = token;
            params[@"ajnh"] = self.caseYear2.value;
            params[@"fyjc"] = self.lowItem2.value;
            params[@"ajzh"] = self.caseTextItem2.value;
            params[@"ajbh"] = self.caseNumItem2.value;
            params[@"name"] = self.nameItem2.value;
            params[@"phone"] = self.phoneNumItem2.value;
            params[@"gender"] = [NSString stringWithFormat:@"%ld",(long)self.sexItem2.value];
            if (self.jobItem2.value) {
                params[@"occupation"] = self.jobItem2.value;
            }
            if (self.workItem2.value) {
                params[@"company"] = self.workItem2.value;
            }
            if (self.addressItem2.value) {
                params[@"address"] = self.addressItem2.value;
            }
            if (self.callItem2.value) {
                params[@"telephone "] = self.callItem2.value;
            }
            if (self.emailItem2.value) {
                params[@"email"] = self.emailItem2.value;
            }
            params[@"idNumber"] = self.cardItem2.value;
            params[@"caseRelationship"] = [NSString stringWithFormat:@"%ld",itemSel2];
            params[@"content"] = self.longTextItem2.value;
            [self submitVisit:params];
        }
    }
}

//联系大法官
- (void)submitContact:(NSDictionary *)params{
    NSLog(@"请求参数:%@",params);
    [FSHttpTool post:@"app/applicationFrom!lxfgAjax.action" params:params success:^(id json) {
        
    } failure:^(NSError *error) {
        
    }];
}

//看看录像
- (void)submitApplicationVideo:(NSDictionary *)params{
    NSLog(@"请求参数:%@",params);
    
    [FSHttpTool post:@"app/applicationFrom!lxsqAjax.action" params:params success:^(id json) {
        
    } failure:^(NSError *error) {
    }];
    
}

//拜访
- (void)submitVisit:(NSDictionary *)params{
    NSLog(@"请求参数:%@",params);
    [FSHttpTool post:@"app/applicationFrom!xfyyAjax.action" params:params success:^(id json) {
        
    } failure:^(NSError *error) {
    }];
    
}

@end
