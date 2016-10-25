//
//  EmojiKeyboardView.h
//  UC_Demo_1.0.0
//
//  Created by Barry on 15/5/7.
//  Copyright (c) 2015年 Barry. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, EmojiKeyboardViewCategoryImage) {
    EmojiKeyboardViewCategoryImageRecent,
    EmojiKeyboardViewCategoryImageFace,
};

//发送按钮在哪个位置
typedef NS_ENUM(NSUInteger, UCMessageToolBarSendType) {
    UCMessageToolBarSendTypeUP = 0,
    UCMessageToolBarSendTypeDown,
};

@protocol EmojiKeyboardViewDelegate;




@interface EmojiKeyboardView : UIView



@property (nonatomic, readonly) UIScrollView *emojiPagesScrollView;


@property (nonatomic, weak) id<EmojiKeyboardViewDelegate> delegate;

- (instancetype)initWithSendButtonType:(UCMessageToolBarSendType)SendButtntype;

- (instancetype)initWithFrame:(CGRect)frame;

- (BOOL)stringIsFace:(NSString *)string; //判断字符串是不是表情

@end




@protocol EmojiKeyboardViewDelegate <NSObject>

//选中
- (void)emojiKeyBoardView:(EmojiKeyboardView *)emojiKeyBoardView
              didUseEmoji:(NSString *)emoji;

//删除
- (void)emojiKeyBoardViewDidPressBackSpace:(EmojiKeyboardView *)emojiKeyBoardView;

//点击了发送
- (void)emojiKeyBoardViewdidSendFace;

@end

