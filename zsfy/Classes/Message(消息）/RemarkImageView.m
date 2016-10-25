//
//  RemarkImageView.m
//  UC_Demo_1.0.0
//
//  Created by Barry on 15/5/12.
//  Copyright (c) 2015年 Barry. All rights reserved.
//

#import "RemarkImageView.h"
#import "UIImageView+WebCache.h"

#define RemarkImageViewW 40


@implementation RemarkImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _editing = NO;
        self.userInteractionEnabled = YES;
        CGFloat vMargin = frame.size.height / 6; //垂直间隙
        CGFloat hMargin = (frame.size.width - RemarkImageViewW)/2; //水平间隙
        CGFloat imageW  = RemarkImageViewW;
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(hMargin, vMargin, imageW, imageW)];
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.layer.cornerRadius = _imageView.layer.cornerRadius * 0.5;
        [self addSubview:_imageView];
        
        CGFloat rHeight = frame.size.height - imageW - vMargin;
        _remarkLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_imageView.frame)  , self.frame.size.width, rHeight)];
        _remarkLabel.autoresizesSubviews = UIViewAutoresizingFlexibleTopMargin;
        _remarkLabel.clipsToBounds = YES;
        _remarkLabel.numberOfLines = 0;
        _remarkLabel.textAlignment = NSTextAlignmentCenter;
        _remarkLabel.font = [UIFont systemFontOfSize:11];
        _remarkLabel.textColor = UIColorFromRGB(0x999999);
        [self addSubview:_remarkLabel];
    }
    return self;
}

- (void)setRemark:(NSString *)remark
{
    _remark = remark;
    _remarkLabel.text = _remark;
    
}

- (void)setImageUrl:(NSString *)image
{
    _imageView.image = [UIImage imageNamed:@"Head"];
    if (![image isEqualToString:@""]) {
        _imageUrl = image;
        [_imageView sd_setImageWithURL:[NSURL URLWithString:_imageUrl]];
    }
}



@end
