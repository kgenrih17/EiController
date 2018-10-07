//
//  IDeviceOperationLogStorage.h
//  EiController
//
//  Created by Genrih Korenujenko on 27.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "StorageInterface.h"
#import "DeviceOperationLog.h"

@protocol IDeviceOperationLogStorage <StorageInterface>

@required
-(void)add:(DeviceOperationLog*)item;
-(NSMutableArray<DeviceOperationLog*>*)getByFingerprint:(NSString*)fingerprint;
-(DeviceOperationLog*)getLastByFingerprint:(NSString*)fingerprint;
-(void)clearByTimestamp:(NSInteger)timestamp;
-(void)removeByFingerping:(NSString*)fingerprint;

@end
