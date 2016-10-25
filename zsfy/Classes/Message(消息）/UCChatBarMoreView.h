//
//  UCChatBarMoreView.h
//  UC_Demo_1.0.0
//
//  Created by Barry on 15/4/23.
//  Copyright (c) 2015年 Barry. All rights reserved.
//

#import <UIKit/UIKit.h>


@class UCChatBarMoreView;
@protocol UCChatBarMoreViewDelegate <NSObject>

@required
- (void)moreViewTakePicAction:(UCChatBarMoreView *)moreView;
- (void)moreViewPhotoAction:(UCChatBarMoreView *)moreView;
- (void)moreViewLocationAction:(UCChatBarMoreView *)moreView;
- (void)moreViewVideoAction:(UCChatBarMoreView *)moreView;
- (void)moreViewAudioCallAction:(UCChatBarMoreView *)moreView;
- (void)moreviewtakeShortVideoAction:(UCChatBarMoreView *)moreView;
- (void)moreviewCardAction:(UCChatBarMoreView *)moreView;
- (void)moreviewFileAction:(UCChatBarMoreView *)moreView;
- (void)moreviewvideoChatAction:(UCChatBarMoreView *) moreView;
@end




@interface UCChatBarMoreView : UIView

@property (nonatomic,assign) id<UCChatBarMoreViewDelegate> delegate;

@property (nonatomic, strong) UIButton *photoButton; //相册
@property (nonatomic, strong) UIButton *takePicButton; // 拍照、录视频
@property (nonatomic, strong) UIButton *locationButton; // 位置
@property (nonatomic, strong) UIButton *videoButton; // 选取本地视频
@property (nonatomic, strong) UIButton *audioCallButton; // 语音
@property (nonatomic, strong) UIButton *fileButton; //文件
@property (nonatomic, strong) UIButton *cardButton; // 名片
@property (nonatomic, strong) UIButton *shortVideoButton; //短视频
@property (nonatomic ,strong) UIButton *videoChatButton; //视频聊天

- (instancetype)initWithFrame:(CGRect)frame ;


@end
