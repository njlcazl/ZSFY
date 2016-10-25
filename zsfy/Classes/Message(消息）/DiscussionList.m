//
//  DiscussionList.m
//  zsfy
//
//  Created by 曾祺植 on 11/21/15.
//  Copyright © 2015 wzy. All rights reserved.
//

#import "DiscussionList.h"
#import "CreateDiscussion.h"
#import "ChatViewController.h"
#import "ContactTVC.h"
#import "UCSIMSDK.h"
#import "FriendModel.h"
#import "ComUnit.h"
#import "Helper.h"
#import "MultiSelectItem.h"
#import "MultiSelectViewController.h"

@interface DiscussionList () <UCSIMClientDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *DiscussionList;
@property (nonatomic, strong) NSArray *DiscussionInfo;

@end

@implementation DiscussionList

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self dealSeparator];
    self.DiscussionList.delegate = self;
    self.DiscussionList.dataSource = self;
    self.navigationItem.title = @"讨论组";
    self.DiscussionInfo = [[UCSIMClient sharedIM] getDiscussions];
    [self setExtraCellLineHidden:self.DiscussionList];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_add"]
                                                                 style:UIBarButtonItemStyleDone target:self
                                                                action:@selector(CreateDiscussion)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    [self.DiscussionList registerNib:[UINib nibWithNibName:@"ContactTVC" bundle:nil] forCellReuseIdentifier:@"ContactTVC"];
    [self.DiscussionList reloadData];
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.DiscussionInfo.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UCSDiscussion *discussionInfo = self.DiscussionInfo[indexPath.row];
    ContactTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactTVC"];
    [cell setInfo2:@"0" Word:discussionInfo.discussionName Image:[UIImage imageNamed:@"Discussion"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UCSDiscussion *discussionInfo = self.DiscussionInfo[indexPath.row];
    ChatViewController *desVC = [[ChatViewController alloc] initWithChatter:discussionInfo.discussionId
                                                                       type:UCS_IM_DISCUSSIONCHAT];
    desVC.navigationItem.title = discussionInfo.discussionName;
    [self.navigationController pushViewController:desVC animated:YES];
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

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)dealSeparator
{
    if ([self.DiscussionList respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.DiscussionList setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.DiscussionList respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.DiscussionList setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)CreateDiscussion
{
    NSMutableArray * items = [NSMutableArray array];
    
    [ComUnit getFriendList:[Helper getUser_Token] Callback:^(NSArray *allFriendInfo, BOOL succeed) {
        if (succeed) {
            for (NSUInteger i=0; i<allFriendInfo.count; i++) {
                FriendModel * addressBook = allFriendInfo[i];
                MultiSelectItem *item = [[MultiSelectItem alloc]init];
                item.name = addressBook.nikeName;
                item.userId = addressBook.Fid;
                item.imageURL = [NSURL URLWithString:addressBook.imageUrl];
                item.placeHolderImage = [UIImage imageNamed:@"Head"];
                
                [items addObject:item];
            }
            MultiSelectViewController *vc = [[MultiSelectViewController alloc] initWithType:UCSelectTypeCreate targetId:nil];
            vc.navigationItem.title = @"选择好友";
            vc.items = items;
            
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
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
