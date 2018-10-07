//
//  UploadSchedulesAction.h
//  EiController
//
//  Created by Genrih Korenujenko on 02.01.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#import "DeviceActionInterface.h"
#import "EDeviceActionType.h"
#import "ScheduleStorageInterface.h"
#import "UploadFileStatusStorageInterface.h"
#import "FileInfoStorageInterface.h"
#import "ScheduleFile.h"

@interface UploadSchedulesAction : NSObject <DeviceActionInterface>
{
    Completion completion;
    id <TransferInterface> transfer;
    Device *currentDevice;
    Schedule *schedule;
    NSMutableArray *files;
    ScheduleFile *currentFile;
    NSInteger tryingCounter;
    ConnectionData *connectionData;
    dispatch_block_t block;
}
@property (nonatomic, readwrite, weak) id <ActionListener> listener;
@property (nonatomic, readwrite, strong) id <ScheduleStorageInterface> scheduleStorage;
@property (nonatomic, readwrite, strong) id <UploadFileStatusStorageInterface> uploadStatusStorage;
@property (nonatomic, readwrite, strong) id <FileInfoStorageInterface> fileInfoStorage;

+(instancetype)build:(id<ActionListener>)listener
     scheduleStorage:(id<ScheduleStorageInterface>)scheduleStorage
 uploadStatusStorage:(id<UploadFileStatusStorageInterface>)uploadStatusStorage
     fileInfoStorage:(id<FileInfoStorageInterface>)fileInfoStorage;

@end
