//
//  DevicesStorageInterface.h
//  EiController
//
//  Created by Genrih Korenujenko on 13.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

//#import "StorageInterface.h"
//#import "DevicesStorageObserverInterface.h"
//#import "StorageCleanerInterface.h"
//#import "DeviceSyncStatus.h"
//
//@protocol DevicesStorageInterface <StorageInterface>
//
//@property (nonatomic, readwrite, weak) id <StorageCleanerInterface> storageCleaner;
//
//@required
//+(instancetype)build:(id<StorageCleanerInterface>)storageCleaner;
//-(void)load;
//
//-(void)addObserver:(id<DevicesStorageObserverInterface>)observerInterface;
//-(void)removeObserver:(id<DevicesStorageObserverInterface>)observerInterface;
//-(void)removeAllObservers;
//
//-(NSMutableArray<NSString*>*)getCentralFingerprints;
//-(NSArray<Device*>*)getDevicesByFingerprints:(NSArray<NSString*>*)fingerprints;
//-(Device*)getDeviceByFingerprint:(NSString*)fingerprint;
//-(NSArray<Device*>*)getCentralDevices;
//-(NSArray<Device*>*)getLocalDevices;
//-(NSMutableDictionary<NSString*,Device*>*)getLiveDevices;
//-(NSMutableDictionary<NSString*,Device*>*)getNodes;
//-(NSMutableDictionary<NSString*,Device*>*)getControllers;
//-(NSMutableDictionary<NSString*,Device*>*)getNotSuported;
//
//-(void)setCentralDevices:(NSArray<Device*>*)devices;
//-(void)setLocalDevices:(NSArray<Device*>*)devices;
//-(void)setLiveDevices:(NSMutableDictionary<NSString*,Device*>*)devices;
//-(void)setSyncStatus:(DeviceSyncStatus*)syncStatus forFingerprint:(NSString*)fingerprint;
//
/////
//-(void)removeData:(NSString*)fingerprint;
//
//@end
