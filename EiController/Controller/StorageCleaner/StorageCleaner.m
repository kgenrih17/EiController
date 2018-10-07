//
//  AppDataCleaner.m
//  EiController
//
//  Created by Genrih Korenujenko on 25.01.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#import "StorageCleaner.h"

/// Storages
#import "ScheduleStorage.h"
#import "ScheduleFilesTable.h"
#import "ApplicationsTable.h"
#import "ApplicationFilesTable.h"
#import "DownloadFileStatusesTable.h"
#import "UploadFileStatusesTable.h"
#import "ServerLogsTable.h"
#import "DeviceOperationLogsTable.h"
#import "LogFilesTable.h"

#import "DeviceSyncStatusesTable.h"

#import "EiController-Swift.h"

@interface StorageCleaner ()
{
    ScheduleStorage *scheduleStorage;
    ScheduleFilesTable *scheduleFilesStorage;
    ApplicationsTable *applicationStorage;
    ApplicationFilesTable *applicationFileStorage;
    DownloadFileStatusesTable *downloadFileStatusStorage;
    UploadFileStatusesTable *uploadFileStatusStorage;
    ServerLogsTable *serverLogStorage;
    DeviceOperationLogsTable *deviceOperationLogsTable;
    LogFilesTable *logFileStorage;
    DeviceSyncStatusesTable *deviceSyncStatusesStorage;
    NodeStorage *nodeStorage;
}
@end

@implementation StorageCleaner

#pragma mark - Init
-(void)initStorages
{
    scheduleStorage = [ScheduleStorage new];
    scheduleFilesStorage = [ScheduleFilesTable new];
    applicationStorage = [ApplicationsTable new];
    applicationFileStorage = [ApplicationFilesTable new];
    downloadFileStatusStorage = [DownloadFileStatusesTable new];
    uploadFileStatusStorage = [UploadFileStatusesTable new];
    serverLogStorage = [ServerLogsTable new];
    deviceOperationLogsTable = [DeviceOperationLogsTable new];
    logFileStorage = [LogFilesTable new];
    deviceSyncStatusesStorage = [DeviceSyncStatusesTable new];
    nodeStorage = [NodeStorage new];
}

-(void)deinitStorages
{
    scheduleFilesStorage = nil;
    applicationFileStorage = nil;
}

#pragma mark - Public Methods
-(void)clearDataForNewSchedule:(NSString*)fingerprint
{
    [self initStorages];
    [self clearDeviceContent:fingerprint];
    NSMutableArray <id<FileInfoInterface>> *filesForDelete = [self getDeviceFilesForDelete:fingerprint];
    [self removeFiles:[filesForDelete valueForKey:pNameForProtocol(FileInfoInterface, localPath)]];
    [self deinitStorages];
}

-(void)clearAllData
{
    [self initStorages];
    [scheduleStorage clear];
    [scheduleFilesStorage clear];
    [applicationStorage clear];
    [applicationFileStorage clear];
    [downloadFileStatusStorage clear];
    [uploadFileStatusStorage clear];
    [serverLogStorage clear];
    [deviceOperationLogsTable clear];
    [logFileStorage clear];
    [deviceSyncStatusesStorage clear];
    [nodeStorage clear];
    [self deinitStorages];
}

-(void)clearUnnecessaryDeviceData:(NSArray<NSString*>*)fingerprints
{
    [self initStorages];
    NSMutableArray <id<FileInfoInterface>> *filesForDelete = [NSMutableArray new];

    for (NSString *fingerprint in fingerprints)
    {
        [[Logger currentLog] writeWithObject:self selector:_cmd text:fingerprint logLevel:DEBUG_L];
        [nodeStorage removeData:fingerprint];
        [logFileStorage removeBy:fingerprint];
        [deviceOperationLogsTable removeByFingerping:fingerprint];
        [self clearDeviceContent:fingerprint];
        [filesForDelete addObjectsFromArray:[self getDeviceFilesForDelete:fingerprint]];
    }
    [self removeFiles:[filesForDelete valueForKey:pNameForProtocol(FileInfoInterface, localPath)]];
    [self deinitStorages];
}

#pragma mark - Private Methods
-(void)removeFiles:(NSArray<NSString*>*)paths
{
    NSString *pathToDocuments = [AppInfromation getPathToDocuments];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    for (NSString *path in paths)
        [fileManager removeItemAtPath:[pathToDocuments stringByAppendingPathComponent:path] error:nil];
}

-(void)clearDeviceContent:(NSString*)fingerprint
{
    [scheduleStorage removeBy:fingerprint];
    [applicationStorage removeBy:fingerprint];
    [downloadFileStatusStorage removeBy:fingerprint];
    [uploadFileStatusStorage removeBy:fingerprint];
    [deviceSyncStatusesStorage removeBy:fingerprint];
}

-(NSMutableArray<id<FileInfoInterface>>*)getDeviceFilesForDelete:(NSString*)fingerprint
{
    NSMutableArray <id<FileInfoInterface>> *filesForDelete = [NSMutableArray new];
    [filesForDelete addObjectsFromArray:[self getScheduleFilesForDelete:fingerprint]];
    [filesForDelete addObjectsFromArray:[self getApplicationFilesForDelete:fingerprint]];
    return filesForDelete;
}

-(NSArray*)getScheduleFilesForDelete:(NSString*)fingerprint
{
    NSArray *dublicatePointers = [scheduleFilesStorage getDuplicatePointers:fingerprint];
    NSMutableArray *scheduleFilesForDelete = [scheduleFilesStorage getBy:fingerprint];
    [scheduleFilesStorage removeItems:scheduleFilesForDelete];
    [scheduleFilesForDelete removeObjectsInArray:dublicatePointers];
    return scheduleFilesForDelete;
}

-(NSArray*)getApplicationFilesForDelete:(NSString*)fingerprint
{
    NSArray *dublicatePointers = [applicationFileStorage getDuplicatePointers:fingerprint];
    NSMutableArray *applicationFilesForDelete = [applicationFileStorage getBy:fingerprint];
    [applicationFileStorage removeItems:applicationFilesForDelete];
    [applicationFilesForDelete removeObjectsInArray:dublicatePointers];
    return applicationFilesForDelete;
}

@end
