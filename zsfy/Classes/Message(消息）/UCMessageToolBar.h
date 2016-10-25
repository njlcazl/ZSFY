//
//  UCMessageToolBar.h
//  UC_Demo_1.0.0
//
//  Created by Barry on 15/4/23.
//  Copyright (c) 2015年 Barry. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MessageTextView.h"

#import "UCRecordView.h"
#import "EmojiKeyboardView.h"

#define kInputTextViewMinHeight 36
#define kHorizontalPadding 0  //x间距
#define kVerticalPadding 5  //y间距


#define kTouchToRecord @"按下说话"
#define kTouchToFinish @"松开发送"



/**
 *  类说明：
 *  1、推荐使用[initWithFrame:...]方法进行初始化
 *  2、提供默认的录音，表情，更多按钮的附加页面
 *  3、可自定义以上的附加页面
 */


@protocol UCMessageToolBarDelegate;
@interface UCMessageToolBar : UIView

@property (nonatomic, weak) id <UCMessageToolBarDelegate> delegate;

/**
 *  发送按键在哪个位置
 */
@property (nonatomic, assign) UCMessageToolBarSendType SendType;

/**
 *  在切换语音和文本消息的时候，需要保存原本已经输入的文本，这样达到一个好的UE
 */
@property (strong, nonatomic) NSString * inputText; 

/**
 *  操作栏背景图片
 */
@property (strong, nonatomic) UIImage *toolbarBackgroundImage;

/**
 *  背景图片
 */
@property (strong, nonatomic) UIImage *backgroundImage;


/**
 *  表情的附加页面
 */
@property (strong, nonatomic) UIView *faceView;


/**
 *  录音的附加页面
 */
@property (strong, nonatomic) UIView *recordView;

/**
 *  用于输入文本消息的输入框
 */
@property (strong, nonatomic) MessageTextView *inputTextView;
/**
 *  更多按钮
 */
@property (strong, nonatomic) UIButton *moreButton;

/**
 *  表情按钮
 */
@property (strong, nonatomic) UIButton *faceButton;


/**
 *  初始化方法
 *
 *  @param frame      位置及大小
 *
 *  @return UCMessageToolBar
 */
- (instancetype)initWithFrame:(CGRect)frame ;

/**
 *  toolbar默认高度
 *
 *  @return 默认高度
 */
+ (CGFloat)defaultHeight;

/**
 *  动态改变高度
 *
 *  @param changeInHeight 目标变化的高度
 */
- (void)adjustTextViewHeightBy:(CGFloat)changeInHeight;

/**
 *  获取输入框内容字体行高
 *
 *  @return 返回行高
 */
+ (CGFloat)textViewLineHeight;

/**
 *  获取最大行数
 *
 *  @return 返回最大行数
 */
+ (CGFloat)maxLines;

/**
 *  获取根据最大行数和每行高度计算出来的最大显示高度
 *
 *  @return 返回最大显示高度
 */
+ (CGFloat)maxHeight;


@end




@protocol UCMessageToolBarDelegate <NSObject>

@optional

/**
 *  在普通状态和语音状态之间进行切换时，会触发这个回调函数
 *
 *  @param changedToRecord 是否改为发送语音状态
 */
- (void)didStyleChangeToRecord:(BOOL)changedToRecord;

/**
 *  点击“表情”按钮触发
 *
 *  @param isSelected 是否选中。YES,显示表情页面；NO，收起表情页面
 */
- (void)didSelectedFaceButton:(BOOL)isSelected;

/**
 *  点击“更多”按钮触发
 *
 *  @param isSelected 是否选中。YES,显示更多页面；NO，收起更多页面
 */
- (void)didSelectedMoreButton:(BOOL)isSelected;

/**
 *  文字输入框开始编辑
 *
 *  @param inputTextView 输入框对象
 */
- (void)inputTextViewDidBeginEditing:(MessageTextView *)messageInputTextView;

/**
 *  文字输入框将要开始编辑
 *
 *  @param inputTextView 输入框对象
 */
- (void)inputTextViewWillBeginEditing:(MessageTextView *)messageInputTextView;

/**
 *  发送文字消息，可能包含系统自带表情
 *
 *  @param text 文字消息
 */
- (void)didSendText:(NSString *)text;

/**
 *  发送第三方表情，不会添加到文字输入框中
 *
 *  @param faceLocalPath 选中的表情的本地路径
 */
- (void)didSendFace:(NSString *)faceLocalPath;


#pragma mark 录音动作代理

/**
 *  按下录音按钮开始录音
 */
- (void)didStartRecordingVoiceAction:(UIView *)recordView;
/**
 *  手指向上滑动取消录音
 */
- (void)didCancelRecordingVoiceAction:(UIView *)recordView;
/**
 *  松开手指完成录音
 */
- (void)didFinishRecoingVoiceAction:(UIView *)recordView;
/**
 *  当手指离开按钮的范围内时，主要为了通知外部的HUD
 */
- (void)didDragOutsideAction:(UIView *)recordView;
/**
 *  当手指再次进入按钮的范围内时，主要也是为了通知外部的HUD
 */
- (void)didDragInsideAction:(UIView *)recordView;


@end
