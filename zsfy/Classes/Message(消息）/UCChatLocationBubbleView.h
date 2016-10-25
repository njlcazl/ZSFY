//
//  UCChatLocationBubbleView.h
//  IMDemo_UI
//
//  Created by Barry on 15/4/20.
//  Copyright (c) 2015年 Barry. All rights reserved.
//

#import "UCChatBaseBubbleView.h"


#define LOCATION_IMAGE @"chat_location_preview" // 显示的地图图片
#define LOCATION_IMAGEVIEW_SIZE 95 // 地图图片大小

#define LOCATION_ADDRESS_LABEL_FONT_SIZE  10 // 位置字体大小
#define LOCATION_ADDRESS_LABEL_PADDING 2 // 位置文字与外边间距
#define LOCATION_ADDRESS_LABEL_BGVIEW_HEIGHT 25 // 位置文字显示外框的高度

extern NSString *const kRouterEventLocationBubbleTapEventName;

@interface UCChatLocationBubbleView : UCChatBaseBubbleView



@end
