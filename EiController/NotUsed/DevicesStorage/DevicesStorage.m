//
//  DevicesStorage.m
//  EiController
//
//  Created by admin on 9/30/16.
//  Copyright © 2016 RadicalComputing. All rights reserved.
//

//#import "DevicesStorage.h"
//#import "DevicesTable.h"
//#import "DeviceSyncStatusesTable.h"
////#import "EiController-Swift.h"
//
//static NSString * const SUPPORTED_VERSION_4_0_2 = @"4.0.2";
//static NSString * const SUPPORTED_VERSION_4_0_0_P1 = @"4.0.0.p1";
//
//@interface DevicesStorage ()
//{
//    NSMutableArray <id<DevicesStorageObserverInterface>> *observers;
//
//    NSMutableDictionary *userDevices; // fingerprint - object Device
//    NSMutableArray <Device*> *centralDevices;
//    NSMutableArray <Device*> *localDevices;
//
//    DevicesTable *table;
//    DeviceSyncStatusesTable *syncStatusesTable;
//}
//@end
//
//@implementation DevicesStorage
//
//@synthesize storageCleaner;

//#pragma mark - Public Init Methods
//+(instancetype)build:(id<StorageCleanerInterface>)storageCleaner
//{
//    DevicesStorage *result = [self new];
//    result.storageCleaner = storageCleaner;
//    return result;
//}
//
//#pragma mark - Init
//-(instancetype)init
//{
//    self = [super init];
//
//    if (self)
//    {
//        observers = [NSMutableArray new];
//        localDevices = [NSMutableArray new];
//        centralDevices = [NSMutableArray new];
//        table = [DevicesTable new];
//        syncStatusesTable = [DeviceSyncStatusesTable new];
//    }
//
//    return self;
//}
//
//-(void)dealloc
//{
//    [observers removeAllObjects];
//    observers = nil;
//}
//
//#pragma mark -INodeStorage
//-(void)setLiveDevices:(NSMutableDictionary<NSString*,Device*>*)devices
//{
//    userDevices = devices;
//}
//
//-(NSMutableDictionary<NSString*,Device*>*)getLiveDevices
//{
//    return userDevices;
//}
//
//-(NSMutableDictionary<NSString*,Device*>*)getNodes
//{
//    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(Device *device, NSDictionary<NSString*,id> * bindings)
//    {
//        return [device.version containsString:SUPPORTED_NODE_VERSION_4_0_2];
//        //                if ([device.version containsString:SUPPORTED_NODE_VERSION_4_0_2_X] ||
//        //                    device.version.integerValue >= MIN_SUPPORTED_NODE_VERSION_402)
//        //                    return YES;
//        //                else
//        //                    return NO;
//    }];
//    NSArray *nodeSpecies = [userDevices.allValues filteredArrayUsingPredicate:predicate];
//    NSArray *fingers = [nodeSpecies valueForKey:pNameForClass(Device, fingerprint)];
//    return [NSMutableDictionary dictionaryWithObjects:nodeSpecies forKeys:fingers];
//    return nil;
//}
//
//-(NSMutableDictionary<NSString*,Device*>*)getControllers
//{
////    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(Device *device, NSDictionary<NSString*,id> * bindings)
////                 {
////                     return [device.version containsString:SUPPORTED_CONTROLLER_VERSION_4_0_0_P1];
////                     //                if ([device.version containsString:SUPPORTED_CONTROLLER_VERSION_4_0_0_P1] ||
////                     //                    device.version.integerValue >= MIN_SUPPORTED_CONTROLLER_VERSION_401)
////                     //                    return YES;
////                     //                else
////                     //                    return NO;
////                 }];
////    NSArray *nodeSpecies = [userDevices.allValues filteredArrayUsingPredicate:predicate];
////    NSArray *fingers = [nodeSpecies valueForKey:pNameForClass(Device, fingerprint)];
////    return [NSMutableDictionary dictionaryWithObjects:nodeSpecies forKeys:fingers];
//    return nil;
//}
//
//-(NSMutableDictionary<NSString*,Device*>*)getNotSuported
//{
////    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(Device *device, NSDictionary<NSString*,id> * bindings)
////                 {
////                     return (![device.version containsString:SUPPORTED_NODE_VERSION_4_0_2_X] &&
////                             ![device.version containsString:SUPPORTED_CONTROLLER_VERSION_4_0_0_P1]);
////                 }];
////    NSArray *nodeSpecies = [userDevices.allValues filteredArrayUsingPredicate:predicate];
////    NSArray *fingers = [nodeSpecies valueForKey:pNameForClass(Device, fingerprint)];
////    return [NSMutableDictionary dictionaryWithObjects:nodeSpecies forKeys:fingers];
//    return nil;
//}
//
//-(NSArray<Device*>*)getDevicesByFingerprints:(NSArray<NSString*>*)fingerprints
//{
//    NSArray *filteredDevices = [userDevices objectsForKeys:fingerprints notFoundMarker:[NSNull null]];
//    NSMutableArray *result = [NSMutableArray arrayWithArray:filteredDevices];
//    [result removeObject:[NSNull null]];
//    return result;
//}
//
//-(Device*)getDeviceByFingerprint:(NSString*)fingerprint
//{
//    Device *result = nil;
//    NSArray *devices = [self getDevicesByFingerprints:@[fingerprint]];
//    if (!devices.isEmpty)
//        result = devices.firstObject;
//    return result;
//}
//
//-(void)setSyncStatus:(DeviceSyncStatus*)syncStatus forFingerprint:(NSString*)fingerprint
//{
//    NSMutableArray *allDevices = [NSMutableArray new];
//    [allDevices addObjectsFromArray:centralDevices];
//    [allDevices addObjectsFromArray:localDevices];
//    for (Device *device in allDevices)
//    {
//        if ([device.fingerprint isEqualToString:fingerprint])
//        {
//            syncStatus.fingerprint = fingerprint;
//            device.syncStatus = syncStatus;
//        }
//    }
//}
//
//-(void)clear
//{
//    [userDevices removeAllObjects];
//    [centralDevices removeAllObjects];
//    [localDevices removeAllObjects];
//    [table clear];
//}
//
//-(void)addObserver:(id<DevicesStorageObserverInterface>)observerInterface
//{
//    [observers addObject:observerInterface];
//}
//
//-(void)removeObserver:(id<DevicesStorageObserverInterface>)observerInterface
//{
//    [observers removeObject:observerInterface];
//}
//
//-(void)removeAllObservers
//{
//    [observers removeAllObjects];
//}
//
//-(NSArray<Device*>*)getCentralDevices
//{
//    return centralDevices;
//}
//
//-(NSArray<Device*>*)getLocalDevices
//{
//    return localDevices;
//}
//
//-(void)setCentralDevices:(NSArray<Device*>*)devices
//{
//    NSMutableArray *fingerprintsForDelete = [self prepareFingerprintsForRemove:devices];
//    if (!fingerprintsForDelete.isEmpty)
//        [storageCleaner clearUnnecessaryDeviceData:fingerprintsForDelete];
//
//    if (![devices isEqualToArray:centralDevices])
//    {
//        [table update:devices];
//        [centralDevices removeAllObjects];
//        [centralDevices addObjectsFromArray:devices];
//        [self notifDevicesUpdatedObservers];
//    }
//    else
//        [self notifDevicesNotUpdatedObservers];
//}
//
//-(void)setLocalDevices:(NSArray<Device*>*)devices
//{
//    if (![devices isEqualToArray:localDevices])
//    {
//        [localDevices removeObjectsInArray:devices];
//        [self updateSyncStatusIfNeed:localDevices];
//        [localDevices removeAllObjects];
//        [localDevices addObjectsFromArray:devices];
//        [self notifDevicesUpdatedObservers];
//    }
//    else
//        [self notifDevicesNotUpdatedObservers];
//}
//
//-(NSMutableArray<NSString*>*)getCentralFingerprints
//{
//    return [NSMutableArray arrayWithArray:[centralDevices valueForKey:pNameForClass(Device, fingerprint)]];
//}
//
//-(void)removeData:(NSString*)fingerprint
//{
//    [table removeByFingerprints:@[fingerprint]];
//}
//
//#pragma mark - Public Methods
//-(void)load
//{
//    centralDevices = [table getAll];
//    [self notifDevicesUpdatedObservers];
//}
//
//#pragma mark - Private Methods
//-(void)notifDevicesUpdatedObservers
//{
//    for (id<DevicesStorageObserverInterface> observer in observers)
//        [observer devicesUpdated];
//}
//
//-(void)notifDevicesNotUpdatedObservers
//{
//    for (id<DevicesStorageObserverInterface> observer in observers)
//        [observer devicesNotUpdated];
//}
//
//-(NSMutableArray<NSString*>*)prepareFingerprintsForRemove:(NSArray<Device*>*)newDevices
//{
//    NSMutableArray *newFingerprints = [newDevices valueForKey:pNameForClass(Device, fingerprint)];
//    NSMutableArray *fingerprintsForDelete = [NSMutableArray new];
//    for (Device *device in centralDevices)
//    {
//        if (![newFingerprints containsObject:device.fingerprint])
//            [fingerprintsForDelete addObject:device.fingerprint];
//    }
//    return fingerprintsForDelete;
//}
//
//-(void)updateSyncStatusIfNeed:(NSArray<Device*>*)devices
//{
//    NSMutableArray *fingerprints = [devices valueForKey:pNameForClass(Device, fingerprint)];
//    NSArray *syncStatuses = [syncStatusesTable getByFingerprints:fingerprints].allValues;
//    NSMutableArray *statusesForUpdate = [NSMutableArray new];
//    for (DeviceSyncStatus *syncStatus in syncStatuses)
//    {
//        if (syncStatus.processing == WAITING_SYNC || syncStatus.processing == SYNCHRONIZING)
//        {
//            syncStatus.processing = END_SYNC;
//            syncStatus.message = @"Can't find device locally";
//            [statusesForUpdate addObject:syncStatus];
//        }
//    }
//    if (!statusesForUpdate.isEmpty)
//        [syncStatusesTable updateItems:statusesForUpdate];
//}
//
//@end
