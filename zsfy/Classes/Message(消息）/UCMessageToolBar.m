//
//  UCMessageToolBar.m
//  UC_Demo_1.0.0
//
//  Created by Barry on 15/4/23.
//  Copyright (c) 2015年 Barry. All rights reserved.
//

#import "UCMessageToolBar.h"
#import "NSString+UCMessageInputView.h"

@interface UCMessageToolBar()<UITextViewDelegate,EmojiKeyboardViewDelegate>


@property (nonatomic) CGFloat version;

/**
 *  按钮、输入框、
 */
@property (strong, nonatomic) UIButton *styleChangeButton; //切换语音和文字的按钮

@property (strong, nonatomic) UIButton *recordButton;
@property (strong, nonatomic) UIButton *sendButton;


@end

@implementation UCMessageToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (frame.size.height < (kVerticalPadding * 2 + kInputTextViewMinHeight)) {
        frame.size.height = kVerticalPadding * 2 + kInputTextViewMinHeight;
    }
    self = [super initWithFrame:frame];
    if (self) {
        
        //设置显示的发送按钮的类型
        _SendType = UCMessageToolBarSendTypeDown;
        // 设置初始化界面
        [self setupConfigure];
    }
    return self;
}

     
- (void)setFrame:(CGRect)frame
{
    if (frame.size.height < (kVerticalPadding * 2 + kInputTextViewMinHeight)) {
        frame.size.height = kVerticalPadding * 2 + kInputTextViewMinHeight;
    }
    [super setFrame:frame];
}


- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    // 当别的地方需要add的时候，就会调用这里
    if (newSuperview) {
        [self setupSubviews];
    }
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
}

- (void)dealloc
{
    self.inputText = nil;
    _inputTextView.delegate = nil;
    _inputTextView = nil;
    
    _styleChangeButton = nil;
    _sendButton = nil;
    _faceButton = nil;
    _moreButton =  nil;
    _faceView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(inputTextViewWillBeginEditing:)]) {
        [self.delegate inputTextViewWillBeginEditing:self.inputTextView];
    }
    
    self.faceButton.selected = NO;
    self.styleChangeButton.selected = NO;
    self.moreButton.selected = NO;
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView becomeFirstResponder];
    
    if ([self.delegate respondsToSelector:@selector(inputTextViewDidBeginEditing:)]) {
        [self.delegate inputTextViewDidBeginEditing:self.inputTextView];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
}


// 检测到回车键就是发送消息
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        if ([self.delegate respondsToSelector:@selector(didSendText:)]) {
            if (textView.text.length > 1000) {
                [self showAlerViewWithTitle:@"字数超长"];
                return NO;
            }
            [self.delegate didSendText:textView.text];
            self.inputTextView.text = @"";
        }
        
        return NO;
    }

    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
}



#pragma mark EmojiKeyboardViewDelegate
- (void)emojiKeyBoardView:(EmojiKeyboardView *)emojiKeyBoardView didUseEmoji:(NSString *)emoji{
    
    if (emoji.length > 0) {
        [self.inputTextView insertText:emoji];
    }
    [self textViewDidChange:self.inputTextView];
}

-(void)emojiKeyBoardViewDidPressBackSpace:(EmojiKeyboardView *)emojiKeyBoardView{
    
    NSString * chatText = self.inputTextView.text;
    
    // 大于2的时候判断是不是表情，是就直接删除2个字符，不是走到下一步
    if (chatText.length >= 2) {
        NSString * subStr = [chatText substringFromIndex:chatText.length - 2];
        if ([(EmojiKeyboardView *)self.faceView  stringIsFace:subStr]) {
            self.inputTextView.text = [chatText substringToIndex:chatText.length - 2];
            [self textViewDidChange:self.inputTextView];
            return;
        }
    }
    
    // 最后面两个字符不是表情，删除一个字符
    if (chatText.length > 0) {
        self.inputTextView.text = [chatText substringToIndex:chatText.length-1];
        [self textViewDidChange:self.inputTextView];
    }

}

//点击了表情键盘的send按钮
- (void)emojiKeyBoardViewdidSendFace{
    NSString *chatText = self.inputTextView.text;
    if (chatText.length > 0) {
        if ([self.delegate respondsToSelector:@selector(didSendText:)]) {
            if (chatText.length > 1000) {
                [self showAlerViewWithTitle:@"字数超长"];
                return ;
            }
            [self.delegate didSendText:chatText];
            self.inputTextView.text = @"";
        }
    }

}


#pragma mark - private

/**
 *  设置初始属性
 */
- (void)setupConfigure
{
    self.version = [[[UIDevice currentDevice] systemVersion] floatValue];
    self.autoresizingMask  = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin);
    self.backgroundColor = UIColorFromRGB(0xffffff);
}


- (void)setupSubviews
{
    CGFloat allButtonWidth = 0.0;
    CGFloat textViewLeftMargin = 2.0;
    
    
    //转变输入样式
    self.styleChangeButton = [[UIButton alloc] initWithFrame:CGRectMake(kHorizontalPadding, kVerticalPadding, kInputTextViewMinHeight, kInputTextViewMinHeight)];
    self.styleChangeButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.styleChangeButton setImage:[UIImage imageNamed:@"voice_icon"] forState:UIControlStateNormal];
    [self.styleChangeButton setImage:[UIImage imageNamed:@"voice_icon_on"] forState:UIControlStateHighlighted];
    [self.styleChangeButton setImage:[UIImage imageNamed:@"keyboard_icon"] forState:UIControlStateSelected];
    [self.styleChangeButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.styleChangeButton.tag = 0;
    allButtonWidth += CGRectGetMaxX(self.styleChangeButton.frame);
    textViewLeftMargin += CGRectGetMaxX(self.styleChangeButton.frame);
    
    //发送按钮
    if (_SendType == UCMessageToolBarSendTypeUP) {
        self.sendButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds) -kHorizontalPadding - kInputTextViewMinHeight, kVerticalPadding, kInputTextViewMinHeight, kInputTextViewMinHeight)];
        self.sendButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self.sendButton setImage:[UIImage imageNamed:@"chat_send_button"] forState:UIControlStateNormal];
        [self.sendButton setImage:[UIImage imageNamed:@"chat_send_buttonHL"] forState:UIControlStateHighlighted];
        [self.sendButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        self.sendButton.tag = 5;
        self.sendButton.hidden = YES;
    }
    

    //更多
    self.moreButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds) - kHorizontalPadding - kInputTextViewMinHeight, kVerticalPadding, kInputTextViewMinHeight, kInputTextViewMinHeight)];
    self.moreButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [self.moreButton setImage:[UIImage imageNamed:@"add_icon"] forState:UIControlStateNormal];
    [self.moreButton setImage:[UIImage imageNamed:@"add_icon_on"] forState:UIControlStateHighlighted];
    [self.moreButton setImage:[UIImage imageNamed:@"keyboard_icon"] forState:UIControlStateSelected];
    [self.moreButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.moreButton.tag = 2;
    allButtonWidth += CGRectGetWidth(self.moreButton.frame) + kHorizontalPadding ;
    
    
    
    
    //表情
    self.faceButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.moreButton.frame) - kInputTextViewMinHeight , kVerticalPadding, kInputTextViewMinHeight, kInputTextViewMinHeight)];
    self.faceButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [self.faceButton setImage:[UIImage imageNamed:@"facial_expression_icon"] forState:UIControlStateNormal];
    [self.faceButton setImage:[UIImage imageNamed:@"facial_expression_icon_on"] forState:UIControlStateHighlighted];
    [self.faceButton setImage:[UIImage imageNamed:@"keyboard_icon"] forState:UIControlStateSelected];
    [self.faceButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.faceButton.tag = 1;
    allButtonWidth += CGRectGetWidth(self.faceButton.frame) + 2 * 2;
    
    
    // 输入框的高度和宽度
    CGFloat width = CGRectGetWidth(self.bounds) - (allButtonWidth ? allButtonWidth : (textViewLeftMargin * 2));
    // 初始化输入框
    self.inputTextView = [[MessageTextView  alloc] initWithFrame:CGRectMake(textViewLeftMargin, kVerticalPadding, width, kInputTextViewMinHeight)];
    _inputTextView.scrollEnabled = YES;
    _inputTextView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    _inputTextView.returnKeyType = UIReturnKeySend;
    _inputTextView.enablesReturnKeyAutomatically = YES; // UITextView内部判断send按钮是否可以用
//    _inputTextView.placeHolder = @"发送新消息";
    _inputTextView.delegate = self;
    _inputTextView.font = [UIFont systemFontOfSize:16];
    _inputTextView.backgroundColor = [UIColor whiteColor];
    _inputTextView.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
    _inputTextView.layer.borderWidth = 0.65f;
    _inputTextView.layer.cornerRadius = 6.0f;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextViewTextDidChangeNotification object:nil];
    
    //显示在聊天框上的语音录制按钮
    self.recordButton = [[UIButton alloc] initWithFrame:CGRectMake(textViewLeftMargin, kVerticalPadding, width, kInputTextViewMinHeight)];
    self.recordButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [self.recordButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.recordButton setBackgroundImage:[[UIImage imageNamed:@"record_backGroudImage"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    [self.recordButton setBackgroundImage:[[UIImage imageNamed:@"record_backGroudImageHL"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateHighlighted];
    [self.recordButton setTitle:kTouchToRecord forState:UIControlStateNormal];
    [self.recordButton setTitle:kTouchToFinish forState:UIControlStateHighlighted];
    self.recordButton.hidden = YES;
    [self.recordButton addTarget:self action:@selector(recordButtonTouchDown) forControlEvents:UIControlEventTouchDown];
    [self.recordButton addTarget:self action:@selector(recordButtonTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
    [self.recordButton addTarget:self action:@selector(recordButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [self.recordButton addTarget:self action:@selector(recordDragOutside) forControlEvents:UIControlEventTouchDragExit];
    [self.recordButton addTarget:self action:@selector(recordDragInside) forControlEvents:UIControlEventTouchDragEnter];

    
    if (!self.faceView) {
        self.faceView = [[EmojiKeyboardView alloc] initWithSendButtonType:_SendType];
        [(EmojiKeyboardView *)self.faceView setDelegate:self];
        self.faceView.autoresizingMask =  UIViewAutoresizingFlexibleTopMargin;
    }
    
    if (!self.recordView) {
        UIImage *image = [UIImage imageNamed:@"recordViewbg"];
        CGFloat  w = image.size.width;
        CGFloat h = image.size.height;
        CGFloat x = ([UIScreen mainScreen].bounds.size.width - w)/2;
        CGFloat y = ([UIScreen mainScreen].bounds.size.height - h) / 2;
        self.recordView = [[UCRecordView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    }
    
    [self addSubview:self.styleChangeButton];
    [self addSubview:self.moreButton];
    [self addSubview:self.faceButton];
    [self addSubview:self.inputTextView];
    [self addSubview:self.recordButton];
    [self addSubview:self.sendButton];
}

- (void)textFieldDidChange:(NSNotification *)note
{
    MessageTextView * textView = (MessageTextView *)note.object;
    if (textView == self.inputTextView) {
        if (self.inputTextView.text.length > 1000) {
            self.inputTextView.textColor = [UIColor redColor];
        }else{
            self.inputTextView.textColor = [UIColor blackColor];
        }
    }
}


// 是否显示发送按钮，不显示就显示更多按钮
- (void)showSendButton:(BOOL) ret{
    
    if (_SendType == UCMessageToolBarSendTypeDown) {
        return;
    }
    
    if (ret) {
        self.sendButton.hidden = NO;
        self.moreButton.hidden = YES;
    }else{
        self.sendButton.hidden = YES;
        self.moreButton.hidden = NO;
    }
}



//根据文字获取高度
- (CGFloat)getTextViewContentH:(UITextView *)textView
{
    if (self.version >= 7.0)
    {
        return ceilf([textView sizeThatFits:textView.frame.size].height);
    } else {
        return textView.contentSize.height;
    }
}

#pragma mark - action

- (void)buttonAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    NSInteger tag = button.tag;
    
    switch (tag) {
        case 0://切换状态
        {
            if (button.selected) {  //切换到语音状态
                self.faceButton.selected = NO;
                self.moreButton.selected = NO;
                self.inputText = self.inputTextView.text;
                self.inputTextView.text = @"";
                [self.inputTextView resignFirstResponder];
            }
            else{
                self.inputTextView.text = self.inputText;
                self.inputText = nil;
                [self.inputTextView becomeFirstResponder];
            }
            
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.recordButton.hidden = !button.selected;
                self.inputTextView.hidden = button.selected;
            } completion:^(BOOL finished) {
                
            }];
            
            if ([self.delegate respondsToSelector:@selector(didStyleChangeToRecord:)]) {
                [self.delegate didStyleChangeToRecord:button.selected];
            }
        }
            break;
        case 1://表情
        {
            if (button.selected) {  //展开表情
                self.moreButton.selected = NO;
                //如果选择表情并且处于录音状态，切换成文字输入状态，但是不显示键盘
                if (self.styleChangeButton.selected) {
                    self.styleChangeButton.selected = NO;
                }
                
                //这里不需要取消，否知会让toolbar跳动，影响效果
//                else{//如果处于文字输入状态，使文字输入框失去焦点
//                    [self.inputTextView resignFirstResponder];
//                }
                
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.recordButton.hidden = button.selected;
                    self.inputTextView.hidden = !button.selected;
                } completion:^(BOOL finished) {
                    
                }];
            } else {  //收缩表情
                if (!self.styleChangeButton.selected) {
                    
//                    [self.inputTextView becomeFirstResponder];
                }
            }
            
            if ([self.delegate respondsToSelector:@selector(didSelectedFaceButton:)]) {
                [self.delegate didSelectedFaceButton:button.selected];
            }
            
        }
            break;
        case 2://更多
        {
            if (button.selected) {
                self.faceButton.selected = NO;
                //如果选择更多并且处于录音状态，切换成文字输入状态，但是不显示键盘
                if (self.styleChangeButton.selected) {
                    self.styleChangeButton.selected = NO;
                }
//                else{//如果处于文字输入状态，使文字输入框失去焦点
//                    [self.inputTextView resignFirstResponder];
//                }
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.recordButton.hidden = button.selected;
                    self.inputTextView.hidden = !button.selected;
                } completion:^(BOOL finished) {
                    
                }];
            }
            else
            {
                self.styleChangeButton.selected = NO;
//                [self.inputTextView becomeFirstResponder];
            }
            
            if ([self.delegate respondsToSelector:@selector(didSelectedMoreButton:)]) {
                [self.delegate didSelectedMoreButton:button.selected];
            }
            
        }
            break;
            
        case 5://发送
        {
            NSString *chatText = self.inputTextView.text;
            if (chatText.length > 0) {
                if ([self.delegate respondsToSelector:@selector(didSendText:)]) {
                    if (chatText.length > 1000) {
                        [self showAlerViewWithTitle:@"字数超长"];
                        return;
                    }
                    [self.delegate didSendText:chatText];
                    self.inputTextView.text = @"";
                }
                
                [self showSendButton:NO];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)showAlerViewWithTitle:(NSString *)title
{
    UIAlertView * v = [[UIAlertView alloc] initWithTitle:@"提示" message:title delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    [v show];
}


#pragma mark   Action
- (void)recordButtonTouchDown
{
    if ([self.recordView isKindOfClass:[UCRecordView class]]) {
        [(UCRecordView *)self.recordView recordButtonTouchDown];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(didStartRecordingVoiceAction:)]) {
        [_delegate didStartRecordingVoiceAction:self.recordView];
    }
}

- (void)recordButtonTouchUpOutside
{
    if (_delegate && [_delegate respondsToSelector:@selector(didCancelRecordingVoiceAction:)])
    {
        [_delegate didCancelRecordingVoiceAction:self.recordView];
    }
    
    if ([self.recordView isKindOfClass:[UCRecordView class]]) {
        [(UCRecordView *)self.recordView recordButtonTouchUpOutside];
    }
    
    [self.recordView removeFromSuperview];
}

- (void)recordButtonTouchUpInside
{
    if ([self.recordView isKindOfClass:[UCRecordView class]]) {
        [(UCRecordView *)self.recordView recordButtonTouchUpInside];
    }
    
    if ([self.delegate respondsToSelector:@selector(didFinishRecoingVoiceAction:)])
    {
        [self.delegate didFinishRecoingVoiceAction:self.recordView];
    }
    
    [self.recordView removeFromSuperview];
}

- (void)recordDragOutside
{
    if ([self.recordView isKindOfClass:[UCRecordView class]]) {
        [(UCRecordView *)self.recordView recordButtonDragOutside];
    }
    
    if ([self.delegate respondsToSelector:@selector(didDragOutsideAction:)])
    {
        [self.delegate didDragOutsideAction:self.recordView];
    }
}

- (void)recordDragInside
{
    if ([self.recordView isKindOfClass:[UCRecordView class]]) {
        [(UCRecordView *)self.recordView recordButtonDragInside];
    }
    
    if ([self.delegate respondsToSelector:@selector(didDragInsideAction:)])
    {
        [self.delegate didDragInsideAction:self.recordView];
    }
}



- (void)adjustTextViewHeightBy:(CGFloat)changeInHeight {
    // 动态改变自身的高度和输入框的高度
    CGRect prevFrame = self.inputTextView.frame;
    
    NSUInteger numLines = MAX([self.inputTextView numberOfLinesOfText],
                              [self.inputTextView.text numberOfLines]);
    
    self.inputTextView.frame = CGRectMake(prevFrame.origin.x,
                                          prevFrame.origin.y,
                                          prevFrame.size.width,
                                          prevFrame.size.height + changeInHeight);

    
    self.inputTextView.contentInset = UIEdgeInsetsMake((numLines >= 6 ? 4.0f : 0.0f),
                                                       0.0f,
                                                       (numLines >= 6 ? 4.0f : 0.0f),
                                                       0.0f);
    
    // from iOS 7, the content size will be accurate only if the scrolling is enabled.
    self.inputTextView.scrollEnabled = YES;
    
    if (numLines >= 6) {
        CGPoint bottomOffset = CGPointMake(0.0f, self.inputTextView.contentSize.height - self.inputTextView.bounds.size.height);
        [self.inputTextView setContentOffset:bottomOffset animated:YES];
        [self.inputTextView scrollRangeToVisible:NSMakeRange(self.inputTextView.text.length - 2, 1)];
    }
}


+ (CGFloat)maxLines {
    //iphone返回3行，ipad返回8行
    return ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) ? 3.0f : 8.0f;
}

+ (CGFloat)textViewLineHeight {
    return 36.0f; // for fontSize 16.0f
}

+ (CGFloat)maxHeight {
//    return ([UCMessageToolBar maxLines] + 1.0f) * [UCMessageToolBar textViewLineHeight];
    return 16.0 * [UCMessageToolBar maxLines] + [UCMessageToolBar textViewLineHeight];
}

+ (CGFloat)defaultHeight
{
    // 5*2 + 36 = 46
    return kVerticalPadding * 2 + kInputTextViewMinHeight;
}




@end
