//
//  FYUserMessage.h
//  zsfy
//
//  Created by pyj on 15/11/22.
//  Copyright (c) 2015年 wzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FYUserMessage : NSObject
@property (nonatomic, strong) NSObject * adress;
@property (nonatomic, strong) NSObject * age;
@property (nonatomic, strong) NSString * clientId;
@property (nonatomic, strong) NSString * clientNumber;
@property (nonatomic, strong) NSString * clientPwd;
@property (nonatomic, strong) NSObject * company;
@property (nonatomic, assign) NSInteger courtId;
@property (nonatomic, strong) NSObject * email;
@property (nonatomic, strong) NSObject * gender;
@property (nonatomic, strong) NSString * id;
@property (nonatomic, strong) NSObject * idNumber;
@property (nonatomic, strong) NSObject * idType;
@property (nonatomic, strong) NSString * image;
@property (nonatomic, assign) BOOL isAccessSearch;
@property (nonatomic, strong) NSString * loginToken;
@property (nonatomic, strong) NSObject * nativePlace;
@property (nonatomic, strong) NSString * nikeName;
@property (nonatomic, strong) NSObject * occupation;
@property (nonatomic, assign) NSInteger osId;
@property (nonatomic, strong) NSObject * phone;
@property (nonatomic, strong) NSString * token;
@property (nonatomic, strong) NSString * userName;
@property (nonatomic, assign) NSInteger userType;
@end
