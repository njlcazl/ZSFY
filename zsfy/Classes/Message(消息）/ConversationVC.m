//
//  ConversationVC.m
//  zsfy
//
//  Created by 曾祺植 on 11/14/15.
//  Copyright © 2015 wzy. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import "ConversationVC.h"
#import "PPDragDropBadgeView.h"
#import "CoreDataOperation.h"
#import "ConversationTVC.h"
#import "ChatViewController.h"
#import "NotificationVC.h"
#import "CreateDiscussion.h"
#import "Search.h"
#import "ComUnit.h"
#import "Helper.h"
#import "FriendModel.h"
#import "ChatVC.h"
#import "ContactTVC.h"
#import "AddFriendVC.h"
#import "FriendListVC.h"
#import "UCSIMSDK.h"
#import "GeTuiSdk.h"
#import "NotificationModel.h"

static NSString * const menuCellIdentifier = @"rotationCell";
static NSString * const CellIdentifier = @"conversationCell";

@interface ConversationVC () <UCSIMClientDelegate, ConversationCellDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *ConversationList;
@property (assign, nonatomic) int PushCount;
@property (assign, nonatomic) BOOL showNoteCell;
@property (strong, nonatomic) NSMutableArray *conversations;
@property (nonatomic, strong) NSArray *ApplyInfo;
@property (nonatomic, strong) NSArray *menuTitles;
@property (nonatomic, strong) NSArray *menuIcons;
@property (nonatomic, strong) NSString *CurrentUnread;
@property (weak, nonatomic) IBOutlet UILabel *NoMsg;

@end

@implementation ConversationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showNoteCell = true;
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_add"] style:UIBarButtonItemStyleDone target:self action:@selector(showOption)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetPush) name:@"GetPush" object:nil];
    self.ConversationList.delegate = self;
    self.ConversationList.dataSource = self;
    
    [self.ConversationList registerNib:[UINib nibWithNibName:@"ConversationTVC" bundle:nil]
                forCellReuseIdentifier:CellIdentifier];
    [self.ConversationList registerNib:[UINib nibWithNibName:@"ContactTVC" bundle:nil]
                forCellReuseIdentifier:@"ContactCell"];
    [self setExtraCellLineHidden:self.ConversationList];
    [self dealSeparator];
}

- (void)dealSeparator
{
    if ([self.ConversationList respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.ConversationList setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.ConversationList respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.ConversationList setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self isLogin]) {
        if (![Helper getStatus]) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [ComUnit getPushInfo:[Helper getUser_Token] ClientId:[GeTuiSdk clientId] Callback:^(long long time, NSString *description, NSString *title, NSString *UnreadCount, BOOL succeed) {
                if (succeed) {
                    self.PushCount = [UnreadCount intValue];
                    if (![UnreadCount isEqualToString:@"0"]) {
                        self.showNoteCell = YES;
                    }
                } else {
                    self.showNoteCell = NO;
                }
            }];
            [ComUnit Login_userName:[Helper getUserName] Password:[Helper getPassword] clientId:[GeTuiSdk clientId] Callback:^(NSString *IM_Token, NSString *userID, NSString * User_Token, NSString *name, NSString *ImageUrl, NSString *courtId, NSString *Info, BOOL succeed) {
                if (succeed) {
                    [Helper setIM_Token:IM_Token];
                    [Helper setUserID:userID];
                    [Helper setUser_Token:User_Token];
                    [Helper setNickname:name];
                    [[UCSTcpClient sharedTcpClientManager] login_uninitWithFlag:NO];
                    [[UCSTcpClient sharedTcpClientManager] login_connect:[Helper getIM_Token] success:^(NSString *userId) {
                        [Helper setStatus:YES];
                        [[UCSIMClient sharedIM] setDelegate:self];
                        [self.navigationItem setTitle:@"消息"];
                        self.navigationItem.rightBarButtonItem.enabled = YES;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                            [self UpdateData];
                        });
                    } failure:^(UCSError *error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                            [MBProgressHUD showError:@"登陆失败"];
                        });
                    }];
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD showError:Info ];
                    });
                }
            }];
        } else {
            [[UCSIMClient sharedIM] setDelegate:self];
            [self.navigationItem setTitle:@"消息"];
            self.navigationItem.rightBarButtonItem.enabled = YES;
            [self UpdateData];
        }
        //登录
    } else {
        //没登录
        [self.navigationItem setTitle:@"请先登录"];
        self.conversations = [[NSMutableArray alloc] init];
        [self.ConversationList reloadData];
        self.navigationItem.rightBarButtonItem.enabled = NO;
        [self updateBadge];
    }
//    [ComUnit getNotificationMsgList:[Helper getUser_Token] ClientId:[GeTuiSdk clientId] Page:1 rowSize:5 Callback:^(NSArray *allNoteInfo, BOOL succeed) {
//        for(int i = 0;i < allNoteInfo.count;i++) {
//            NotificationModel *item = allNoteInfo[i];
//            NSLog(@"%@ %@ %@ %@ %@", [item.content valueForKey:@"value"], item.date, item.Nid, [item.title valueForKey:@"value"], item.Url);
//        }
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)isLogin
{
    NSString *userId = [[NSString alloc] init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    userId =  [defaults objectForKey:@"user_id"];
    BOOL ret = userId.length > 0;
    return ret;
}

- (void)showOption
{
    AddFriendVC *desVC = [[AddFriendVC alloc] initWithNibName:@"AddFriendVC" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:desVC animated:YES];
}

- (void)showLable
{
    if (self.conversations.count == 0) {
        self.NoMsg.hidden = NO;
    } else {
        self.NoMsg.hidden = YES;
    }
}

- (void)UpdateData
{
    NSArray *temp = [[UCSIMClient sharedIM] getConversationList: allChat];
    self.conversations = [temp copy];
    [ComUnit getFriendList:[Helper getUser_Token] Callback:^(NSArray *allFriendInfo, BOOL succeed) {
        if (succeed) {
            [[Search shareInstance] setFriendData:allFriendInfo];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self RemoveNotFriend];
                NSArray *temp = [[UCSIMClient sharedIM] getConversationList: allChat];
                self.conversations = [temp copy];
                [self showLable];
                [self.ConversationList reloadData];
                [self updateBadge];
            });
            
        }
    }];
    [self updateBadge];

}


/**
 *  IM_SDK回调
 *
 *  @param error
 *
 */

- (void)didReceiveMessages:(NSArray *)messgeArray
{
    NSArray *blockList = [CoreDataOperation getBlockList:[Helper getUserID]];
    BOOL flag1 = NO;
    //有没有一个会话不在屏蔽列表
    for (int i = 0; i < messgeArray.count; i++) {
        BOOL flag2 = NO;
        for (int j = 0; j < blockList.count; j++) {
            UCSMessage *item = messgeArray[i];
            if (item.conversationType == UCS_IM_SOLOCHAT) {
                if ([[(UCSMessage *)messgeArray[i] senderUserId] isEqualToString:blockList[j]]) {
                    flag2 = YES;
                    break;
                }
            } else {
                if ([[(UCSMessage *)messgeArray[i] receiveId] isEqualToString:blockList[j]]) {
                    flag2 = YES;
                    break;
                }
            }
                    }
        if (!flag2) {
            flag1 = YES;
            break;
        }
        
    }
    if (flag1) {
        NSArray *VoiceSettings = [CoreDataOperation getVoiceSetting:[Helper getUserID]];
        if ([VoiceSettings[0] isEqual:@1]) {
            if ([VoiceSettings[1] isEqual:@1]) {
                AudioServicesPlaySystemSound(1106);
            }
            if ([VoiceSettings[2] isEqual:@1]) {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            }
        }

    }
    
    [self UpdateData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else {
        if (self.showNoteCell) {
            return self.conversations.count + 1;
        } else {
            return self.conversations.count;
        }
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ContactTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell" forIndexPath:indexPath];
        [cell HideBadgeView];

        if ([self isLogin]) {
            [ComUnit getUnreadApply:[Helper getUser_Token] Callback:^(NSString *UnreadCount, BOOL succeed) {
                if (succeed) {
                    [cell setInfo1:UnreadCount];
                    self.CurrentUnread = UnreadCount;
                }
            }];
        } else {
            [cell setInfo1:@"0"];
        }
        return cell;
    } else {
        ConversationTVC *cell = [[ConversationTVC alloc] init];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ConversationTVC" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.delegate = self;
        if (self.showNoteCell && indexPath.row == 0) {
            [cell setPushInfo:tableView];
        } else {
            if (self.showNoteCell) {
                cell.conversationItem = self.conversations[indexPath.row - 1];
            } else {
                cell.conversationItem = self.conversations[indexPath.row];
            }
            [cell setInfo];
        }
        return cell;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"";
    } else {
        return @"   消息";
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        if(![self isLogin])return;
        FriendListVC *desVC = [[FriendListVC alloc] initWithNibName:@"FriendListVC" bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:desVC animated:YES];
    } else {
        if (indexPath.row == 0 && self.showNoteCell) {
            NotificationVC *desVC = [[NotificationVC alloc] initWithNibName:@"NotificationVC" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:desVC animated:YES];
        } else {
            if(![self isLogin])return;
            ConversationTVC *itemCell = [tableView cellAtIndexPath:indexPath];
            for (id obj in [itemCell subviews]) {
                if ([obj isKindOfClass:[PPDragDropBadgeView class]]) {
                    [obj removeFromSuperview];
                }
            }
            UCSConversation *itemInfo = itemCell.conversationItem;
            ChatViewController *desVC = [[ChatViewController alloc] initWithChatter:itemInfo.targetId type:itemInfo.conversationType];
            if (itemInfo.conversationType == UCS_IM_SOLOCHAT) {
                desVC.navigationItem.title = [[Search shareInstance] getNickName:itemInfo.targetId];
            } else {
                desVC.navigationItem.title = itemInfo.conversationTitle;
            }
            [self.navigationController pushViewController:desVC animated:YES];
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (self.showNoteCell && (indexPath.section == 1 && indexPath.row == 0)) {
            BOOL suc = [ComUnit ClearUnreadCount:[Helper getUser_Token] clientId:[GeTuiSdk clientId]];
            if (suc) {
                self.PushCount = 0;
                self.showNoteCell = false;
                [self.ConversationList reloadData];
                [self updateBadge];
            }
        } else {
            UCSConversation *item;
            if (self.showNoteCell) {
                item = self.conversations[indexPath.row-1];
            } else {
                item = self.conversations[indexPath.row];
            }
            [[UCSIMClient sharedIM] removeConversation:item.conversationType targetId:item.targetId];
            [self UpdateData];
            [self showLable];
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return NO;
    } else {
        return YES;
    }
}

- (void)didRemoveFromDiscussionWithDiscussionId:(NSString *)discussionID
{
    [[UCSIMClient sharedIM] removeConversation:UCS_IM_DISCUSSIONCHAT targetId:discussionID];
    NSArray *tmp = [[UCSIMClient sharedIM] getConversationList: allChat];
    self.conversations = [tmp copy];
    [self.ConversationList reloadData];
}

- (void)updateBadge
{
    __block int unreadcnt = 0;
    if([self isLogin]) {
        unreadcnt = [[UCSIMClient sharedIM] getTotalUnreadCount];
        NSArray *blockList = [CoreDataOperation getBlockList:[Helper getUserID]];
        for (int i = 0; i < self.conversations.count; i++) {
            UCSConversation *item = self.conversations[i];
            for (int j = 0; j < blockList.count; j++) {
                if ([item.targetId isEqualToString:blockList[j]]) {
                    int minus = [[UCSIMClient sharedIM] getUnreadCount:item.conversationType targetId:item.targetId];
                    unreadcnt -= minus;
                }
            }
        }
    }
    if(self.showNoteCell) {
        [ComUnit getPushInfo:[Helper getUser_Token] ClientId:[GeTuiSdk clientId] Callback:^(long long time, NSString *description, NSString *title, NSString *UnreadCount, BOOL succeed) {
            if (succeed) {
                self.PushCount = [UnreadCount intValue];
                unreadcnt += self.PushCount;
                if (unreadcnt > 0) {
                    [self.navigationController.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%d", unreadcnt]];
                } else {
                    [self.navigationController.tabBarItem setBadgeValue:nil];
                }
                
            }
        }];
    } else {
        if (unreadcnt > 0) {
            [self.navigationController.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%d", unreadcnt]];
        } else {
            [self.navigationController.tabBarItem setBadgeValue:nil];
        }

    }
}

//- (void)RemoveEmpty
//{
//    NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:self.conversations];
//    for (int i = 0; i < tmpArr.count; i++) {
//        if ([(UCSConversation *)tmpArr[i] conversationType] == UCS_IM_DISCUSSIONCHAT) {
//            NSString *DiscussionID = [tmpArr[i] targetId];
//            UCSDiscussion *item = [[UCSIMClient sharedIM] getDiscussionInfoWithDiscussionId:DiscussionID];
//            if (!item.discussionName) {
//                [[UCSIMClient sharedIM] clearConversationsUnreadCount:UCS_IM_DISCUSSIONCHAT targetId:DiscussionID];
//                [tmpArr removeObjectAtIndex:i];
//                i--;
//            }
//        } else if([(UCSConversation *)tmpArr[i] conversationType] == UCS_IM_GROUPCHAT) {
//            if (![(UCSConversation *)tmpArr[i] conversationTitle]) {
//                [tmpArr removeObjectAtIndex:i];
//                i--;
//            }
//        }
//    }
//    self.conversations = [tmpArr copy];
//    [self showLable];
//}

- (void)GetPush
{
    NSArray *VoiceSettings = [CoreDataOperation getVoiceSetting:[Helper getUserID]];
    if ([VoiceSettings[0] isEqual:@1]) {
        if ([VoiceSettings[1] isEqual:@1]) {
            AudioServicesPlaySystemSound(1106);
        }
        if ([VoiceSettings[2] isEqual:@1]) {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }
    }

    self.showNoteCell = true;
    [self.ConversationList reloadData];
    [self updateBadge];
}

- (void)RemoveNotFriend
{
    for (int i = 0; i < self.conversations.count; i++) {
        UCSConversation *item = self.conversations[i];
        if (item.conversationType == UCS_IM_SOLOCHAT) {
            BOOL isFriend = [[Search shareInstance] checkFriend:item.targetId];
            if (!isFriend) {
                [[UCSIMClient sharedIM] removeConversation:UCS_IM_SOLOCHAT targetId:item.targetId];
            }
        }
    }
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
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
