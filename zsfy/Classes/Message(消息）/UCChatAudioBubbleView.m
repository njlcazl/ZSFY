//
//  UCChatAudioBubbleView.m
//  IMDemo_UI
//
//  Created by Barry on 15/4/20.
//  Copyright (c) 2015年 Barry. All rights reserved.
//

#import "UCChatAudioBubbleView.h"

NSString *const kRouterEventAudioBubbleTapEventName = @"kRouterEventAudioBubbleTapEventName";

@interface UCChatAudioBubbleView ()
{
    NSMutableArray *_senderAnimationImages;
    NSMutableArray *_recevierAnimationImages;
    UIImageView    *_isReadView; //是否未读
}

@end


@implementation UCChatAudioBubbleView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _animationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ANIMATION_IMAGEVIEW_SIZE, ANIMATION_IMAGEVIEW_SIZE)];
        _animationImageView.animationDuration = ANIMATION_IMAGEVIEW_SPEED;
        [self addSubview:_animationImageView];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ANIMATION_TIME_LABEL_WIDHT, ANIMATION_TIME_LABEL_HEIGHT)];
        _timeLabel.font = [UIFont boldSystemFontOfSize:ANIMATION_TIME_LABEL_FONT_SIZE];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.textColor = [UIColor grayColor];
        _timeLabel.backgroundColor = [UIColor clearColor];
//        _timeLabel.backgroundColor = [UIColor redColor];
        [self addSubview:_timeLabel];
        
        _isReadView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        _isReadView.layer.cornerRadius = 5;
        [_isReadView setClipsToBounds:YES];
        [_isReadView setBackgroundColor:[UIColor redColor]];
        [self addSubview:_isReadView];
        
        _senderAnimationImages = [[NSMutableArray alloc] initWithObjects: [UIImage imageNamed:SENDER_ANIMATION_IMAGEVIEW_IMAGE_01], [UIImage imageNamed:SENDER_ANIMATION_IMAGEVIEW_IMAGE_02], [UIImage imageNamed:SENDER_ANIMATION_IMAGEVIEW_IMAGE_03], [UIImage imageNamed:SENDER_ANIMATION_IMAGEVIEW_IMAGE_04], nil];
        _recevierAnimationImages = [[NSMutableArray alloc] initWithObjects: [UIImage imageNamed:RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_01], [UIImage imageNamed:RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_02], [UIImage imageNamed:RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_03], [UIImage imageNamed:RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_04], nil];
    }
    return self;
}

-(CGSize)sizeThatFits:(CGSize)size
{
    //通过改变timelabel 和 喇叭之间的距离来改变，整个气泡的宽度
    
    CGFloat paddingWidth = [self WidthWithModel:self.model];
    
    
//    CGFloat width = BUBBLE_VIEW_PADDING*2 + BUBBLE_ARROW_WIDTH + ANIMATION_TIME_LABEL_WIDHT +ANIMATION_TIME_IMAGEVIEW_PADDING * 20 + ANIMATION_IMAGEVIEW_SIZE;
    
    CGFloat width = BUBBLE_VIEW_PADDING*2 + BUBBLE_ARROW_WIDTH + ANIMATION_TIME_LABEL_WIDHT +paddingWidth + ANIMATION_IMAGEVIEW_SIZE;
    
    CGFloat maxHeight = MAX(ANIMATION_IMAGEVIEW_SIZE, ANIMATION_TIME_LABEL_HEIGHT);
    CGFloat height = BUBBLE_VIEW_PADDING*2 + maxHeight;
    return CGSizeMake(width, height);
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = _animationImageView.frame;
    if (self.model.isSender) {
        frame.origin.x = self.frame.size.width - BUBBLE_ARROW_WIDTH - frame.size.width - BUBBLE_VIEW_PADDING;
        frame.origin.y = self.frame.size.height / 2 - frame.size.height / 2;
        _animationImageView.frame = frame;
        
        frame = _timeLabel.frame;
        frame.origin.x = _animationImageView.frame.origin.x - ANIMATION_TIME_IMAGEVIEW_PADDING - ANIMATION_TIME_LABEL_WIDHT;
        frame.origin.y = _animationImageView.center.y - frame.size.height / 2;
        _timeLabel.frame = frame;
        
    }
    else {
        _animationImageView.image = [UIImage imageNamed:RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_DEFAULT];
        
        frame.origin.x = BUBBLE_ARROW_WIDTH + BUBBLE_VIEW_PADDING;
        frame.origin.y = self.frame.size.height / 2 - frame.size.height / 2;
        _animationImageView.frame = frame;
        
        frame = _timeLabel.frame;
        frame.origin.x = ANIMATION_TIME_IMAGEVIEW_PADDING + BUBBLE_ARROW_WIDTH + _animationImageView.frame.size.width + _animationImageView.frame.origin.x;
        frame.origin.y = _animationImageView.center.y - frame.size.height / 2;
        _timeLabel.frame = frame;
        
//        frame.origin.x += frame.size.width - _isReadView.frame.size.width / 2;
        frame.origin.x = self.frame.size.width - 5;
        frame.origin.y = - _isReadView.frame.size.height / 2;
        frame.size = _isReadView.frame.size;
        _isReadView.frame = frame;
    }
}

#pragma mark - setter

- (void)setModel:(MessageModel *)model
{
    [super setModel:model];
    
   
    _timeLabel.text = [NSString stringWithFormat:@"%d'",((int)self.model.time) >=1? ((int)self.model.time): 1];
    
    if (self.model.isSender) {
        [_isReadView setHidden:YES];
        _animationImageView.image = [UIImage imageNamed:SENDER_ANIMATION_IMAGEVIEW_IMAGE_DEFAULT];
        _animationImageView.animationImages = _senderAnimationImages;
    }
    else{
        if (model.isPlayed) {
            [_isReadView setHidden:YES];
        }else{
            [_isReadView setHidden:NO];
        }
        
        _animationImageView.image = [UIImage imageNamed:RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_DEFAULT];
        _animationImageView.animationImages = _recevierAnimationImages;
    }
    
    if (self.model.isPlaying)
    {
        [self startAudioAnimation];
    }else {
        [self stopAudioAnimation];
    }
}

#pragma mark - public

-(void)bubbleViewPressed:(id)sender
{
    [self routerEventWithName:kRouterEventAudioBubbleTapEventName userInfo:@{KMESSAGEKEY:self.model}];
}


+(CGFloat)heightForBubbleWithObject:(MessageModel *)object
{
    return 2 * BUBBLE_VIEW_PADDING + ANIMATION_IMAGEVIEW_SIZE;
}

-(void)startAudioAnimation
{
    [_animationImageView startAnimating];
}

-(void)stopAudioAnimation
{
    [_animationImageView stopAnimating];
}



#pragma mark 获取中间距离的宽度
/**
 *  根据长度修改 timelabel 和 喇叭 之间的宽度， 用来改变语音气泡的宽度
 *
 */
- (CGFloat)WidthWithModel:(MessageModel *) object{
    NSInteger time = object.time;
    if (time >=  60) {
        return ANIMATION_TIME_IMAGEVIEW_PADDING * 20;
    }else if(time <=5){
        return ANIMATION_TIME_IMAGEVIEW_PADDING;
    }else{
        NSInteger num = time/3;
        return num * ANIMATION_TIME_IMAGEVIEW_PADDING;
    }
}

@end
