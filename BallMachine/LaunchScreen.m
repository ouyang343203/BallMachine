//
//  LaunchScreenController.m
//  BallMachine
//
//  Created by 李佛军 on 2022/5/17.
//

#import "LaunchScreen.h"
#import "EnvironmentChange.h"
#import "WHToast.h"
@interface LaunchScreen ()

@end

@implementation LaunchScreen

- (void)viewDidLoad {
    [super viewDidLoad];

   // [WHToast showMessage:@"环境切换请您在5秒内完成，并点击右上角按钮切换" inView:self.view duration:4 finishHandler:nil];
    [EnvironmentChange changeEnvironController:self];
  
}

@end
