//
//  HawkPickerView.h
//  zsfy
//
//  Created by QYQ-Hawk on 15/12/8.
//  Copyright © 2015年 wzy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SubView_Type){
    SubView_Type_Normal = 0,
    SubView_Type_Vedio
};

@interface HawkPickerView : UIView

- (id)initWithFrame:(CGRect)frame;

@property(nonatomic,strong)void (^SelectType)(NSInteger type);

- (void)setFrame:(CGRect)frame;

@end
