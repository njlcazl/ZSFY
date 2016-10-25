//
//  CycleScrollView.m
//  PagedScrollView
//
//  Created by 陈政 on 14-1-23.
//  Copyright (c) 2014年 Apple Inc. All rights reserved.
//

#import "CycleScrollView.h"
#import "NSTimer+Addition.h"
#import "UIView+ChangeSize.h"

@interface CycleScrollView () <UIScrollViewDelegate>

@property (nonatomic , assign) NSInteger currentPageIndex;
@property (nonatomic , assign) NSInteger totalPageCount;
@property (nonatomic , strong) NSMutableArray *contentViews;
@property (nonatomic ,strong) UIPageControl *pageControl;
@property (nonatomic , strong) NSTimer *animationTimer;
@property (nonatomic , assign) NSTimeInterval animationDuration;

@end

@implementation CycleScrollView

- (void)setTotalPagesCount:(NSInteger (^)(void))totalPagesCount
{
    _totalPageCount = totalPagesCount();
    if (_totalPageCount > 0) {
        [self configContentViews];
        [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
    }
}

- (id)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration andPageNumber:(NSInteger )num
{
    self = [self initWithFrame:frame andWithpage:num];
    
    if (animationDuration > 0.0) {
        
        if (!self.animationTimer) {
            
            
            self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:(self.animationDuration = animationDuration)
                                                                   target:self
                                                                 selector:@selector(animationTimerDidFired:)
                                                                 userInfo:nil
                                                                  repeats:YES];
            [self.animationTimer pauseTimer];
        }
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andWithpage:(NSInteger )page
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        if (self.scrollView==nil) {
            
            
            self.autoresizesSubviews = YES;
            
            self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
            self.scrollView.autoresizingMask = 0xFF;
            self.scrollView.contentMode = UIViewContentModeCenter;
            self.scrollView.contentSize = CGSizeMake(3 * [UIView setWidth:320], CGRectGetHeight(self.scrollView.frame));
            self.scrollView.delegate = self;
            self.scrollView.contentOffset = CGPointMake([UIView setWidth:320], 0);
            self.scrollView.pagingEnabled = YES;
            [self addSubview:self.scrollView];
            
            self.currentPageIndex = 0;
            
            _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0,self.frame.size.height - [UIView setWidth:10], frame.size.width,[UIView setHeight:10])];
            _pageControl.numberOfPages = page;
            
            _pageControl.currentPage = 0;
            _pageControl.userInteractionEnabled = NO;
            
            [self addSubview:_pageControl];
            
        }
        
        
    }
    return self;
}

#pragma mark -
#pragma mark - 私有函数

- (void)configContentViews
{
    //删除所有子视图
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    /**
     *  创建新的子视图
     */
    [self setScrollViewContentDataSource];
    
    
    //对每一个UIView的视图添加点击事件，并设置其位置
    NSInteger counter = 0;
    for (UIView *contentView in self.contentViews) {
        contentView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapAction:)];
        [contentView addGestureRecognizer:tapGesture];
        CGRect rightRect = contentView.frame;
        rightRect.origin = CGPointMake([UIView setWidth:320] * (counter ++), 0);
        
        contentView.frame = rightRect;
        [self.scrollView addSubview:contentView];
    }
    
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
}

/**
 *  设置scrollView的content数据源，即contentViews
 */


- (void)setScrollViewContentDataSource
{
    //前一个
    NSInteger previousPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
    //中间 _currentPageIndex
    //后一个
    NSInteger rearPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
    if (self.contentViews == nil) {
        self.contentViews = [@[] mutableCopy];
    }
    [self.contentViews removeAllObjects];
    
    if (self.fetchContentViewAtIndex) {
        [self.contentViews addObject:self.fetchContentViewAtIndex(previousPageIndex)];
        [self.contentViews addObject:self.fetchContentViewAtIndex(_currentPageIndex)];
        [self.contentViews addObject:self.fetchContentViewAtIndex(rearPageIndex)];
    }
}

//获取当前位置
- (NSInteger)getValidNextPageIndexWithPageIndex:(NSInteger)currentPageIndex;
{
    if(currentPageIndex == -1) {
        return self.totalPageCount - 1;
    } else if (currentPageIndex == self.totalPageCount) {
        return 0;
    } else {
        return currentPageIndex;
    }
}

#pragma mark -
#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.animationTimer pauseTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    
    [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
    int contentOffsetX = scrollView.contentOffset.x;
    
    
    if(contentOffsetX >= (2 * CGRectGetWidth(scrollView.frame))) {
        self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
        _pageControl.currentPage = self.currentPageIndex;
        
        
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    
    int contentOffsetX = scrollView.contentOffset.x;
    
    if(contentOffsetX >= (2 * CGRectGetWidth(scrollView.frame))) {
        self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
        _pageControl.currentPage = self.currentPageIndex;
        
        [self configContentViews];
    }
    if(contentOffsetX <= 0) {
        self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
        _pageControl.currentPage = self.currentPageIndex;
        
        [self configContentViews];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [scrollView setContentOffset:CGPointMake(CGRectGetWidth(scrollView.frame), 0) animated:YES];
}

#pragma mark -
#pragma mark - 响应事件

//设置定时器的响应事件
- (void)animationTimerDidFired:(NSTimer *)timer
{
    
    
    CGPoint newOffset = CGPointMake([UIView setWidth:320] + [UIView setWidth:320], self.scrollView.contentOffset.y);
    
    
    [self.scrollView setContentOffset:newOffset animated:YES];
}

- (void)setContentPoint:(CGPoint )point
{
    [self.scrollView setContentOffset:point animated:YES];
    
}


//获取当前的位置
- (void)contentViewTapAction:(UITapGestureRecognizer *)tap
{
    if (self.TapActionBlock) {
        self.TapActionBlock(self.currentPageIndex);
    }
}

-(void)dealloc
{
    self.animationTimer = nil;
    
}

@end
