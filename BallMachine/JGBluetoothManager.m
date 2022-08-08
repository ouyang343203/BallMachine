//
//  JGBluetoothManager.m
//  BallMachine
//
//  Created by 李佛军 on 2022/1/13.
//

#import "JGBluetoothManager.h"
@interface JGBluetoothManager()<CBCentralManagerDelegate,CBPeripheralDelegate,CBPeripheralManagerDelegate>
@property (nonatomic, strong) NSMutableArray *offlineperipherals;
@property (nonatomic, strong) NSMutableArray *tempLists;
@property (nonatomic, strong) CBPeripheral *peripheral;
@property (nonatomic, strong) CBPeripheralManager *peripheralmanager;
@end
@implementation JGBluetoothManager
+(JGBluetoothManager *)share {
           static JGBluetoothManager *shareInstance_ = nil;
           static dispatch_once_t onceToken;
           dispatch_once(&onceToken, ^{
           shareInstance_ = [[self alloc] init];
           });
       return shareInstance_;
}
//初始化中心设备CBCentraManager(管理者)和CBPeripheralManager(外设管理者)
-(id)init {
     self = [super init];
     if (self) {
     _cbCentralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
     _peripheralmanager = [[CBPeripheralManager alloc]initWithDelegate:self queue:nil];
     }
     return self;
   }
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
            BOOL state = false;
            NSString *msg = @"";
            switch (central.state) {
                case CBCentralManagerStatePoweredOn:{
                    msg = @"Bluetooth is currently powered on";
                    state = YES;
                }
                    break;
                case CBCentralManagerStatePoweredOff:{
                    msg = @"Bluetooth is currently powered off.";
                }
                    break;
                case CBCentralManagerStateUnauthorized:{
                    msg = @"The application is not authorized to use the Bluetooth Low Energy Central/Client role.";
                }
                    break;
                case CBCentralManagerStateUnsupported:{
                    msg = @"The platform doesn't support the Bluetooth Low Energy Central/Client role.";
                }
                    break;
                case CBCentralManagerStateResetting:{
                    msg = @"The connection with the system service was momentarily lost, update imminent.";
                }
                    break;
                case CBCentralManagerStateUnknown:{
                    msg = @"State unknown, update imminent.";
                }
                    break;
           }
}
//下面是搜索设备封装方法
-(void) scanBlueServes {
    NSDictionary *optionsDict = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
    [self.cbCentralManager scanForPeripheralsWithServices:nil options:optionsDict];
    //CBUUID *uuid = [CBUUID UUIDWithString:@"FFF0"];
    //[self.cbCentralManager scanForPeripheralsWithServices:@[uuid] options:optionsDict];

}
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    if (peripheral.state == CBPeripheralStateConnected) {
          return;
    }
    NSData *data = [advertisementData objectForKey:@"kCBAdvDataManufacturerData"];
    NSString *macAddress = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"macAddress = %@",macAddress);
  
    if (![self.findPeripherals containsObject:peripheral]&&peripheral!=nil&&peripheral.name!=nil&&peripheral.identifier!=nil) {
        [self.findPeripherals addObject:peripheral];
    }
      
    
//    if ((peripheral.name && ([peripheral.name hasPrefix:@"BBCare"]) || [self checkMacAddress]){
//    [self.findPeripherals addObject:peripheral];
//    }

}
@end
