//
//  AddFriendVC.m
//  zsfy
//
//  Created by 曾祺植 on 11/18/15.
//  Copyright © 2015 wzy. All rights reserved.
//

#import "AddFriendVC.h"
#import "ComUnit.h"
#import "Helper.h"
#import "DetailVC.h"
#import "QueryFriendModel.h"
#import "AddFriendTVC.h"
#import "UIImageView+WebCache.h"
#import "Helper.h"

@interface AddFriendVC () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *MyUserName;
@property (weak, nonatomic) IBOutlet UITableView *QueryFriendList;
@property (nonatomic, strong) NSArray *FriendInfo;
@property (weak, nonatomic) IBOutlet UITextField *SearchText;
@property (weak, nonatomic) IBOutlet UILabel *NoMatchLable;

@end

@implementation AddFriendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self dealSeparator];
    self.navigationItem.title = @"添加朋友";
    self.FriendInfo = [[NSArray alloc] init];
    self.NoMatchLable.hidden = YES;
    self.MyUserName.text = [Helper getUserName];
    self.QueryFriendList.delegate = self;
    self.QueryFriendList.dataSource = self;
    [self.QueryFriendList registerNib:[UINib nibWithNibName:@"AddFriendTVC" bundle:nil]
               forCellReuseIdentifier:@"AddFriendCell"];
    [self setExtraCellLineHidden:self.QueryFriendList];
    self.SearchText.returnKeyType = UIReturnKeySearch;
    self.SearchText.delegate = self;
    
}

- (void)dealSeparator
{
    if ([self.QueryFriendList respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.QueryFriendList setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.QueryFriendList respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.QueryFriendList setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.FriendInfo.count;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddFriendTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"AddFriendCell"];
    QueryFriendModel *item = self.FriendInfo[indexPath.row];
    cell.QueryInfo = item;
    [cell setInfo];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    DetailVC *desVC = [[DetailVC alloc] initWithNibName:@"DetailVC" bundle:[NSBundle mainBundle]];
    QueryFriendModel *item = self.FriendInfo[indexPath.row];
    desVC.Fid = item.Qid;
    [self.navigationController pushViewController:desVC animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField.returnKeyType==UIReturnKeySearch){       //显示下一个
        [ComUnit QueryFriend:[Helper getUser_Token] userName:self.SearchText.text nickName:self.SearchText.text Callback:^(NSArray *allQueryFriend, BOOL succeed) {
            if (succeed) {
                self.FriendInfo = allQueryFriend;
                if (self.FriendInfo.count == 0) {
                    self.NoMatchLable.hidden = NO;
                } else {
                    self.NoMatchLable.hidden = YES;
                }
                [self.QueryFriendList reloadData];
            }
        }];
    }
    return YES;
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
