//
//  AppDelegate.m
//  BallMachine
//
//  Created by 李佛军 on 2021/12/31.
//

#import "AppDelegate.h"
#import "ViewController.h"

#import "VersionUpdateManager.h"


//#ifndef DEBUG
///******内网环境******/
//#define NWHJ_POSTURL        @"http://192.168.101.3:8888/app/resource/getTheNewestIssueStaticPackageDetailByCondition"
//
//#define NWHJ_DOMAINNAME @"http://192.168.101.3:8091"
///******外网环境******/
//#define WWHJ_POSTURL @"http://183.62.118.51:10088/app/resource/getTheNewestIssueStaticPackageDetailByCondition"
//#define  WWHJ_DOMAINNAME @"http://183.62.118.51:18091"
//
//#endif

#define kCSIIRGBHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface AppDelegate ()<UIAlertViewDelegate>
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = kCSIIRGBHex(0x1F1F27);
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LaunchScreen" bundle:nil];
    self.window.rootViewController = [storyboard instantiateInitialViewController];
    [[VersionUpdateManager manager] checkingTheLatestVersionUpgrade];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    // 版本升级检测
    [[VersionUpdateManager manager] checkingTheLatestVersionUpgrade];
}
#pragma mark 静态离线包初始化

@end
