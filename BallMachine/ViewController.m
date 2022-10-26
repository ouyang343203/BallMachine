//
//  ViewController.m
//  BallMachine
//
//  Created by 李佛军 on 2021/12/31.
//

#import "ViewController.h"

#define kCSIIRGBHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface ViewController()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kCSIIRGBHex(0x1F1F27);
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
    [[PluginUpdateManager shareManager] startH5ViewControllerWithNebulaParams:Dic withController:self];
}
@end
