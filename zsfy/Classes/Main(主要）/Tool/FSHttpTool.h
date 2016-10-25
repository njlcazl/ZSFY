
//  FSHttpTool.h
//  zsfy
//
//  Created by pyj on 15/11/10.
//  Copyright (c) 2015年 wzy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^requestSuccessBlock)(id data);
typedef void(^requestFailureBlock)(NSError *error);

@interface FSHttpTool : NSObject

+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;


+ (void)GetSDInfo:(NSDictionary *)dic url:(NSString *)URL success:(requestSuccessBlock)success failure:(requestFailureBlock)failure;

@end
