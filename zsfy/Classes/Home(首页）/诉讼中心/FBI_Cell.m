//
//  FBI_Cell.m
//  zsfy
//
//  Created by eshore_it on 15-11-14.
//  Copyright (c) 2015年 wzy. All rights reserved.
//

#import "FBI_Cell.h"

@implementation FBI_Cell

@synthesize lblTitle,lblTime;

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
    lblTitle.frame = CGRectMake(15, 10, Screen_Width-30, 20);
    lblTitle.numberOfLines = 1;
    [self.contentView addSubview:lblTitle];
    
    lblTime = [CTB labelTag:1 toView:self.contentView text:@"12368热线电话，按9，进入人工服务" wordSize:13];
    lblTime.frame = CGRectMake(15, 40, Screen_Width-30, 15);
    lblTime.textAlignment = NSTextAlignmentRight;
    lblTime.textColor = [CTB colorWithHexString:@"848484"];
}

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
@end
