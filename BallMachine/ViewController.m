//
//  ViewController.m
//  BallMachine
//
//  Created by 李佛军 on 2021/12/31.
//

#import "ViewController.h"
@interface ViewController()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadProject];
    NSLog(@"postUrl = %@", [PluginUpdateManager shareManager].postUrl);
}

-(void)loadProject {
    NSDictionary *navagation = @{
                               @"titleColor":[UIColor blackColor],
                               @"titleStr":@"",
                               @"left_back_icon":@"back"};
    NSDictionary *Dic = @{
                         @"area":@"广东省深圳市",
                          @"name":@"BallMachine",
                          @"systemType":@"0",
                          @"versionNumber":@"0.0.1",
                          @"navagation":navagation,
    };
    [[PluginUpdateManager shareManager]startH5ViewControllerWithNebulaParams:Dic];
}
@end
