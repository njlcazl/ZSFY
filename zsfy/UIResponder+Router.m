//
//  UIResponder+Router.m
//  UC_Demo_1.0.0
//
//  Created by Barry on 15/4/22.
//  Copyright (c) 2015年 Barry. All rights reserved.
//

#import "UIResponder+Router.h"

@implementation UIResponder (Router)

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo
{
    [[self nextResponder] routerEventWithName:eventName userInfo:userInfo];
}

@end