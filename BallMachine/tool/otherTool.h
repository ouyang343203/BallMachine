//
//  otherTool.h
//  BallMachine
//
//  Created by 李佛军 on 2022/2/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface otherTool : NSObject
//判断版本号是否要升级
+ (BOOL)compareVesionWithServerVersion:(NSString *)version;

+(BOOL)compareBundleVersionWithServerVersion:(NSString *)version;
//获取的当前的版本好
+(NSString *)getCurrentVersion;
@end

NS_ASSUME_NONNULL_END
