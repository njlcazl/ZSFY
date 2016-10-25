//
//  NotificationModel.m
//  zsfy
//
//  Created by 曾祺植 on 1/29/16.
//  Copyright © 2016 wzy. All rights reserved.
//

#import "NotificationModel.h"

@implementation NotificationModel

+ (id)NoteInfoWithObj:(NSDictionary *)obj
{
    NotificationModel *item = [[NotificationModel alloc] initWithObj:obj];
    return item;
}

- (id)initWithObj:(NSDictionary *)obj
{
    self = [super init];
    if (self) {
        self.content = [[obj valueForKey:@"content"] firstObject];
        self.date = [obj valueForKey:@"date"];
        self.Nid = [obj valueForKey:@"id"];
        self.title = [obj valueForKey:@"title"];
        if ([[obj allKeys] containsObject:@"url"]) {
            self.Url = [obj valueForKey:@"url"];
        }
    }
    return self;
}


@end
