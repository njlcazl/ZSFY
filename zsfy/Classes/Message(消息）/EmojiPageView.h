//
//  EmojiPageView.h
//  UC_Demo_1.0.0
//
//  Created by Barry on 15/5/7.
//  Copyright (c) 2015年 Barry. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EmojiPageViewDelegate;

@interface EmojiPageView : UIView

@property (nonatomic, assign) id<EmojiPageViewDelegate> delegate;


- (id)initWithFrame:(CGRect)frame
         buttonSize:(CGSize)buttonSize
               rows:(NSUInteger)rows
            columns:(NSUInteger)columns;


- (void)setButtonTexts:(NSMutableArray *)buttonTexts;

@end

@protocol EmojiPageViewDelegate <NSObject>

//选中
- (void)emojiPageView:(EmojiPageView *)emojiPageView didUseEmoji:(NSString *)emoji;

//删除
- (void)emojiPageViewDidPressBackSpace:(EmojiPageView *)emojiPageView;

@end
