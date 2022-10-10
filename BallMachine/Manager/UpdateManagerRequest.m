//
//  UpdateManagerRequest.m
//  GalaxyStudio
//  Created by 李佛军 on 2021/11/29.
#import "UpdateManagerRequest.h"
#import "CSIIRequestManager.h"
#import "otherTool.h"
@implementation UpdateManagerRequest
+ (instancetype)manager
{
    static UpdateManagerRequest *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[UpdateManagerRequest alloc]init];
    });
    return manager;
}
-(void)updateRequest:(void(^)(id response))success failure:(void(^)(NSError *error))failure
{
    NSDictionary *dic = @{
                          @"versionNumber":[otherTool getCurrentVersion],
                          @"systemType":@"1",
                          @"projectId":@"145"};
    NSString *appPackageUrl = [NSString stringWithFormat:@"%@%@",Version_URL,AppPackageByCondition];
    NSLog(@"appPackageUrl-----%@",appPackageUrl);
    [[CSIIRequestManager manager]requestWithType:requestTypePost withUrl:appPackageUrl params:dic success:^(id  _Nonnull response) {
        success(response);
        NSLog(@"response-----%@",response);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
        NSLog(@"NSError-----%@",error);
    }];
}
@end
