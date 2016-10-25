//
//  ChatVC.h
//  zsfy
//
//  Created by 曾祺植 on 11/16/15.
//  Copyright © 2015 wzy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UCSConversation;

@interface ChatVC : UIViewController

@property (nonatomic, strong) UCSConversation *conversationItem;
@property (nonatomic, strong) NSString *targetName;
@property (nonatomic, strong) NSString *targetPhone;
@property (nonatomic, strong) NSArray *FriendsInfo;

@end
