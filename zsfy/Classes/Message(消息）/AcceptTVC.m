//
//  AcceptTVC.m
//  zsfy
//
//  Created by 曾祺植 on 11/30/15.
//  Copyright © 2015 wzy. All rights reserved.
//

#import "AcceptTVC.h"
#import "CoreDataOperation.h"
#import "Helper.h"

@interface AcceptTVC()

@property (weak, nonatomic) IBOutlet UILabel *InfoLable;
@property (weak, nonatomic) IBOutlet UISwitch *Switch;

@end


@implementation AcceptTVC

- (void)awakeFromNib {
    // Initialization code
    self.InfoLable.font = [UIFont systemFontOfSize:15];
    [self.Switch addTarget:self action:@selector(SaveStates) forControlEvents:UIControlEventAllTouchEvents];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setInfo:(NSString *)textInfo Type:(int)type
{
    _type = type;
    if (_type == 0) {
        NSArray *blockList = [CoreDataOperation getBlockList:[Helper getUserID]];
        if (blockList == nil) {
            [self.Switch setOn:YES];
        } else {
            BOOL flag = YES;
            for (int i = 0; i < blockList.count; i++) {
                if ([self.targetId isEqualToString:blockList[i]]) {
                    flag = NO;
                    break;
                }
            }
            [self.Switch setOn:flag];
        }
    } else {
         NSArray *tmp = [CoreDataOperation getVoiceSetting:[Helper getUserID]];
        id p = [tmp objectAtIndex:_type - 1];
        BOOL flag = ([p isEqual:@1]) ? YES : NO;
        [self.Switch setOn:flag];
    }
    self.InfoLable.text = textInfo;
}

- (void)setEnable:(BOOL)flag
{
    self.Switch.enabled = flag;
}

- (BOOL)getState
{
    return [self.Switch isOn];
}

- (void)setOff
{
    if (self.Switch.isOn) {
        [self.Switch setOn:NO animated:NO];
        [CoreDataOperation changeVoiceSetting:[Helper getUserID] VoiceFlag:[NSNumber numberWithInt:_type - 1] isOn:[NSNumber numberWithInt:0]];
    }
}

- (void)setOn
{
    if (!self.Switch.isOn) {
        [self.Switch setOn:YES animated:NO];
        [CoreDataOperation changeVoiceSetting:[Helper getUserID] VoiceFlag:[NSNumber numberWithInt:_type - 1] isOn:[NSNumber numberWithInt:1]];
    }
}

- (void)SaveStates
{
    if (_type == 0) {
        if (!self.Switch.isOn) {
            [CoreDataOperation addBlockList:[Helper getUserID] targetId:self.targetId];
        } else {
            [CoreDataOperation removeBlockList:[Helper getUserID] targetId:self.targetId];
        }
    } else {
        if (self.Switch.isOn) {
            [CoreDataOperation changeVoiceSetting:[Helper getUserID] VoiceFlag:[NSNumber numberWithInt:_type - 1] isOn:[NSNumber numberWithInt:1]];
        } else {
            [CoreDataOperation changeVoiceSetting:[Helper getUserID] VoiceFlag:[NSNumber numberWithInt:_type - 1] isOn:[NSNumber numberWithInt:0]];
        }
    }
    if (_delegate && [_delegate respondsToSelector:@selector(SwitchTouched:)])
        [_delegate SwitchTouched:self];
}

@end
