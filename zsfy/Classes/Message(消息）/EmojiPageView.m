//
//  EmojiPageView.m
//  UC_Demo_1.0.0
//
//  Created by Barry on 15/5/7.
//  Copyright (c) 2015年 Barry. All rights reserved.
//

#import "EmojiPageView.h"

#define BACKSPACE_BUTTON_TAG 10
#define BUTTON_FONT_SIZE 32

@interface EmojiPageView ()

@property (nonatomic) CGSize buttonSize;
@property (nonatomic) NSMutableArray *buttons;
@property (nonatomic) NSUInteger columns;
@property (nonatomic) NSUInteger rows;

@end

@implementation EmojiPageView

- (void)setButtonTexts:(NSMutableArray *)buttonTexts {
    
    NSAssert(buttonTexts != nil, @"Array containing texts to be set on buttons is nil");
    
    if (([self.buttons count] - 1) == [buttonTexts count]) {
        // just reset text on each button
        for (NSUInteger i = 0; i < [buttonTexts count]; ++i) {
            UIButton * button = self.buttons[i];
            [button setTitle:buttonTexts[i] forState:UIControlStateNormal];
        }
    } else {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        self.buttons = nil;
        self.buttons = [NSMutableArray arrayWithCapacity:self.rows * self.columns];
        for (NSUInteger i = 0; i < [buttonTexts count]; ++i) {
            UIButton *button = [self createButtonAtIndex:i];
            [button setTitle:buttonTexts[i] forState:UIControlStateNormal];
            [self addToViewButton:button];
        }
        UIButton *button = [self createButtonAtIndex:self.rows * self.columns - 1];
        [button setImage:[UIImage imageNamed:@"emoji_delete_button"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"emoji_delete_buttonHL"] forState:UIControlStateHighlighted];
        button.tag = BACKSPACE_BUTTON_TAG;
        [self addToViewButton:button];
    }
}

- (void)addToViewButton:(UIButton *)button {
    
    NSAssert(button != nil, @"Button to be added is nil");
    
    [self.buttons addObject:button];
    [self addSubview:button];
}





- (CGFloat)XMarginForButtonInColumn:(NSInteger)column {
    CGFloat padding = ((CGRectGetWidth(self.bounds) - self.columns * self.buttonSize.width) / self.columns);
    return (padding / 2 + column * (padding + self.buttonSize.width));
}

- (CGFloat)YMarginForButtonInRow:(NSInteger)rowNumber {
    CGFloat padding = ((CGRectGetHeight(self.bounds) - self.rows * self.buttonSize.height) / self.rows);
    return (padding / 2 + rowNumber * (padding + self.buttonSize.height));
}

- (UIButton *)createButtonAtIndex:(NSUInteger)index {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont fontWithName:@"Apple color emoji" size:BUTTON_FONT_SIZE];
    NSInteger row = (NSInteger)(index / self.columns);
    NSInteger column = (NSInteger)(index % self.columns);
    button.frame = CGRectIntegral(CGRectMake([self XMarginForButtonInColumn:column],
                                             [self YMarginForButtonInRow:row],
                                             self.buttonSize.width,
                                             self.buttonSize.height));
    [button addTarget:self
               action:@selector(emojiButtonPressed:)
     forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (id)initWithFrame:(CGRect)frame
         buttonSize:(CGSize)buttonSize
               rows:(NSUInteger)rows
            columns:(NSUInteger)columns {
    self = [super initWithFrame:frame];
    if (self) {
        _buttonSize = buttonSize; //按钮大小
        _columns = columns; //列数
        _rows = rows; // 行数
        _buttons = [[NSMutableArray alloc] initWithCapacity:rows * columns];
    }
    return self;
}


//表情被点击了
- (void)emojiButtonPressed:(UIButton *)button {
    if (button.tag == BACKSPACE_BUTTON_TAG) {
        [self.delegate emojiPageViewDidPressBackSpace:self];
        return;
    }
    [self.delegate emojiPageView:self didUseEmoji:button.titleLabel.text];
}

@end
