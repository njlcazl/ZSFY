//
//  NotificationTVC.m
//  zsfy
//
//  Created by 曾祺植 on 1/29/16.
//  Copyright © 2016 wzy. All rights reserved.
//

#import "NotificationTVC.h"
#import "NotificationModel.h"
#import "UIColor+Hex.h"

@interface NotificationTVC()

@property (weak, nonatomic) IBOutlet UIView *MainView;
@property (weak, nonatomic) IBOutlet UILabel *ContentLable;
@property (weak, nonatomic) IBOutlet UILabel *TitleLable;
@property (weak, nonatomic) IBOutlet UILabel *DateLable;


@property (weak, nonatomic) IBOutlet UIView *DetailView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ButtunConstraint;

@end

@implementation NotificationTVC

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [tap addTarget:self action:@selector(enterDetail)];
    [self.DetailView addGestureRecognizer:tap];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)enterDetail
{
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:self.NoteItem.Url, @"url", nil];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    NSNotification *notice = [NSNotification notificationWithName:@"enterDetail" object:nil userInfo:dict];
    [center postNotification:notice];
}

- (void)setShadow
{
    self.MainView.layer.borderWidth = 1;
    self.MainView.layer.borderColor = [[UIColor groupTableViewBackgroundColor] CGColor];
    self.MainView.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.MainView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.MainView.layer.shadowRadius = 2;
    self.MainView.layer.shadowOpacity = 0.5f;
}

- (void)setInfo
{
    [self setShadow];
    self.TitleLable.text = [self.NoteItem.title valueForKey:@"value"];
    NSString *titleColor = [self.NoteItem.title valueForKey:@"color"];
    if (titleColor != nil && ![titleColor isEqualToString:@""]) {
        self.TitleLable.textColor = [UIColor colorWithHexString:titleColor];
    } else {
        self.TitleLable.textColor = [UIColor blackColor];
    }
    self.ContentLable.text = [self.NoteItem.content valueForKey:@"value"];
    [self.ContentLable sizeToFit];
    NSString *contentColor = [self.NoteItem.content valueForKey:@"color"];
    if (contentColor != nil && ![contentColor isEqualToString:@""]) {
        self.ContentLable.textColor = [UIColor colorWithHexString:@"color"];
    } else {
        self.ContentLable.textColor = [UIColor blackColor];
    }
    self.DateLable.text = self.NoteItem.date;
    if (self.NoteItem.Url != nil && ![self.NoteItem.Url isEqualToString:@""]) {
        self.ButtunConstraint.constant = 75;
        self.DetailView.hidden = NO;
    } else {
        self.ButtunConstraint.constant = 20;
        self.DetailView.hidden = YES;
    }
    [self.MainView setNeedsUpdateConstraints];
    [self.MainView updateConstraintsIfNeeded];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

@end
