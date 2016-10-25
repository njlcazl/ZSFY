//
//  ChatModel.h
//  UUChatTableView
//
//  Created by shake on 15/1/6.
//  Copyright (c) 2015年 uyiuyao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class UCSConversation;
@class FriendModel;

@interface ChatModel : NSObject

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSString *targetID;
@property (nonatomic, strong) NSArray *FriendsInfo;
@property (nonatomic) long long oldestMsgID;

@property (nonatomic) BOOL isGroupChat;

- (BOOL)addItemsToDataSource:(UCSConversation *)conversationItem count:(NSInteger)number;

- (int)addSpecifiedItem:(NSDictionary *)dic;

- (void)loadConversation:(UCSConversation *)conversationItem;

- (void)Conversation:(UCSConversation *)conversationItem loadNewMsg:(NSArray *)dataMsg;
@end
