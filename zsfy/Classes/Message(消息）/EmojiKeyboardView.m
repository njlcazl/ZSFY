//
//  EmojiKeyboardView.m
//  UC_Demo_1.0.0
//
//  Created by Barry on 15/5/7.
//  Copyright (c) 2015年 Barry. All rights reserved.
//

#import "EmojiKeyBoardView.h"
#import "EmojiPageView.h"
#import "UCPageControl.h"

static const CGFloat ButtonWidth = 45.7;  // 每个表情的宽度
static const CGFloat ButtonHeight = 41.6; // 每个表情的高度41.7


static const CGFloat bottomViewh = 38; // 底部容器的高度
static const CGFloat bottomButtonW = 50; //底部容器内按钮的宽度

static const NSUInteger DefaultRecentEmojisMaintainedCount = 20;  //最近表情最多显示多少，现在只显示一页

static const NSUInteger recentButtonTag = (10000+0);
static const NSUInteger peopleButtonTag = (10000+1);

static NSString *const segmentRecentName = @"Recent";
NSString *const RecentUsedEmojiCharactersKey = @"RecentUsedEmojiCharactersKey";


@interface EmojiKeyboardView () <UIScrollViewDelegate, EmojiPageViewDelegate>


@property (nonatomic) UCPageControl * pageControl;
@property (nonatomic) UIScrollView *emojiPagesScrollView;  // 表情滚动栏
@property (nonatomic) NSDictionary *emojis;
@property (nonatomic) NSMutableArray *pageViews;
@property (nonatomic) NSString *category; // 类型，比如最近、人物等

@property (nonatomic, strong) UIView  * line; //分割线

// 后面加的
@property (nonatomic, strong) UIView * bottomView; //这个View放在最下面
@property (nonatomic, strong) UIButton * recentButton; // 最近的表情按钮
@property (nonatomic, strong) UIButton * peopleButton; //最近表情按钮右边第一个按钮

@property (nonatomic, strong) UIButton * sendButton; //发送按钮

@end

@implementation EmojiKeyboardView


- (NSDictionary *)emojis {
    if (!_emojis) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"EmojisList"
                                                              ofType:@"plist"];
        _emojis = [[NSDictionary dictionaryWithContentsOfFile:plistPath] copy];
    }
    return _emojis;
}

// 分类名
- (NSString *)categoryNameAtIndex:(NSUInteger)index {
    //  NSArray *categoryList = @[segmentRecentName, @"People", @"Objects", @"Nature", @"Places", @"Symbols"];
    
    NSArray *categoryList = @[segmentRecentName, @"People"];
    return categoryList[index];
}




#pragma mark 最近使用表情的获取和保存

// 返回最近的表情
- (NSMutableArray *)recentEmojis {
    NSArray *emojis = [[NSUserDefaults standardUserDefaults] arrayForKey:RecentUsedEmojiCharactersKey];
    NSMutableArray *recentEmojis = [emojis mutableCopy];
    if (recentEmojis == nil) {
        recentEmojis = [NSMutableArray array];
    }
    return recentEmojis;
}

- (void)setRecentEmojis:(NSMutableArray *)recentEmojis {
    // remove emojis if they cross the cache maintained limit
    if ([recentEmojis count] > DefaultRecentEmojisMaintainedCount) {
        NSRange indexRange = NSMakeRange(DefaultRecentEmojisMaintainedCount,
                                         [recentEmojis count] - DefaultRecentEmojisMaintainedCount);
        NSIndexSet *indexesToBeRemoved = [NSIndexSet indexSetWithIndexesInRange:indexRange];
        [recentEmojis removeObjectsAtIndexes:indexesToBeRemoved];
    }
    [[NSUserDefaults standardUserDefaults] setObject:recentEmojis forKey:RecentUsedEmojiCharactersKey];
}


- (instancetype)initWithSendButtonType:(UCMessageToolBarSendType)SendButtntype{
    self = [super init];
    if (self) {
        // initialize category
        
        self.backgroundColor = UIColorFromRGB(0xffffff);
        
        //        self.category = [self categoryNameAtIndex:EmojiKeyboardViewCategoryImageRecent];
        self.category = [self categoryNameAtIndex:EmojiKeyboardViewCategoryImageFace];
        
        
        self.pageControl = [[UCPageControl alloc] init];
        self.pageControl.hidesForSinglePage = YES; //没有分页时隐藏
        self.pageControl.currentPage = 0;
        self.pageControl.backgroundColor = UIColorFromRGB(0xffffff);
        self.pageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
        self.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        CGSize pageControlSize = [self.pageControl sizeForNumberOfPages:3];
        
        CGSize frameSize = CGSizeMake(CGRectGetWidth(self.bounds),
                                      CGRectGetHeight(self.bounds) - bottomViewh - pageControlSize.height);
        NSUInteger numberOfPages = [self numberOfPagesForCategory:self.category
                                                      inFrameSize:frameSize];
        self.pageControl.numberOfPages = numberOfPages;
        pageControlSize = [self.pageControl sizeForNumberOfPages:numberOfPages];
        CGRect pageControlFrame = CGRectMake((CGRectGetWidth(self.bounds) - pageControlSize.width) / 2,
                                             CGRectGetHeight(self.bounds) - pageControlSize.height - bottomViewh,
                                             pageControlSize.width,
                                             pageControlSize.height);
        self.pageControl.frame = CGRectIntegral(pageControlFrame);
        [self.pageControl addTarget:self
                             action:@selector(pageControlTouched:)
                   forControlEvents:UIControlEventValueChanged];
        
        [self addSubview:self.pageControl];
        
        
        
        
        CGRect scrollViewFrame = CGRectMake(0,
                                            0,
                                            CGRectGetWidth(self.bounds),
                                            CGRectGetHeight(self.bounds) - bottomViewh - pageControlSize.height);
        self.emojiPagesScrollView = [[UIScrollView alloc] initWithFrame:scrollViewFrame];
        self.emojiPagesScrollView.pagingEnabled = YES;
        self.emojiPagesScrollView.showsHorizontalScrollIndicator = NO;
        self.emojiPagesScrollView.showsVerticalScrollIndicator = NO;
        self.emojiPagesScrollView.delegate = self;
        [self addSubview:self.emojiPagesScrollView];
        
        
        //容器
        self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                   CGRectGetHeight(self.bounds) - bottomViewh,
                                                                   CGRectGetWidth(self.bounds),
                                                                   bottomViewh)];
        self.bottomView.backgroundColor = UIColorFromRGB(0xffffff);
        [self addSubview:self.bottomView];
        
        
        //容器内分割线
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bottomView.frame), 0.5)];
        _line.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [_line setBackgroundColor:UIColorFromRGB(0xcbd1cd)];
        [self.bottomView addSubview:_line];
        
        
        
        //recent 按钮
        _recentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_recentButton addTarget:self action:@selector(categoryChanged:) forControlEvents:UIControlEventTouchUpInside];
        _recentButton.tag = recentButtonTag;
        _recentButton.frame = CGRectMake(0, 0, bottomButtonW, bottomViewh);
        [_recentButton setImage:[UIImage imageNamed:@"recent_face"] forState:UIControlStateNormal];
        [_recentButton setImage:[UIImage imageNamed:@"recent_face_HL"] forState:UIControlStateSelected];
        _recentButton.selected = NO;
        //        [self.bottomView addSubview:_recentButton];
        
        //people 按钮
        _peopleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_peopleButton addTarget:self action:@selector(categoryChanged:) forControlEvents:UIControlEventTouchUpInside];
        _peopleButton.tag = peopleButtonTag;
        _peopleButton.frame = CGRectMake(0, 0, ButtonWidth, bottomViewh);
        [_peopleButton setImage:[UIImage imageNamed:@"face"] forState:UIControlStateNormal];
        [_peopleButton setImage:[UIImage imageNamed:@"face_HL"] forState:UIControlStateSelected];
        _peopleButton.selected = YES;
        [self.bottomView addSubview:_peopleButton];
        
        //发送按钮
        if (SendButtntype == UCMessageToolBarSendTypeDown) {
            _sendButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0.5, CGRectGetWidth(self.bottomView.frame) - 60 , bottomViewh)]
            ;
             _sendButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            _sendButton.backgroundColor = UIColorFromRGB(0x0063ba);
            [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
            [_sendButton setTitle:@"发送" forState:UIControlStateHighlighted];
            [_sendButton setTintColor:[UIColor whiteColor]];
            [_sendButton addTarget:self action:@selector(sendBUttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.bottomView addSubview:_sendButton];
        }
        
        
    }
    return self;
}

- (void)layoutSubviews {
    
    
//    NSLog(@"self.size :< %f %f >", self.bounds.size.width,  self.bounds.size.height);
    
    
    self.bottomView.frame = CGRectMake(0,
                                       CGRectGetHeight(self.bounds) - bottomViewh,
                                       CGRectGetWidth(self.bounds),
                                       bottomViewh);
    
    CGSize pageControlSize = [self.pageControl sizeForNumberOfPages:3];
    
    // 当前需要显示的表情分类的 页数
    NSUInteger numberOfPages = [self numberOfPagesForCategory:self.category
                                                  inFrameSize:CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - CGRectGetHeight(self.bottomView.bounds) - pageControlSize.height)];
    
    NSInteger currentPage = (self.pageControl.currentPage > numberOfPages) ? numberOfPages : self.pageControl.currentPage;
    
    // if (currentPage > numberOfPages) it is set implicitly to max pageNumber available
    self.pageControl.numberOfPages = numberOfPages;
    pageControlSize = [self.pageControl sizeForNumberOfPages:numberOfPages];

    
    
    //表情滚动视图
    self.emojiPagesScrollView.frame = CGRectMake(0,
                                                 0,
                                                 CGRectGetWidth(self.bounds),
                                                 CGRectGetHeight(self.bounds) - CGRectGetHeight(self.bottomView.bounds) - pageControlSize.height);
    
    // pageControlFrame 设置
//    CGRect pageControlFrame = CGRectMake((CGRectGetWidth(self.bounds) - pageControlSize.width) / 2,
//                                         CGRectGetHeight(self.emojiPagesScrollView.frame),
//                                         pageControlSize.width,
//                                         pageControlSize.height);
    
    CGRect pageControlFrame = CGRectMake(0,
                                         CGRectGetHeight(self.emojiPagesScrollView.frame),
                                         CGRectGetWidth(self.bounds),
                                         pageControlSize.height);

    self.pageControl.frame = CGRectIntegral(pageControlFrame);
    [self.pageControl setImagePageStateNormal:[UIImage imageNamed:@"pageControlHL"]];
    [self.pageControl setImagePageStateHighlighted:[UIImage imageNamed:@"pageControl"]];
    
    
    
    // 移除所有子视图
    [self.emojiPagesScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //  设置当前偏移量
    self.emojiPagesScrollView.contentOffset = CGPointMake(CGRectGetWidth(self.emojiPagesScrollView.bounds) * currentPage, 0);
    //可滚动区域大小
    self.emojiPagesScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.emojiPagesScrollView.bounds) * numberOfPages,
                                                       CGRectGetHeight(self.emojiPagesScrollView.bounds));
    [self purgePageViews]; // 销毁pageviews
    self.pageViews = [NSMutableArray array];
    
    [self setPage:currentPage];
    

}

#pragma mark event handlers

//点击按钮切换分类
- (void)categoryChanged:(UIButton *) sender{
    
    if (sender.tag == recentButtonTag) {
        _recentButton.selected = YES;
        _peopleButton.selected = NO;
    }else if (sender.tag == peopleButtonTag){
        _recentButton.selected = NO;
        _peopleButton.selected = YES;
    }
    
    NSUInteger  index = sender.tag - 10000;
    self.category = [self categoryNameAtIndex:index];
    self.pageControl.currentPage = 0;
    [self setNeedsLayout];
}




// 表情翻页
- (void)pageControlTouched:(UIPageControl *)sender {
    CGRect bounds = self.emojiPagesScrollView.bounds;
    bounds.origin.x = CGRectGetWidth(bounds) * sender.currentPage;
    bounds.origin.y = 0;
    // scrollViewDidScroll is called here. Page set at that time.
    [self.emojiPagesScrollView scrollRectToVisible:bounds animated:YES];
}

// Track the contentOffset of the scroll view, and when it passes the mid
// point of the current view’s width, the views are reconfigured.
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = CGRectGetWidth(scrollView.frame);
    NSInteger newPageNumber = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (self.pageControl.currentPage == newPageNumber) {
        return;
    }
    self.pageControl.currentPage = newPageNumber;
    [self setPage:self.pageControl.currentPage];
    
    [self.pageControl updateDots];
}

#pragma mark change a page on scrollView

// Check if setting pageView for an index is required
- (BOOL)requireToSetPageViewForIndex:(NSUInteger)index {
    if (index >= self.pageControl.numberOfPages) {  //index大于页数，返回no
        return NO;
    }
    for (EmojiPageView *page in self.pageViews) {
        if ((page.frame.origin.x / CGRectGetWidth(self.emojiPagesScrollView.bounds)) == index) {
            return NO;
        }
    }
    return YES;
}

// Create a pageView and add it to the scroll view.
// 创建一个AGEmojiPageView
- (EmojiPageView *)synthesizeEmojiPageView {
    NSUInteger rows = [self numberOfRowsForFrameSize:self.emojiPagesScrollView.bounds.size];
    NSUInteger columns = [self numberOfColumnsForFrameSize:self.emojiPagesScrollView.bounds.size];
    CGRect pageViewFrame = CGRectMake(0,
                                      0,
                                      CGRectGetWidth(self.emojiPagesScrollView.bounds),
                                      CGRectGetHeight(self.emojiPagesScrollView.bounds));
    EmojiPageView *pageView = [[EmojiPageView alloc] initWithFrame: pageViewFrame
                                                            buttonSize:CGSizeMake(ButtonWidth, ButtonHeight)
                                                                  rows:rows
                                                               columns:columns];
    pageView.delegate = self;
    [self.pageViews addObject:pageView];
    [self.emojiPagesScrollView addSubview:pageView];
    return pageView;
}

// return a pageView that can be used in the current scrollView.
// look for an available pageView in current pageView-s on scrollView.
// If all are in use i.e. are of current page or neighbours
// of current page, we create a new one
// 先查找，没有合适的创建一个
- (EmojiPageView *)usableEmojiPageView {
    EmojiPageView *pageView = nil;
    for (EmojiPageView *page in self.pageViews) {
        NSUInteger pageNumber = page.frame.origin.x / CGRectGetWidth(self.emojiPagesScrollView.bounds);
        if (abs((int)(pageNumber - self.pageControl.currentPage)) > 1) {
            pageView = page;
            break;
        }
    }
    if (!pageView) {
        pageView = [self synthesizeEmojiPageView];
    }
    return pageView;
}

// Set emoji page view for given index.
// 设置表情视图
- (void)setEmojiPageViewInScrollView:(UIScrollView *)scrollView atIndex:(NSUInteger)index {
    
    if (![self requireToSetPageViewForIndex:index]) {   //如果不需要就返回
        return;
    }
    
    EmojiPageView *pageView = [self usableEmojiPageView];
    
    NSUInteger rows = [self numberOfRowsForFrameSize:scrollView.bounds.size];
    NSUInteger columns = [self numberOfColumnsForFrameSize:scrollView.bounds.size];
    NSUInteger startingIndex = index * (rows * columns - 1);
    NSUInteger endingIndex = (index + 1) * (rows * columns - 1);
    
    // 表情数组
    NSMutableArray *buttonTexts = [self emojiTextsForCategory:self.category
                                                    fromIndex:startingIndex
                                                      toIndex:endingIndex];
    [pageView setButtonTexts:buttonTexts];
    pageView.frame = CGRectMake(index * CGRectGetWidth(scrollView.bounds),
                                0,
                                CGRectGetWidth(scrollView.bounds),
                                CGRectGetHeight(scrollView.bounds));
}

// Set the current page.
// sets neightbouring pages too, as they are viewable by part scrolling.
// 设置前一张视图 和 后一张视图的表情
- (void)setPage:(NSInteger)page {
    [self setEmojiPageViewInScrollView:self.emojiPagesScrollView atIndex:page - 1];
    [self setEmojiPageViewInScrollView:self.emojiPagesScrollView atIndex:page];
    [self setEmojiPageViewInScrollView:self.emojiPagesScrollView atIndex:page + 1];
}


// pageviews销毁
- (void)purgePageViews {
    for (EmojiPageView *page in self.pageViews) {
        page.delegate = nil;
    }
    self.pageViews = nil;
}

#pragma mark data methods

//表情列数
- (NSUInteger)numberOfColumnsForFrameSize:(CGSize)frameSize {
    return (NSUInteger)floor(frameSize.width / ButtonWidth);
}

//表情行数
- (NSUInteger)numberOfRowsForFrameSize:(CGSize)frameSize {
    return (NSUInteger)floor(frameSize.height / ButtonHeight);
}

//对应分类的表情数组
- (NSArray *)emojiListForCategory:(NSString *)category {
    if ([category isEqualToString:segmentRecentName]) {
        return [self recentEmojis];
    }
    return [self.emojis objectForKey:category];
}

// for a given frame size of scroll view, return the number of pages
// required to show all the emojis for a category


// 返回一个表情分类有多少页，最近的表情只有一页
- (NSUInteger)numberOfPagesForCategory:(NSString *)category inFrameSize:(CGSize)frameSize {
    
    if ([category isEqualToString:segmentRecentName]) {  //最近只有一页
        return 1;
    }
    
    NSUInteger emojiCount = [[self emojiListForCategory:category] count]; //对应分类的表情数量
    NSUInteger numberOfRows = [self numberOfRowsForFrameSize:frameSize]; //每一页表情行数
    NSUInteger numberOfColumns = [self numberOfColumnsForFrameSize:frameSize]; //表情列数
    NSUInteger numberOfEmojisOnAPage = (numberOfRows * numberOfColumns) - 1;  //每一页的表情，加了一个删除按钮，所以-1
    
    NSUInteger numberOfPages = (NSUInteger)ceil((float)emojiCount / numberOfEmojisOnAPage); //页数
    return numberOfPages;
}

// return the emojis for a category, given a staring and an ending index
- (NSMutableArray *)emojiTextsForCategory:(NSString *)category
                                fromIndex:(NSUInteger)start
                                  toIndex:(NSUInteger)end {
    NSArray *emojis = [self emojiListForCategory:category];
    end = ([emojis count] > end)? end : [emojis count];
    NSIndexSet *index = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(start, end-start)];
    return [[emojis objectsAtIndexes:index] mutableCopy];
}

#pragma mark EmojiPageViewDelegate

- (void)setInRecentsEmoji:(NSString *)emoji {
    NSAssert(emoji != nil, @"Emoji can't be nil");
    
    NSMutableArray *recentEmojis = [self recentEmojis];
    for (int i = 0; i < [recentEmojis count]; ++i) {
        if ([recentEmojis[i] isEqualToString:emoji]) {
            [recentEmojis removeObjectAtIndex:i];
        }
    }
    [recentEmojis insertObject:emoji atIndex:0];
    [self setRecentEmojis:recentEmojis];
}

// add the emoji to recents
- (void)emojiPageView:(EmojiPageView *)emojiPageView didUseEmoji:(NSString *)emoji {
    [self setInRecentsEmoji:emoji];
    [self.delegate emojiKeyBoardView:self didUseEmoji:emoji];
}


// 删除按钮被点击
- (void)emojiPageViewDidPressBackSpace:(EmojiPageView *)emojiPageView {
    [self.delegate emojiKeyBoardViewDidPressBackSpace:self];
}

//发送
- (void)sendBUttonClicked:(UIButton *) button{
    if (self.delegate && [self.delegate respondsToSelector:@selector(emojiKeyBoardViewdidSendFace)]) {
        [self.delegate emojiKeyBoardViewdidSendFace];
    }
}


#pragma mark public
- (BOOL)stringIsFace:(NSString *)string{

    // 检测person里面的表情
    NSArray * personArray = [self.emojis objectForKey:@"People"];
    if ([personArray containsObject:string]) {
        return YES;
    }
    
    return NO;
}

@end
