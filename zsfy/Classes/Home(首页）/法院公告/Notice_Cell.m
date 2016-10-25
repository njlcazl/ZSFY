//
//  Notice_Cell.m
//  zsfy
//
//  Created by eshore_it on 15-11-14.
//  Copyright (c) 2015年 wzy. All rights reserved.
//

#import "Notice_Cell.h"

@implementation Notice_Cell

@synthesize lblAction,lblCourt,lblJudge,lblTheCourt,lblTime,lblTitle;

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initWithView];
    }
    return self;
}

-(void)initWithView
{
    lblTitle = [CTB labelTag:1 toView:self.contentView text:@"案号：是丹佛那个文告诉对方" wordSize:15];
    lblTitle.frame = CGRectMake(15, 10, Screen_Width-30, 20);
    lblTitle.numberOfLines = 1;
    [self.contentView addSubview:lblTitle];
    
    
    
    lblCourt = [CTB labelTag:1 toView:self.contentView text:@"审理法院：随碟附送你都给搜房" wordSize:13];
    lblCourt.textColor = [UIColor lightGrayColor];
    lblCourt.frame = CGRectMake(15, 35, Screen_Width-30, 15);
    
    
    
    
    lblTheCourt = [CTB labelTag:1 toView:self.contentView text:@"审理法庭：发神经哦地方你是个" wordSize:13];
    lblTheCourt.textColor = [UIColor lightGrayColor];
    lblTheCourt.frame = CGRectMake(15, 55, Screen_Width-30, 15);
    
    
    
    
    lblAction = [CTB labelTag:1 toView:self.contentView text:@"案由：是丹佛工委顾问" wordSize:13];
    lblAction.textColor = [UIColor lightGrayColor];
    lblAction.frame = CGRectMake(15, 75, Screen_Width-30, 15);
    
    
    
    
    lblJudge = [CTB labelTag:1 toView:self.contentView text:@"案由：水电费水电费你是大哥" wordSize:13];
    lblJudge.textColor = [UIColor lightGrayColor];
    lblJudge.frame = CGRectMake(15, 95, Screen_Width-30, 15);
    
    
    
    
    lblTime = [CTB labelTag:1 toView:self.contentView text:@"2015/11/12 13:12:45" wordSize:13];
    lblTime.textColor = [UIColor lightGrayColor];
    lblTime.frame = CGRectMake(15, 115, Screen_Width-30, 15);
    lblTime.textAlignment = NSTextAlignmentLeft;
    lblTime.textColor = [CTB colorWithHexString:@"848484"];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
