//
//  AddBtnTVC.m
//  zsfy
//
//  Created by 曾祺植 on 11/18/15.
//  Copyright © 2015 wzy. All rights reserved.
//

#import "AddBtnTVC.h"

@interface AddBtnTVC()

@property (weak, nonatomic) IBOutlet UIView *AddBtn;

@end

@implementation AddBtnTVC

- (void)awakeFromNib {
    // Initialization code
    self.AddBtn.backgroundColor = FYBlueColor;
    self.AddBtn.layer.cornerRadius = 4.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
