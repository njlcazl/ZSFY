//
//  UCChatTimeCell.m
//  IMDemo_UI
//
//  Created by Barry on 15/4/20.
//  Copyright (c) 2015年 Barry. All rights reserved.
//

#import "UCChatTimeCell.h"

@interface UCChatTimeCell ()
{
    UIImageView * _backImageView;
    UILabel * _timeLabel;
}
@end

@implementation UCChatTimeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _backImageView = [[UIImageView alloc] init];
        UIImage * image = [UIImage imageNamed:@"chat_timeBubble"];
        CGSize imageSize = image.size;
        image = [image stretchableImageWithLeftCapWidth:imageSize.width/2 topCapHeight:imageSize.height/2];
        _backImageView.image = image;
        [self addSubview:_backImageView];
        
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = [UIFont systemFontOfSize:14];
        _timeLabel.tintColor = [UIColor whiteColor];
        _timeLabel.textColor = [UIColor whiteColor];
        [self addSubview:_timeLabel];
    }
    
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)prepareForReuse{
    [super prepareForReuse];
    _timeLabel.text = nil;
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //计算文字的size
    if (self.time) {
        CGSize sizeToFit = [self.time sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(self.frame.size.width, self.frame.size.height) lineBreakMode:UILineBreakModeWordWrap];
        _backImageView.bounds = CGRectMake(0, 0, sizeToFit.width + 10 , sizeToFit.height + 5);
        _backImageView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height /2);
        
        _timeLabel.bounds = CGRectMake(0, 0, sizeToFit.width, sizeToFit.height);
        _timeLabel.center = CGPointMake(self.frame.size.width /2, self.frame.size.height/2);
        _timeLabel.text = self.time;
    }
    
    
}

@end
