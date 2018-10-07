//
//  UploadSchedulesAction.m
//  EiController
//
//  Created by Genrih Korenujenko on 02.01.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#import "UploadSchedulesAction.h"
#import "HTTPTransfer.h"
#import "CentralMethod.h"

@implementation UploadSchedulesAction

@synthesize listener;
@synthesize scheduleStorage;
@synthesize uploadStatusStorage;
@synthesize fileInfoStorage;

#pragma mark - Public Init Methods
+(instancetype)build:(id<ActionListener>)listener
     scheduleStorage:(id<ScheduleStorageInterface>)scheduleStorage
 uploadStatusStorage:(id<UploadFileStatusStorageInterface>)uploadStatusStorage
     fileInfoStorage:(id<FileInfoStorageInterface>)fileInfoStorage
{
    UploadSchedulesAction *result = [UploadSchedulesAction new];
    result.listener = listener;
    result.scheduleStorage = scheduleStorage;
    result.uploadStatusStorage = uploadStatusStorage;
    result.fileInfoStorage = fileInfoStorage;
    return result;
}

#pragma mark - DeviceActionInterface
-(void)setDevice:(Device*)device byConnectionData:(ConnectionData*)newConnectionData
{
    currentDevice = device;
    connectionData = newConnectionData;
}


-(void)do:(Completion)aCompletion
{
    tryingCounter = 0;
    completion = aCompletion;
    transfer = [HTTPTransfer build:self settings:nil];
    files = [fileInfoStorage getNotUpload:currentDevice.fingerprint];
    if (files.isEmpty)
        [self notifListener:100 error:nil desc:@"No schedules to send"];
    [self transferFiles];
}

-(void)cancel
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    if (block)
        dispatch_block_cancel(block);
    [transfer cancel];
    [self clearCache];
    [self notifListener:100.0 error:[ErrorDescription getError:PROCESS_CANCELED] desc:@"Canceled"];
    listener = nil;
    completion = nil;
}

-(void)transferProgress:(CGFloat)progress
{
    NSString *desc = [NSString stringWithFormat:@"%.0f upload: %@", progress * 100.0, currentFile.localPath.lastPathComponent];
    [[Logger currentLog] writeWithObject:self selector:_cmd text:desc logLevel:DEBUG_L];
}

#pragma mark - Private Methods
-(void)transferFiles
{
    if (!files.isEmpty)
    {
        currentFile = files.firstObject;
        [files removeObjectAtIndex:0];
        transfer.settings = [self prepareFileTransferInfo:currentFile];
        [self uploadFile];
    }
    else
    {
        schedule = [scheduleStorage getByFingerprint:currentDevice.fingerprint];
        block = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, ^{
            [self transferSchedule];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(REQUEST_TIMEOUT * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
    }
}

-(void)uploadFile
{
    [transfer upload:^(TransferResult *result)
    {
        if (result.error == nil)
        {
            [self parseUploadFile:result];
        }
        else if (tryingCounter < MAX_TRY_COUNT)
        {
            tryingCounter++;
            block = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, ^{
                transfer.settings = [self prepareFileTransferInfo:currentFile];
                [self uploadFile];
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(WAITING_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
        }
        else
        {
            [self updateUploadStatus:result.error];
            NSString *desc = [NSString stringWithFormat:@"Upload failed: %@ by unique: %@", result.error, currentFile.unique];
            [self notifListener:100.0 error:result.error desc:desc];
            [self completion:result];
        }
    }];
}

-(void)parseUploadFile:(TransferResult*)result
{
    NSString *desc = [NSString stringWithFormat:@"Uploaded file: %@", currentFile.fileUrl.lastPathComponent];
    [self notifListener:100.0 error:result.error desc:desc];
    tryingCounter = 0;
    [self updateUploadStatus:nil];
    currentFile = nil;
    block = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, ^{
        [self transferFiles];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(REQUEST_TIMEOUT * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}

-(void)transferSchedule
{
    if (schedule != nil)
    {
        transfer.settings = [self prepareScheduleTransferInfo:schedule];
        [transfer upload:^(TransferResult *result)
        {
            NSString *desc = nil;
            if (result.error == nil)
                desc = @"Uploaded schedule data";
            else
                desc = [NSString stringWithFormat:@"Upload schedule data failed: %@", result.error];
            [self notifListener:100.0 error:result.error desc:desc];
            [self completion:result];
        }];
    }
    else
    {
        TransferResult *result = [TransferResult build:nil data:nil];
        [self notifListener:100.0 error:result.error desc:@"Schedule is absent"];
        [self completion:result];
    }
}

-(TransferInfo*)prepareFileTransferInfo:(ScheduleFile*)file
{
    NSDictionary *data = @{@"file_url" : file.fileUrl,
                           @"es_id" : file.esID,
                           @"unique" : file.unique,
                           @"md5" : file.md5};
    
    TransferInfo *transferInfo = [TransferInfo new];
    transferInfo.address = [connectionData.urlString stringByAppendingString:EiOSMethod.uploadMedia];
    transferInfo.pathToFile = [[AppInfromation getPathToDocuments] stringByAppendingPathComponent:file.localPath];
    transferInfo.parameters = @{@"fingerprint" : [EiControllerSysInfo getUdid],
                                @"data" : [data.json stringByReplacingOccurrencesOfString:@"\n" withString:@""]};
    return transferInfo;
}

-(TransferInfo*)prepareScheduleTransferInfo:(Schedule*)item
{
    TransferInfo *transferInfo = [TransferInfo new];
    transferInfo.address = [connectionData.urlString stringByAppendingString:EiOSMethod.applyScheduleData];
    transferInfo.pathToFile = nil;
    transferInfo.parameters = @{@"fingerprint" : [EiControllerSysInfo getUdid],
                                @"data" : item.details};
    return transferInfo;
}

-(void)updateUploadStatus:(NSString*)error
{
    BOOL isSuccess = (error == nil);
    NSInteger code = isSuccess ? 0 : UPLOAD_FILE_ERROR;
    [uploadStatusStorage updateFlag:isSuccess code:code byFileId:currentFile.unique fingerprint:currentFile.fingerprint];
}

-(void)notifListener:(CGFloat)progress error:(NSString*)error desc:(NSString*)desc
{
    NSMutableString *fullDesc = [NSMutableString stringWithString:desc];
    CGFloat percent = [self calculateProgress:progress];
    [listener actionReport:percent error:error description:fullDesc];
}

-(CGFloat)calculateProgress:(CGFloat)progress
{
    NSInteger fileCount = files.count + 1;
    CGFloat partOfProgress = 100.0 / fileCount;
    CGFloat result = partOfProgress / 100.0 * progress;
    return result;
}

-(void)completion:(TransferResult*)result
{
    block = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, ^{
        [self clearCache];
        completion([ActionResult build:result.error data:nil]);
        completion = nil;
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}

-(void)clearCache
{
    transfer = nil;
    currentDevice = nil;
    schedule = nil;
    files = nil;
    currentFile = nil;
}

@end
