//
//  FriendModel.h
//  zsfy
//
//  Created by 曾祺植 on 11/17/15.
//  Copyright © 2015 wzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendModel : NSObject

@property (nonatomic, strong) NSString * Fid;

@property (nonatomic, strong) NSString * userType;

@property (nonatomic, strong) NSString * userName;

@property (nonatomic, strong) NSString *nikeName;

@property (nonatomic, strong) NSString *clientNumber;

@property (nonatomic, strong) NSString *imageUrl;

@property (nonatomic, strong) NSString *occupation;

@property (nonatomic, strong) NSString *company;

@property (nonatomic, strong) NSString *phone;

@property (nonatomic, strong) NSString *email;

@property (assign) int gender;

@property (assign) int age;

@property (nonatomic, strong) NSString *address;

@property (nonatomic, strong) NSString *nativePlace;

+ (id)FriendInfoWithObj:(NSDictionary *)obj;

@end
