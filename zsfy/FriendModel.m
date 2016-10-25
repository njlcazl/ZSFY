//
//  FriendModel.m
//  zsfy
//
//  Created by 曾祺植 on 11/17/15.
//  Copyright © 2015 wzy. All rights reserved.
//

#import "FriendModel.h"

@implementation FriendModel

+ (id)FriendInfoWithObj:(NSDictionary *)obj
{
    FriendModel *item = [[FriendModel alloc] initWithObj:obj];
    return item;
}

- (id)initWithObj:(NSDictionary *)obj
{
    self = [super init];
    if (self) {
        self.Fid = [obj valueForKey:@"id"];
        self.userType = [[obj valueForKey:@"userType"] stringValue];
        self.userName = [obj valueForKey:@"userName"];
        self.nikeName = [obj valueForKey:@"nikeName"];
        self.clientNumber = [obj valueForKey:@"clientNumber"];
        self.imageUrl = [obj valueForKey:@"image"];
        self.occupation = [obj valueForKey:@"occupation"];
        self.company = [obj valueForKey:@"company"];
        self.phone = [obj valueForKey:@"phone"];
        self.email = [obj valueForKey:@"email"];
        self.gender = (int)[obj valueForKey:@"gender"];
        self.age = (int)[obj valueForKey:@"age"];
        self.address = [obj valueForKey:@"adress"];
        self.nativePlace = [obj valueForKey:@"nativePlace"];
    }
    return self;
}

@end
