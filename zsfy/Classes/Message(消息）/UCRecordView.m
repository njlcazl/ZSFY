//
//  UCRecordView.m
//  UC_Demo_1.0.0
//
//  Created by Barry on 15/4/23.
//  Copyright (c) 2015年 Barry. All rights reserved.
//

#import "UCRecordView.h"
#import <AVFoundation/AVFoundation.h>

@interface UCRecordView ()
{
    NSTimer *_timer;
    // 显示动画的ImageView
    UIImageView *_recordAnimationView;
    // 提示文字
    UILabel *_textLabel;
    
    // 显示喇叭和删除的imageview
    UIImageView * _speakerView;
    
    BOOL isTouchUpOutSide; //手指是否已到外面，开始时 为no
}

@end

@implementation UCRecordView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //底图
        UIImageView * backView = [[UIImageView alloc] initWithFrame:self.bounds];
        backView.image = [UIImage imageNamed:@"recordViewbg"];
        backView.userInteractionEnabled = YES;
        [self addSubview:backView];
        
        CGFloat w = 184/2;
        CGFloat h = 74/2;
        _recordAnimationView = [[UIImageView alloc] initWithFrame:CGRectMake((self.bounds.size.width - w)/2, 10, w, h)];
        _recordAnimationView.image = [UIImage imageNamed:@"greenVolume01"];
        [self addSubview:_recordAnimationView];
        
        //放喇叭的图
        w = 88/2;
        h = 132/2;
        _speakerView = [[UIImageView alloc] initWithFrame:CGRectMake((self.bounds.size.width - w)/2 , CGRectGetMaxY(_recordAnimationView.frame) + 15 , w, h)];
        _speakerView.image = [UIImage imageNamed:@"record_speaker"];
        _speakerView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_speakerView];
        
        //文字
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,
                                                                CGRectGetMaxY(_speakerView.frame) + 10,
                                                               self.bounds.size.width - 10,
                                                               25)];
        
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.text = @"手指上滑,取消发送";
        [self addSubview:_textLabel];
        _textLabel.font = [UIFont systemFontOfSize:12];
        _textLabel.textColor = UIColorFromRGB(0xf0f0f0);
        _textLabel.layer.cornerRadius = 5;
        _textLabel.layer.borderColor = [[UIColor redColor] colorWithAlphaComponent:0.5].CGColor;
        _textLabel.layer.masksToBounds = YES;
        
        isTouchUpOutSide = NO;
    }
    return self;
}

// 录音按钮按下
-(void)recordButtonTouchDown
{
    isTouchUpOutSide = NO;
    _speakerView.image = [UIImage imageNamed:@"record_speaker"];
    
    // 需要根据声音大小切换recordView动画
    _textLabel.text = @"手指上滑,取消发送";
    _textLabel.backgroundColor = [UIColor clearColor];
    
}
// 手指在录音按钮内部时离开
-(void)recordButtonTouchUpInside
{
    isTouchUpOutSide = NO;
     _speakerView.image = [UIImage imageNamed:@"record_speaker"];
}
// 手指在录音按钮外部时离开
-(void)recordButtonTouchUpOutside
{
    isTouchUpOutSide = NO;
}
// 手指移动到录音按钮内部
-(void)recordButtonDragInside
{
    isTouchUpOutSide = NO;
    _textLabel.text = @"手指上滑,取消发送";
    _textLabel.backgroundColor = [UIColor clearColor];
    
    _speakerView.image = [UIImage imageNamed:@"record_speaker"];
}

// 手指移动到录音按钮外部
-(void)recordButtonDragOutside
{
    isTouchUpOutSide = YES;
    _textLabel.text = @"松开手指,取消发送";
    _textLabel.backgroundColor = [UIColor redColor];
    
    _speakerView.image = [UIImage imageNamed:@"record_delete"];
}


- (void)setVoiceImage:(CGFloat)voiceSound{
    
    if (isTouchUpOutSide) {  //在外面
        if (voiceSound == 0) {
            _recordAnimationView.image = [UIImage imageNamed:@"redVolume01"];
        }else if (0 < voiceSound <= 0.16) {
            _recordAnimationView.image = [UIImage imageNamed:@"redVolume02"];
        }else if (0.16<voiceSound<=0.33) {
            _recordAnimationView.image = [UIImage imageNamed:@"redVolume03"];
        }else if (0.33<voiceSound<=0.5) {
            _recordAnimationView.image = [UIImage imageNamed:@"redVolume04"];
        }else if (0.5<voiceSound<=0.66) {
            _recordAnimationView.image = [UIImage imageNamed:@"redVolume05"];
        }else if (0.66<voiceSound<=0.88) {
            _recordAnimationView.image = [UIImage imageNamed:@"redVolume06"];
        }else {
            _recordAnimationView.image = [UIImage imageNamed:@"redVolume07"];
        }
    }else{   //里面
        if (voiceSound == 0) {
            _recordAnimationView.image = [UIImage imageNamed:@"greenVolume01"];
        }else if (0 < voiceSound <= 0.16) {
            _recordAnimationView.image = [UIImage imageNamed:@"greenVolume02"];
        }else if (0.16<voiceSound<=0.33) {
            _recordAnimationView.image = [UIImage imageNamed:@"greenVolume03"];
        }else if (0.33<voiceSound<=0.5) {
            _recordAnimationView.image = [UIImage imageNamed:@"greenVolume04"];
        }else if (0.5<voiceSound<=0.66) {
            _recordAnimationView.image = [UIImage imageNamed:@"greenVolume05"];
        }else if (0.66<voiceSound<=0.88) {
            _recordAnimationView.image = [UIImage imageNamed:@"greenVolume06"];
        }else {
            _recordAnimationView.image = [UIImage imageNamed:@"greenVolume07"];
        }
    }

}

- (void)setlableText:(double)time{
    if (!isTouchUpOutSide) {  //在里面
        int t = (60 - time);
        _textLabel.text = [NSString stringWithFormat:@"你还可以说%d秒", t];
    }
}


@end
