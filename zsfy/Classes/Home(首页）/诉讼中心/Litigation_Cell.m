//
//  Litigation_Cell.m
//  zsfy
//
//  Created by eshore_it on 15-11-14.
//  Copyright (c) 2015年 wzy. All rights reserved.
//

#import "Litigation_Cell.h"

@implementation Litigation_Cell

@synthesize lblContent,lblTitle,imgphone,vline;

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
    lblTitle = [CTB labelTag:1 toView:self.contentView text:@"拨打12368热线电话" wordSize:15];
    lblTitle.frame = CGRectMake(10, 50, Screen_Width-90, 20);
    lblTitle.numberOfLines = 1;
    [self.contentView addSubview:lblTitle];
    
    lblContent = [CTB labelTag:1 toView:self.contentView text:@"12368热线电话，按9，进入人工服务" wordSize:13];
    lblContent.frame = CGRectMake(10, 75, Screen_Width-90, 15);
    lblContent.numberOfLines = 1;
    lblContent.textColor = [CTB colorWithHexString:@"848484"];
    
    vline = [[UIView alloc] initWithFrame:CGRectMake(Screen_Width-60, 15, 1, 110)];
    vline.backgroundColor = [UIColor blackColor];
    [self.contentView addSubview:vline];
    
    UIButton *btnHone = [CTB buttonType:UIButtonTypeCustom delegate:self to:self.contentView tag:1 title:@"" img:@""];
    btnHone.frame = CGRectMake(Screen_Width-59, 0, 59, 140);
    btnHone.backgroundColor = [UIColor yellowColor];
    
    imgphone = [[UIImageView alloc] initWithFrame:CGRectMake(15, 50, 30, 36)];
    imgphone.backgroundColor = [UIColor redColor];
    [btnHone addSubview:imgphone];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
