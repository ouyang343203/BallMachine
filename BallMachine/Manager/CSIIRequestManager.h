//
//  CSIIRequestManager.h
//  GIDC-animation
//
//  Created by 李佛军 on 2021/9/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef  NS_ENUM(NSInteger,requestType)
{
    requestTypeGet = 0,//GET请求
    requestTypePost //Post请求
};

@interface CSIIRequestManager : NSObject
+ (instancetype)manager;
-(void)checkworking;
/**网络请求*/
-(void)requestWithType:(requestType)requestType
              withUrl:(NSString*)url
               params:(NSDictionary*)params
              success:(void(^)(id response))success
              failure:(void(^)(NSError *error))failure;
@end

NS_ASSUME_NONNULL_END
