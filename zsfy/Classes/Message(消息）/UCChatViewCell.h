//
//  UCChatViewCell.h
//  IMDemo_UI
//
//  Created by Barry on 15/4/20.
//  Copyright (c) 2015年 Barry. All rights reserved.
//

#import "UCChatVIewBaseCell.h"

#import "UCChatTextBubbleView.h"
#import "UCChatImageBubbleView.h"
#import "UCChatAudioBubbleView.h"
#import "UCChatVideoBubbleView.h"
#import "UCChatLocationBubbleView.h"

#define SEND_STATUS_SIZE 20 // 发送状态View的Size
#define ACTIVTIYVIEW_BUBBLE_PADDING 5 // 菊花和bubbleView之间的间距

extern NSString *const kResendButtonTapEventName;
extern NSString *const kShouldResendCell;

@interface UCChatViewCell : UCChatVIewBaseCell

//sender
@property (nonatomic, strong) UIActivityIndicatorView *activtiy; //转动的菊花
@property (nonatomic, strong) UIView *activityView;
@property (nonatomic, strong) UIButton *retryButton; //重发

@end
