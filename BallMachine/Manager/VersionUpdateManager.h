//
//  VersionUpdateManager.h
//  GalaxyStudio
//
//  Created by 李佛军 on 2021/11/29
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VersionUpdateManager : NSObject
+ (instancetype)manager;
-(void)checkingTheLatestVersionUpgrade;
@end
NS_ASSUME_NONNULL_END
