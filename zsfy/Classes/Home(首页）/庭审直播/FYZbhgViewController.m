//
//  FYZbhgViewController.m
//  zsfy
//
//  Created by pyj on 15/11/19.
//  Copyright (c) 2015年 wzy. All rights reserved.
//

#import "FYZbhgViewController.h"
#import <MediaPlayer/MediaPlayer.h>
@interface FYZbhgViewController ()

@end

@implementation FYZbhgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"直播回顾";
    self.view.backgroundColor = FYColor(230, 230, 238);
    [self initView];
    
}


- (void)initView
{
    NSLog(@"视频地址%@",self.attach.url);
    UIWebView *videoView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height- 64)];
    [videoView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.attach.url]]];
    [self.view addSubview:videoView];
}



@end
