//
//  DetailWebView.m
//  zsfy
//
//  Created by 曾祺植 on 1/30/16.
//  Copyright © 2016 wzy. All rights reserved.
//

#import "DetailWebView.h"

@interface DetailWebView () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *WebView;

@end

@implementation DetailWebView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.WebView.delegate = self;
    
    NSURL *url = [NSURL URLWithString:self.url];
    [self.WebView loadRequest:[NSURLRequest requestWithURL:url]];



}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}


@end
