//
//  CSIIRequestManager.m
//  GIDC-animation
//
//  Created by 李佛军 on 2021/9/10.
//#define LoginHost @"http://192.168.80.8:180/studio/sys/token/password"
#import "CSIIRequestManager.h"
#import "AFNetworking.h"
@implementation CSIIRequestManager
+ (instancetype)manager {
    static CSIIRequestManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CSIIRequestManager alloc]init];
    });
    return manager;
}
-(void)checkworking
{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        switch (status) {
            case 0:
                NSLog(@"没有网络");
                break;
            case 1:
                NSLog(@"自己的3G/4G网/5G");
                break;
            case 2:
                NSLog(@"wifi网络");
                break;
            default:
                break;
        }
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}
-(void)requestWithType:(requestType)requestType
              withUrl:(NSString*)url
               params:(NSDictionary*)params
              success:(void(^)(id response))success
              failure:(void(^)(NSError *error))failure
{
    switch (requestType) {
        case requestTypeGet:
            NSLog(@"没有定义该请求");
            break;
        case requestTypePost:
            [self requestWithTypePost:url params:params success:success failure:failure];
            break;
        default:
            break;
    }
}

-(void)requestWithTypePost:(NSString*)urlStr
                   params:(NSDictionary*)params
                  success:(void(^)(id response))success
                  failure:(void(^)(NSError *error))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];

    [manager POST:urlStr parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        success(responseObject);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
        failure(error);
    }];
}
@end
