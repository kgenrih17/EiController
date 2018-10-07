//
//  DeviceSyncStatusesStorageInterface.h
//  EiController
//
//  Created by Genrih Korenujenko on 22.01.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#import "StorageInterface.h"
#import "DeviceSyncStatus.h"

@protocol DeviceSyncStatusesStorageInterface <StorageInterface>

@required
-(void)update:(DeviceSyncStatus*)item;
-(void)updateItems:(NSArray<DeviceSyncStatus*>*)items;
-(NSMutableDictionary<NSString*,DeviceSyncStatus*>*)getByFingerprints:(NSArray<NSString*>*)fingerprints;
-(void)removeBy:(NSString*)fingerprint;
-(NSArray<DeviceSyncStatus*>*)getWithProgressWaitingAndSync;

@end
