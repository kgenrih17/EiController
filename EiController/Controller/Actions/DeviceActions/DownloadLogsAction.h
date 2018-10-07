//
//  DownloadLogsAction.h
//  EiController
//
//  Created by Genrih Korenujenko on 02.01.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#import "DeviceActionInterface.h"
#import "EDeviceActionType.h"
#import "FileInfoStorageInterface.h"
#import "DownloadFileStatusStorageInterface.h"
#import "UploadFileStatusStorageInterface.h"
#import "LogFile.h"

@interface DownloadLogsAction : NSObject <DeviceActionInterface>
{
    Completion completion;
    id <TransferInterface> transfer;
    Device *currentDevice;
    NSMutableArray *files;
    NSMutableArray *downloadedFiles;
    NSString *currentFile;
    NSString *fullPath;
    ConnectionData *connectionData;
    dispatch_block_t block;
}

@property (nonatomic, readwrite, weak) id <ActionListener> listener;
@property (nonatomic, readwrite, strong) id <FileInfoStorageInterface> fileInfoStorage;
@property (nonatomic, readwrite, strong) id <DownloadFileStatusStorageInterface> downloadStatusStorage;
@property (nonatomic, readwrite, strong) id <UploadFileStatusStorageInterface> uploadStatusStorage;
@property (nonatomic, readwrite, copy) NSString *localPath;

+(instancetype)build:(id<ActionListener>)listener
     fileInfoStorage:(id<FileInfoStorageInterface>)fileInfoStorage
downloadStatusStorage:(id<DownloadFileStatusStorageInterface>)downloadStatusStorage
 uploadStatusStorage:(id<UploadFileStatusStorageInterface>)uploadStatusStorage
                path:(NSString*)path;

@end
