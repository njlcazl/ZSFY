//
//  FriendListVC.m
//  zsfy
//
//  Created by 曾祺植 on 11/19/15.
//  Copyright © 2015 wzy. All rights reserved.
//

#import "FriendListVC.h"
#import "MBProgressHUD.h"
#import "DiscussionList.h"
#import "ChatViewController.h"
#import "FriendModel.h"
#import "ComUnit.h"
#import "ContactTVC.h"
#import "ApplyVC.h"
#import "ChatVC.h"
#import "Helper.h"
#import "UCSIMSDK.h"
#import "UIImageView+WebCache.h"

@interface FriendListVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSString *Unread;
@property (weak, nonatomic) IBOutlet UITableView *FriendList;
@property (nonatomic, strong) NSMutableArray *FriendInfo;

@end

@implementation FriendListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.FriendInfo = [[NSMutableArray alloc] init];
    self.FriendList.delegate = self;
    self.FriendList.dataSource = self;
    self.navigationItem.title = @"通讯录";
    [self.FriendList registerNib:[UINib nibWithNibName:@"ContactTVC" bundle:nil]
          forCellReuseIdentifier:@"ContactCell"];
    [self dealSeparator];
    [self setExtraCellLineHidden:self.FriendList];
}

- (void)dealSeparator
{
    if ([self.FriendList respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.FriendList setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.FriendList respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.FriendList setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ComUnit getUnreadApply:[Helper getUser_Token] Callback:^(NSString *UnreadCount, BOOL succeed) {
        if (succeed) {
            self.Unread = UnreadCount;
            [self.FriendList reloadData];
        }
    }];
    [ComUnit getFriendList:[Helper getUser_Token] Callback:^(NSArray *allFriendInfo, BOOL succeed) {
        if (succeed) {
            self.FriendInfo = [NSMutableArray arrayWithArray:allFriendInfo];
            [self.FriendList reloadData];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    } else {
        return 30;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    } else {
        return self.FriendInfo.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ContactTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell"];
        if (indexPath.row == 0) {
            [cell setInfo2:self.Unread Word:@"新的朋友" Image:[UIImage imageNamed:@"AddFriend"]];
        } else {
            [cell setInfo2:@"0" Word:@"讨论组" Image:[UIImage imageNamed:@"Discussion"]];
        }
        return cell;
    } else {
        ContactTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell"];
        FriendModel *item = self.FriendInfo[indexPath.row];
        [cell setInfo3:item];
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            ApplyVC *desVC = [[ApplyVC alloc] initWithNibName:@"ApplyVC" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:desVC animated:YES];
        } else {
            DiscussionList *desVC = [[DiscussionList alloc] initWithNibName:@"DiscussionList" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:desVC animated:YES];
        }
    } else {
        FriendModel *FInfo = self.FriendInfo[indexPath.row];
        ChatViewController *desVC = [[ChatViewController alloc] initWithChatter:FInfo.Fid type:UCS_IM_SOLOCHAT];
        desVC.title = FInfo.nikeName;
        [self.navigationController pushViewController:desVC animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return NO;
    } else {
        return YES;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            FriendModel *item = self.FriendInfo[indexPath.row];
            BOOL succeed = [ComUnit DeleteFriend:[Helper getUser_Token] targetUserId:item.Fid];
            if (succeed) {
                [self.FriendInfo removeObjectAtIndex:indexPath.row];
                [self.FriendList reloadData];
                [MBProgressHUD showSuccess:@"删除好友成功"];
            } else {
                [MBProgressHUD showError:@"删除好友失败"];
            }
        }
    }

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除好友";
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
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
