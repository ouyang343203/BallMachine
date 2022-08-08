//
//  otherTool.m
//  BallMachine
//
//  Created by 李佛军 on 2022/2/21.
//

#import "otherTool.h"

@implementation otherTool
+ (BOOL)compareVesionWithServerVersion:(NSString *)version {
    
    NSArray *versionArray = [version componentsSeparatedByString:@"."];//拿到iTunes获取App的版本
    NSArray *currentVesionArray = [[otherTool getCurrentVersion] componentsSeparatedByString:@"."];//当前版本
    NSInteger a = (versionArray.count> currentVesionArray.count)?currentVesionArray.count : versionArray.count;
    BOOL haveNew = NO;
    for (int i = 0; i < a; i++) {
        NSInteger a = [[versionArray objectAtIndex:i] integerValue];
        NSInteger b = [[currentVesionArray objectAtIndex:i] integerValue];
        if (a > b) {
            haveNew = YES;
        }else{
            haveNew = NO;
        }
    }
    if (haveNew) {
        NSLog(@"APP store 版本号大于当前版本号：有新版本更新");
    }else{
        NSLog(@"APP store 版本号小于等于当前版本号：没有新版本");
    }
    return haveNew;
}
+(NSString *)getCurrentVersion {
    NSDictionary *infoDict   = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"当前版本号：%@",currentVersion);
    return currentVersion;
}
+(BOOL)compareBundleVersionWithServerVersion:(NSString *)version
{
    NSDictionary *infoDict   = [[NSBundle mainBundle] infoDictionary];
    NSString *appBuildVersion = [infoDict objectForKey:@"CFBundleVersion"];
    BOOL haveNew = NO;
    return NO;

}
@end
