//
//  FYSearchTitle_View.m
//  zsfy
//
//  Created by pyj on 15/11/16.
//  Copyright (c) 2015年 wzy. All rights reserved.
//

#import "FYSearchTitle_View.h"

@implementation FYSearchTitle_View

+(UIView *)initWithTitle:(NSString *)title TipImage:(NSString *)imageName
{
    UIView *broadV = [[UIView alloc]initWithFrame:CGRectMake(10, 0, Screen_Width - 20, 30)];
    UIView *broad1 = [[UIView alloc]initWithFrame:CGRectMake(0, 5, 5, 20)];
    broad1.backgroundColor = FYColor(0, 111, 194);
    [broadV addSubview:broad1];
    NSString *titleText = title;
    CGSize titleSize = [titleText sizeWithFont:[UIFont systemFontOfSize:12]];
    UILabel *titleLb = [[UILabel alloc]init];
    titleLb.font = [UIFont systemFontOfSize:12];
    titleLb.text = titleText;
    [titleLb setFrame:CGRectMake(CGRectGetMaxX(broad1.frame)+5, 0, titleSize.width, broadV.height)];
    [broadV addSubview:titleLb];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(GetMaxX(titleLb.frame)+5, 10, 10, 10)];
    [imageView setImage:[UIImage imageNamed:imageName]];
    [broadV addSubview:imageView];
    
    return broadV;
    
}

@end
