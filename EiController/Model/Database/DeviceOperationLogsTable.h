//
//  DeviceOperationLogsTable.h
//  EiController
//
//  Created by Genrih Korenujenko on 26.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "DatabaseTableInterface.h"
#import "IDeviceOperationLogStorage.h"
#import "DeviceOperationLog.h"

@interface DeviceOperationLogsTable : NSObject <DatabaseTableInterface, IDeviceOperationLogStorage>

-(NSMutableArray<DeviceOperationLog*>*)getAll;
-(void)remove:(DeviceOperationLog*)item;

@end
