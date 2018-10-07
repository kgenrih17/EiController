//
//  DeviceAPIInterface.h
//  EiController
//
//  Created by Genrih Korenujenko on 23.03.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "DeviceIntegrationInfo.h"
//#import "NetworkSettings.h"
//#import "SwitchConfig.h"
//#import "Device.h"
//#import "CommandResult.h"
//#import "IDeviceOperationLogStorage.h"

//typedef void (^CommandResultBlock)(CommandResult *result);

@protocol DeviceCommandSenderInteface <NSObject>
//
//@property (nonatomic, readwrite, strong) id <IDeviceOperationLogStorage> storage;
//@property (nonatomic, readwrite, strong) NSMutableArray *devices;
//
//@required
//+(instancetype)build:(id<IDeviceOperationLogStorage>)storage;
//
//-(void)getInfo:(Device*)device completion:(CommandResultBlock)completion;
//-(void)setName:(Device*)device name:(NSString*)name completion:(CommandResultBlock)completion;
//
//-(void)getNetworkSettings:(Device*)device completion:(CommandResultBlock)completion;
//-(void)setNetworkSettings:(Device*)device netSettings:(NetworkSettings*)netSettings completion:(CommandResultBlock)completion;
//-(void)setNetworkSettingsList:(NSArray<Device*>*)devices networkSettings:(NetworkSettings*)netSettings completion:(CommandResultBlock)completion;
//
//-(void)getModeConfiguration:(Device*)device completion:(CommandResultBlock)completion;
//-(void)setModeConfiguration:(Device*)device switchConfig:(SwitchConfig*)switchConfig completion:(CommandResultBlock)completion;
//
//-(void)setRestartNodeScheduler:(Device*)device scheduler:(NSDictionary*)info completion:(CommandResultBlock)completion;
//-(void)setShutdownNodeScheduler:(Device*)device scheduler:(NSDictionary*)info completion:(CommandResultBlock)completion;
//-(void)setRestartPlaybackScheduler:(Device*)device scheduler:(NSDictionary*)info completion:(CommandResultBlock)completion;
//
//-(void)restartNode:(Device*)device params:(NSDictionary*)params completion:(CommandResultBlock)completion;
//-(void)restartNodeList:(NSArray<Device*>*)devices params:(NSDictionary*)params completion:(CommandResultBlock)completion;
//
//-(void)restartPlayback:(Device*)device params:(NSDictionary*)params completion:(CommandResultBlock)completion;
//-(void)restartPlaybackList:(NSArray<Device*>*)devices params:(NSDictionary*)params completion:(CommandResultBlock)completion;
//
//-(void)shutdown:(Device*)device params:(NSDictionary*)params completion:(CommandResultBlock)completion;
//
//-(void)checkConnectionManagementServer:(Device*)device address:(NSString*)address completion:(CommandResultBlock)completion;
//-(void)getManagementServer:(Device*)device completion:(CommandResultBlock)completion;
//-(void)setManagementServer:(DeviceIntegrationInfo*)integration device:(Device*)device completion:(CommandResultBlock)completion;
//-(void)setManagementServerList:(DeviceIntegrationInfo*)integration device:(NSArray<Device*>*)devices completion:(CommandResultBlock)completion;
//
//-(void)checkConnectionRMServer:(Device*)device address:(NSString*)address completion:(CommandResultBlock)completion;
//-(void)setReverseMonitoringServer:(Device*)device params:(NSDictionary*)params completion:(CommandResultBlock)completion;
//-(void)setReverseMonitoringServerList:(NSArray<Device*>*)devices params:(NSDictionary*)params completion:(CommandResultBlock)completion;
//-(void)getReverseMonitoringServer:(Device*)device completion:(CommandResultBlock)completion;
//
//-(void)checkConnectionUpdateServer:(Device*)device address:(NSString*)address completion:(CommandResultBlock)completion;
//-(void)setUpdateServer:(Device*)device params:(NSDictionary*)params completion:(CommandResultBlock)completion;
//-(void)getUpdateServerCommand:(Device*)device completion:(CommandResultBlock)completion;

@end
