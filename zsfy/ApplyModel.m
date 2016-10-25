//
//  ApplyModel.m
//  zsfy
//
//  Created by 曾祺植 on 11/18/15.
//  Copyright © 2015 wzy. All rights reserved.
//

#import "ApplyModel.h"

@implementation ApplyModel

+ (ApplyModel *)objWithDic:(NSDictionary *)obj
{
    ApplyModel *item = [[ApplyModel alloc] initWithObj:obj];
    return item;
}

- (id)initWithObj:(NSDictionary *)obj
{
    self = [super init];
    if (self) {
        self.Aid = [obj valueForKey:@"id"];
        self.userType = [[obj valueForKey:@"userType"] stringValue];
        self.userName = [obj valueForKey:@"userName"];
        self.nikeName = [obj valueForKey:@"nikeName"];
        self.imageUrl = [obj valueForKey:@"image"];
        self.occupation = [obj valueForKey:@"occupation"];
        self.company = [obj valueForKey:@"company"];
        self.applyMessage = [obj valueForKey:@"applyMessage"];
    }
    return self;
}

@end
