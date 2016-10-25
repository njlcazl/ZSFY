//
//  UCChatImageBubbleView.h
//  IMDemo_UI
//
//  Created by Barry on 15/4/20.
//  Copyright (c) 2015年 Barry. All rights reserved.
//

#import "UCChatBaseBubbleView.h"

#define MAX_SIZE 120 //　图片最大显示大小

extern NSString *const kRouterEventImageBubbleTapEventName;

@interface UCChatImageBubbleView : UCChatBaseBubbleView

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, assign) CGFloat downloadProgress;

@property (nonatomic, assign) BOOL isDownLoading; //是不是在下载

@end





