//
//  GetFilesInfoAction.h
//  EiController
//
//  Created by Genrih Korenujenko on 20.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "ActionInterface.h"
#import "CentralAPIInterface.h"
#import "ScheduleStorageInterface.h"
#import "DownloadFileStatusStorageInterface.h"
#import "FileInfoStorageInterface.h"
#import "ScheduleFile.h"
#import "StorageCleaner.h"
#import "EiController-Swift.h"

@interface GetScheduleAction : NSObject <ActionInterface>
{
    NSMutableArray <NSString*> *fingerprints;
    NSString *fingerprint;
    dispatch_block_t block;
    
    StorageCleaner *cleaner;
}

@property (nonatomic, readonly, strong) GetScheduleValidator *validator;
@property (nonatomic, readwrite, weak) id <CentralAPIInterface> api;
@property (nonatomic, readwrite, weak) id <ActionListener> listener;
@property (nonatomic, readwrite, strong) id <ScheduleStorageInterface> storage;
@property (nonatomic, readwrite, strong) id <INodeStorage> devicesStorage;
@property (nonatomic, readwrite, strong) id <DownloadFileStatusStorageInterface> fileStatusStorage;
@property (nonatomic, readwrite, strong) id <FileInfoStorageInterface> scheduleFilesStorage;
@property (nonatomic, readwrite, strong) Completion completion;

+(instancetype)build:(id<ActionListener>)listener
                 api:(id<CentralAPIInterface>)api
             storage:(id<ScheduleStorageInterface>)storage
      devicesStorage:(id<INodeStorage>)devicesStorage
   fileStatusStorage:(id<DownloadFileStatusStorageInterface>)fileStatusStorage
scheduleFilesStorage:(id<FileInfoStorageInterface>)scheduleFilesStorage;

@end
