//
//  DeviceIntegrator.m
//  EiController
//
//  Created by Genrih Korenujenko on 20.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "DeviceIntegrator.h"
#import "Folders.h"
#import "CentralMethod.h"

/// Storages
#import "ScheduleStorage.h"
#import "ApplicationFilesTable.h"

#import "ScheduleFilesTable.h"
#import "ApplicationsTable.h"
#import "DownloadFileStatusesTable.h"
#import "UploadFileStatusesTable.h"
#import "LogFilesTable.h"
#import "DeviceOperationLogsTable.h"

/// Actions
#import "UploadSchedulesAction.h"
#import "UploadApplicationsAction.h"
#import "DownloadLogsAction.h"

static const NSInteger SYNC_LOGS_DAYS_MAX = 7;
static const NSInteger RETRY_ERROR_TIMEOUT = 60;
static const NSInteger ACTION_TIMEOUT = 2;

@implementation DeviceIntegrator

@synthesize devices;
@synthesize scheduleStorage;
@synthesize deviceStorage;
@synthesize deviceStatusStorage;
@synthesize listener;
@synthesize isStarted;

#pragma mark - ServerIntegratorInterface
+(instancetype)build:(id<ScheduleStorageInterface>)scheduleStorage
       deviceStorage:(id<INodeStorage>)deviceStorage
 deviceStatusStorage:(id<DeviceSyncStatusesStorageInterface>)deviceStatusStorage
            listener:(id<DeviceIntegratorListener>)listener
{
    DeviceIntegrator *result = [DeviceIntegrator new];
    result.scheduleStorage = scheduleStorage;
    result.deviceStorage = deviceStorage;
    result.deviceStatusStorage = deviceStatusStorage;
    result.listener = listener;
    return result;
}

-(void)start:(NSArray<NSString*>*)fingerprints;
{
    [self prepareSyncStatuses:fingerprints];
    if (!isStarted)
    {
        isStarted = YES;
        devices = [NSMutableArray new];
        [self addWaitingDevices];
        if ([listener respondsToSelector:@selector(deviceSyncWillStart)])
            [listener deviceSyncWillStart];
        [[Logger currentLog] writeWithObject:self selector:_cmd text:@"Started" logLevel:DEBUG_L];
        [self prepareToWork];
        if (!devices.isEmpty || processingDevice != nil)
            [self performActionAfter:ACTION_TIMEOUT];
        else
            [self stop];
    }
    else
        [self addWaitingDevices];
}

-(void)stop
{
    if (isStarted)
    {
        [self prepareToStop];
        isStarted = NO;
        [[Logger currentLog] writeWithObject:self selector:_cmd text:@"Stopped" logLevel:DEBUG_L];
    }
}

-(void)deinit
{
    [self stop];
    scheduleStorage = nil;
    deviceStorage = nil;
    deviceStatusStorage = nil;
    listener = nil;
}

-(void)clearOldLogs
{
    NSInteger currentTimestamp = [NSDate date].timeIntervalSince1970;
    NSInteger time = currentTimestamp - SECOND_IN_ONE_DAY * SYNC_LOGS_DAYS_MAX;
    [deviceOperationLogStorage clearByTimestamp:time];
}

#pragma mark - Private Methods
-(void)prepareSyncStatuses:(NSArray<NSString*>*)fingerprints
{
    NSArray *tempDevices = [deviceStorage getDevicesByFingerprints:fingerprints];
    NSMutableArray *syncStatuses = [NSMutableArray new];
    for (Device *device in tempDevices)
    {
        if (device.syncStatus == nil || device.syncStatus.processing == SYNCED || device.syncStatus.processing == END_SYNC || device.syncStatus.processing == ERROR_SYNC)
        {
            DeviceSyncStatus *item = [DeviceSyncStatus new];
            item.lastTimestamp = [NSDate date].timeIntervalSince1970;
            item.fingerprint = device.fingerprint;
            item.processing = WAITING_SYNC;
            item.message = @"WAITING...";
            [syncStatuses addObject:item];
            [deviceStorage setSyncStatus:item];
        }
    }
    if (!syncStatuses.isEmpty)
    {
        [deviceStatusStorage updateItems:syncStatuses];
        [[UploadFileStatusesTable new] updateFlag:NO code:0 fingerprints:[syncStatuses valueForKey:pNameForClass(DeviceSyncStatus, fingerprint)]];
    }
}

-(void)addWaitingDevices
{
    NSArray *localDevices = [deviceStorage getLocalDevices];
    for (Device *device in localDevices)
    {
        if ((device.syncStatus != nil) && (device.syncStatus.processing == WAITING_SYNC))
            [devices addObject:device];
    }
}

-(void)prepareToWork
{
    if (queue == nil)
        queue = dispatch_queue_create("device.integrator", NULL);
    [self prepareFolders];
    status = [DeviceActionStatus new];
    actions = [NSMutableArray new];
    deviceOperationLogStorage = [DeviceOperationLogsTable new];
    [self addActions];
    [self prepareDataForTheNextCycle];
}

-(void)prepareToStop
{
    [devices removeAllObjects];
    devices = nil;
    processingDevice = nil;
    deviceConnectionData = nil;
    deviceOperationLogStorage = nil;
    [self removeActions];
    actions = nil;
    actionIndex = 0;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [status clear];
    status = nil;
}

-(void)prepareFolders
{
    [AppInfromation createPathIfNeed:EI_OS_LOGS_FOLDER_NAME];
}

-(void)addActions
{
    [[Logger currentLog] writeWithObject:self selector:_cmd text:@"" logLevel:DEBUG_L];
    [actions addObject:[UploadSchedulesAction build:self
                                    scheduleStorage:scheduleStorage
                                uploadStatusStorage:[UploadFileStatusesTable new]
                                    fileInfoStorage:[ScheduleFilesTable new]]];
    [actions addObject:[UploadApplicationsAction build:self
                                    applicationStorage:[ApplicationsTable new]
                                   uploadStatusStorage:[UploadFileStatusesTable new]
                                       fileInfoStorage:[ApplicationFilesTable new]]];
    [actions addObject:[DownloadLogsAction build:self
                                 fileInfoStorage:[LogFilesTable new]
                           downloadStatusStorage:[DownloadFileStatusesTable new]
                             uploadStatusStorage:[UploadFileStatusesTable new]
                                            path:EI_OS_LOGS_FOLDER_NAME]];
  }

-(void)removeActions
{
    [[Logger currentLog] writeWithObject:self selector:_cmd text:@"" logLevel:DEBUG_L];
    if ([actions isValidIndex:actionIndex])
    {
        id <DeviceActionInterface> action = actions[actionIndex];
        [action cancel];
    }
    [actions removeAllObjects];
    actionIndex = 0;
}

-(void)prepareDataForTheNextCycle
{
    actionIndex = 0;
    processingDevice = nil;
    [status clear];
    if (!devices.isEmpty)
    {
        processingDevice = devices.firstObject;
        [devices removeObjectAtIndex:0];
        
        NSString *host = processingDevice.host;
        if (processingDevice.address != nil && !processingDevice.address.isEmpty)
            host = processingDevice.address;
        deviceConnectionData = [ConnectionData createWithScheme:HTTP_KEY
                                                           host:host
                                                           port:processingDevice.port
                                                           path:CentralMethod.dasJsonPHP];
        [listener deviceSyncWillStartFor:processingDevice.fingerprint];
    }
}

-(id<DeviceActionInterface>)getNextAction
{
    id <DeviceActionInterface> action = nil;
    if ([actions isValidIndex:actionIndex])
        action = actions[actionIndex];
    return action;
}

-(void)performAction
{
    [[Logger currentLog] writeWithObject:self selector:_cmd text:@"" logLevel:DEBUG_L];
    id <DeviceActionInterface> action = [self getNextAction];
    if (action != nil)
    {
        [action setDevice:processingDevice byConnectionData:deviceConnectionData];
        status.actionIndex = actionIndex;
        NSString *logMessage = [NSString stringWithFormat:@"Action progress title: %tu", [status getProgressTitle]];
        [[Logger currentLog] writeWithObject:self selector:_cmd text:logMessage logLevel:DEBUG_L];
        dispatch_sync(dispatch_get_main_queue(), ^
        {
            [action do:^(ActionResult *result)
            {
                [[Logger currentLog] writeWithObject:self selector:_cmd text:@"Processing action complete" logLevel:DEBUG_L];
                [self refreshStatus:result];
                [self actionCompletion];
            }];
        });
    }
    else
        [self completeTheCycleOfActions];
}

-(void)actionCompletion
{
    [[Logger currentLog] writeWithObject:self selector:_cmd text:@"" logLevel:DEBUG_L];
    if (status.errorText == nil)
    {
        actionIndex++;
        status.actionIndex = actionIndex;
        [listener deviceSyncChangeProgress:status.progress withMessage:[status getProgressTitle] fingerprint:processingDevice.fingerprint];
        [self performActionAfter:ACTION_TIMEOUT];
    }
    else
    {
        [listener deviceSyncError:status.errorText fingerprint:processingDevice.fingerprint];
        [self refreshStatus:nil];
        [self performActionAfter:RETRY_ERROR_TIMEOUT];
    }
}

-(void)refreshStatus:(ActionResult*)result
{
    status.errorText = result.error;
    status.info = result.data;
    [status setProgress:100];
}

-(void)performActionAfter:(NSInteger)seconds
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), queue, ^
    {
        [self performAction];
        if (processingDevice != nil)
        {
            dispatch_sync(dispatch_get_main_queue(), ^
            {
                [listener deviceSyncChangeProgress:status.progress withMessage:[status getProgressTitle] fingerprint:processingDevice.fingerprint];
            });
        }
    });
}

-(void)completeTheCycleOfActions
{
    dispatch_sync(dispatch_get_main_queue(), ^
    {
        [listener deviceSyncDidEnd:processingDevice.fingerprint];
        [self prepareDataForTheNextCycle];
        if (processingDevice == nil)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
            {
                [self stop];
            });
            if ([listener respondsToSelector:@selector(deviceSyncDidEnd)])
                [listener deviceSyncDidEnd];
        }
        else
            [self performActionAfter:ACTION_TIMEOUT];
    });
}

#pragma mark - ActionListener
-(void)actionReport:(CGFloat)progress error:(NSString*)error description:(NSString*)desc
{
    [status setProgress:progress];
    NSString *logMessage = [NSString stringWithFormat:@"Action sync progress: %f, action progress: %f, desc: %@", progress, status.progress, desc];
    [[Logger currentLog] writeWithObject:self selector:_cmd text:logMessage logLevel:DEBUG_L];
    [self writeDeviceOperationLog:[status getProgressTitle] error:error desc:desc fingerprint:processingDevice.fingerprint];
}

#pragma mark - Log Methods
-(void)writeDeviceOperationLog:(NSString*)title error:(NSString*)error desc:(NSString*)desc fingerprint:(NSString*)fingerprint
{
    DeviceOperationLog *deviceOperationLog = [DeviceOperationLog build:title code:0 errorMessage:error desc:desc fingerprint:fingerprint];
    [deviceOperationLogStorage add:deviceOperationLog];
}

@end
