//
//  ContactView.h
//  UC_Demo_1.0.0
//
//  Created by Barry on 15/5/12.
//  Copyright (c) 2015年 Barry. All rights reserved.
//

#import "RemarkImageView.h"

@interface ContactView : RemarkImageView
{
    UIButton *_deleteButton;
}

@property (copy) void (^deleteContact)(NSInteger index);
@property (nonatomic, strong) NSString *UserID;


@end
