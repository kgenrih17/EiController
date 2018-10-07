//
//  UploadApplicationsAction.h
//  EiController
//
//  Created by Genrih Korenujenko on 24.01.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#import "DeviceActionInterface.h"
#import "EDeviceActionType.h"
#import "ApplicationStorageInterface.h"
#import "FileInfoStorageInterface.h"
#import "UploadFileStatusStorageInterface.h"
#import "ApplicationFile.h"

@interface UploadApplicationsAction : NSObject <DeviceActionInterface>
{
    Completion completion;
    id <TransferInterface> transfer;
    Device *currentDevice;
    Application *application;
    NSMutableArray *files;
    ApplicationFile *currentFile;
    NSInteger tryingCounter;
    ConnectionData *connectionData;
    dispatch_block_t block;
}
@property (nonatomic, readwrite, weak) id <ActionListener> listener;
@property (nonatomic, readwrite, strong) id <ApplicationStorageInterface> applicationStorage;
@property (nonatomic, readwrite, strong) id <UploadFileStatusStorageInterface> uploadStatusStorage;
@property (nonatomic, readwrite, strong) id <FileInfoStorageInterface> fileInfoStorage;

+(instancetype)build:(id<ActionListener>)listener
  applicationStorage:(id<ApplicationStorageInterface>)applicationStorage
 uploadStatusStorage:(id<UploadFileStatusStorageInterface>)uploadStatusStorage
     fileInfoStorage:(id<FileInfoStorageInterface>)fileInfoStorage;

@end
