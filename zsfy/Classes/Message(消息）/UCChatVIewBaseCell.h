//
//  UCChatVIewBaseCell.h
//  IMDemo_UI
//
//  Created by Barry on 15/4/17.
//  Copyright (c) 2015年 Barry. All rights reserved.
//


#import <UIKit/UIKit.h>

#import "MessageModel.h"
#import "UCChatBaseBubbleView.h"

#import "UIResponder+Router.h"

#define HEAD_SIZE 40 // 头像大小
#define HEAD_PADDING 5 // 头像到cell的内间距和头像到bubble的间距(水平方向)
#define CELLPADDING 8 // 头像到cell 内顶部的间距(竖直方向)

#define NAME_LABEL_WIDTH 180 // nameLabel宽度
#define NAME_LABEL_HEIGHT 20 // nameLabel 高度
#define NAME_LABEL_PADDING 0 // nameLabel间距
#define NAME_LABEL_FONT_SIZE 14 // 字体

extern NSString *const kRouterEventChatHeadImageTapEventName;

@interface UCChatVIewBaseCell : UITableViewCell
{
    UIImageView *_headImageView;
    UILabel *_nameLabel;
    UCChatBaseBubbleView *_bubbleView;
    
    CGFloat _nameLabelHeight;
    MessageModel *_messageModel;
}

@property (nonatomic, strong) MessageModel *messageModel;

@property (nonatomic, strong) UIImageView *headImageView;       //头像
@property (nonatomic, strong) UILabel *nameLabel;               //姓名
@property (nonatomic, strong) UCChatBaseBubbleView *bubbleView;   //内容区域

- (id)initWithMessageModel:(MessageModel *)model reuseIdentifier:(NSString *)reuseIdentifier;


- (void)setupSubviewsForMessageModel:(MessageModel *)model;

+ (NSString *)cellIdentifierForMessageModel:(MessageModel *)model;

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath withObject:(MessageModel *)model;

@end