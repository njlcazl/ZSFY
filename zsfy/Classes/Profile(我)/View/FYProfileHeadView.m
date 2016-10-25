//
//  FYProfileHeadView.m
//  zsfy
//
//  Created by pyj on 15/11/10.
//  Copyright (c) 2015年 wzy. All rights reserved.
//

#import "FYProfileHeadView.h"
@interface FYProfileHeadView()
@property (weak, nonatomic) IBOutlet UIButton *headView;

@end
@implementation FYProfileHeadView
+ (id)proFileHeadView
{
    return [[[NSBundle mainBundle]loadNibNamed:@"FYProfileHeadView" owner:nil options:nil]lastObject];
}

- (void)awakeFromNib
{
    self.headView.layer.cornerRadius = self.headView.width*0.5;
    self.headView.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.headView.layer.borderWidth = 1.0f;
    
}

- (IBAction)clickHeadView:(UIButton *)sender {

    if([self.delegate respondsToSelector:@selector(ProfileHeadView:clickHeadViewBtn:)])
    {
         [self.delegate ProfileHeadView:self clickHeadViewBtn:sender];
    }

}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
