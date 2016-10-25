//
//  ConversationTVC.m
//  ucpaas_IM
//
//  Created by 曾祺植 on 8/21/15.
//  Copyright (c) 2015 曾祺植. All rights reserved.
//

#import "ConversationTVC.h"
#import "CoreDataOperation.h"
#import "UIImageView+WebCache.h"
#import "NSString+Emojize.h"
#import "MBProgressHUD.h"
#import "GeTuiSdk.h"
#import "ComUnit.h"
#import "Helper.h"
#import "Search.h"
#import "FriendModel.h"
#import "PPDragDropBadgeView.h"


#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width


@interface ConversationTVC()

@property (weak, nonatomic) IBOutlet UIImageView *HeadImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *dateLable;
@property (weak, nonatomic) IBOutlet UILabel *latestLable;
@property (weak, nonatomic) IBOutlet UIView *Red;
@property (weak, nonatomic) IBOutlet UIImageView *BlockImg;

@end

@implementation ConversationTVC

- (void)awakeFromNib {
    self.backgroundColor = [UIColor clearColor];
    self.Red.layer.cornerRadius = 5;
    self.Red.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 *  设置会话的UI信息
 */
- (void)setInfo
{
    if (self.conversationItem.conversationType == UCS_IM_SOLOCHAT) {
        FriendModel *Info = [[Search shareInstance] getAllInfo:self.conversationItem.targetId];
        [self.HeadImage sd_setImageWithURL:[NSURL URLWithString:Info.imageUrl] placeholderImage:[UIImage imageNamed:@"Head"]];
        self.nameLable.text = Info.nikeName;
    } else if (self.conversationItem.conversationType == UCS_IM_DISCUSSIONCHAT) {
        self.nameLable.text = self.conversationItem.conversationTitle;
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.conversationItem.time];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    self.dateLable.text = [formatter stringFromDate:date];
    if (self.conversationItem.lastestMessageType == UCS_IM_TEXT) {
        UCSTextMsg *aTextMsg = (UCSTextMsg *)self.conversationItem.lastestMessage;
        NSString * str = aTextMsg.content;
        //转换内容里面的通用字符串为表情字符串
        NSString * emojizedString  =  [str emojizedString];
        self.latestLable.text = emojizedString;
    } else if (self.conversationItem.lastestMessageType == UCS_IM_IMAGE) {
        self.latestLable.text = @"[图片]";
    } else if (self.conversationItem.lastestMessageType == UCS_IM_VOICE) {
        self.latestLable.text = @"[语音]";
    } else if (self.conversationItem.lastestMessageType == UCS_IM_DiscussionNotification) {
        self.latestLable.text = @"[通知]";
    }


    if (self.conversationItem.conversationType == UCS_IM_SOLOCHAT) {
        
    } else if (self.conversationItem.conversationType == UCS_IM_DISCUSSIONCHAT) {
        [self.HeadImage setImage:[UIImage imageNamed:@"Discussion"]];
    } else if (self.conversationItem.conversationType == UCS_IM_GROUPCHAT) {
      //  [self.HeadImage sd_setImageWithURL:[NSURL URLWithString:self.GroupItem.groupIcon] placeholderImage:[UIImage imageNamed:@"group"]];
    }
    
    self.Red.hidden = YES;
    self.BlockImg.hidden = YES;
    int Unread = [[UCSIMClient sharedIM] getUnreadCount:self.conversationItem.conversationType targetId:self.conversationItem.targetId];
    
    if (Unread > 0) {
        //设置未读信息拖动删除回调事件
        NSArray *blockList = [CoreDataOperation getBlockList:[Helper getUserID]];
        for (int i = 0; i < blockList.count; i++) {
            if ([blockList[i] isEqualToString:self.conversationItem.targetId]) {
                self.BlockImg.hidden = NO;
                self.Red.hidden = NO;
                for (id obj in [self subviews]) {
                    if ([obj isKindOfClass:[PPDragDropBadgeView class]]) {
                        [obj removeFromSuperview];
                    }
                }
                return;
            }
        }

        PPDragDropBadgeView* badge = [[PPDragDropBadgeView alloc] initWithFrame:CGRectMake(SCREENWIDTH - 40, 30, 40, 20) dragdropCompletion:^{
            NSLog(@"Drag Done");
            [[UCSIMClient sharedIM] clearConversationsUnreadCount:self.conversationItem.conversationType
                                                         targetId:self.conversationItem.targetId];
            if (_delegate && [_delegate respondsToSelector:@selector(updateBadge)]) {
                [_delegate updateBadge];
            }
        }];
        badge.fontSizeAutoFit = YES;
        badge.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:badge];
        
        badge.text = [NSString stringWithFormat:@"%d", Unread];

    } else {
        NSArray *blockList = [CoreDataOperation getBlockList:[Helper getUserID]];
        for (int i = 0; i < blockList.count; i++) {
            if ([blockList[i] isEqualToString:self.conversationItem.targetId]) {
                self.BlockImg.hidden = NO;
                break;
            }
        }
        //移除多余的未读信息View
    }
}

- (void)setPushInfo:(UIView *)Superview
{
    [MBProgressHUD showHUDAddedTo:Superview animated:YES];
    self.Red.hidden = YES;
    self.BlockImg.hidden = YES;
    self.HeadImage.image = [UIImage imageNamed:@"Notification"];
    [ComUnit getPushInfo:[Helper getUser_Token] ClientId:[GeTuiSdk clientId] Callback:^(long long time, NSString *description, NSString *title, NSString *UnreadCount, BOOL succeed) {
        if (succeed) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.nameLable.text = title;
                self.latestLable.text = description;
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"MM-dd HH:mm"];
                self.dateLable.text = [formatter stringFromDate:date];
                //设置未读信息拖动删除回调事件
                for (id obj in [self subviews]) {
                    if ([obj isKindOfClass:[PPDragDropBadgeView class]]) {
                        [obj removeFromSuperview];
                    }
                }
                PPDragDropBadgeView* badge = [[PPDragDropBadgeView alloc] initWithFrame:CGRectMake(SCREENWIDTH - 40, 30, 40, 20) dragdropCompletion:^{
                    NSLog(@"Drag Done");
                    [ComUnit ClearUnreadCount:[Helper getUser_Token] clientId:[GeTuiSdk clientId]];
                    if (_delegate && [_delegate respondsToSelector:@selector(updateBadge)]) {
                        [_delegate updateBadge];
                    }
                }];
                //badge.translatesAutoresizingMaskIntoConstraints = NO;
                [self addSubview:badge];
                badge.text = UnreadCount;
                
            });
        }
        [MBProgressHUD hideAllHUDsForView:Superview animated:YES];
    }];
}

- (void)hideBadge
{
    for (id obj in [self subviews]) {
        if ([obj isKindOfClass:[PPDragDropBadgeView class]]) {
            PPDragDropBadgeView *item = obj;
            item.hidden = YES;
            break;
        }
    }
}

- (void)showBadge
{
    for (id obj in [self subviews]) {
        if ([obj isKindOfClass:[PPDragDropBadgeView class]]) {
            PPDragDropBadgeView *item = obj;
            item.hidden = NO;
            break;
        }
    }
}

@end
