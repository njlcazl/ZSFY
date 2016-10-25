//
//  NewsCenter_Cell.m
//  zsfy
//
//  Created by tiannuo on 15/11/11.
//  Copyright (c) 2015年 wzy. All rights reserved.
//

#import "NewsCenter_Cell.h"
#import "CTB.h"

@implementation NewsCenter_Cell

@synthesize img,lblTitle,lblContent,lblTime;

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
//    img = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
//    img.backgroundColor = [UIColor redColor];
//    [self.contentView addSubview:img];
    
    lblTitle = [CTB labelTag:1 toView:self.contentView text:@"我院召开禁毒宣判大会" wordSize:17];
    lblTitle.numberOfLines = 0;
    [self.contentView addSubview:lblTitle];
    
    lblContent = [CTB labelTag:1 toView:self.contentView text:@"类型:民事一审发生的奶粉搜公司的你是哪的发了啥地方" wordSize:13];
//    lblContent.frame = CGRectMake(10, 35, Screen_Width-10, 15);
    lblContent.numberOfLines = 1;
    lblContent.textColor = [CTB colorWithHexString:@"848484"];
    
    lblTime = [CTB labelTag:1 toView:self.contentView text:@"2015-03-01 20:56:51" wordSize:13];
    lblTime.numberOfLines = 1;
    lblTime.textAlignment = NSTextAlignmentRight;
    lblTime.textColor = [CTB colorWithHexString:@"848484"];
}

/*

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    
    //    //上分割线，
    //    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:198/255.0 green:198/255.0 blue:198/255.0 alpha:1].CGColor);
    //    CGContextStrokeRect(context, CGRectMake(0, 0, rect.size.width, 0.5));
    
    //下分割线
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:198/255.0 green:198/255.0 blue:198/255.0 alpha:1].CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height, rect.size.width, 0.5));
    
}
 */

@end
