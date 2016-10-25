//
//  UCChatBarMoreView.m
//  UC_Demo_1.0.0
//
//  Created by Barry on 15/4/23.
//  Copyright (c) 2015年 Barry. All rights reserved.
//

#import "UCChatBarMoreView.h"

#define CHAT_BUTTON_SIZE 60
#define INSETS 8

#define KButtonW 70
#define KButtonH KButtonW
#define KinsetsW ((self.frame.size.width - 4 * KButtonW) / 5)
#define KinsetsH ((self.frame.size.height - 2 * KButtonH) / 3)


@implementation UCChatBarMoreView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews
{
    
    //图片
    _photoButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_photoButton setFrame:CGRectMake(KinsetsW, KinsetsH, KButtonW , KButtonH)];
    [_photoButton setImage:[UIImage imageNamed:@"chat_more_pic"] forState:UIControlStateNormal];
    [_photoButton setImage:[UIImage imageNamed:@"chat_more_picHL"] forState:UIControlStateHighlighted];
    [_photoButton addTarget:self action:@selector(photoAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_photoButton];
    
    //拍照
    _takePicButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_takePicButton setFrame:CGRectMake(KinsetsW * 2  + KButtonW , KinsetsH, KButtonW , KButtonH)];
    [_takePicButton setImage:[UIImage imageNamed:@"chat_more_recordVideo"] forState:UIControlStateNormal];
    [_takePicButton setImage:[UIImage imageNamed:@"chat_more_recordVideoHL"] forState:UIControlStateHighlighted];
    [_takePicButton addTarget:self action:@selector(takePicAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_takePicButton];
    
    // 短片
    _shortVideoButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_shortVideoButton setFrame:CGRectMake(KinsetsW * 3  + 2 * KButtonW , KinsetsH, KButtonW , KButtonH)];
    [_shortVideoButton setImage:[UIImage imageNamed:@"chat_more_shortVideo"] forState:UIControlStateNormal];
    [_shortVideoButton setImage:[UIImage imageNamed:@"chat_more_shortVideoHL"] forState:UIControlStateHighlighted];
    [_shortVideoButton addTarget:self action:@selector(takeShortVideoAction) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_shortVideoButton];
    
    //位置
    _locationButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_locationButton setFrame:CGRectMake(KinsetsW * 4  + 3 * KButtonW , KinsetsH, KButtonW , KButtonH)];
    [_locationButton setImage:[UIImage imageNamed:@"chat_more_location"] forState:UIControlStateNormal];
    [_locationButton setImage:[UIImage imageNamed:@"chat_more_locationHL"] forState:UIControlStateHighlighted];
    [_locationButton addTarget:self action:@selector(locationAction) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_locationButton];
    
    //名片
    _cardButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_cardButton setFrame:CGRectMake(KinsetsW, KinsetsH * 2 + KButtonH, KButtonW , KButtonH)];
    [_cardButton setImage:[UIImage imageNamed:@"chat_more_card"] forState:UIControlStateNormal];
    [_cardButton setImage:[UIImage imageNamed:@"chat_more_cardHL"] forState:UIControlStateHighlighted];
    [_cardButton addTarget:self action:@selector(cardAction) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_cardButton];
    
    //文件
    _cardButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_cardButton setFrame:CGRectMake(KinsetsW * 2  + KButtonW , KinsetsH * 2 + KButtonH, KButtonW , KButtonH)];
    [_cardButton setImage:[UIImage imageNamed:@"chat_more_file"] forState:UIControlStateNormal];
    [_cardButton setImage:[UIImage imageNamed:@"chat_more_fileHL"] forState:UIControlStateHighlighted];
    [_cardButton addTarget:self action:@selector(fileAction) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_cardButton];
    
    //视频聊天
    _videoChatButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_videoChatButton setFrame:CGRectMake(KinsetsW * 3  + KButtonW * 2 , KinsetsH * 2 + KButtonH, KButtonW , KButtonH)];
    [_videoChatButton setImage:[UIImage imageNamed:@"chat_more_videoChat"] forState:UIControlStateNormal];
    [_videoChatButton setImage:[UIImage imageNamed:@"chat_more_videoChatHL"] forState:UIControlStateHighlighted];
    [_videoChatButton addTarget:self action:@selector(videoChatAction) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_videoChatButton];
    
    
    //视频
//    _videoButton =[UIButton buttonWithType:UIButtonTypeCustom];
//    [_videoButton setFrame:CGRectMake(insets * 4 + CHAT_BUTTON_SIZE * 3, 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
//    [_videoButton setImage:[UIImage imageNamed:@"chatBar_colorMore_video"] forState:UIControlStateNormal];
//    [_videoButton setImage:[UIImage imageNamed:@"chatBar_colorMore_videoSelected"] forState:UIControlStateHighlighted];
//    [_videoButton addTarget:self action:@selector(takeVideoAction) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_videoButton];
    
    
    //语音
    _audioCallButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_audioCallButton setFrame:CGRectMake(KinsetsW * 4  + KButtonW * 3 , KinsetsH * 2 + KButtonH, KButtonW , KButtonH)];
    [_audioCallButton setImage:[UIImage imageNamed:@"chat_more_voiceChat"] forState:UIControlStateNormal];
    [_audioCallButton setImage:[UIImage imageNamed:@"chat_more_voiceChatHL"] forState:UIControlStateHighlighted];
    [_audioCallButton addTarget:self action:@selector(takeAudioCallAction) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_audioCallButton];
    
}

#pragma mark - action

- (void)takePicAction{
    if(_delegate && [_delegate respondsToSelector:@selector(moreViewTakePicAction:)]){
        [_delegate moreViewTakePicAction:self];
    }
}

- (void)takeShortVideoAction{
    if (_delegate && [_delegate respondsToSelector:@selector(moreviewtakeShortVideoAction:)]) {
        [_delegate moreviewtakeShortVideoAction:self];
    }
}

- (void)photoAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewPhotoAction:)]) {
        [_delegate moreViewPhotoAction:self];
    }
}

- (void)locationAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewLocationAction:)]) {
        [_delegate moreViewLocationAction:self];
    }
}

- (void)cardAction{
    if (_delegate && [_delegate respondsToSelector:@selector(moreviewCardAction:)]) {
        [_delegate moreviewCardAction:self];
    }
}

- (void)fileAction{
    if (_delegate && [_delegate respondsToSelector:@selector(moreviewFileAction:)]) {
        [_delegate moreviewFileAction:self];
    }
}

- (void)videoChatAction{
    if (_delegate && [_delegate respondsToSelector:@selector(moreviewvideoChatAction:)]) {
        [_delegate moreviewvideoChatAction:self];
    }
}

- (void)takeVideoAction{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewLocationAction:)]) {
        [_delegate moreViewVideoAction:self];
    }
}

- (void)takeAudioCallAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewAudioCallAction:)]) {
        [_delegate moreViewAudioCallAction:self];
    }
}

@end
