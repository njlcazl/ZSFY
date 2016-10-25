//
//  UCChatNotificationCell.m
//  UC_Demo_1.0.0
//
//  Created by Barry on 15/5/23.
//  Copyright (c) 2015年 Barry. All rights reserved.
//

#import "UCChatNotificationCell.h"

#define TEXT_MAX_WIDTH  ([UIScreen mainScreen].bounds.size.width - 40) //通知文本的最大宽度
#define LABEL_FONT_SIZE 15      // 文字大小
#define LABEL_LINESPACE 0       // 行间距

@interface UCChatNotificationCell()
{
    UILabel *_noteLabel;
    
    UIImageView * _backImageView; //背景
}

@end

@implementation UCChatNotificationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //背景
        _backImageView = [[UIImageView alloc] init];
        [self addSubview:_backImageView];
        
        //显示文本
        _noteLabel = [[UILabel alloc] init];
        _noteLabel.backgroundColor = [UIColor clearColor];
        _noteLabel.textAlignment = NSTextAlignmentLeft;
        _noteLabel.font = [UIFont systemFontOfSize:LABEL_FONT_SIZE];
        _noteLabel.textColor = [UIColor whiteColor];
        _noteLabel.numberOfLines = 0;
        _noteLabel.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:_noteLabel];

    }
    
    return self;
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


+(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath withObject:(MessageModel *)model{

    CGFloat bubbleHeight = [self notificationBubbleViewHeightForMessageModel:model];
    return bubbleHeight + 15;
}


- (void)setModel:(MessageModel *)model{
    _model = model;
    
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]
                                                    initWithString:self.model.content];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:[[self class] lineSpacing]];
    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:paragraphStyle
                             range:NSMakeRange(0, [self.model.content length])];
    [_noteLabel setAttributedText:attributedString];
    
    UIImage * image = [UIImage imageNamed:@"chat_timeBubble"];
    CGSize imageSize = image.size;
    image = [image stretchableImageWithLeftCapWidth:imageSize.width/2 topCapHeight:imageSize.height/2];
    _backImageView.image = image;

    [self setNeedsLayout];
    
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    _backImageView.frame = CGRectZero;
    _noteLabel.frame = CGRectZero;
    
    CGSize textBlockMinSize = {TEXT_MAX_WIDTH, CGFLOAT_MAX};
    CGSize size;
    static float systemVersion;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    });
    if (systemVersion >= 7.0) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:[[self class] lineSpacing]];//调整行间距
        size = [_model.content boundingRectWithSize:textBlockMinSize options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{
                                                     NSFontAttributeName:[[self class] textLabelFont],
                                                     NSParagraphStyleAttributeName:paragraphStyle
                                                     }
                                           context:nil].size;
    }else{
        size = [_model.content sizeWithFont:[[self class] textLabelFont]
                         constrainedToSize:textBlockMinSize
                             lineBreakMode:NSLineBreakByCharWrapping];
    }
    
    _noteLabel.frame  = CGRectMake( (self.frame.size.width - size.width )/2, 2 , size.width, size.height);

    _backImageView.frame = CGRectMake(_noteLabel.frame.origin.x - 5, _noteLabel.frame.origin.y - 2, size.width + 10, size.height + 4);
    
    
}



#pragma mark
+ (CGFloat)notificationBubbleViewHeightForMessageModel:(MessageModel *) model{
    
    CGSize textBlockMinSize = {TEXT_MAX_WIDTH, CGFLOAT_MAX};
    CGSize size;
    static float systemVersion;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    });
    if (systemVersion >= 7.0) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:[[self class] lineSpacing]];//调整行间距
        size = [model.content boundingRectWithSize:textBlockMinSize options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{
                                                      NSFontAttributeName:[[self class] textLabelFont],
                                                      NSParagraphStyleAttributeName:paragraphStyle
                                                      }
                                            context:nil].size;
    }else{
        size = [model.content sizeWithFont:[[self class] textLabelFont]
                          constrainedToSize:textBlockMinSize
                              lineBreakMode:NSLineBreakByCharWrapping];
    }
    return  size.height;
}

+(UIFont *)textLabelFont
{
    return [UIFont systemFontOfSize:LABEL_FONT_SIZE];
}

+(CGFloat)lineSpacing{
    return LABEL_LINESPACE;
}



@end
