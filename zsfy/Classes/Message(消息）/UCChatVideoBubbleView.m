//
//  UCChatVideoBubbleView.m
//  IMDemo_UI
//
//  Created by Barry on 15/4/20.
//  Copyright (c) 2015年 Barry. All rights reserved.
//

#import "UCChatVideoBubbleView.h"

NSString *const kRouterEventChatCellVideoTapEventName = @"kRouterEventChatCellVideoTapEventName";

@interface UCChatVideoBubbleView ()

@property (strong, nonatomic)UIButton *videoPlayButton;

@end

@implementation UCChatVideoBubbleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.videoPlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *backgroundImage = [UIImage imageNamed:@"chat_video_play.png"];
        [self.videoPlayButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        [self.videoPlayButton addTarget:self action:@selector(playVideoAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.videoPlayButton];
    }
    return self;
}

//- (void)bubbleViewPressed:(id)sender
//{
//    //图片点击事件, 啥都不做
//}

- (void)playVideoAction:(id)sender{
    [self routerEventWithName:kRouterEventChatCellVideoTapEventName userInfo:@{KMESSAGEKEY:self.model}];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat width = 50.0f;
    CGFloat height = 50.0f;
    CGFloat x = self.frame.size.width/2 - width/2;
    CGFloat y = self.frame.size.height/2 - height/2;
    [self.videoPlayButton setFrame:CGRectMake(x, y, width, height)];
}


@end
