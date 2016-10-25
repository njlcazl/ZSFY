//
//  CourtBook_Cell.m
//  zsfy
//
//  Created by tiannuo on 15/11/10.
//  Copyright (c) 2015年 wzy. All rights reserved.
//

#import "CourtBook_Cell.h"
#import "CTB.h"

@implementation CourtBook_Cell

@synthesize img,lblTitle,lblType,lblCase,lblParty;

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
    img = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 56, 80)];
    img.image = [UIImage imageNamed:@"裁判文书"];
    [self.contentView addSubview:img];
    
    lblTitle = [CTB labelTag:1 toView:self.contentView text:@"案号:(2015)是东方故事就回家对方是否" wordSize:14];
    CGFloat title_H = [CTB heightOfContent:lblTitle.text width:Screen_Width-86 fontSize:15];
    lblTitle.frame = CGRectMake(76, 10, Screen_Width-86, title_H);
    [self.contentView addSubview:lblTitle];
    
    lblType = [CTB labelTag:1 toView:self.contentView text:@"类型:民事一审" wordSize:13];
    lblType.frame = CGRectMake(76, title_H+10, Screen_Width-86, 20);
    lblType.textColor = [CTB colorWithHexString:@"848484"];
    
    lblCase = [CTB labelTag:1 toView:self.contentView text:@"案由:合同纠纷" wordSize:13];
    lblCase.frame = CGRectMake(76, title_H +30, Screen_Width-86, 20);
    lblCase.textColor = [CTB colorWithHexString:@"848484"];
    
    lblParty = [CTB labelTag:1 toView:self.contentView text:@"当事人:山东省公司答复国际化看看和客户和" wordSize:13];
    CGFloat Party_H = [CTB heightOfContent:lblParty.text width:Screen_Width-86 fontSize:15];
    lblParty.frame = CGRectMake(76, title_H +50, Screen_Width-86, Party_H);
    lblParty.textColor = [CTB colorWithHexString:@"848484"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


@end
