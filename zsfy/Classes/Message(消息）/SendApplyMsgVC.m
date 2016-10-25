//
//  SendApplyMsgVC.m
//  zsfy
//
//  Created by 曾祺植 on 11/18/15.
//  Copyright © 2015 wzy. All rights reserved.
//

#import "SendApplyMsgVC.h"
#import "MBProgressHUD.h"
#import "Helper.h"
#import "ComUnit.h"

@interface SendApplyMsgVC ()
@property (weak, nonatomic) IBOutlet UITextField *SendMsg;

@end

@implementation SendApplyMsgVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(showOption)];
    self.navigationItem.title = @"验证信息";
    self.navigationItem.rightBarButtonItem = rightBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showOption
{
    BOOL succeed = [ComUnit sendApply:[Helper getUser_Token] targetID:self.Fid Content:self.SendMsg.text];
    if (succeed) {
        [MBProgressHUD showSuccess:@"发送请求成功"];
        [self.navigationController popToRootViewControllerAnimated:YES];
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
