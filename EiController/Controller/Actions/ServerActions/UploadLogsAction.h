//
//  UploadFilesAction.h
//  EiController
//
//  Created by Genrih Korenujenko on 20.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "ActionInterface.h"
#import "TransferInterface.h"
#import "FileInfoStorageInterface.h"
#import "UploadFileStatusStorageInterface.h"

@interface UploadLogsAction : NSObject <ActionInterface, TransferListener>
{
    NSMutableArray *files;
    id <FileInfoInterface> currentFile;
    NSString *pathToDocuments;
    Completion completion;
    dispatch_block_t block;
}
@property (nonatomic, readwrite, weak) id <ActionListener> listener;
@property (nonatomic, readwrite, weak) ConnectionData *connectionData;
@property (nonatomic, readwrite, strong) id <TransferInterface> transfer;
@property (nonatomic, readwrite, strong) id <FileInfoStorageInterface> fileStorage;
@property (nonatomic, readwrite, strong) id <UploadFileStatusStorageInterface> uploadStatusStorage;

+(instancetype)build:(id<ActionListener>)listener
      connectionData:(ConnectionData*)connectionData
            transfer:(id<TransferInterface>)transfer
         fileStorage:(id<FileInfoStorageInterface>)fileStorage
 uploadStatusStorage:(id<UploadFileStatusStorageInterface>)uploadStatusStorage;

@end
