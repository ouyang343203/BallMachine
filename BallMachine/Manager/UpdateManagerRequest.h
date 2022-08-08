//
//  UpdateManagerRequest.h
//  GalaxyStudio
//
//  Created by 李佛军 on 2021/11/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UpdateManagerRequest : NSObject

+ (instancetype)manager;

-(void)updateRequest:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
