//
//  UCRecordView.h
//  UC_Demo_1.0.0
//
//  Created by Barry on 15/4/23.
//  Copyright (c) 2015年 Barry. All rights reserved.
//  



#import <UIKit/UIKit.h>

@interface UCRecordView : UIView

@property (nonatomic) long currentTime; // 当前录了多久了

// 录音按钮按下
-(void)recordButtonTouchDown;
// 手指在录音按钮内部时离开
-(void)recordButtonTouchUpInside;
// 手指在录音按钮外部时离开
-(void)recordButtonTouchUpOutside;
// 手指移动到录音按钮内部
-(void)recordButtonDragInside;
// 手指移动到录音按钮外部
-(void)recordButtonDragOutside;




- (void)setVoiceImage:(CGFloat)voiceSound; // 设置振幅

- (void)setlableText:(double) time; //设置倒计时，当前还可以说几秒

@end
