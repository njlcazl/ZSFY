//
//  ChatViewController.h
//  IMDemo_UI
//
//  Created by Barry on 15/4/17.
//  Copyright (c) 2015年 Barry. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "UCSIMDefine.h"

@interface ChatViewController : UIViewController

- (instancetype)initWithChatter:(NSString *) chatter type:(UCS_IM_ConversationType) type;
@end
