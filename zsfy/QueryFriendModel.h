//
//  QueryFriendModel.h
//  zsfy
//
//  Created by 曾祺植 on 11/18/15.
//  Copyright © 2015 wzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QueryFriendModel : NSObject

@property (nonatomic, strong) NSString * Qid;

@property (nonatomic, strong) NSString * userType;

@property (nonatomic, strong) NSString * userName;

@property (nonatomic, strong) NSString *nikeName;

@property (nonatomic, strong) NSString *imageUrl;

@property (nonatomic, strong) NSString *occupation;

@property (nonatomic, strong) NSString *company;

+ (id)FriendInfoWithObj:(NSDictionary *)obj;

@end
