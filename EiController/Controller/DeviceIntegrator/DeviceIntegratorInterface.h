//
//  DeviceIntegrator.h
//  EiController
//
//  Created by Genrih Korenujenko on 20.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "DeviceIntegratorListener.h"
#import "ScheduleStorageInterface.h"
#import "DeviceSyncStatusesStorageInterface.h"

#import "EiController-Swift.h"

@protocol DeviceIntegratorInterface <NSObject>

@property (nonatomic, readwrite, strong) NSMutableArray <Device*> *devices;
@property (nonatomic, readwrite, weak) id <ScheduleStorageInterface> scheduleStorage;
@property (nonatomic, readwrite, weak) id <INodeStorage> deviceStorage;
@property (nonatomic, readwrite, weak) id <DeviceSyncStatusesStorageInterface> deviceStatusStorage;
@property (nonatomic, readwrite, weak) id <DeviceIntegratorListener> listener;
@property (nonatomic, readwrite) BOOL isStarted;

@required
+(instancetype)build:(id<ScheduleStorageInterface>)scheduleStorage
       deviceStorage:(id<INodeStorage>)deviceStorage
 deviceStatusStorage:(id<DeviceSyncStatusesStorageInterface>)deviceStatusStorage
            listener:(id<DeviceIntegratorListener>)listener;
-(void)start:(NSArray<NSString*>*)fingerprints;
-(void)stop;
-(void)deinit;
-(void)clearOldLogs;

@end
