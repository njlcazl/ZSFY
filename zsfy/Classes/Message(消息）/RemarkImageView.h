//
//  RemarkImageView.h
//  UC_Demo_1.0.0
//
//  Created by Barry on 15/5/12.
//  Copyright (c) 2015年 Barry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RemarkImageView : UIView
{
    UILabel *_remarkLabel; //显示昵称
    UIImageView *_imageView; //显示头像
    
    NSInteger _index; //第几个
    BOOL _editing; //是否显示编辑按钮，删除
}

@property (nonatomic) NSInteger index;
@property (nonatomic) BOOL editing;
@property (strong, nonatomic) NSString *remark;
@property (strong, nonatomic) NSString *imageUrl;

@end
