//
//  EnvironmentChange.m
//  BallMachine
//
//  Created by 李佛军 on 2022/5/17.
//

#import "EnvironmentChange.h"
#import <UIKit/UIKit.h>
#import <CSIIJSBridge/CSIIJSBridge.h>
#import "AppDelegate.h"
#import "ViewController.h"
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width
static UIButton *skipButton;
static dispatch_source_t _timer;
static UIView *startPageSuperView;
static UIViewController *environVC;
static BOOL isClose;
@implementation EnvironmentChange


// 页面排版规范
// MARK:  mark - HTTP Method -- 网络请求

//MARK: - Delegate Method -- 代理方法

//MARK: - Private Method -- 私有方法
+(void)openCountdown:(UIButton*)buttion {
    
    __block NSInteger time =5; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
     _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
            if(time <= 0){ //倒计时结束，关闭
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [EnvironmentChange clearAllView];
                    if (!isClose) {
                        [EnvironmentChange JumpToRootViewController];
                    }
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置按钮显示读秒效果
                [buttion setTitle:[NSString stringWithFormat:@"%lds", (long)time] forState:UIControlStateNormal];
                });
                time--;
            }
        });
        dispatch_resume(_timer);
}


+(void)changeEnvironmentList {
    
    //显示弹出框列表选择
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"环境切换"
                                                                   message:@"请根据您需要的环境进行切换"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * action) {
                                                              //响应事件
                                                              NSLog(@"action = %@", action);
        [EnvironmentChange setTestNetwork];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [EnvironmentChange JumpToRootViewController];
        });
    }];
    
    UIAlertAction* deleteAction = [UIAlertAction actionWithTitle:@"测试环境(内网)" style:UIAlertActionStyleDestructive
                                                         handler:^(UIAlertAction * action) {
                                                             //响应事件
                                                             NSLog(@"action = %@", action);
        [EnvironmentChange setTestNetwork];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [EnvironmentChange JumpToRootViewController];
        });
    }];
    
    UIAlertAction* saveAction = [UIAlertAction actionWithTitle:@"测试环境(外网)" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             //响应事件
                                                             NSLog(@"action = %@", action);
        [EnvironmentChange setProductionNetwork];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [EnvironmentChange JumpToRootViewController];
        });
        
    }];
    [alert addAction:saveAction];
    [alert addAction:cancelAction];
    [alert addAction:deleteAction];
    if (environVC!=nil) {
        [environVC presentViewController:alert animated:YES completion:nil];
    }
}

+(void)stop_Timer {
    
    if (_timer) {
        dispatch_cancel(_timer);
        _timer = nil;
    }
}

+(void)clearAllView {
    
    if (skipButton !=nil) {
        [skipButton removeFromSuperview];
        skipButton = nil;
    }
}

+(void)JumpToRootViewController {
    
    [EnvironmentChange setRootViewController];
}

+(void)setRootViewController {
    
    AppDelegate *app = [EnvironmentChange getDelegate];
    UIViewController *VC = app.window.rootViewController;
    [VC removeFromParentViewController];
    CSIINavigationController *rootVC =  [[CSIINavigationController alloc] initWithRootViewController:[[ViewController alloc] init]];
    app.window.rootViewController = rootVC;
}

+(AppDelegate*)getDelegate {
    
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}

//MARK: - Public Method -- 公开方法
+(void)changeEnvironController:(UIViewController*)controller {
    
    environVC = controller;
    [EnvironmentChange initTimerButton];
//    [EnvironmentChange setTestNetwork];
    [EnvironmentChange setProductionNetwork];
}

//设置测试网络
+(void)setTestNetwork {
    
    [PluginUpdateManager shareManager].postUrl = @"http://192.168.101.3:8888/app/resource/getTheNewestIssueStaticPackageDetailByCondition";
    [PluginUpdateManager shareManager].projectId =@"145";
    [PluginUpdateManager shareManager].domainName = @"http://192.168.101.3:8091";
}
//设置生产网络
+(void)setProductionNetwork {
    
    [PluginUpdateManager shareManager].postUrl = @"http://183.62.118.51:10088/app/resource/getTheNewestIssueStaticPackageDetailByCondition";
    [PluginUpdateManager shareManager].projectId =@"145";
    [PluginUpdateManager shareManager].domainName = @"http://183.62.118.51:18091";
}

//MARK:  - Action Method -- 公开方法
+(void)skipAction {
    
    isClose = YES;
    [EnvironmentChange changeEnvironmentList];
}

//MARK:  - Setter/Getter -- Getter尽量写出懒加载形式
+(void)initTimerButton {
    
    skipButton= [UIButton buttonWithType:UIButtonTypeCustom];
    skipButton.frame = CGRectMake(MainScreenWidth - 80, 40, 60, 60);
    skipButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    skipButton.layer.cornerRadius = 30;
    skipButton.layer.masksToBounds = YES;
    skipButton.titleLabel.font = [UIFont systemFontOfSize:18.5];
   // [skipButton addTarget:self action:@selector(skipAction) forControlEvents:UIControlEventTouchUpInside];
    [environVC.view addSubview:skipButton];
    [EnvironmentChange openCountdown:skipButton];
}

@end
