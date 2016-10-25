//
//  ApplyVC.m
//  zsfy
//
//  Created by 曾祺植 on 11/19/15.
//  Copyright © 2015 wzy. All rights reserved.
//

#import "MBProgressHUD.h"
#import "ApplyVC.h"
#import "ApplyTVC.h"
#import "ApplyModel.h"
#import "ComUnit.h"
#import "Helper.h"

@interface ApplyVC () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *ApplyList;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UILabel *NoDataLable;

@end

@implementation ApplyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"新的朋友";
    
    self.ApplyList.delegate = self;
    self.ApplyList.dataSource = self;
    [self dealSeparator];
    [self setExtraCellLineHidden:self.ApplyList];
    [self.ApplyList registerNib:[UINib nibWithNibName:@"ApplyTVC" bundle:nil] forCellReuseIdentifier:@"ApplyTVC"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ComUnit readApplyMessage:[Helper getUser_Token]];
    [ComUnit getApplyInfo:[Helper getUser_Token] Callback:^(NSArray *allApplyInfo, BOOL succeed) {
        if (succeed) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            self.dataSource = [[NSMutableArray alloc] initWithArray:allApplyInfo];
            if (self.dataSource.count == 0) {
                self.NoDataLable.hidden = NO;
            } else {
                self.NoDataLable.hidden = YES;
            }
            [self.ApplyList reloadData];
        }
    }];

}

- (void)dealSeparator
{
    if ([self.ApplyList respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.ApplyList setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.ApplyList respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.ApplyList setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ApplyTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"ApplyTVC"];
    ApplyModel *item = self.dataSource[indexPath.row];
    [cell setInfo:item];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ApplyModel *item = self.dataSource[indexPath.row];
        BOOL succeed = [ComUnit RejectApply:[Helper getUser_Token] targetUserId:item.Aid];
        if (succeed) {
            [self.dataSource removeObjectAtIndex:indexPath.row];
            if (self.dataSource.count == 0) {
                self.NoDataLable.hidden = NO;
            } else {
                self.NoDataLable.hidden = YES;
            }
            [self.ApplyList reloadData];
            [MBProgressHUD showSuccess:@"已拒绝好友申请"];
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"拒绝";
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
