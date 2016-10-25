//
//  ChatVC.m
//  zsfy
//
//  Created by 曾祺植 on 11/16/15.
//  Copyright © 2015 wzy. All rights reserved.
//

#import "ChatVC.h"
#import "UCSIMSDK.h"
#import "UUInputFunctionView.h"
#import "UUMessageCell.h"
#import "UUMessageFrame.h"
#import "UUMessage.h"
#import "ComUnit.h"
#import "Helper.h"
#import "FriendModel.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "ChatModel.h"
#import "DiscussionSetting.h"

@interface ChatVC () <UUInputFunctionViewDelegate, UUMessageCellDelegate, UITableViewDataSource, UITableViewDelegate, UCSIMClientDelegate>
@property (weak, nonatomic) IBOutlet UITableView *chatTableView;
@property (strong, nonatomic) ChatModel *chatModel;
@property (strong, nonatomic) NSString *Target_ID;
@property (strong, nonatomic) FriendModel *FriendInfo;
@end

@implementation ChatVC
{
    UUInputFunctionView *IFView;
    id savedGestureRecognizerDelegate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  //  self.navigationController.navigationBar.translucent = YES;
    self.chatTableView.delegate = self;
    self.chatTableView.dataSource = self;
    self.chatModel = [[ChatModel alloc] init];
    if (self.conversationItem.conversationType == UCS_IM_DISCUSSIONCHAT) {
        UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Discussion_option"]
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(showOption)];
        self.navigationItem.rightBarButtonItem = rightBtn;
        self.navigationItem.title = self.conversationItem.conversationTitle;
    } else {
        [ComUnit getFriendInfo:[Helper getUser_Token] targetID:self.conversationItem.targetId Callback:^(FriendModel *item, BOOL succeed) {
            if (succeed) {
                self.FriendInfo = item;
                self.navigationItem.title = self.FriendInfo.nikeName;
            }
        }];
    }
    [ComUnit getFriendList:[Helper getUser_Token] Callback:^(NSArray *allFriendInfo, BOOL succeed) {
        if (succeed) {
            self.chatModel.FriendsInfo = allFriendInfo;
            [self loadBaseViewsAndData];
            [self addRefreshViews];
        } else {
            [MBProgressHUD showError:@"内部错误"];
        }
        
    }];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  下滑加载历史聊天记录
 */
- (void)addRefreshViews
{
    __weak typeof(self) weakSelf = self;
    
    //load more
    int pageNum = 5;
    
    
    self.chatTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if ([weakSelf.chatModel addItemsToDataSource:weakSelf.conversationItem count:pageNum]) {
            if (weakSelf.chatModel.dataSource.count > pageNum) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:pageNum inSection:0];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.chatTableView reloadData];
                    [weakSelf.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
                });
            }
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"没有更多消息了" delegate:nil
                                                  cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        [weakSelf.chatTableView.header endRefreshing];
    }];
}

/**
 *  载入最近的聊天信息
 */
- (void)loadBaseViewsAndData
{
    [self.chatModel loadConversation:self.conversationItem];
    
    IFView = [[UUInputFunctionView alloc] initWithSuperVC:self];
    IFView.delegate = self;
    [self.view addSubview:IFView];
    
    [self.chatTableView reloadData];
    [self FirstScrollToBottom];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[UCSIMClient sharedIM] setDelegate:self];
    //add notification
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tableViewScrollToBottom) name:UIKeyboardDidShowNotification object:nil];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        [self.navigationController.view removeGestureRecognizer:self.navigationController.interactivePopGestureRecognizer];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UCSIMClient sharedIM] clearConversationsUnreadCount:self.conversationItem.conversationType
                                                 targetId:self.conversationItem.targetId];
    [[UCSIMClient sharedIM] setDelegate:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

-(void)keyboardChange:(NSNotification *)notification
{
//    NSDictionary *userInfo = [notification userInfo];
//    NSTimeInterval animationDuration;
//    UIViewAnimationCurve animationCurve;
//    CGRect keyboardEndFrame;
//    
//    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
//    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
//    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
//    
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:animationDuration];
//    [UIView setAnimationCurve:animationCurve];
    
    //adjust ChatTableView's height

//    if (notification.name == UIKeyboardWillShowNotification) {
//        self.bottomConstraint.constant = keyboardEndFrame.size.height * (-1) - 40;
//    }else{
//        self.bottomConstraint.constant = -40;
//    }
//    
//    [self.view layoutIfNeeded];
//    
//    //adjust UUInputFunctionView's originPoint
//    CGRect newFrame = IFView.frame;
//    newFrame.origin.y = keyboardEndFrame.origin.y - newFrame.size.height - 64;
//    IFView.frame = newFrame;
//    [UIView commitAnimations];
    
}

- (void)FirstScrollToBottom
{
    if (self.chatModel.dataSource.count==0)
        return;
    [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chatModel.dataSource.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom  animated:YES];
//    [self.chatTableView setContentOffset:CGPointMake(0, self.chatTableView.contentSize.height) animated:YES];
}

//tableView Scroll to bottom
- (void)tableViewScrollToBottom
{
    if (self.chatModel.dataSource.count==0)
        return;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.chatModel.dataSource.count - 1 inSection:0];
    [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

/**
 *  发送文本信息
 *
 *  @return
 */
#pragma mark - InputFunctionViewDelegate
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendMessage:(NSString *)message
{
    NSDictionary *dic = @{@"strContent": message,
                          @"type": @(UUMessageTypeText)};
    funcView.TextViewInput.text = @"";
    [funcView changeSendBtnWithPhoto:YES];
    int MsgID =[self dealTheFunctionData:dic];
    UCSTextMsg *aText = [[UCSTextMsg alloc] init];
    aText.content = message;
    [[UCSIMClient sharedIM] sendMessage:self.conversationItem.conversationType
                              receiveId:self.conversationItem.targetId
                                msgType:UCS_IM_TEXT
                                content:aText
                                success:^(long long messageId) {
                                    NSLog(@"发送成功");
                                    UUMessageFrame *item = self.chatModel.dataSource[MsgID];
                                    item.message.state = UUMessageSendSuccess;
                                    [self.chatModel.dataSource replaceObjectAtIndex:MsgID withObject:item];
                                    [self.chatTableView reloadData];

                                } failure:^(UCSError *error, long long messageId) {
                                    if (error.description) {
                                        [MBProgressHUD showError:error.description];
                                    } else {
                                        [MBProgressHUD showError:@"发送失败"];
                                    }
                                }];
}

/**
 *  发送图片信息
 *
 *  @param funcView
 *  @param image
 */
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendPicture:(UIImage *)image
{
    NSDictionary *dic = @{@"picture": image,
                          @"type": @(UUMessageTypePicture)};
    int MsgID = [self dealTheFunctionData:dic];
    UCSImageMsg *imageMsg = [[UCSImageMsg alloc] init];
    imageMsg.originalImage = image;
    [[UCSIMClient sharedIM] sendMessage:self.conversationItem.conversationType
                              receiveId:self.conversationItem.targetId
                                msgType:UCS_IM_IMAGE
                                content:imageMsg
                                success:^(long long messageId) {
                                    NSLog(@"发送成功");
                                    UUMessageFrame *item = self.chatModel.dataSource[MsgID];
                                    item.message.state = UUMessageSendSuccess;
                                    [self.chatModel.dataSource replaceObjectAtIndex:MsgID withObject:item];
                                    [self.chatTableView reloadData];

                                } failure:^(UCSError *error, long long messageId) {
                                    if (error.description) {
                                        [MBProgressHUD showError:error.description];
                                    } else {
                                        [MBProgressHUD showError:@"发送失败"];
                                    }

                                }];
}

/**
 *  发送语音信息
 *
 *  @param funcView
 *  @param voice
 *  @param second
 */
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendVoice:(NSData *)voice time:(NSInteger)second
{
    NSMutableData *voiceData = [NSMutableData dataWithData:voice];
    UCSVoiceMsg *voiceMsg = [[UCSVoiceMsg alloc] init];
    voiceMsg.amrAudioData = voiceData;
    voiceMsg.duration = (second >= 1.0) ? second : 1.0;
    NSDictionary *dic = @{@"voice": voice,
                          @"strVoiceTime": [NSString stringWithFormat:@"%d",(int)second],
                          @"type": @(UUMessageTypeVoice)};
    int MsgID = [self dealTheFunctionData:dic];
    [[UCSIMClient sharedIM] sendMessage:self.conversationItem.conversationType
                              receiveId:self.conversationItem.targetId
                                msgType:UCS_IM_VOICE
                                content:voiceMsg
                                success:^(long long messageId) {
                                    NSLog(@"发送成功");
                                    UUMessageFrame *item = self.chatModel.dataSource[MsgID];
                                    item.message.state = UUMessageSendSuccess;
                                    [self.chatModel.dataSource replaceObjectAtIndex:MsgID withObject:item];
                                    [self.chatTableView reloadData];

                                } failure:^(UCSError *error, long long messageId) {
                                    if (error.description) {
                                        [MBProgressHUD showError:error.description];
                                    } else {
                                        [MBProgressHUD showError:@"发送失败"];
                                    }
                                }];
}

/**
 *  聊天界面展示自己发出的信息
 *
 *  @param dic
 *
 *  @return
 */
- (int)dealTheFunctionData:(NSDictionary *)dic
{
    int ret = [self.chatModel addSpecifiedItem:dic];
    [self.chatTableView reloadData];
    [self tableViewScrollToBottom];
    return ret;
}

#pragma mark - tableView delegate & datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.chatModel.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UUMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    if (cell == nil) {
        
        cell = [[UUMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellID"];
        cell.delegate = self;
    }
    [cell setMessageFrame:self.chatModel.dataSource[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.chatModel.dataSource[indexPath.row] cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

/**
 *  点击头像时回调
 *
 *  @return
 */
#pragma mark - cellDelegate
- (void)headImageDidClick:(UUMessageCell *)cell userId:(NSString *)userId{
    
}

#pragma mark - UCSIMClientDelegate

- (void)didReceiveMessages:(NSArray *)messgeArray
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.chatModel Conversation:self.conversationItem loadNewMsg:messgeArray];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.chatTableView reloadData];
            [self tableViewScrollToBottom];
        });
    });
    
}

- (void)showOption
{
    DiscussionSetting *desVC = [[DiscussionSetting alloc] initWithNibName:@"DiscussionSetting" bundle:[NSBundle mainBundle]];
    desVC.discussionID = self.conversationItem.targetId;
    [self.navigationController pushViewController:desVC animated:YES];
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
