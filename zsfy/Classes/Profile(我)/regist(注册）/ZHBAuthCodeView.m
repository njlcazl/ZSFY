//
//  ZHBAuthCodeView.m
//  ZHBTestDemo
//
//  Created by 庄彪 on 15/9/7.
//  Copyright (c) 2015年 zhuang. All rights reserved.
//

#import "ZHBAuthCodeView.h"

#define ZHBColorAlpha(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define ZHBColor(r, g, b) ZHBColorAlpha(r, g, b, 1.0)
#define ZHBRandomColorA ZHBColorAlpha(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random() % 50 / 100.f)
#define ZHBRandomColor ZHBColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

@interface ZHBAuthCodeView ()

/*! @brief  验证码 */
@property (nonatomic, copy, readwrite) NSString *authCode;

@end

@implementation ZHBAuthCodeView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)awakeFromNib {
    [self setupView];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    //绘制验证码
    NSMutableParagraphStyle *textStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
    textStyle.alignment = NSTextAlignmentCenter;
    NSMutableDictionary *authAttributes = [NSMutableDictionary dictionary];
    authAttributes[NSParagraphStyleAttributeName] = textStyle;
    
    NSString *authCode = self.authCode;
    CGFloat width = CGRectGetWidth(rect) / authCode.length;
    CGFloat height = CGRectGetHeight(rect);
    for (NSInteger index = 0; index < authCode.length; index ++) {
        UIFont *codeFont = nil;
        switch (arc4random() % 3) {
            case 0:
                codeFont = [UIFont boldSystemFontOfSize:17 + arc4random() % 15];
                break;
            case 1:
                codeFont = [UIFont systemFontOfSize:17 + arc4random() % 15];
                break;
            case 2:
                codeFont = [UIFont italicSystemFontOfSize:17 + arc4random() % 15];
                break;
            default:
                break;
        }
        
        authAttributes[NSFontAttributeName] = codeFont;
        authAttributes[NSForegroundColorAttributeName] = ZHBRandomColor;
        NSString *code = [authCode substringWithRange:NSMakeRange(index, 1)];
        CGFloat codeY = 0;
        if (height > codeFont.lineHeight + 1) {
             codeY = arc4random() % (NSInteger)(height - codeFont.lineHeight - 1);
        }
        [code drawInRect:CGRectMake(index * width, codeY, width, height - codeY) withAttributes:authAttributes];
    }

    //绘制干扰线
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0);
    NSInteger lineX = 0.f;
    NSInteger lineY = 0.f;
    for(NSInteger count = 0; count < 10; count ++) {
        CGContextSetStrokeColorWithColor(context, ZHBRandomColorA.CGColor);
        lineX = arc4random() % (NSInteger)rect.size.width;
        lineY = arc4random() % (NSInteger)rect.size.height;
        CGContextMoveToPoint(context, lineX, lineY);
        lineX = arc4random() % (NSInteger)rect.size.width;
        lineY = arc4random() % (NSInteger)rect.size.height;
        CGContextAddLineToPoint(context, lineX, lineY);
        CGContextStrokePath(context);
    }
}

#pragma mark - Public Methods
- (BOOL)isCorrectAuthCode:(NSString *)code {
    NSString *lowerCode = [code lowercaseString];
    NSString *lowerAuthCode = [self.authCode lowercaseString];
    return [lowerAuthCode isEqualToString:lowerCode];
}

- (void)changeAuthCode {
    self.authCode = [self randomAuthCode];
}

#pragma mark - Private Methods

- (void)setupView {
    self.backgroundColor = ZHBRandomColorA;
    self.authCode = [self randomAuthCode];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer:)];
    tap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:tap];
}

- (NSString *)randomAuthCode {
    const int count = 5;
    char data[count];
    for (int x = 0; x < count; x++) {
        int j = '0' + (arc4random_uniform(75));
        if((j >= 58 && j <= 64) || (j >= 91 && j <= 96)){
            --x;
        } else {
            data[x] = (char)j;
        }
    }
    return [[NSString alloc] initWithBytes:data length:count encoding:NSUTF8StringEncoding];
}

#pragma mark - Event Response
- (void)tapGestureRecognizer:(UITapGestureRecognizer *)sender {
    [self changeAuthCode];
}

#pragma mark Setters
- (void)setAuthCode:(NSString *)authCode {
    _authCode = [authCode copy];
    self.backgroundColor = ZHBRandomColorA;
    [self setNeedsDisplay];
}

@end
