//
//  SendMsgBtnTVC.m
//  zsfy
//
//  Created by 曾祺植 on 12/12/15.
//  Copyright © 2015 wzy. All rights reserved.
//

#import "SendMsgBtnTVC.h"
#include "Search.h"

@interface SendMsgBtnTVC()
@property (weak, nonatomic) IBOutlet UIView *SendBtn;

@end

@implementation SendMsgBtnTVC

- (void)awakeFromNib {
    // Initialization code
    self.SendBtn.backgroundColor = FYBlueColor;
    self.SendBtn.layer.cornerRadius = 4.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
