//
//  VersionUpdateManager.m
//  GalaxyStudio
//
//  Created by 李佛军 on 2021/11/29.
//

#import "VersionUpdateManager.h"
#import "UpdateManagerRequest.h"
#import "otherTool.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface VersionUpdateManager()
@property (nonatomic,strong) UIWindow *updateWindow;

@end
@implementation VersionUpdateManager
+ (instancetype)manager
{
    static VersionUpdateManager *manager;
    static dispatch_once_t onceToken;
     dispatch_once(&onceToken, ^{
    manager = [[VersionUpdateManager alloc]init];
     });
     return manager;
}
//检查新版本升级
-(void)checkingTheLatestVersionUpgrade
{
    [[UpdateManagerRequest manager] updateRequest:^(id  _Nonnull response) {
            NSDictionary *dicton = (NSDictionary*)response;

                 if ([dicton[@"code"] isEqual:@"200"]) {
                     NSString *updateMessage =  dicton[@"data"][@"versionName"];
                     if ([otherTool compareVesionWithServerVersion:updateMessage]) {
                         NSString *resourceUrl = dicton[@"data"][@"resourceUrl"];
                         NSString *upgradeMessage = dicton[@"data"][@"upgradeMessage"];
                         [self showCustomAlertView:upgradeMessage resourceUrl:resourceUrl];
                     }
                     
                 }
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"NSError-----%@",error);
        }];
}
-(void)showCustomAlertView:(NSString*)message resourceUrl:(NSString*)openUrl
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"发现新版本" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *defaultR = [UIAlertAction actionWithTitle:@"升级" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (openUrl) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:openUrl]];
            [self removeWindow];
        }
    }];
    UIAlertAction *canclel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self removeWindow];
    }];
    UILabel *label1 = [alertController.view valueForKeyPath:@"_messageLabel"];
    if (label1) {label1.textAlignment = NSTextAlignmentLeft;}
    [alertController addAction:defaultR];
    [alertController addAction:canclel];
    
    [self.updateWindow makeKeyAndVisible];
    UIViewController *bgVC = [[UIViewController alloc] init];
    [bgVC.view setBackgroundColor:[UIColor blackColor]];
    self.updateWindow.rootViewController = bgVC;
    bgVC.view.alpha = 0.3;
     
    [bgVC presentViewController:alertController animated:YES completion:nil];
}
-(UIWindow*)updateWindow
{
    if (!_updateWindow) {
        _updateWindow =  [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _updateWindow.backgroundColor = [UIColor clearColor];
        _updateWindow.windowLevel = UIWindowLevelAlert;
    }
    return _updateWindow;
}
-(void)removeWindow
{
    UIViewController *VC = self.updateWindow.rootViewController;
    [VC removeFromParentViewController];
    self.updateWindow.rootViewController = nil;
    [self.updateWindow removeFromSuperview];
    self.updateWindow = nil;
}
@end
