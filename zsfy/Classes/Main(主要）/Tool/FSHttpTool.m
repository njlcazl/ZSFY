//
//  FSHttpTool.m
//  zsfy
//
//  Created by pyj on 15/11/10.
//  Copyright (c) 2015年 wzy. All rights reserved.
//

#import "FSHttpTool.h"
#import "AFNetworking.h"

@implementation FSHttpTool
+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    // 1.创建请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.发送请求
    url = [NSString stringWithFormat:@"%@%@",baseUrl,url];
    [mgr GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    // 1.创建请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.发送请求
    url = [NSString stringWithFormat:@"%@%@",baseUrl,url];
    NSLog(@"请求的url:%@",url);
    [mgr POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)GetSDInfo:(NSDictionary *)dic url:(NSString *)URL success:(requestSuccessBlock)success failure:(requestFailureBlock)failure
{
     URL = [NSString stringWithFormat:@"%@%@",baseUrl,URL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:URL parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if(success)
        {
            success(dict);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if(failure)
        {
            failure(error);
        }
    }];
}


@end
