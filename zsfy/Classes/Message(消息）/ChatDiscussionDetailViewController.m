//
//  ChatDiscussionDetailViewController.m
//  UC_Demo_1.0.0
//
//  Created by Barry on 15/5/12.
//  Copyright (c) 2015年 Barry. All rights reserved.
//

#import "SingelChatDeltailViewController.h"
#import "ChatDiscussionDetailViewController.h"
#import "ContactView.h"
#import "ComUnit.h"
#import "AcceptTVC.h"
#import "FriendModel.h"
#import "Helper.h"
#import "Search.h"
#import "ChatBackGroudImageViewController.h"

#import "MultiSelectItem.h"
#import "MultiSelectViewController.h"
#import "BaseNavigationViewController.h"
#import "UCAlertView.h"


#define kColOfRow 4 //每行几个成员

#define KVmembersViewMargin 0   //垂直间距
#define kHmembersViewMargin 0   //水平间距

#define  kContactViewH  90

#define KFont 15

@interface ChatDiscussionDetailViewController ()<UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate, UCSIMClientDelegate, UIGestureRecognizerDelegate>
{
    BOOL _isEditing;
    NSString * _targetId;
    UCSDiscussion * _discussion;
    UCS_IM_ConversationType  _type;
    UILabel * _discussionNameLabel; //显示讨论组名的label
}

@property (nonatomic ,strong) NSMutableArray * dataSource;

@property (nonatomic ,strong) UIButton       * addButton;
@property (nonatomic, strong) UIButton       * removeButton;

@property (nonatomic, strong) UIView         * footerView;
@property (nonatomic, strong) UIView         * membersView;//容纳讨论组成员的容器

@property (nonatomic, strong) UIButton       * exitButton;

@property (nonatomic ,strong) UITableView    * tableView;

@property (nonatomic ,strong) NSMutableArray * members;//加入组的成员列表

@property (nonatomic, strong) UCAlertView    * alertView;

@end

@implementation ChatDiscussionDetailViewController


- (instancetype)initWithDiscussionId:(NSString *)chatDiscussionId type:(UCS_IM_ConversationType) type{
    self = [super init];
    if (self) {
        // Custom initialization
        _targetId = chatDiscussionId;
        _dataSource = [NSMutableArray array];
        _type = type;
        _isEditing = NO; //进入编辑模式
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UCSIMClient sharedIM] setDelegate:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDataSource:) name:DiscussionMembersDidAddNotification object:nil];
    // 监听是否被移除讨论组
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removedADiscussion:) name:RemovedADiscussionNotification object:nil];
    
    self.title = @"讨论组信息";
    [self initDataSource];
    [self.view addSubview:self.tableView];
   
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

- (void)initDataSource{
    
    _discussion = [[UCSIMClient sharedIM] getDiscussionInfoWithDiscussionId:_targetId];
    
    NSArray * memberIdList = [Helper getMemberIdList:_discussion.memberList];
    [_dataSource removeAllObjects];
    [_dataSource addObjectsFromArray:memberIdList];
}

- (void)refreshDataSource:(NSNotification *) note{
    
    [self initDataSource];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateMemberView];
        [self.tableView reloadData];
    });
   
}

- (void)setupBarButtonItem{
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 10, 17)];
    [button addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    button.imageView.contentMode = UIViewContentModeLeft;
    [button setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setCustomLeftBarButtonItem:leftBarItem];
}

- (void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)popToRoot{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/**
 *  被踢出讨论组
 */
- (void)removedADiscussion:(NSNotification *)note
{
    NSString * discussionId = (NSString *)note.object;
    if ([discussionId isEqualToString:_targetId]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
}

/**
 *  取消编辑用户
 */
- (void)cancleEdit{
    
    if (_isEditing) {
        _isEditing = NO;
        [self updateMemberView];
        [self.tableView reloadData];
    }
}


/*!
 *  @brief  是不是讨论组的拥有者，最高权限，可以删除用户
 */
- (BOOL)isOwner{
    BOOL ret = NO;
    NSString * currentUserID = [Helper getUserID];
    if ([_discussion.creatorId isEqualToString:currentUserID]) {
        ret = YES;
    }
    
    return ret;
}




- (void)updateMemberView{
    [_membersView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if ([self isOwner]) {
        
        NSUInteger  count = [_dataSource count]; //几个成员
        NSUInteger totalCount = count + 2; //加上加减按钮
        
        int row = (int)totalCount / kColOfRow;
        if ((int)totalCount%kColOfRow > 0) {
            row = row + 1;
        }
        _membersView.frame = CGRectMake(kHmembersViewMargin, KVmembersViewMargin, self.view.frame.size.width - 2 * kHmembersViewMargin, row * kContactViewH);
        
        
        
        CGFloat contactViewW = CGRectGetWidth(_membersView.frame) / kColOfRow;
        
        int i = 0;
        int j = 0;
        for ( i= 0 ; i < row; i ++) {
            for ( j = 0 ; j < kColOfRow; j++) {
                NSInteger index = i * kColOfRow + j;
                
                if (index < totalCount) {
                    if (index < count) {  //成员头像
                        ContactView * contactView = [[ContactView alloc] initWithFrame:CGRectMake( j * contactViewW , i * kContactViewH , contactViewW, kContactViewH)];
                        NSString * memberPhone = [_dataSource objectAtIndex:index];
                        contactView.UserID = memberPhone;
                        NSString * meString ;
                        if ([memberPhone isEqualToString:[Helper getUserID]]) {
                            meString = @"我";
                        }
                        contactView.index = index;
                        [ComUnit getFriendInfo:[Helper getUser_Token] targetID:[_dataSource  objectAtIndex:index] Callback:^(FriendModel *item, BOOL succeed) {
                            contactView.remark = (meString && meString.length > 0)? meString : item.nikeName;
                            contactView.imageUrl = item.imageUrl;
                            
                        }];
                        contactView.editing = _isEditing;

                        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterDetail:)];
                        tap.delegate = self;
                        [contactView addGestureRecognizer:tap];
                        [self.membersView addSubview:contactView];
                        //自己不能删
                        if (index == 0) {
                            contactView.editing = NO;
                        }
                        
                        [_membersView addSubview:contactView];
                        
                        __weak typeof(self) weakSelf = self;
                        [contactView setDeleteContact:^(NSInteger index) {
                            
                            //要删除的成员
                            UCSUserInfo * info = [[UCSUserInfo alloc] init];
                            info.userId = _dataSource[index];
                            NSArray *memberArray = @[info];
                            
                            //判断是不是自己，自己不能删
                            NSString * currentUserID = [Helper getUserID];
                            if ([info.userId isEqualToString:currentUserID]) {
                                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不能删除自己" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好", nil];
                                [alertView show];
                                return ;
                            }
                            
                            
                            [MBProgressHUD showMessage:@"正在移除成员.." toView:self.view];
                            
                            [[UCSIMClient sharedIM] removeMemberFromDiscussionWithDiscussionId:_targetId memberArray:memberArray success:^(UCSDiscussion *discussion) {
        
                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                                [MBProgressHUD showSuccess:@"移除成员成功" toView:self.view];
                                    
                                [_dataSource removeObjectAtIndex:index];
                                    
                                [weakSelf updateMemberView];
                                    
                                [weakSelf.tableView reloadData];
         
                            } failure:^(UCSError *error) {
                                
                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                                [MBProgressHUD showError:@"移除成员失败" toView:self.view];
                            }];
                            
                        }];
                        
                    }else if( index == totalCount - 2){  //加号
                        self.addButton.frame = CGRectMake( j * contactViewW , i * kContactViewH , contactViewW, kContactViewH);
                        [self.membersView addSubview:self.addButton];
                        
                    }else if(index == totalCount - 1){
                        self.removeButton.frame = CGRectMake( j * contactViewW , i * kContactViewH , contactViewW, kContactViewH);
                        [self.membersView addSubview:self.removeButton];
                    }else{
                        
                    }
                    
                }
            }
            
        }
        
        
    }else{
        
        NSUInteger  count = [_dataSource count]; //几个成员
        NSUInteger totalCount = count + 1; //加上加按钮
        
        int row = (int)totalCount / kColOfRow;
        if ((int)totalCount%kColOfRow > 0) {
            row = row + 1;
        }
        _membersView.frame = CGRectMake(kHmembersViewMargin, KVmembersViewMargin, self.view.frame.size.width - 2 * kHmembersViewMargin, row * kContactViewH);
        
        CGFloat contactViewW = CGRectGetWidth(_membersView.frame) / kColOfRow;
        
        int i = 0;
        int j = 0;
        for ( i= 0 ; i < row; i ++) {
            for ( j = 0 ; j < kColOfRow; j++) {
                NSInteger index = i * kColOfRow + j;
                
                if (index < totalCount) {
                    if (index < count) {  //成员头像
                        ContactView * contactView = [[ContactView alloc] initWithFrame:CGRectMake( j * contactViewW , i * kContactViewH , contactViewW, kContactViewH)];
                        
                        NSString * memberPhone = [_dataSource objectAtIndex:index];
                        contactView.UserID = memberPhone;
                        
                        NSString * meString ;
                        if ([memberPhone isEqualToString:[Helper getUserID]]) {
                            meString = @"我";
                        }
                        
                        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterDetail:)];
                        tap.delegate = self;
                        [contactView addGestureRecognizer:tap];
                        [self.membersView addSubview:contactView];
                        contactView.index = index;
                        [ComUnit getFriendInfo:[Helper getUser_Token] targetID:[_dataSource objectAtIndex:index] Callback:^(FriendModel *item, BOOL succeed) {
                            if (succeed) {
                                contactView.remark = (meString && meString.length > 0)? meString : item.nikeName;
                                contactView.imageUrl = item.imageUrl;
                            }
                        }];
                        contactView.editing = _isEditing;
                        [self.membersView addSubview:contactView];
                        [_membersView addSubview:contactView];
                    }else if( index == totalCount - 1){  //加号
                        self.addButton.frame = CGRectMake( j * contactViewW , i * kContactViewH , contactViewW, kContactViewH);
                        [_membersView addSubview:self.addButton];
                        
                    }else{
                        
                    }
                    
                }
            }
            
        }
    }
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)enterDetail:(UITapGestureRecognizer *)sender
{
    NSString *UserID =  [(ContactView *)sender.view UserID];
    SingelChatDeltailViewController *desVC = [[SingelChatDeltailViewController alloc] initWithChatter:UserID type:UCS_IM_SOLOCHAT Flag:YES];
    [self.navigationController pushViewController:desVC animated:YES];
}

- (void)selectMembers:(UIButton *) button{
    
    [self addContactForGroup];
    
}

- (void)removeMembers:(UIButton *) button{
    if (_dataSource.count == 0) {
        return;
    }
    _isEditing = !_isEditing;
    [self  updateMemberView];
    [self.tableView reloadData];
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
                
                for (NSString * nameId in _dataSource) {
                    if ([nameId isEqualToString:item.userId]) {
                        item.selected = YES;
                        item.disabled = YES;
                    }
                }
                
                [items addObject:item];
            }
            MultiSelectViewController *vc = [[MultiSelectViewController alloc] initWithType:UCSelectTypeAdd targetId:_targetId];
            vc.navigationItem.title = @"邀请好友";
            vc.items = items;
            
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];

    
}



//修改讨论组名称
- (void)editDiscussionName{
    
    _alertView = [[UCAlertView alloc] initWithTitle:@"讨论组名称" message:nil textFieldHint:@"新的讨论组名称" textFieldValue:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定" cancelButtonBlock:^{
        
    } otherButtonBlock:^(NSString * newName) {
        
        [MBProgressHUD showMessage:@"正在修改讨论组名称.." toView:self.view];
        
        [[UCSIMClient sharedIM] setDiscussionTopicWithDiscussionId:_targetId newTopic:newName success:^(UCSDiscussion *discussion){
                
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showSuccess:@"修改讨论组名称成功" toView:self.view];
                
            [[NSNotificationCenter defaultCenter] postNotificationName:DiscussionNameChanged object:newName];
                
            _discussion.discussionName = newName;
            NSIndexPath * indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
                
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexpath] withRowAnimation:UITableViewRowAnimationFade];
            
            
        } failure:^(UCSError *error) {

            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showError:@"修改讨论组名称失败" toView:self.view];

        }];
    }];
}

// 退出讨论组
- (void)exitDiscussion{
    
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示 " message:@"确认退出讨论组吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alertView show];
}
// 确认退出讨论组
- (void)didExitDiscussion{
    
    [MBProgressHUD showMessage:@"退出中.." toView:self.view];
    [[UCSIMClient sharedIM] quitDiscussionWithDiscussionId:_targetId success:^(UCSDiscussion *discussion) {
        
        [self deleteConversation:_targetId];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showSuccess:@"已经退出了讨论组"];
        [self popToRoot];
   
    } failure:^(UCSError *error) {

        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showSuccess:@"退出讨论组失败" toView:self.view];

    }];
}

//清空聊天记录
- (void)clearMessages{
    self.alertView = [[UCAlertView alloc] initWithTitle:nil message:@"删除当前的聊天记录吗?" cancelButtonTitle:@"取消" otherButtonTitles:@"清空" cancelButtonBlock:^{
        
    } otherButtonBlock:^{
        
        [MBProgressHUD showMessage:@"删除消息记录中.." toView:self.view];
        BOOL ret = [[UCSIMClient sharedIM] clearMessages:UCS_IM_DISCUSSIONCHAT targetId:_targetId];
        if (ret) {
            [[NSNotificationCenter defaultCenter] postNotificationName:ChatMessageDidCleanNotification object:_targetId];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showSuccess:@"已删除" toView:self.view];
        }else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showError:@"删除失败" toView:self.view];
        }
        
    }];
    
}



//发送一个通知，删除对应会话，并刷新
- (void)deleteConversation:(NSString *) targetId{
    [[UCSIMClient sharedIM] removeConversation:UCS_IM_DISCUSSIONCHAT targetId:targetId];
    [[NSNotificationCenter defaultCenter] postNotificationName:DidQuitDiscussionNotification object:targetId];
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
        [_tableView registerNib:[UINib nibWithNibName:@"AcceptTVC" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"AcceptTVC"];
    }
    
    return _tableView;
}

- (UIButton *)exitButton{
    if (_exitButton == nil) {
        _exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat buttonW = [UIImage imageNamed:@"discussion_eixt"].size.width;
        CGFloat buttonH = [UIImage imageNamed:@"discussion_eixtHL"].size.height;
        _exitButton.bounds = CGRectMake(0, 0, buttonW, buttonH);
        _exitButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _exitButton.center = CGPointMake(self.view.frame.size.width / 2, 50);
        [_exitButton setBackgroundImage:[UIImage imageNamed:@"discussion_eixt"] forState:UIControlStateNormal];
        [_exitButton setBackgroundImage:[UIImage imageNamed:@"discussion_eixtHL"] forState:UIControlStateHighlighted];
        [_exitButton addTarget:self action:@selector(exitDiscussion) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exitButton;
}

- (UIView *)footerView{
    UIView * view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, self.view.frame.size.width, 90);
    
    [view addSubview:self.exitButton];
    
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

- (UIButton *)removeButton{
    if (!_removeButton) {
        _removeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_removeButton setImage:[UIImage imageNamed:@"discussion_remove"] forState:UIControlStateNormal];
        [_removeButton setImage:[UIImage imageNamed:@"discussion_removeHL"] forState:UIControlStateHighlighted];
        [_removeButton addTarget:self action:@selector(removeMembers:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _removeButton;
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else if(section == 1){
        return 1;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    
    if (indexPath.section == 0 && indexPath.row == 1) {
        [cell.contentView addSubview:self.membersView];
    }
    
    if (indexPath.section == 0 && indexPath.row == 0 ) {
        cell.textLabel.text = @"讨论组名称";
        cell.textLabel.textColor = UIColorFromRGB(0x383838);
        cell.textLabel.font = [UIFont systemFontOfSize:KFont];
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 44)];
        label.text =  (_discussion.discussionName && _discussion.discussionName.length > 0)
        ? _discussion.discussionName
        :@"未命名";
        
        label.textAlignment = UITextAlignmentCenter;
        label.textColor = UIColorFromRGB(0x999999);
        label.font = [UIFont systemFontOfSize:KFont];
        cell.accessoryView = label;
    }
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        AcceptTVC *AcceptCell = [tableView dequeueReusableCellWithIdentifier:@"AcceptTVC"];
        AcceptCell.targetId = _targetId;
        [AcceptCell setInfo:@"接收消息" Type:0];
        return AcceptCell;
    }
    
    if (indexPath.section == 2 && indexPath.row == 0 ) {
        UILabel *tmpLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 14, 150, 18)];
        tmpLable.text = @"更换聊天背景";
        tmpLable.font = [UIFont systemFontOfSize:15];
        [cell addSubview:tmpLable];
    }
    
    if (indexPath.section == 3 && indexPath.row == 0 ) {
        UILabel *tmpLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 14, 150, 18)];
        tmpLable.text = @"清空聊天记录";
        tmpLable.font = [UIFont systemFontOfSize:15];
        [cell addSubview:tmpLable];
    }
    
    
    return cell;
}



#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 1) {
        return self.membersView.frame.size.height + 2 * KVmembersViewMargin;
    }else{
        return 45;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return 20;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.row == 0 && indexPath.section ==0) {
        [self editDiscussionName];
    }else if (indexPath.row == 0 && indexPath.section == 2) {
        
        ChatBackGroudImageViewController * chatBackGroudImageViewController = [[ChatBackGroudImageViewController alloc] initWithChatter:_targetId];
        [self.navigationController pushViewController:chatBackGroudImageViewController animated:YES];
    }else if(indexPath.row == 0 && indexPath.section == 3){
        [self clearMessages];
    }
}



#pragma mark scrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self cancleEdit];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        return;
    }
    [self didExitDiscussion];
    
}

- (void)didRemoveFromDiscussionWithDiscussionId:(NSString *)discussionID
{
    NSNotification *item = [NSNotification notificationWithName:RemovedADiscussionNotification object:discussionID];
    [[NSNotificationCenter defaultCenter] postNotification:item];
}

@end
