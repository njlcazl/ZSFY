//
//  FYWebViewController.m
//  zsfy
//
//  Created by pyj on 15/11/21.
//  Copyright (c) 2015年 wzy. All rights reserved.
//
#define IOS8x ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
#import "FYWebViewController.h"
#import <WebKit/WebKit.h>


@interface FYWebViewController ()<UIWebViewDelegate,WKNavigationDelegate>
@property (assign, nonatomic) NSUInteger loadCount;
@property (strong, nonatomic) UIProgressView *progressView;
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) WKWebView *wkWebView;
@end

@implementation FYWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = FYColor(230, 230, 238);
    if (self.Title&&self.url) {
         self.navigationItem.title = self.Title;
        self.view.backgroundColor = FYColor(230, 230, 238);
        [self initView];
        
    }
}

- (void)initView
{
    
    // 进度条
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
    progressView.tintColor =FYBlueColor;
    progressView.trackTintColor = [UIColor whiteColor];
    [self.view addSubview:progressView];
    self.progressView = progressView;
    
    // 网页
    if (IOS8x) {
        WKWebView *wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds];
        wkWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        wkWebView.backgroundColor = [UIColor whiteColor];
        wkWebView.navigationDelegate = self;
        [self.view insertSubview:wkWebView belowSubview:progressView];
        
        [wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
        [wkWebView loadRequest:request];
        self.wkWebView = wkWebView;
    }else {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        webView.scalesPageToFit = YES;
        webView.backgroundColor = [UIColor whiteColor];
        webView.delegate = self;
        [self.view insertSubview:webView belowSubview:progressView];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
        [webView loadRequest:request];
        self.webView = webView;
    }
    
    
//    NSLog(@"%@",self.url);
//    UIWebView *videoView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height- 64)];
////    NSURL * url = [NSURL URLWithString:@"http://map.baidu.com/mobile/webapp/walk/list/qt=walk&sn=1%24%24ceb25e5793cf53aa7adbd280%24%2412518514.70%2C2625655.00%24%24%E8%82%87%E5%BA%86%E7%81%AB%E8%BD%A6%E7%AB%99%24%24&en=1%24%240f14629c672f71720d0e6bd1%24%2412518351.40%2C2625892.00%24%24%E8%82%87%E5%BA%86%E9%93%81%E8%B7%AF%E8%BF%90%E8%BE%93%E6%B3%95%E9%99%A2%24%24&sc=338&ec=338&c=338&pn=0&rn=5&searchFlag=transit&version=3&wm=1/foo=bar&vt=map"];
////    
////    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:url];
//    [videoView loadRequest:[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:self.url]]];
//    [self.view addSubview:videoView];
}

#pragma mark - wkWebView代理
// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.wkWebView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}

// 记得取消监听
- (void)dealloc {
    if (IOS8x) {
        [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    }
}

#pragma mark - webView代理

// 计算webView进度条
- (void)setLoadCount:(NSUInteger)loadCount {
    _loadCount = loadCount;
    if (loadCount == 0) {
        self.progressView.hidden = YES;
        [self.progressView setProgress:0 animated:NO];
    }else {
        self.progressView.hidden = NO;
        CGFloat oldP = self.progressView.progress;
        CGFloat newP = (1.0 - oldP) / (loadCount + 1) + oldP;
        if (newP > 0.95) {
            newP = 0.95;
        }
        [self.progressView setProgress:newP animated:YES];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    self.loadCount ++;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.loadCount --;
    self.progressView.hidden = YES;
    
}

//- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
//    self.loadCount --;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
