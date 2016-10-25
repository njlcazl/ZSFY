//
//  ChatDiscussionDetailViewController.h
//  UC_Demo_1.0.0
//
//  Created by Barry on 15/5/12.
//  Copyright (c) 2015年 Barry. All rights reserved.
//

#import "BaseViewController.h"


@interface ChatDiscussionDetailViewController : BaseViewController

- (instancetype)initWithDiscussionId:(NSString *)chatDiscussionId type:(UCS_IM_ConversationType) type;

@end
