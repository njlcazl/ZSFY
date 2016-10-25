//
//  AlertSettingVC.m
//  zsfy
//
//  Created by 曾祺植 on 12/13/15.
//  Copyright © 2015 wzy. All rights reserved.
//

#import "AlertSettingVC.h"
#import "AcceptTVC.h"

@interface AlertSettingVC () <UITableViewDelegate, UITableViewDataSource, AcceptCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *SettingList;

@end

@implementation AlertSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setExtraCellLineHidden:self.SettingList];
    self.navigationItem.title = @"消息提醒设置";
    self.SettingList.delegate = self;
    self.SettingList.dataSource = self;
    [self.SettingList registerNib:[UINib nibWithNibName:@"AcceptTVC" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Cell"];
    [self.SettingList reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else {
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AcceptTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.delegate = self;
    if (indexPath.section == 0) {
        [cell setInfo:@"接收新消息通知" Type:1];
    } else {
        if (indexPath.row == 0) {
            [cell setInfo:@"声音" Type:2];
        } else {
            [cell setInfo:@"振动" Type:3];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
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

- (void)SwitchTouched:(AcceptTVC *)unitCell
{
    if (unitCell.type == 1) {
        NSIndexPath *pos1 = [NSIndexPath indexPathForRow:0 inSection:1];
        AcceptTVC *cell = [self.SettingList cellForRowAtIndexPath:pos1];
        [cell setEnable:[unitCell getState]];
        if ([unitCell getState]) {
            [cell setOn];
        } else {
            [cell setOff];
        }
        NSIndexPath *pos2 = [NSIndexPath indexPathForRow:1 inSection:1];
        cell = [self.SettingList cellForRowAtIndexPath:pos2];
        [cell setEnable:[unitCell getState]];
        if (![unitCell getState]) {
            [cell setOff];
        }
    }
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
