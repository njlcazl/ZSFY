//
//  Notice_Cell.h
//  zsfy
//
//  Created by eshore_it on 15-11-14.
//  Copyright (c) 2015年 wzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Notice_Cell : UITableViewCell

/**标题*/
@property(nonatomic,strong) UILabel *lblTitle;//标题
/**法院*/
@property(nonatomic,strong) UILabel *lblCourt;//法院
/**法庭*/
@property(nonatomic,strong) UILabel *lblTheCourt;//法庭
/**案由*/
@property(nonatomic,strong) UILabel *lblAction;//案由
/**法官*/
@property(nonatomic,strong) UILabel *lblJudge;//法官
/**时间*/
@property(nonatomic,strong) UILabel *lblTime;//时间

@end
