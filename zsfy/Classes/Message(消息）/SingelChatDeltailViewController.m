//
//  SingelChatDeltailViewController.m
//  UC_Demo_1.0.0
//
//  Created by Barry on 15/5/23.
//  Copyright (c) 2015年 Barry. All rights reserved.
//

#import "SingelChatDeltailViewController.h"
#import "ChatViewController.h"
#import "Search.h"
#import "FriendModel.h"
#import "UCAlertView.h"
#import "ContactView.h"
#import "UCSUserInfo.h"
#import "MultiSelectItem.h"
#import "MultiSelectViewController.h"
#import "BaseNavigationViewController.h"
#import "ChatBackGroudImageViewController.h"
#import "ComUnit.h"
#import "Helper.h"
#import "FriendModel.h"
#import "SendMsgBtnTVC.h"
#import "Search.h"
#import "UCSIMClient.h"
#import "AcceptTVC.h"



#define kColOfRow 4 //每行几个成员

#define KVmembersViewMargin 0   //垂直间距
#define kHmembersViewMargin 0   //水平间距

#define  kContactViewH  90

@interface SingelChatDeltailViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    BOOL _isEditing;
    BOOL _flag;
    NSString * _chatter;
    UCS_IM_ConversationType _type;
}

@property (nonatomic ,strong) NSMutableArray * dataSource;

@property (nonatomic ,strong) UIButton * addButton;

@property (nonatomic, strong) UIView * footerView;
@property (nonatomic, strong) UIView * membersView; //容纳讨论组成员的容器


@property (nonatomic ,strong) UITableView * tableView;

@property (nonatomic ,strong) NSMutableArray * members; //创建组的成员列表

@property (nonatomic, strong) UCAlertView * alertView;

@property (nonatomic, strong) FriendModel *FriendInfo;

@end

@implementation SingelChatDeltailViewController

- (instancetype)initWithChatter:(NSString *) chatter type:(UCS_IM_ConversationType) type Flag:(BOOL)flag{
    self = [super init];
    if (self) {
        // Custom initialization
        _chatter = chatter;
        _type = type;
        _flag = flag;
        _dataSource = [NSMutableArray array];
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"聊天信息";
    [self initDataSource];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"AcceptTVC" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Accept"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SendMsgBtnTVC" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SendMsgBtnTVC"];
    [ComUnit getPersonInfo:[Helper getUser_Token] PersonId:_chatter Callback:^(FriendModel *item, BOOL succeed) {
        if (succeed) {
            self.FriendInfo = item;
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [self setupBarButtonItem];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}


#pragma mark private
- (void)initDataSource{
    NSArray * array  = @[_chatter];
    [_dataSource addObjectsFromArray:array];
}

- (void)setupBarButtonItem{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 10, 17)];
    button.imageView.contentMode = UIViewContentModeLeft;
    [button addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setCustomLeftBarButtonItem:leftBarItem];
}

- (void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}




- (void)updateMemberView{
    [self.membersView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSUInteger  count = [_dataSource count]; //几个成员
    NSUInteger totalCount = count + 1; //加上加按钮
    
    int row = (int)totalCount / kColOfRow;
    if ((int)totalCount%kColOfRow > 0) {
        row = row + 1;
    }
    self.membersView.frame = CGRectMake(kHmembersViewMargin, KVmembersViewMargin, self.view.frame.size.width - 2 * kHmembersViewMargin, row * kContactViewH);
    
    
    CGFloat contactViewW = CGRectGetWidth(self.membersView.frame) / kColOfRow;
    
    int i = 0;
    int j = 0;
    for ( i= 0 ; i < row; i ++) {
        for ( j = 0 ; j < kColOfRow; j++) {
            NSInteger index = i * kColOfRow + j;
            
            if (index < totalCount) {
                if (index < count) {  //成员头像
                    ContactView * contactView = [[ContactView alloc] initWithFrame:CGRectMake( j * contactViewW , i * kContactViewH , contactViewW, kContactViewH)];
                    AddressBook * addressbook = [[AddressBookManager sharedInstance] checkAddressBook:[_dataSource objectAtIndex:index]];
                    if (addressbook) {
                        contactView.index  = index;
                       // contactView.image = addressbook.head;
                        contactView.remark = addressbook.name;
                    }else{
                        contactView.index = index;
                       // contactView.image = [UIImage imageNamed:@"Head"];
                        contactView.contentMode = UIViewContentModeScaleAspectFit;
                        [ComUnit getFriendInfo:[Helper getUser_Token] targetID:[_dataSource objectAtIndex:index] Callback:^(FriendModel *item, BOOL succeed) {
                            if (succeed) {
                                contactView.remark = item.nikeName;
                                contactView.imageUrl = item.imageUrl;
                            }
                            
                        }];
                    }
                    contactView.editing = _isEditing;
                    [self.membersView addSubview:contactView];
                    
                    
                }else if( index == totalCount - 1){  //加号
                    self.addButton.frame = CGRectMake( j * contactViewW , i * kContactViewH , contactViewW, kContactViewH);
                    [self.membersView addSubview:self.addButton];
                    
                }else{
                    
                }
                
            }
        }
        
    }
    
}

- (void)selectMembers:(UIButton *) button{
    
    [self addContactForGroup];
}



- (void)addContactForGroup {
    
    //获取到所有的通信录数据
    
    NSMutableArray * items = [NSMutableArray array];
    
    [ComUnit getFriendList:[Helper getUser_Token] Callback:^(NSArray *allFriendInfo, BOOL succeed) {
        if (succeed) {
            for (NSUInteger i=0; i<allFriendInfo.count; i++) {
                FriendModel * addressBook = allFriendInfo[i];
                MultiSelectItem *item = [[MultiSelectItem alloc]init];
                item.name = addressBook.nikeName;
                item.userId = addressBook.Fid;
                item.imageURL = [NSURL URLWithString:addressBook.imageUrl];
                item.placeHolderImage = [UIImage imageNamed:@"Head"];
                
                if ([_chatter isEqualToString:item.userId]) {  //当前聊天的对象设为默认选中，且不能取消选中
                    item.disabled = YES;
                    item.selected = YES;
                }
                
                [items addObject:item];
            }
            MultiSelectViewController *vc = [[MultiSelectViewController alloc] initWithType:UCSelectTypeCreate targetId:_chatter];
            vc.items = items;
            
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    
    
    
}



//清空聊天记录
- (void)clearMessages{
    self.alertView = [[UCAlertView alloc] initWithTitle:nil message:@"删除当前的聊天记录吗?" cancelButtonTitle:@"取消" otherButtonTitles:@"清空" cancelButtonBlock:^{
        
    } otherButtonBlock:^{
        
        [MBProgressHUD showMessage:@"删除消息记录中.." toView:self.view];
        BOOL ret = [[UCSIMClient sharedIM] clearMessages:UCS_IM_SOLOCHAT targetId:_chatter];
        if (ret) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:ChatMessageDidCleanNotification object:_chatter];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showSuccess:@"已删除" toView:self.view];
        }else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showError:@"删除失败" toView:self.view];
        }
        
    }];
    
}



#pragma mark getter
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height ) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _tableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = self.footerView;
    }
    
    return _tableView;
}


- (UIView *)footerView{
    UIView * view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, self.view.frame.size.width, 90);
    
    return view;
}

- (UIView *)membersView{
    if (_membersView == nil) {
        _membersView = [[UIView alloc] initWithFrame:CGRectMake(kHmembersViewMargin, KVmembersViewMargin, self.view.frame.size.width - 2 * kHmembersViewMargin, 0)];
        [self updateMemberView];
    }
    
    return _membersView;
}

- (UIButton *)addButton{
    if (!_addButton) {
        _addButton  = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setImage:[UIImage imageNamed:@"discussion_add"] forState:UIControlStateNormal];
        [_addButton setImage:[UIImage imageNamed:@"discussion_addHL"] forState:UIControlStateHighlighted];
        [_addButton addTarget:self action:@selector(selectMembers:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}


#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    BOOL isFriend = [[Search shareInstance] checkFriend:_chatter];
    if (!isFriend) {
        if (_flag) {
            return 2;
        } else {
            return 5;
        }
    } else {
        if (_flag) {
            return 3;
        } else {
            return 6;
        }

    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if(section == 1){
        return 1;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell1"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell1"];
        }
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.FriendInfo.imageUrl] placeholderImage:[UIImage imageNamed:@"Head"]];
        cell.textLabel.text = self.FriendInfo.nikeName;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.detailTextLabel.textColor = [UIColor grayColor];
        cell.detailTextLabel.text = [self getType:self.FriendInfo.userType];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
        return cell;

        
    }
    
    if (indexPath.section == 1 && indexPath.row == 0 ) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell2"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell2"];
        }
        cell.textLabel.text = @"地区";
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.detailTextLabel.textColor = [UIColor grayColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
        cell.detailTextLabel.text = self.FriendInfo.address;
        return cell;
        
        
    } else if (indexPath.section == 2 && indexPath.row == 0 ) {
        if (_flag) {
            SendMsgBtnTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"SendMsgBtnTVC"];
            return cell;
        } else {
            AcceptTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"Accept"];
            cell.targetId = _chatter;
            [cell setInfo:@"接收消息" Type:0];
            return cell;
        }
       
    } else if (indexPath.section == 3 && indexPath.row == 0){
        UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        cell.textLabel.text = @"更换聊天背景";
        cell.textLabel.textColor = UIColorFromRGB(0x383838);
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        return cell;
    } else if(indexPath.section == 4 && indexPath.row == 0) {
        UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        cell.textLabel.text = @"清空聊天记录";
        cell.textLabel.textColor = UIColorFromRGB(0x383838);
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        return cell;
    } else {
        SendMsgBtnTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"SendMsgBtnTVC"];
        return cell;
    }
    
    
    //    if (indexPath.section == 2 && indexPath.row == 1 ) {
    //        cell.textLabel.text = @"清空聊天记录";
    //        cell.textLabel.textColor = UIColorFromRGB(0x383838);
    //        cell.textLabel.font = [UIFont systemFontOfSize:14];
    //    }
    

}

- (NSString *)getType:(NSString *)userType
{
    if ([userType isEqualToString:@"0"]) {
        return @"当事人";
    } if ([userType isEqualToString:@"1"]) {
        return @"律师";
    } else {
        return @"法官";
    }
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 58;
    } else {
        return 45;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_flag) {
        if (indexPath.section == 2) {
            ChatViewController *desVC = [[ChatViewController alloc] initWithChatter:_chatter type:UCS_IM_SOLOCHAT];
            desVC.navigationItem.title = [[Search shareInstance] getNickName:_chatter];
            [self.navigationController pushViewController:desVC animated:YES];
        }
    }
    if (indexPath.section == 3 && indexPath.row == 0) {
        
        ChatBackGroudImageViewController * chatBackGroudImageViewController = [[ChatBackGroudImageViewController alloc] initWithChatter:_chatter];
        [self.navigationController pushViewController:chatBackGroudImageViewController animated:YES];
    }else if (indexPath.section == 4 && indexPath.row == 0){
        //清空聊天记录
        [self clearMessages];
    }else if (indexPath.section == 5 && indexPath.row == 0){
        ChatViewController *desVC = [[ChatViewController alloc] initWithChatter:_chatter type:UCS_IM_SOLOCHAT];
        desVC.navigationItem.title = [[Search shareInstance] getNickName:_chatter];
        [self.navigationController pushViewController:desVC animated:YES];
    } else {
        
    }
}

@end
