//
//  ApplyTVC.m
//  zsfy
//
//  Created by 曾祺植 on 11/19/15.
//  Copyright © 2015 wzy. All rights reserved.
//

#import "ApplyTVC.h"
#import "ComUnit.h"
#import "MBProgressHUD.h"
#import "Helper.h"
#import "UIImageView+WebCache.h"
#import "ApplyModel.h"
#import "FriendModel.h"
#import "UCSIMSDK.h"

@interface ApplyTVC()
@property (weak, nonatomic) IBOutlet UIImageView *HeadImage;
@property (weak, nonatomic) IBOutlet UILabel *NickName;
@property (weak, nonatomic) IBOutlet UILabel *ApplyMsg;
@property (weak, nonatomic) IBOutlet UIButton *AcceptBtn;
@property (nonatomic, strong) ApplyModel *ApplyInfo;

@end

@implementation ApplyTVC

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.AcceptBtn.layer.cornerRadius = 5.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setInfo:(ApplyModel *)item
{
    [self.HeadImage setImage:[UIImage imageNamed:@"Head"]];
    if (![item.imageUrl isKindOfClass:[NSNull class]]) {
        [self.HeadImage sd_setImageWithURL:[NSURL URLWithString:item.imageUrl] placeholderImage:[UIImage imageNamed:@"Head"]];
    }
    self.NickName.text = item.nikeName;
    self.ApplyMsg.text = item.applyMessage;
    self.ApplyInfo = item;
}

- (IBAction)Accept:(id)sender
{
    [ComUnit AcceptApply:[Helper getUser_Token] targetUserId:self.ApplyInfo.Aid Callback:^(FriendModel *item, BOOL succeed) {
        if (succeed) {
            UCSTextMsg *aText = [[UCSTextMsg alloc] init];
            aText.content = @"我们已经是好友了,现在开始对话吧!";
            [[UCSIMClient sharedIM] sendMessage:UCS_IM_SOLOCHAT receiveId:item.Fid msgType:UCS_IM_TEXT content:aText success:^(long long messageId) {
                [MBProgressHUD showSuccess:@"添加好友成功!"];
                self.AcceptBtn.backgroundColor = [UIColor grayColor];
                self.AcceptBtn.enabled = NO;
            } failure:^(UCSError *error, long long messageId) {
                [MBProgressHUD showError:@"添加好友失败"];
            }];
        }
    }];
}

@end
