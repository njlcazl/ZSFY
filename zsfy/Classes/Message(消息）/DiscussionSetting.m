//
//  DiscussionSetting.m
//  zsfy
//
//  Created by 曾祺植 on 11/21/15.
//  Copyright © 2015 wzy. All rights reserved.
//

#import "DiscussionSetting.h"
#import "MBProgressHUD.h"
#import "UCSIMSDK.h"
#import "FriendModel.h"
#import "UIImageView+WebCache.h"
#import "UnitView.h"
#import "ComUnit.h"
#import "Helper.h"

@interface DiscussionSetting () <UITableViewDataSource, UITableViewDelegate, UnitViewDelegate, UCSIMClientDelegate>

@property (nonatomic, strong) UnitView *unitView;
@property (weak, nonatomic) IBOutlet UILabel *DiscussionLable;
@property (weak, nonatomic) IBOutlet UITableView *FriendsList;
@property (nonatomic, strong) NSMutableArray *FriendsInfo;
@property (nonatomic, strong) NSMutableArray *Members;

@end

@implementation DiscussionSetting


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.FriendsList.delegate = self;
    self.FriendsList.dataSource = self;
    self.navigationItem.title = @"讨论组设置";
    [self.FriendsList dequeueReusableCellWithIdentifier:@"cell"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self InitUnitView];
    
    UCSDiscussion *discussion = [[UCSIMClient sharedIM] getDiscussionInfoWithDiscussionId:self.discussionID];
    self.DiscussionLable.text = discussion.discussionName;
    
    NSArray *memberIdList = [Helper getMemberIdList:discussion.memberList];
    [ComUnit getFriendList:[Helper getUser_Token] Callback:^(NSArray *allFriendInfo, BOOL succeed) {
        self.FriendsInfo = [NSMutableArray arrayWithArray:allFriendInfo];
        
        for (int i = 0; i < memberIdList.count; i++) {
            for (int j = 0; j < self.FriendsInfo.count; j++) {
                if ([[(FriendModel *)self.FriendsInfo[j] Fid] isEqualToString:memberIdList[i]]) {
                    [self.Members addObject:self.FriendsInfo[j]];
                    [_unitView addNewUnit:[(FriendModel *)self.FriendsInfo[j] imageUrl] withName:[(FriendModel *)self.FriendsInfo[j] nikeName] Info:self.FriendsInfo[j]];
                    [self.FriendsInfo removeObjectAtIndex:j];
                }
            }
        }

    }];
}

/**
 *  初始化UnitView
 */
- (void)InitUnitView
{
    _unitView = [[UnitView alloc] initWithFrame:CGRectMake(0, 90, self.view.frame.size.width, 70)];
    _unitView.translatesAutoresizingMaskIntoConstraints = NO;
    _unitView.delegate = self;
    [self.view addSubview:_unitView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}

/**
 *  调用接口删除讨论组成员
 *
 *  @param unitCell
 */
- (void)deleteCell:(UnitCell *)unitCell
{
    FriendModel *item = [[FriendModel alloc] init];
    item = unitCell.Info;
    
    UCSUserInfo *UserItem = [[UCSUserInfo alloc] init];
    UserItem.userId = item.Fid;
    NSArray *removeArr = [NSArray arrayWithObjects:UserItem, nil];
    [[UCSIMClient sharedIM] removeMemberFromDiscussionWithDiscussionId:self.discussionID
                                                           memberArray:removeArr
                                                               success:^(UCSDiscussion *discussion) {
                                                                   [self.FriendsInfo addObject:item];
                                                                   [self.FriendsList reloadData];
                                                               } failure:^(UCSError *error) {
                                                                   [_unitView addNewUnit:item.imageUrl withName:item.nikeName Info:item];
                                                                   if (error.description) {
                                                                       [MBProgressHUD showError:error.description];
                                                                   } else {
                                                                       [MBProgressHUD showError:@"删除成员失败"];
                                                                   }
                                                               }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UCSIMClient sharedIM] setDelegate:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.FriendsInfo.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[(FriendModel *)self.FriendsInfo[indexPath.row] imageUrl]] placeholderImage:[UIImage imageNamed:@"Default-User.png"]];
     cell.textLabel.text = [(FriendModel *)self.FriendsInfo[indexPath.row] nikeName];
    return cell;
}

/**
 *  调用接口邀请讨论组成员
 *
 *  @param tableView
 *  @param indexPath
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendModel *item = [[FriendModel alloc] init];
    item = self.FriendsInfo[indexPath.row];
    UCSUserInfo *UserItem = [[UCSUserInfo alloc] init];
    UserItem.userId = item.Fid;
    NSArray *addArr = [NSArray arrayWithObjects:UserItem, nil];
    [[UCSIMClient sharedIM] addMemberToDiscussionWithDiscussionId:self.discussionID
                                                      memberArray:addArr
                                                          success:^(UCSDiscussion *discussion) {
                                                              NSString *imageUrl = [(FriendModel *)self.FriendsInfo[indexPath.row] imageUrl];
                                                              [_unitView addNewUnit:imageUrl withName:item.nikeName Info:item];
                                                              [self.FriendsInfo removeObjectAtIndex:indexPath.row];
                                                              [self.FriendsList reloadData];
                                                          } failure:^(UCSError *error) {
                                                              if (error.description) {
                                                                  [MBProgressHUD showError:error.description];
                                                              } else {
                                                                  [MBProgressHUD showError:@"添加成员失败"];
                                                              }
                                                          }];
}

/**
 *  设置讨论组名称
 *
 *  @param sender
 */
- (IBAction)ChangeName:(id)sender
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
        NSLog(@"%@",[alertController.textFields[0] text]);
        NSString *DiscussionName = [alertController.textFields[0] text];
        [[UCSIMClient sharedIM] setDiscussionTopicWithDiscussionId:self.discussionID
                                                          newTopic:DiscussionName
                                                           success:^(UCSDiscussion *discussion) {
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   self.DiscussionLable.text = DiscussionName;
                                                                   [MBProgressHUD showSuccess:@"修改讨论组名称成功"];
                                                               });
                                                           } failure:^(UCSError *error) {
                                                               if (error.description) {
                                                                   [MBProgressHUD showError:error.description];
                                                               } else {
                                                                   [MBProgressHUD showError:@"修改讨论组名称失败"];
                                                               }
                                                           }];
    }];


    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

/**
 *  调用接口退出讨论组
 *
 *  @param sender
 */
- (IBAction)QuitDiscussion:(id)sender
{
    [[UCSIMClient sharedIM] quitDiscussionWithDiscussionId:self.discussionID
                                                   success:^(UCSDiscussion *discussion) {
                                                       [MBProgressHUD showSuccess:@"退出讨论组成功"];
                                                       [[UCSIMClient sharedIM] removeConversation:UCS_IM_DISCUSSIONCHAT targetId:self.discussionID];
                                                       [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:NO];
                                                   } failure:^(UCSError *error) {
                                                       [MBProgressHUD showError:@"退出讨论组失败"];
                                                   }];
}


@end
