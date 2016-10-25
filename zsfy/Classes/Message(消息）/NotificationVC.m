//
//  NotificationVC.m
//  zsfy
//
//  Created by 曾祺植 on 1/29/16.
//  Copyright © 2016 wzy. All rights reserved.
//

#import "NotificationVC.h"
#import "NotificationTVC.h"
#import "DetailWebView.h"
#import "NotificationModel.h"
#import "TOWebViewController.h"
#import "DetailWebView.h"
#import "MJRefresh.h"
#import "GeTuiSdk.h"
#import "Helper.h"
#import "ComUnit.h"

@interface NotificationVC () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *NotificationList;
@property (assign) int page;
@property (nonatomic, strong) NSArray *NoteInfo;
@end

#define CellIdentifier @"NoteCell"

@implementation NotificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(enterDetail:) name:@"enterDetail" object:nil];
    self.navigationItem.title = @"服务窗口";
    self.NotificationList.delegate = self;
    self.NotificationList.dataSource = self;
    [self.NotificationList registerNib:[UINib nibWithNibName:@"NotificationTVC" bundle:nil] forCellReuseIdentifier:CellIdentifier];
    self.NotificationList.estimatedRowHeight = 160;
    self.NotificationList.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    self.page = 1;
    [ComUnit getNotificationMsgList:[Helper getUser_Token] ClientId:[GeTuiSdk clientId] Page:1 rowSize:8 Callback:^(NSArray *allNoteInfo, BOOL succeed) {
        if (succeed) {
            self.NoteInfo = [self Reverse:allNoteInfo];
            [self.NotificationList reloadData];
            [self.NotificationList scrollToRowAtIndexPath:[NSIndexPath indexPathForRow: [self.NoteInfo count] - 1  inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
             //      atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)Reverse:(NSArray *)arr
{
    NSMutableArray *ret = [[NSMutableArray alloc] initWithArray:arr];
    NSInteger cnt = arr.count;
    for (int i = 0; i < cnt; i++) {
        ret[i] = arr[cnt-i-1];
    }
    return [ret copy];
}

- (void)loadNewData
{
    self.page++;
    [ComUnit getNotificationMsgList:[Helper getUser_Token] ClientId:[GeTuiSdk clientId] Page:self.page rowSize:4 Callback:^(NSArray *allNoteInfo, BOOL succeed) {
        if (succeed) {
            NSMutableArray *tmpArr = [[NSMutableArray alloc] initWithArray:[self Reverse:allNoteInfo]];
            [tmpArr addObjectsFromArray:self.NoteInfo];
            self.NoteInfo = [tmpArr copy];
            [self.NotificationList reloadData];
            [self.NotificationList scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:7  inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            [self.NotificationList.header endRefreshing];
        }
    }];

}

- (void)enterDetail:(NSNotification *)text
{
    NSString *url = text.userInfo[@"url"];
    TOWebViewController *desVC = [[TOWebViewController alloc] initWithURLString:url];
    desVC.navigationButtonsHidden = YES;
//desVC.navigationButtonsHidden = YES;
//    desVC.showActionButton = NO;
//  desVC.hideWebViewBoundaries = YES;
//   [self.navigationController pushViewController:desVC animated:YES];
//    DetailWebView *desVC = [[DetailWebView alloc] initWithNibName:@"DetailWebView" bundle:[NSBundle mainBundle]];
//    desVC.url = url;
    [self.navigationController pushViewController:desVC animated:YES];
//   [self presentViewController:[[UINavigationController alloc] initWithRootViewController:desVC] animated:YES completion:nil];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.NoteInfo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NotificationTVC *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.NoteItem = self.NoteInfo[indexPath.row];
    [cell setInfo];
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
