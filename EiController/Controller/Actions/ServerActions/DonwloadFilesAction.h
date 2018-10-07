//
//  DonwloadFilesAction.h
//  EiController
//
//  Created by Genrih Korenujenko on 20.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "ActionInterface.h"
#import "FileInfoStorageInterface.h"
#import "DownloadFileStatusStorageInterface.h"
#import "UploadFileStatusStorageInterface.h"

@interface DonwloadFilesAction : NSObject <ActionInterface, FileDownloaderDelegate> 
{
    NSMutableArray <id<FileInfoInterface>> *files;
    id<FileInfoInterface> currentFile;
    NSString *fullPath;
    FileDownloader *fileDownloader;
    Completion completion;
    dispatch_block_t block;
}
@property (nonatomic, readwrite, weak) id <ActionListener> listener;
@property (nonatomic, readwrite, strong) ConnectionData *connectionData;
@property (nonatomic, readwrite, strong) id <FileInfoStorageInterface> storage;
@property (nonatomic, readwrite, strong) id <DownloadFileStatusStorageInterface> downloadStatusStorage;
@property (nonatomic, readwrite, strong) id <UploadFileStatusStorageInterface> uploadStatusStorage;
@property (nonatomic, readwrite, copy) NSString *localPath;

+(instancetype)build:(id<ActionListener>)listener
      connectionData:(ConnectionData*)connectionData
             storage:(id<FileInfoStorageInterface>)storage
downloadStatusStorage:(id<DownloadFileStatusStorageInterface>)downloadStatusStorage
 uploadStatusStorage:(id<UploadFileStatusStorageInterface>)uploadStatusStorage
                path:(NSString*)path;

@end
