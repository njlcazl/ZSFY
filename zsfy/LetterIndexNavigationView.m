//
//  LetterIndexNavigationView.m
//  UC_Demo_1.0.0
//
//  Created by Barry on 15/5/11.
//  Copyright (c) 2015年 Barry. All rights reserved.
//

#import "LetterIndexNavigationView.h"
#import "LetterIndexNavigationItem.h"

#define kImageViewTag 888
@interface LetterIndexNavigationView()

@property(nonatomic,strong) UIView *contentView;
@property(nonatomic,strong) NSMutableArray *items;
@property (nonatomic, strong) UIView *searchIconView;

@end

@implementation LetterIndexNavigationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setUp];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.backgroundColor = [UIColor clearColor];
}

- (UIView *)searchIconView
{
    if (!_searchIconView) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"SearchIcon"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.clipsToBounds = YES;
        imageView.backgroundColor = [UIColor clearColor];
        imageView.tag = kImageViewTag;
        
        
        _searchIconView = [[UIView alloc]init];
        _searchIconView.backgroundColor = [UIColor clearColor];
        [_searchIconView addSubview:imageView];
    }
    return _searchIconView;
}

- (UIView*)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor clearColor];
        [self addSubview:_contentView];
    }
    return _contentView;
}

- (void)setIsNeedSearchIcon:(BOOL)isNeedSearchIcon
{
    _isNeedSearchIcon = isNeedSearchIcon;
    if (isNeedSearchIcon&&!self.searchIconView.superview) {
        [self.contentView addSubview:self.searchIconView];
    }else if(!isNeedSearchIcon&&self.searchIconView.superview){
        [self.searchIconView removeFromSuperview];
    }
    
    [self setNeedsLayout];
}

- (void)setKeys:(NSArray *)keys
{
    if ([keys isEqual:_keys]) {
        return;
    }
    
    _keys = keys;
    
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[LetterIndexNavigationItem class]]) {
            [view removeFromSuperview];
        }
    }//删除所有的子View，重新加载
    
    self.items = [NSMutableArray array];
    
    for (NSUInteger i=0; i<self.keys.count; i++) {
        LetterIndexNavigationItem *item = [[LetterIndexNavigationItem alloc]init];
        item.text = self.keys[i];
        item.index = i;
        [self.contentView addSubview:item];
        [self.items addObject:item];
    }
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!self.keys) {
        return;
    }
    
    NSUInteger count = self.keys.count;
    if (self.isNeedSearchIcon) {
        count++;
    }
    //整理自身的数据
#define kMaxItemHeight 15  //最高15高度，如果太多的话可能会重叠
    CGFloat itemHeight = self.frame.size.height/count;
    if (itemHeight>kMaxItemHeight) {
        itemHeight = kMaxItemHeight;
    }
    
    CGFloat lastY = 0;
    if (self.isNeedSearchIcon) {
#define kIconWidth 10.0f
        self.searchIconView.frame = CGRectMake(0, lastY, self.frame.size.width, itemHeight);
        //找到imageView
        [self.searchIconView viewWithTag:kImageViewTag].frame = CGRectMake((self.searchIconView.frame.size.width-kIconWidth)/2, lastY, kIconWidth, kIconWidth);
        
        lastY+=itemHeight;
    }
    for (LetterIndexNavigationItem *item in self.items) {
        item.frame = CGRectMake(0, lastY, self.frame.size.width, itemHeight);
        lastY+=itemHeight;
    }
    //内容View放在中间
    self.contentView.frame = CGRectMake(0, (self.frame.size.height-lastY)/2, self.frame.size.width, lastY);
}

- (void)unHighlightAllItem
{
    //全局取消高亮
    for (LetterIndexNavigationItem *item in self.items) {
        item.isHighlighted = NO;
    }
}

#pragma mark - 下面处理触摸事件

- (void)findAndSelectItemWithTouchPoint:(CGPoint)touchPoint
{
    if (self.isNeedSearchIcon) {
        if (CGRectContainsPoint(self.searchIconView.frame,touchPoint)) {
            //找到了选择的index
            if (self.delegate&&[self.delegate respondsToSelector:@selector(LetterIndexNavigationView:didSelectIndex:)]) {
                [self.delegate LetterIndexNavigationView:self didSelectIndex:0];
            }
            return;
        }
    }
    
    for (LetterIndexNavigationItem *item in self.items) {
        if (CGRectContainsPoint(item.frame, touchPoint)) {
            [self unHighlightAllItem];
            item.isHighlighted = YES;//设置其高亮
            //找到了选择的index
            if (self.delegate&&[self.delegate respondsToSelector:@selector(LetterIndexNavigationView:didSelectIndex:)]) {
                [self.delegate LetterIndexNavigationView:self didSelectIndex:self.isNeedSearchIcon?item.index+1:item.index];
            }
            return;
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.contentView];
    
    [self.delegate tableViewIndexTouchesBegan:self];

    [self findAndSelectItemWithTouchPoint:touchPoint];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.contentView];
    
    

    [self findAndSelectItemWithTouchPoint:touchPoint];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [self.delegate tableViewIndexTouchesEnd:self];

    [self touchesCancelled:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self unHighlightAllItem];
}


@end
