//
//  JGBBluetoothManager.m
//  BallMachine
//
//  Created by 李佛军 on 2022/1/14.
//

#import "JGBBluetoothManager.h"
#import <CoreBluetooth/CoreBluetooth.h>
@interface JGBBluetoothManager()<CBCentralManagerDelegate,CBPeripheralDelegate>
@property (strong, nonatomic) CBCentralManager *manager;
@property (nonatomic, strong) CBPeripheral *peripheral;
  
@property (nonatomic, weak)NSTimer * connentTimer;
@end
@implementation JGBBluetoothManager
//蓝牙状态
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
  NSString * state = nil;
  switch ([central state])
  {
    case CBCentralManagerStateUnsupported:
      state = @"The platform/hardware doesn't support Bluetooth Low Energy.";
      break;
   //应用程序没有被授权使用蓝牙
    case CBCentralManagerStateUnauthorized:
      state = @"The app is not authorized to use Bluetooth Low Energy.";
      break;
       //尚未打开蓝牙
    case CBCentralManagerStatePoweredOff:
      state = @"Bluetooth is currently powered off.";
      break;
       //连接成功
    case CBCentralManagerStatePoweredOn:
      [self.manager scanForPeripheralsWithServices:nil options:nil];
      state = @"work";
      break;
    case CBCentralManagerStateUnknown:
    default:
      ;
  }
   
  NSLog(@"Central manager state: %@", state);
}
//查找设备
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
   //每个蓝牙设备有自己唯一的标识符，根据标识符确认自己要连接的设备
  if ([peripheral.identifier isEqual:self.peripheral.identifier])
  {
    self.peripheral = peripheral;
    //数据连接定时器
    self.connentTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(connentPeripheral) userInfo:@"timer" repeats:YES];
    [self.connentTimer fire];
  }
}
  
- (void)connentPeripheral {
  //连接外设
  self.manager.delegate = self;
  [self.manager connectPeripheral:_peripheral options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
  
}
  
//连接成功后调用
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
  NSLog(@"Did connect to peripheral: %@,%@", peripheral,peripheral.name);
  [peripheral setDelegate:self]; //查找服务
  [peripheral discoverServices:nil];
  [self.connentTimer invalidate];
  //监测设备是否断开了
//  [self createWorkDataSourceWithTimeInterval:1];
}
//当监听到失去和外围设备连接，重新建立连接
//这个方法是必须实现的，因为蓝牙会中断连接，正好触发这个方法重建连接。重建连接可能造成数秒后才能读取到RSSI。
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
  [self.manager connectPeripheral:peripheral options:nil];
}
  
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
  NSLog(@"%@",error.description);
}
  
//返回的蓝牙服务通知通过代理实现
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
  if (error)
  {
    NSLog(@"Discovered services for %@ with error: %@", peripheral.name, [error localizedDescription]);
    return;
  }
  for (CBService *service in peripheral.services)
  {
//    NSLog(@"Service found with UUID: %@", service.UUID.UUIDString);
    //发现服务
    if ([service.UUID isEqual:[CBUUID UUIDWithString:@"180D"]])//heart rate
    {
      //在一个服务中寻找特征值
      [peripheral discoverCharacteristics:nil forService:service];
    }
  }
}
  
//返回的蓝牙特征值通知通过代理实现
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
  if (error)
  {
    NSLog(@"Discovered characteristics for %@ with error: %@", service.UUID, [error localizedDescription]);
    return;
  }
  for (CBCharacteristic * characteristic in service.characteristics)
  {
    NSLog(@"characteristic:%@",characteristic);
    if( [characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A37"]])
    {
       
      [self notification:service.UUID characteristicUUID:characteristic.UUID peripheral:peripheral on:YES];
//      [self.peripheral setNotifyValue:YES forCharacteristic:characteristic];
    }
  }
}
  
//处理蓝牙发过来的数据
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
  
}
  
-(void) notification:(CBUUID *) serviceUUID characteristicUUID:(CBUUID *)characteristicUUID peripheral:(CBPeripheral *)p on:(BOOL)on
{
  CBService *service = [self getServiceFromUUID:serviceUUID p:p];
  if (!service)
  {
    //    if (p.UUID == NULL) return; // zach ios6 addedche
    //    NSLog(@"Could not find service with UUID on peripheral with UUID \n");
    return;
  }
  CBCharacteristic *characteristic = [self getCharacteristicFromUUID:characteristicUUID service:service];
  if (!characteristic)
  {
    //    if (p.UUID == NULL) return; // zach ios6 added
    //    NSLog(@"Could not find characteristic with UUID on service with UUID on peripheral with UUID\n");
    return;
  }
  [p setNotifyValue:on forCharacteristic:characteristic];
   
}
  
-(CBService *) getServiceFromUUID:(CBUUID *)UUID p:(CBPeripheral *)p
{
   
  for (CBService* s in p.services)
  {
    if ([s.UUID isEqual:UUID]) return s;
  }
  return nil; //Service not found on this peripheral
}
-(CBCharacteristic *) getCharacteristicFromUUID:(CBUUID *)UUID service:(CBService*)service {
   
  for (CBCharacteristic* c in service.characteristics)
  {
    if ([c.UUID isEqual:UUID]) return c;
  }
  return nil; //Characteristic not found on this service
}
@end
