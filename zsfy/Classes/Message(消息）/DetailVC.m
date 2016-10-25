//
//  DetailVC.m
//  zsfy
//
//  Created by 曾祺植 on 11/18/15.
//  Copyright © 2015 wzy. All rights reserved.
//

#import "DetailVC.h"
#import "ComUnit.h"
#import "AddBtnTVC.h"
#import "SendApplyMsgVC.h"
#import "Helper.h"
#import "FriendModel.h"
#import "UIImageView+WebCache.h"

@interface DetailVC () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *DetailInfoList;
@property (nonatomic, strong) FriendModel *FriendInfo;

@end

@implementation DetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.DetailInfoList.delegate = self;
    self.DetailInfoList.dataSource = self;
    self.navigationItem.title = @"详细资料";
    [self.DetailInfoList registerNib:[UINib nibWithNibName:@"AddBtnTVC" bundle:nil] forCellReuseIdentifier:@"AddBtnCell"];
    [ComUnit getFriendInfo:[Helper getUser_Token] targetID:self.Fid Callback:^(FriendModel *item, BOOL succeed) {
        if (succeed) {
            self.FriendInfo = item;
            [self.DetailInfoList reloadData];
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 58;
    } else {
        return 45;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell1"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell1"];
        }
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.FriendInfo.imageUrl] placeholderImage:[UIImage imageNamed:@"Head"]];
        cell.textLabel.text = self.FriendInfo.nikeName;
        cell.detailTextLabel.textColor = [UIColor grayColor];
        cell.detailTextLabel.text = [self getType:self.FriendInfo.userType];
        return cell;
    } else if (indexPath.section == 1){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell2"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell2"];
        }
        cell.textLabel.text = @"地区";
        cell.detailTextLabel.textColor = [UIColor grayColor];
        cell.detailTextLabel.text = self.FriendInfo.address;
        return cell;
    } else {
        AddBtnTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"AddBtnCell"];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 2) {
        SendApplyMsgVC *desVC = [[SendApplyMsgVC alloc] initWithNibName:@"SendApplyMsgVC" bundle:nil];
        desVC.Fid = self.Fid;
        [self.navigationController pushViewController:desVC animated:YES];
    }
}

- (NSString *)getType:(NSString *)userType
{
    if ([userType isEqualToString:@"0"]) {
        return @"当事人";
    } if ([userType isEqualToString:@"1"]) {
        return @"律师";
    } else {
        return @"法官";
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
