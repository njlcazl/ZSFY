//
//  UCConst.m
//  UC_Demo_1.0.0
//
//  Created by Barry on 15/5/25.
//  Copyright (c) 2015年 Barry. All rights reserved.
//

#import "UCConst.h"

NSString * const UCLoginStateChangedNotication = @"UCLoginStateChangedNotication";
NSString * const UCLoginStateConnectingNotification = @"UCLoginStateConnectingNotification";  //连接中....
NSString * const UCLoginStateLoginSuccessNotification = @"UCLoginStateLoginSuccessNotification";  //登录成功
NSString * const UCLoginStateLoginFailureNotification = @"UCLoginStateLoginFailureNotification" ; //登录失败
NSString * const UCLoginStateNetErrorNotification = @"UCLoginStateNetErrorNotification" ; //网络不给力
NSString * const UCLoginStateLoginOutNotification = @"UCLoginStateLoginOutNotification" ; //退出
NSString * const UCTCPConnectingNotification = @"UCTCPConnectingNotification" ;  // tcp正在连接
NSString * const UCTCPDesConnectNotification = @"UCTCPDesConnectNotification" ;  // tcp断开连接
NSString * const UCTCPDidConnectNotification = @"UCTCPDidConnectNotification" ;  // tcp已经连接
NSString * const UCTCPNoNetWorkNotification = @"UCTCPNoNetWorkNotification"   ;  // 没网
NSString * const UCTCPHaveNetWorkNotification = @"UCTCPHaveNetWorkNotification"; // 有网

//消息未读数变化通知
NSString * const UnReadMessageCountChangedNotification = @"UnReadMessageCountChangedNotification";

//会话列表变化通知，来了新消息，自己发了消息等
NSString * const ConversationListDidChangedNotification = @"ConversationListDidChangedNotification";

//收到新的聊天信息
NSString * const DidReciveNewMessageNotifacation = @"DidReciveNewMessageNotifacation";

//清空了聊天消息
NSString * const ChatMessageDidCleanNotification = @"ChatMessageDidCleanNotification";

// 聊天背景改变了
NSString * const ChatViewBackImageDidChangedNotification = @"chatViewBackImageDidChangedNotification" ;

//讨论组好友成员增加了
NSString * const DiscussionMembersDidAddNotification = @"discussionMembersDidAddNotification" ;

//主动退出讨论组
NSString * const DidQuitDiscussionNotification = @"didQuitDiscussionNotification";

//创建讨论组成功,rootViewController跳转到chatviewCotroller
NSString * const DidCreateDiscussionNotification = @"didCreateDiscussionNotification";

//本地通知体中的key
NSString * const LocationNotificationChatterKey = @"LocationNotificationChatterKey";

// 收到删除空的会话的通知
NSString * const RemoveEmptyConversationNotification = @"RemoveEmptyConversationNotification";

// 讨论组名称被修改了
NSString * const DiscussionNameChanged = @"DiscussionNameChanged";

// 自己被踢出讨论组
NSString * const RemovedADiscussionNotification = @"RemovedADiscussionNotification";

// tcp连接状态
NSString * const TCPConnectStateNotification = @"TCPConnectStateNotification";

// 自己被踢线
NSString * const TCPKickOffNotification = @"TCPKickOffNotification";
