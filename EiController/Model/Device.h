//
//  Device.h
//  TestProj
//
//  Created by admin on 2/17/16.
//  Copyright © 2016 RadicalComputing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceIntegrationInfo.h"
#import "NetworkSettings.h"
#import "DeviceSyncStatus.h"
#import "EDeviceStatus.h"

@class ModeConfiguration;

static const NSInteger NO_HARDWARE_DATA = -1;

@interface Device : NSObject

@property (nonatomic, readwrite, copy) NSString *md5;
///
@property (nonatomic, readwrite, copy) NSString *fingerprint;
@property (nonatomic, readwrite, copy) NSString *productId;
@property (nonatomic, readwrite, copy) NSString *title;
@property (nonatomic, readwrite, copy) NSString *token;
@property (nonatomic, readwrite, copy) NSString *vendor;

@property (nonatomic, readwrite, copy) NSString *host;
@property (nonatomic, readwrite, copy) NSString *address;
@property (nonatomic) NSInteger port;
@property (nonatomic) NSString *domain;

@property (nonatomic, readwrite, strong) DeviceIntegrationInfo *esIntegrInfo;
@property (nonatomic, readwrite, strong) NetworkSettings *netSettings;
@property (nonatomic, readwrite, strong) ModeConfiguration *modeConfiguration;

@property (nonatomic, readwrite) BOOL isUseTunnel;
@property (nonatomic, readwrite, copy) NSString *tunnelAddress;

@property (nonatomic, readwrite) BOOL isEnableUpdateServer;
@property (nonatomic, readwrite, copy) NSString *updateServerAddress;

@property (nonatomic, readwrite) EDeviceStatus status;
@property (nonatomic, readwrite, strong) DeviceSyncStatus *syncStatus;

/// Description
@property (nonatomic, readwrite, copy) NSString *model;
@property (nonatomic, readwrite, copy) NSString *version;
@property (nonatomic, readwrite, copy) NSString *edition;
@property (nonatomic, readwrite, copy) NSString *sn;
@property (nonatomic, readwrite, copy) NSString *sid;

// Summary
@property (nonatomic, readwrite, copy) NSString *location;
@property (nonatomic, readwrite, copy) NSString *company;
@property (nonatomic, readwrite, copy) NSString *protocol;
@property (nonatomic, readwrite, copy) NSString *timezone;
@property (nonatomic, readwrite, copy) NSString *upTime;
@property (nonatomic, readwrite, copy) NSString *sysTime;
@property (nonatomic, readwrite) NSInteger period;
@property (nonatomic, readwrite) NSInteger videoChannelsCount;
@property (nonatomic, readwrite) NSInteger audioChannelsCount;
@property (nonatomic, readwrite) NSInteger registrationDate;

// hardware
@property (nonatomic, readwrite, strong) NSMutableArray <NSNumber*> *cpusLoad;
@property (nonatomic, readwrite, strong) NSMutableArray <NSNumber*> *cpusTemp;
@property (nonatomic, readwrite, strong) NSMutableArray <NSNumber*> *gpusTemp;
@property (nonatomic, readwrite, copy) NSString *macAddress;
@property (nonatomic, readwrite, copy) NSString *motherboard;
@property (nonatomic, readwrite, copy) NSString *hddSN;
@property (nonatomic, readwrite) NSInteger ramTotal;
@property (nonatomic, readwrite) NSInteger ramFree;
@property (nonatomic, readwrite) NSInteger hddTotal;
@property (nonatomic, readwrite) NSInteger hddFree;
@property (nonatomic, readwrite) NSInteger interfaceTrafficDate;
@property (nonatomic, readwrite) NSInteger interfaceTrafficSendLAN;
@property (nonatomic, readwrite) NSInteger interfaceTrafficReceivedLAN;
@property (nonatomic, readwrite) NSInteger interfaceTrafficSendWiFi;
@property (nonatomic, readwrite) NSInteger interfaceTrafficReceivedWiFi;

// Scheduler
@property (nonatomic, readwrite) NSInteger rebootHour;
@property (nonatomic, readwrite) NSInteger rebootMinute;
@property (nonatomic, readwrite, copy) NSString *rebootMeridiem;
@property (nonatomic, readwrite) BOOL rebootEnabled;
@property (nonatomic, readwrite) NSInteger playbackRestartHour;
@property (nonatomic, readwrite) NSInteger playbackRestartMinute;
@property (nonatomic, readwrite, copy) NSString *playbackRestartMeridiem;
@property (nonatomic, readwrite) BOOL playbackRestartEnabled;
@property (nonatomic, readwrite) NSInteger shutdownHour;
@property (nonatomic, readwrite) NSInteger shutdownMinute;
@property (nonatomic, readwrite, copy) NSString *shutdownMeridiem;
@property (nonatomic, readwrite) BOOL shutdownEnabled;

/// For details info command
@property (nonatomic, readwrite) NSInteger detailsLastTimestamp;

+(instancetype)centralDevice:(NSDictionary*)dic;
-(void)updateInfo:(NSDictionary*)_answer;

@end
