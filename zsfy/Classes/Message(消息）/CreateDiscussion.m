//
//  CreateDiscussion.m
//  zsfy
//
//  Created by 曾祺植 on 11/21/15.
//  Copyright © 2015 wzy. All rights reserved.
//

#import "CreateDiscussion.h"
#import "MultiSelectItem.h"
#import "MultiSelectViewController.h"
#import "MBProgressHUD.h"
#import "UCSIMSDK.h"
#import "FriendModel.h"
#import "ComUnit.h"
#import "Helper.h"

@interface CreateDiscussion () <UITableViewDataSource, UITableViewDelegate, UCSIMClientDelegate>
@property (weak, nonatomic) IBOutlet UITableView *FriendList;
@property (nonatomic, strong) NSArray *FriendInfo;

@end

@implementation CreateDiscussion

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.FriendList setDelegate:self];
    [self.FriendList setDataSource:self];
    self.FriendInfo = [[NSArray alloc] init];
    [self setExtraCellLineHidden:self.FriendList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [[UCSIMClient sharedIM] setDelegate:self];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(CreateDiscussion)];
    self.navigationItem.rightBarButtonItem = item;
    self.navigationItem.title = @"选择联系人";
    [ComUnit getFriendList:[Helper getUser_Token] Callback:^(NSArray *allFriendInfo, BOOL succeed) {
        if (succeed) {
            self.FriendInfo = allFriendInfo;
            [self.FriendList reloadData];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.FriendInfo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    FriendModel *item = self.FriendInfo[indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:item.imageUrl] placeholderImage:[UIImage imageNamed:@"Head"]];
    cell.textLabel.text = item.nikeName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (void)CreateDiscussion
{
    NSString *title = @"请输入讨论组标题:";
    NSString *cancelButtonTitle = @"取消";
    NSString *otherButtonTitle = @"确定";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    // Add the text field for the secure text entry.
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        // Listen for changes to the text field's text so that we can toggle the current
        // action's enabled property based on whether the user has entered a sufficiently
        // secure entry.
        
    }];
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSMutableArray *dataArr = [[NSMutableArray alloc] init];
        for (int i = 0; i < self.FriendList.visibleCells.count; i++) {
            UITableViewCell *cell = self.FriendList.visibleCells[i];
            if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
                UCSUserInfo *UserItem = [[UCSUserInfo alloc] init];
                FriendModel *InfoItem = [[FriendModel alloc] init];
                InfoItem = self.FriendInfo[i];
                UserItem.userId = InfoItem.Fid;
                UserItem.name = InfoItem.nikeName;
                [dataArr addObject:UserItem];
            }
        }
        
        [[UCSIMClient sharedIM] createDiscussionWithTopic:alertController.textFields[0].text
                                              memberArray:[dataArr copy]
                                                  success:^(UCSDiscussion *discussion) {
                                                      [MBProgressHUD showSuccess:@"创建讨论组成功"];
                                                      [self.navigationController popToRootViewControllerAnimated:YES];
                                                  } failure:^(UCSError *error) {
                                                      [MBProgressHUD showError:@"创建讨论组失败"];
                                                  }];
    }];
    
    // The text field initially has no text in the text field, so we'll disable it.
    
    // Hold onto the secure text alert action to toggle the enabled/disabled state when the text changed.
    
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
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
