//
//  JGBluetoothManager.h
//  BallMachine
//
//  Created by 李佛军 on 2022/1/13.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
NS_ASSUME_NONNULL_BEGIN

@interface JGBluetoothManager : NSObject
@property (nonatomic, strong) NSMutableArray *findPeripherals; //查找到设备（不包含用户列表里的设备）
@property (nonatomic, strong) NSMutableArray *connectPeripherals; //连接上的设备
@property (nonatomic, strong) CBCentralManager *cbCentralManager;
+(JGBluetoothManager *)share;
@end

NS_ASSUME_NONNULL_END
