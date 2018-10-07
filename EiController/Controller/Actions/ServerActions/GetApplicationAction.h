//
//  GetApplicationAction.h
//  EiController
//
//  Created by Genrih Korenujenko on 20.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "ActionInterface.h"
#import "PublisherAPIInterface.h"
#import "FileInfoStorageInterface.h"
#import "ApplicationStorageInterface.h"
#import "DownloadFileStatusStorageInterface.h"
#import "UploadFileStatusStorageInterface.h"
#import "Application.h"
#import "ApplicationFile.h"
#import "EiController-Swift.h"

@interface GetApplicationAction : NSObject <ActionInterface>
{
    NSMutableArray <NSString*> *fingerprints;
    NSString *fingerprint;
    NSMutableArray <NSDictionary*> *fileInfos;
    NSDictionary *fileInfo;
    NSMutableArray *files;
    NSInteger rapeatCounter;
    NSString *pathToDocument;
    NSString *sessionToken;
    dispatch_block_t block;
}

@property (nonatomic, readonly, strong) GetApplicationValidator *validator;
@property (nonatomic, readwrite, weak) id <PublisherAPIInterface> api;
@property (nonatomic, readwrite, weak) id <INodeStorage> deviceStorage;
@property (nonatomic, readwrite, weak) id <ActionListener> listener;
@property (nonatomic, readwrite, strong) id <ApplicationStorageInterface> applicationStorage;
@property (nonatomic, readwrite, strong) id <FileInfoStorageInterface> fileInfoStorage;
@property (nonatomic, readwrite, strong) id <DownloadFileStatusStorageInterface> downloadStatusStorage;
@property (nonatomic, readwrite, strong) id <UploadFileStatusStorageInterface> uploadStatusStorage;
@property (nonatomic, readwrite, strong) Completion completion;
@property (nonatomic, readwrite, strong) NSString *folder;

+(instancetype)build:(id<PublisherAPIInterface>)api
       deviceStorage:(id<INodeStorage>)deviceStorage
  applicationStorage:(id<ApplicationStorageInterface>)applicationStorage
     fileInfoStorage:(id<FileInfoStorageInterface>)fileInfoStorage
downloadStatusStorage:(id<DownloadFileStatusStorageInterface>)downloadStatusStorage
 uploadStatusStorage:(id<UploadFileStatusStorageInterface>)uploadStatusStorage
            listener:(id<ActionListener>)listener
              folder:(NSString*)folder;

@end
