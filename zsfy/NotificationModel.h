//
//  NotificationModel.h
//  zsfy
//
//  Created by 曾祺植 on 1/29/16.
//  Copyright © 2016 wzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationModel : NSObject

@property (nonatomic, strong) NSDictionary *content;

@property (nonatomic, strong) NSString *date;

@property (nonatomic, strong) NSString *Nid;

@property (nonatomic, strong) NSDictionary *title;

@property (nonatomic, strong) NSString *Url;

+ (id)NoteInfoWithObj:(NSDictionary *)obj;

@end
