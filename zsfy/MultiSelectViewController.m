//
//  MultiSelectViewController.m
//  UC_Demo_1.0.0
//
//  Created by Barry on 15/5/11.
//  Copyright (c) 2015年 Barry. All rights reserved.
//

#import "MultiSelectViewController.h"
#import "MultiSelectItem.h"
#import "MultiSelectTableViewCell.h"
#import "UIView+Convenience.h"
#import "LetterIndexNavigationView.h"
#import "MultiSelectedPanel.h"

#import "UIImageView+WebCache.h"

#import "ChatViewController.h"
#import "UCAlertView.h"
#import "BaseTabBarController.h"

#import "UCSIMClient.h"
#import "UCSUserInfo.h"


#define kDefaultSectionHeaderHeight 22.0f
#define kDefaultRowHeight 55.0f

@interface MultiSelectViewController ()<UITableViewDataSource, UITableViewDelegate, LetterIndexNavigationViewDelegate, MultiSelectedPanelDelegate>{
    
    NSString * _targetId;  // 讨论组ID
    UCAlertView * _alertView;
}

@property (nonatomic, strong) UITableView               *tableView;

@property (nonatomic, strong) NSMutableArray            *keys;
@property (nonatomic, strong) NSMutableDictionary       *dict;

@property (nonatomic, strong) LetterIndexNavigationView *letterIndexView;
@property (nonatomic, strong) MultiSelectedPanel        *selectedPanel;

@property (nonatomic, strong) NSMutableArray            * oldSelectedItems;// 旧的成员列表

@property (nonatomic, strong) NSMutableArray            *selectedItems;// 当前选中的成员列表
@property (nonatomic, strong) NSMutableArray            *selectedIndexes;//记录选择项对应的路径

@property (nonatomic        ) UCSelectType              selectType;//类型

@property (nonatomic, strong) UILabel                   * flotageLabel;


@end

@implementation MultiSelectViewController

- (instancetype)initWithType:(UCSelectType)type targetId:(NSString *) targetId{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _selectType = type;
        if (targetId != nil) {
            _targetId = targetId;
        }
    }
    
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self dealSeparator];
    [self setExtraCellLineHidden:self.tableView];
    [self stupNavItem];
}

- (void)dealSeparator
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)stupNavItem{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 10, 17)];
    [button addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setCustomLeftBarButtonItem:leftBarItem];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"确定   " style:UIBarButtonItemStyleDone target:self action:@selector(DialDiscussion)];
    [self.navigationItem setCustomRightBarButtonItem:rightBtn];
}


/*!
 *  @brief  异步排序,解决通讯录人太多卡顿
 */
- (void)asySortData{

    self.view.backgroundColor = [UIColor colorWithWhite:1.000 alpha:1.000];
    self.tableView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:1.000];
    
    
    [MBProgressHUD showMessage:@"加载中.." toView:self.view];
    
    
    _oldSelectedItems = [NSMutableArray array];

    
    WEAKSELF
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        //处理传递进来的数组成字典
        weakSelf.dict = [NSMutableDictionary dictionary];
        NSMutableArray *letters = [@[@"*", @"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#"]mutableCopy];
        for (NSString *letter in letters) {
            weakSelf.dict[letter] = [NSMutableArray array];//先初始化
        }
        
        //这里的思想是，先将3个测试账号移除self.items,把移除来的3个账号加到 * 块中
        NSMutableArray * testArray = [NSMutableArray array];
        NSMutableArray * testItemsArray = [weakSelf.items mutableCopy];
        
        
        
        for (MultiSelectItem *item in testItemsArray) {
            NSString *firstLetter = [self firstLetterOfString:item.name];
            [weakSelf.dict[firstLetter] addObject:item]; //对应的字母数组添加元素。
        }
        
        //删除没有元素的字母key
        for (NSString *key in [weakSelf.dict allKeys]) {
            if (((NSArray*)weakSelf.dict[key]).count<=0) {
                [weakSelf.dict removeObjectForKey:key];
                [letters removeObject:key]; //由于字典是无序的，这里刚好把此数组作为有效key的排序结果。
            }else{
                //对这个数组进行字母排序，系统方法就可以对汉字排序，第一个汉字的首字母，第二个字母。。。这样来排序。
                weakSelf.dict[key] = [((NSArray*)weakSelf.dict[key]) sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                    return [((MultiSelectItem *)obj1).name localizedCompare:((MultiSelectItem *)obj2).name];
                }];
            }
        }
        
        //整理完毕，将key的排序结果记录
        weakSelf.keys = letters;
//        weakSelf.letterIndexView.keys = weakSelf.keys;
        
        //找到已经选择的项目
        NSMutableArray *selectedItems = [NSMutableArray array];
        NSMutableArray *selectedIndexes = [NSMutableArray array];
        for (NSUInteger section=0; section<weakSelf.keys.count; section++) {
            for (NSUInteger row=0; row<((NSArray*)weakSelf.dict[weakSelf.keys[section]]).count; row++) {
                MultiSelectItem *item = weakSelf.dict[weakSelf.keys[section]][row];
                if (!item.disabled&&item.selected) {
                    [selectedItems addObject:item];
                    [selectedIndexes addObject:[NSIndexPath indexPathForRow:row inSection:section]];
                }
            }
        }
        
        
        //保存旧的成员列表
        weakSelf.oldSelectedItems = [selectedItems mutableCopy];
        
        weakSelf.selectedItems = selectedItems;
        weakSelf.selectedIndexes = selectedIndexes;
//        weakSelf.selectedPanel.selectedItems = weakSelf.selectedItems;
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            weakSelf.letterIndexView.keys = weakSelf.keys;
            weakSelf.selectedPanel.selectedItems = weakSelf.selectedItems;
            
            [weakSelf.view addSubview:weakSelf.tableView];
            [weakSelf.view addSubview:weakSelf.letterIndexView];
            [weakSelf.view addSubview:weakSelf.selectedPanel];
            
            
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            
        });
        
    });
    
}




- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    
    [self asySortData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*!
 *  @brief  增加讨论组成员
 */
- (void)addDiscussionMember{
    
    [MBProgressHUD showMessage:@"正在添加成员.." toView:self.view];
    
    NSMutableArray * selectedArray = [self.selectedItems mutableCopy];
    
    [selectedArray removeObjectsInArray:_oldSelectedItems]; //移除旧的成员
    
    NSMutableArray * array  = [NSMutableArray array];
    for (int i = 0;  i < selectedArray.count; i++) {
        UCSUserInfo * info = [[UCSUserInfo alloc] init];
        info.name = [selectedArray[i] valueForKeyPath:@"name"];
        info.portraitUri = [selectedArray[i] valueForKeyPath:@"imageURL"];
        info.userId = [selectedArray[i] valueForKeyPath:@"userId"];
        [array addObject:info];
    }
    
    NSArray * memberArray = [array copy];
    
    [[UCSIMClient sharedIM] addMemberToDiscussionWithDiscussionId:_targetId memberArray:memberArray success:^(UCSDiscussion *discussion) {

            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showSuccess:@"添加成员成功" toView:self.view];
            
            //通知前一个页面好友成员增加了
            [[NSNotificationCenter defaultCenter] postNotificationName:DiscussionMembersDidAddNotification object:nil];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self popViewController];
        });
        
    } failure:^(UCSError *error) {

            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showError:@"添加成员失败(注：非注册用户无法加入)" toView:self.view];

    }];

    
}


/*!
 *  @brief  创建讨论组
 */
- (void) createDiscussion:(NSString *)string{
    
    [MBProgressHUD showMessage:@"正在创建讨论组" toView:self.view];
    
    
    NSMutableArray * array  = [NSMutableArray array];
    
    for (MultiSelectItem * item  in _selectedItems) {
        UCSUserInfo * info = [[UCSUserInfo alloc] init];
        info.userId = item.userId;
        info.name = item.name;
        [array addObject:info];
    }
    
    NSArray * memberArray = [array copy];
    
    //拼接讨论组名字
    NSString * topic = [NSString stringWithString:string];
    
    
    [[UCSIMClient sharedIM] createDiscussionWithTopic:topic memberArray:memberArray success:^(UCSDiscussion *discussion) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showSuccess:@"创建成功" toView:self.view];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            //会话界面被选中
            [self.navigationController popViewControllerAnimated:YES];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:DidCreateDiscussionNotification object:discussion];
        });

    } failure:^(UCSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error.code == ErrorCode_TIMEOUT) {
            [MBProgressHUD showError:@"创建超时" toView:self.view];
        }else{
            [MBProgressHUD showError:@"创建失败(注：非注册用户无法加入)" toView:self.view];
        }

    }];
    

}

#pragma mark - getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.scrollsToTop = YES;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}



- (LetterIndexNavigationView *)letterIndexView
{
    if (!_letterIndexView) {
        _letterIndexView = [[LetterIndexNavigationView alloc]init];
        _letterIndexView.isNeedSearchIcon = NO;
        _letterIndexView.delegate = self;
    }
    return _letterIndexView;
}

- (MultiSelectedPanel *)selectedPanel
{
    if (!_selectedPanel) {
        _selectedPanel = [[MultiSelectedPanel alloc] initWithFrame:CGRectMake(0, self.tableView.frameBottom, self.view.frameWidth, 44.0f)];
        _selectedPanel.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        _selectedPanel.delegate = self;
        _selectedPanel.hidden = YES;
    }
    return _selectedPanel;
}


- (UILabel *)flotageLabel
{
    if (_flotageLabel == nil)
    {
        _flotageLabel = [[UILabel alloc] initWithFrame:(CGRect){(self.view.bounds.size.width - 64 ) / 2,(self.view.bounds.size.height - 64) / 2,64,64}];
        _flotageLabel.backgroundColor = RGBACOLOR(93, 93, 95, 1);//[UIColor colorWithPatternImage:[UIImage imageNamed:@"flotageBackgroud"]];
        _flotageLabel.hidden = YES;
        _flotageLabel.textAlignment = NSTextAlignmentCenter;
        _flotageLabel.textColor = [UIColor whiteColor];
//        _flotageLabel.layer.masksToBounds = YES;
//        _flotageLabel.layer.cornerRadius = 5.0f;
        [self.view addSubview:_flotageLabel];
        
    }
    return _flotageLabel;
    
}




#pragma mark - layout
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
#define kSelectPanelHeight 0.0f
    self.tableView.frame = CGRectMake(0, 0, self.view.frameWidth, self.view.frameHeight-kSelectPanelHeight);
    
    CGFloat topY = 0.0f;
    //导航View的位置
    if (IOS_VERSION>=7.0) { //简单处理下适配吧
        topY += 20.0f;
        topY += (self.view.frameHeight>self.view.frameWidth)?44.0f:32.0f;
    }
    self.letterIndexView.frame = CGRectMake(self.tableView.frameRight-20.0f, topY, 20.0f, self.view.frameHeight-kSelectPanelHeight-topY);
    
    self.selectedPanel.frame = CGRectMake(0, self.tableView.frameBottom, self.view.frameWidth, kSelectPanelHeight);
    
}


#pragma mark - letter index delegate
- (void)LetterIndexNavigationView:(LetterIndexNavigationView *)LetterIndexNavigationView didSelectIndex:(NSInteger)index
{
    if (index==0) {
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    }else{
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index-1] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        self.flotageLabel.text = self.letterIndexView.keys[index-1];

    }
    

}


- (void)tableViewIndexTouchesBegan:(LetterIndexNavigationView *)tableViewIndex
{
    self.flotageLabel.hidden = NO;
    
}


- (void)tableViewIndexTouchesEnd:(LetterIndexNavigationView *)tableViewIndex
{
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.duration = 0.4;
    [self.flotageLabel.layer addAnimation:animation forKey:nil];
    
    self.flotageLabel.hidden = YES;
    
//    [UIView animateWithDuration:0.4 animations:^{
//        self.flotageLabel.alpha = 0;
//    } completion:^(BOOL finished) {
//        self.flotageLabel.alpha = 1;
//        self.flotageLabel.hidden = YES;
//        
//    }];

    
}


#pragma mark - tableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([tableView isEqual:self.tableView]) {
        return self.keys.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [((NSArray*)self.dict[self.keys[section]]) count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    
    if (indexPath.section == 0) {
        CellIdentifier = @"MultiSelectTableViewCellTest";
        
    }else{
        CellIdentifier = @"MultiSelectTableViewCell";
    }
    
    
    MultiSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[MultiSelectTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    MultiSelectItem *item = ((NSArray*)self.dict[self.keys[indexPath.section]])[indexPath.row];
    
    [cell.cellImageView sd_setImageWithURL:item.imageURL placeholderImage:item.placeHolderImage];
    cell.testLabel.text = item.name;
    
    if (item.disabled) {
        cell.selectState = MultiSelectTableViewSelectStateDisabled;
    }else{
        cell.selectState = item.selected?MultiSelectTableViewSelectStateSelected:MultiSelectTableViewSelectStateNoSelected;
    }
    
    return cell;
    
}

#pragma mark - tableView delegate
//section 头部,为了IOS6的美化
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:self.tableView]) {
        UIView *customHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frameWidth, kDefaultSectionHeaderHeight)];
        customHeaderView.backgroundColor = [UIColor colorWithRed:0.926 green:0.920 blue:0.956 alpha:1.000];
        UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 0, customHeaderView.frameWidth-15.0f, kDefaultSectionHeaderHeight)];
        headerLabel.text = self.keys[section];
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        headerLabel.textColor = [UIColor darkGrayColor];
        [customHeaderView addSubview:headerLabel];
        return customHeaderView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:self.tableView]) {
        return kDefaultSectionHeaderHeight;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kDefaultRowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
        MultiSelectItem *item = ((NSArray*)self.dict[self.keys[indexPath.section]])[indexPath.row];
        if (item.disabled) {  //不能被选择
            return;
        }
    
        item.selected = !item.selected;
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        if (item.selected) {
            //告诉panel应该添加
            [self.selectedItems addObject:item];
            [self.selectedIndexes addObject:indexPath];
            
            [self.selectedPanel didAddSelectedIndex:self.selectedItems.count-1];
        }else{
            //告诉panel应该删除
            NSUInteger index = [self.selectedItems indexOfObject:item];
            
            [self.selectedItems removeObject:item];
            [self.selectedIndexes removeObject:indexPath];
            
            if (index!=NSNotFound) {
                [self.selectedPanel didDeleteSelectedIndex:index];
            }
        }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - common
- (NSString*)firstLetterOfString:(NSString*)chinese
{
    CFMutableStringRef string = CFStringCreateMutableCopy(NULL, 0, (__bridge CFMutableStringRef)[NSMutableString stringWithString:chinese]);
    CFStringTransform(string, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform(string, NULL, kCFStringTransformStripDiacritics, NO);
    
    NSMutableString *aNSString = (__bridge NSMutableString *)string;
    NSString *finalString = [aNSString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%c", 32] withString:@""];
    
    
    NSString *firstLetter = [[finalString substringToIndex:1]uppercaseString];
    if (!firstLetter||firstLetter.length<=0) {
        firstLetter = @"#";
    }else{
        unichar letter = [firstLetter characterAtIndex:0];
        if (letter<65||letter>90) {
            firstLetter = @"#";
        }
    }
    return firstLetter;
}



#pragma mark - selelcted panel delegate
- (void)willDeleteRowWithItem:(MultiSelectItem*)item withMultiSelectedPanel:(MultiSelectedPanel*)multiSelectedPanel
{
    //在此做对数组元素的删除工作
    NSUInteger index = [self.selectedItems indexOfObject:item];
    if (index==NSNotFound) {
        return;
    }
    
    item.selected = NO;
    
    NSIndexPath *indexPath = self.selectedIndexes[index];
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    [self.selectedItems removeObjectAtIndex:index];
    [self.selectedIndexes removeObjectAtIndex:index];
}

- (void)DialDiscussion
{
    

    
    if (_selectType == UCSelectTypeCreate) {
        NSString *title = @"请输入讨论组标题:";
        NSString *cancelButtonTitle = @"取消";
        NSString *otherButtonTitle = @"确定";
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        // Add the text field for the secure text entry.
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            // Listen for changes to the text field's text so that we can toggle the current
            // action's enabled property based on whether the user has entered a sufficiently
            // secure entry.
            
        }];
        // Create the actions.
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self createDiscussion:alertController.textFields[0].text];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:otherAction];
        
        [self presentViewController:alertController animated:YES completion:nil];

    }else if (_selectType == UCSelectTypeAdd) {
        
        [self addDiscussionMember];
    }else{}
}

- (void)didConfirmWithMultiSelectedPanel:(MultiSelectedPanel*)multiSelectedPanel
{
    
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

@end
