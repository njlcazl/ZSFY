//
//  FYHawkCommens.m
//  zsfy
//
//  Created by 李晓飞 on 15/11/30.
//  Copyright (c) 2015年 wzy. All rights reserved.
//

#import "FYHawkCommens.h"
#import "FYLoginViewController.h"

@implementation FYHawkCommens

+ (BOOL)checkIfLogin:(UINavigationController *)nav{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *userId  =  [userDefault objectForKey:@"user_id"];
    NSLog(@"userId  is %@",userId);
    
    if([NSString isBlankString:userId] )
    {
        FYLoginViewController * lc = [[FYLoginViewController alloc] init];
        [nav pushViewController:lc animated:YES];
        return NO;
    }else
    {
        return YES;
    }
}

+ (NSString *)fetchUserInfoByKey:(NSString *)key{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *userId  =  [userDefault objectForKey:key];
    if (userId) {
        return userId;
    }
    else{
        return @"";
    }
}

+ (void)setUserInfo:(id)info WithKey:(NSString *)key{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:info forKey:key];
    [userDefault synchronize];
}

@end
