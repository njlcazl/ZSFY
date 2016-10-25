//
//  UCChatTextBubbleView.h
//  IMDemo_UI
//
//  Created by Barry on 15/4/17.
//  Copyright (c) 2015年 Barry. All rights reserved.
//

#import "UCChatBaseBubbleView.h"

#define TEXTLABEL_MAX_WIDTH ([UIScreen mainScreen].bounds.size.width - 2 * 40 - 2* 5 - 5 - 2 * 8 ) // textLaebl 最大宽度
#define LABEL_FONT_SIZE 16      // 文字大小
#define LABEL_LINESPACE 5       // 行间距

extern NSString *const kRouterEventTextURLTapEventName;

@interface UCChatTextBubbleView : UCChatBaseBubbleView

@property (nonatomic, strong) UILabel *textLabel;

+ (CGFloat)lineSpacing;
+ (UIFont *)textLabelFont;
+ (NSLineBreakMode)textLabelLineBreakModel;

@end
