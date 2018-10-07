//
//  DeviceIntegrator.h
//  EiController
//
//  Created by Genrih Korenujenko on 20.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "DeviceIntegratorInterface.h"
#import "IDeviceOperationLogStorage.h"
#import "ActionListener.h"
#import "DeviceActionStatus.h"
#import "DeviceActionInterface.h"

@interface DeviceIntegrator : NSObject <DeviceIntegratorInterface, ActionListener>
{
    dispatch_queue_t queue;
    DeviceActionStatus *status;
    NSMutableArray <id<DeviceActionInterface>> *actions;
    NSInteger actionIndex;
    Device *processingDevice;
    ConnectionData *deviceConnectionData;
    id <IDeviceOperationLogStorage> deviceOperationLogStorage;
}

@end
