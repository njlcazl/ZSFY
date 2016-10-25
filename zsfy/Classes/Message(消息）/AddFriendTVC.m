//
//  AddFriendTVC.m
//  zsfy
//
//  Created by 曾祺植 on 11/23/15.
//  Copyright © 2015 wzy. All rights reserved.
//

#import "AddFriendTVC.h"
#import "QueryFriendModel.h"
#import "UIImageView+WebCache.h"

@interface AddFriendTVC()

@property (weak, nonatomic) IBOutlet UIImageView *Head;
@property (weak, nonatomic) IBOutlet UILabel *Nickname;
@property (weak, nonatomic) IBOutlet UILabel *Username;

@end

@implementation AddFriendTVC

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setInfo
{
    if ([self.QueryInfo.imageUrl isKindOfClass:[NSNull class]] || [self.QueryInfo.imageUrl isEqualToString:@""]) {
        self.Head.image = [UIImage imageNamed:@"Head"];
    } else {
        [self.Head sd_setImageWithURL:[NSURL URLWithString:self.QueryInfo.imageUrl]];
    }
    self.Nickname.text = self.QueryInfo.nikeName;
    self.Username.text = self.QueryInfo.userName;
}

@end
