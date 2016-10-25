//
//  ApplyModel.h
//  zsfy
//
//  Created by 曾祺植 on 11/18/15.
//  Copyright © 2015 wzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApplyModel : NSObject

@property (nonatomic, strong) NSString *Aid;

@property (nonatomic, strong) NSString *userType;

@property (nonatomic, strong) NSString *userName;

@property (nonatomic, strong) NSString *nikeName;

@property (nonatomic, strong) NSString *imageUrl;

@property (nonatomic, strong) NSString *occupation;

@property (nonatomic, strong) NSString *company;

@property (nonatomic, strong) NSString *applyMessage;

+ (ApplyModel *)objWithDic:(NSDictionary *)obj;

@end
