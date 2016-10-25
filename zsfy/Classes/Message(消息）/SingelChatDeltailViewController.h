//
//  SingelChatDeltailViewController.h
//  UC_Demo_1.0.0
//
//  Created by Barry on 15/5/23.
//  Copyright (c) 2015年 Barry. All rights reserved.
//

#import "BaseViewController.h"
#import "UCSIMClient.h"

@interface SingelChatDeltailViewController : BaseViewController


- (instancetype)initWithChatter:(NSString *) chatter type:(UCS_IM_ConversationType) type Flag:(BOOL)flag;


@end
