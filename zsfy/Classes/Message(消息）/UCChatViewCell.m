//
//  UCChatViewCell.m
//  IMDemo_UI
//
//  Created by Barry on 15/4/20.
//  Copyright (c) 2015年 Barry. All rights reserved.
//

#import "UCChatViewCell.h"
#import "UCChatVideoBubbleView.h"
#import "UIResponder+Router.h"

NSString *const kResendButtonTapEventName = @"kResendButtonTapEventName";
NSString *const kShouldResendCell = @"kShouldResendCell";

@implementation UCChatViewCell

- (id)initWithMessageModel:(MessageModel *)model reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithMessageModel:model reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.headImageView.clipsToBounds = YES;
//        self.headImageView.layer.cornerRadius = 3.0;
    }
    return self;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
    CGRect bubbleFrame = _bubbleView.frame;
    bubbleFrame.origin.y = CGRectGetMaxY(_nameLabel.frame);
    
    if (self.messageModel.isSender) {
        bubbleFrame.origin.y = self.headImageView.frame.origin.y;
        // 菊花状态 （因不确定菊花具体位置，要在子类中实现位置的修改）
        switch (self.messageModel.status) {
            case MessageDeliveryState_Delivering:
            {
                [_activityView setHidden:NO];
                [_retryButton setHidden:YES];
                [_activtiy setHidden:NO];
                [_activtiy startAnimating];
            }
                break;
            case MessageDeliveryState_Delivered:
            {
                [_activtiy stopAnimating];
                [_activityView setHidden:YES];
                
            }
                break;
            case MessageDeliveryState_Failure:
            {
                [_activityView setHidden:NO];
                [_activtiy stopAnimating];
                [_activtiy setHidden:YES];
                [_retryButton setHidden:NO];
            }
                break;
            default:
                break;
        }
        
        
        bubbleFrame.origin.x = self.headImageView.frame.origin.x - bubbleFrame.size.width - HEAD_PADDING;
        _bubbleView.frame = bubbleFrame;
        
        CGRect frame = self.activityView.frame;
        frame.origin.x = bubbleFrame.origin.x - frame.size.width - ACTIVTIYVIEW_BUBBLE_PADDING;
        frame.origin.y = _bubbleView.center.y - frame.size.height / 2;
        self.activityView.frame = frame;
    }
    else{
        bubbleFrame.origin.x = HEAD_PADDING * 2 + HEAD_SIZE;
        _bubbleView.frame = bubbleFrame;
    }
}



- (void)setMessageModel:(MessageModel *)model
{
    [super setMessageModel:model];
    
    if (model.isChatGroup) {   //群聊的时候
        
        _nameLabel.text = model.nickName;
        _nameLabel.hidden = model.isSender;  // 自己发送的不显示
    }
    
    _bubbleView.model = self.messageModel;
    [_bubbleView sizeToFit];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - action

// 重发按钮事件
-(void)retryButtonPressed:(UIButton *)sender
{
    [self routerEventWithName:kResendButtonTapEventName
                     userInfo:@{kShouldResendCell:self}];
}

#pragma mark - private

- (void)setupSubviewsForMessageModel:(MessageModel *)messageModel
{
    [super setupSubviewsForMessageModel:messageModel];
    
    if (messageModel.isSender) {
        // 发送进度显示view
        _activityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SEND_STATUS_SIZE, SEND_STATUS_SIZE)];
        [_activityView setHidden:YES];
        [self.contentView addSubview:_activityView];
        
        // 重发按钮
        _retryButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _retryButton.frame = CGRectMake(0, 0, SEND_STATUS_SIZE, SEND_STATUS_SIZE);
        [_retryButton addTarget:self action:@selector(retryButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_retryButton setBackgroundImage:[UIImage imageNamed:@"messageSendFail.png"] forState:UIControlStateNormal];
        [_retryButton setBackgroundImage:[UIImage imageNamed:@"messageSendFailHL"] forState:UIControlStateHighlighted];
        [_activityView addSubview:_retryButton];
        
        // 菊花
        _activtiy = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activtiy.backgroundColor = [UIColor clearColor];
        [_activityView addSubview:_activtiy];
    }
    
    _bubbleView = [self bubbleViewForMessageModel:messageModel];
    [self.contentView addSubview:_bubbleView];
}

- (UCChatBaseBubbleView *)bubbleViewForMessageModel:(MessageModel *)messageModel
{
    switch (messageModel.type) {
        case MessageBodyType_Text:
        {
            return [[UCChatTextBubbleView alloc] init];
        }
            break;
        case MessageBodyType_Image:
        {
            return [[UCChatImageBubbleView alloc] init];
        }
            break;
        case MessageBodyType_Voice:
        {
            return [[UCChatAudioBubbleView alloc] init];
        }
            break;
        case MessageBodyType_Location:
        {
            return [[UCChatLocationBubbleView alloc] init];
        }
            break;
        case MessageBodyType_Video:
        {
            return [[UCChatVideoBubbleView alloc] init];
        }
            break;
        default:
            break;
    }
    
    return nil;
}


+ (CGFloat)bubbleViewHeightForMessageModel:(MessageModel *)messageModel
{
    switch (messageModel.type) {
        case MessageBodyType_Text:
        {
            return [UCChatTextBubbleView heightForBubbleWithObject:messageModel];
        }
            break;
        case MessageBodyType_Image:
        {
            return [UCChatImageBubbleView heightForBubbleWithObject:messageModel];
        }
            break;
        case MessageBodyType_Voice:
        {
            return [UCChatAudioBubbleView heightForBubbleWithObject:messageModel];
        }
            break;
        case MessageBodyType_Location:
        {
            return [UCChatLocationBubbleView heightForBubbleWithObject:messageModel];
        }
            break;
        case MessageBodyType_Video:
        {
            return [UCChatVideoBubbleView heightForBubbleWithObject:messageModel];
        }
            break;
        default:
            break;
    }
    
    return HEAD_SIZE;
}

#pragma mark - public

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath withObject:(MessageModel *)model
{
    CGFloat bubbleHeight = [self bubbleViewHeightForMessageModel:model] + 2 * CELLPADDING;
    CGFloat headHeight = CELLPADDING * 2 + HEAD_SIZE;
    
    //这里去掉，因为名字现在不显示在头像下面了，而是显示在消息内容上面
//    if (model.isChatGroup && !model.isSender) {  //群聊的时候，因为要显示对方的名字，所以相应的增加名字label的高度
//        headHeight += NAME_LABEL_HEIGHT;
//    }
    
    //如果群聊，并且不是发送者，显示名字，在气泡上面，那么可以把名字高度加到气泡上面
    if (model.isChatGroup && !model.isSender) {
        bubbleHeight += NAME_LABEL_HEIGHT;
    }

    
    return MAX(headHeight , bubbleHeight) ;
}



@end
