//
//  CourtBook_Cell.h
//  zsfy
//
//  Created by tiannuo on 15/11/10.
//  Copyright (c) 2015年 wzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pdws.h"

@interface CourtBook_Cell : UITableViewCell

@property (nonatomic,strong)pdws *Pdws;

@property(nonatomic,strong) UIImageView *img;//图片
@property(nonatomic,strong) UILabel *lblTitle;//标题
@property(nonatomic,strong) UILabel *lblType;//类型
@property(nonatomic,strong) UILabel *lblCase;//案由
@property(nonatomic,strong) UILabel *lblParty;//当事人

@end
