//
//  ContactTVC.m
//  zsfy
//
//  Created by 曾祺植 on 11/18/15.
//  Copyright © 2015 wzy. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ContactTVC.h"
#import "UIImageView+WebCache.h"
#import "FriendModel.h"

@interface ContactTVC()

@property (weak, nonatomic) IBOutlet UIView *BadgeView;
@property (weak, nonatomic) IBOutlet UILabel *BadgeText;
@property (weak, nonatomic) IBOutlet UIImageView *HeadImage;
@property (weak, nonatomic) IBOutlet UILabel *WordLable;

@end

@implementation ContactTVC

- (void)awakeFromNib {
    self.BadgeView.layer.masksToBounds = YES;
    self.BadgeView.layer.cornerRadius = self.BadgeView.size.width / 2;
    self.BadgeView.backgroundColor = [UIColor redColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)HideBadgeView
{
    self.BadgeView.hidden = YES;
}

- (void)setInfo1:(NSString *)InfoCount
{
    self.HeadImage.image = [UIImage imageNamed:@"Contact"];
    if([InfoCount isEqualToString:@"0"] || [InfoCount isEqualToString:@""] || InfoCount == nil)
    {
        self.BadgeView.hidden = YES;
    } else {
        self.BadgeView.hidden = NO;
        self.BadgeText.textColor = [UIColor whiteColor];
        self.BadgeText.text = InfoCount;
    }
}

- (void)setInfo2:(NSString *)ApplyCount Word:(NSString *)word Image:(UIImage *)image
{
    if ([ApplyCount isEqualToString:@"0"] || [ApplyCount isEqualToString:@""] || ApplyCount == nil) {
        self.BadgeView.hidden = YES;
    } else {
        self.BadgeView.hidden = NO;
    }
    self.BadgeText.textColor = [UIColor whiteColor];
    self.BadgeText.text = ApplyCount;
    self.WordLable.text = word;
    self.HeadImage.image = image;
}

- (void)setInfo3:(FriendModel *)item
{
    self.BadgeView.hidden = YES;
    self.WordLable.text = item.nikeName;
    [self.HeadImage sd_setImageWithURL:[NSURL URLWithString:item.imageUrl] placeholderImage:[UIImage imageNamed:@"Head"]];
}

@end
