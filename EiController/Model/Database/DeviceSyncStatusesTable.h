//
//  OSSyncStatuses.h
//  EiController
//
//  Created by Genrih Korenujenko on 25.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "DatabaseTableInterface.h"
#import "DeviceSyncStatusesStorageInterface.h"
#import "DeviceSyncStatus.h"

@interface DeviceSyncStatusesTable : NSObject <DatabaseTableInterface, DeviceSyncStatusesStorageInterface>

-(NSMutableArray<DeviceSyncStatus*>*)getAll;
-(DeviceSyncStatus*)getByFingerprint:(NSString*)fingerprint;

@end
