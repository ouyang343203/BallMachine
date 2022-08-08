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

@interface AppDelegate ()<UIAlertViewDelegate>
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.backgroundColor = [UIColor whiteColor];

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
//-(void)initStaticPackage
//{
//    [PluginUpdateManager shareManager].postUrl = @"http://183.62.118.51:10088/app/resource/getTheNewestIssueStaticPackageDetailByCondition";
//     [PluginUpdateManager shareManager].projectId =@"145";
//    [PluginUpdateManager shareManager].domainName = @"http://183.62.118.51:18091";
//
//}

@end
