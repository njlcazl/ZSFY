//
//  GroupSettingsVC.m
//  ucpaas_IM
//
//  Created by 曾祺植 on 9/4/15.
//  Copyright (c) 2015 曾祺植. All rights reserved.
//

#import "UnitCell.h"
#import "UIImageView+WebCache.h"

@interface UnitCell ()

// user的头像url

@end

@implementation UnitCell

- (id)initWithFrame:(CGRect)frame andIcon:(NSString *)icon andName:(NSString *)name
{
    _icon = icon;
    _name = name;
    self = [super initWithFrame:frame];
    if (self) {
        [self setProperty:frame];
    }
    return self;
}

/*
 *@method 设置UnitCell的属性
 */
- (void)setProperty:(CGRect)frame
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 4.0;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, frame.size.width - 20, frame.size.height - 20)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:_icon] placeholderImage:[UIImage imageNamed:@"Default-User.png"]];
    [self addSubview:imageView];
    UILabel *Phone = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height - 20, frame.size.width, 20)];
    Phone.adjustsFontSizeToFitWidth = YES;
    Phone.text = _name;
    [self addSubview:Phone];
    [self addTarget:self action:@selector(touched:) forControlEvents:UIControlEventTouchUpInside];
}

/*
 *@method UnitCell点击删除（代理告知上层）
 */
- (void)touched:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(unitCellTouched:)])
        [_delegate unitCellTouched:self];
}

@end
