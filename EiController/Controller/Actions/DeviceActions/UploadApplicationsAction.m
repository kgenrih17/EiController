//
//  UploadApplicationsAction.m
//  EiController
//
//  Created by Genrih Korenujenko on 24.01.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#import "UploadApplicationsAction.h"
#import "HTTPTransfer.h"
#import "CentralMethod.h"

@implementation UploadApplicationsAction

@synthesize listener;
@synthesize applicationStorage;
@synthesize uploadStatusStorage;
@synthesize fileInfoStorage;

#pragma mark - Public Init Methods
+(instancetype)build:(id<ActionListener>)listener
  applicationStorage:(id<ApplicationStorageInterface>)applicationStorage
 uploadStatusStorage:(id<UploadFileStatusStorageInterface>)uploadStatusStorage
     fileInfoStorage:(id<FileInfoStorageInterface>)fileInfoStorage
{
    UploadApplicationsAction *result = [UploadApplicationsAction new];
    result.listener = listener;
    result.applicationStorage = applicationStorage;
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
        [self notifListener:100 error:nil desc:@"No App files to upload"];
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
}

-(void)transferProgress:(CGFloat)progress
{
    NSString *logMessage = [NSString stringWithFormat:@"Upload progress: %.2f", [self calculateProgress:(progress * 100.0)]];
    [[Logger currentLog] writeWithObject:self selector:_cmd text:logMessage logLevel:DEBUG_L];
}

#pragma mark - Private Methods
-(void)transferFiles
{
    if (!files.isEmpty)
    {
        currentFile = files.firstObject;
        [files removeObjectAtIndex:0];
        transfer.settings = [self prepareFileTransferInfo:currentFile];
        block = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, ^{
            [self uploadFile];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(REQUEST_TIMEOUT * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
    }
    else
    {
        application = [applicationStorage getBy:currentDevice.fingerprint];
        block = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, ^{
            [self transferApplyData];
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
    tryingCounter = 0;
    NSString *desc = [NSString stringWithFormat:@"Uploaded file: %@", currentFile.fileName.lastPathComponent];
    [self notifListener:100.0 error:result.error desc:desc];
    [self updateUploadStatus:nil];
    currentFile = nil;
    block = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, ^{
        [self transferFiles];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(REQUEST_TIMEOUT * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}

-(void)transferApplyData
{
    if (application != nil)
    {
        transfer.settings = [self prepareApplicationsTransferInfo];
        [transfer upload:^(TransferResult *result)
        {
            NSString *desc = nil;
            if (result.error == nil)
                desc = @"Uploaded application data";
            else
                desc = [NSString stringWithFormat:@"Upload application data failed: %@", result.error];
            [self notifListener:100.0 error:result.error desc:desc];
            [self completion:result];
        }];
    }
    else
        [self completion:[TransferResult build:nil data:nil]];
}

-(TransferInfo*)prepareFileTransferInfo:(ApplicationFile*)file
{
    NSDictionary *data = @{@"filename" : file.fileName};
    TransferInfo *transferInfo = [TransferInfo new];
    transferInfo.address = [connectionData.urlString stringByAppendingString:EiOSMethod.uploadApplication];
    transferInfo.pathToFile = [[AppInfromation getPathToDocuments] stringByAppendingPathComponent:file.localPath];
    transferInfo.parameters = @{@"fingerprint" : [EiControllerSysInfo getUdid],
                                @"data" : [data.json stringByReplacingOccurrencesOfString:@"\n" withString:@""]};
    return transferInfo;
}

-(TransferInfo*)prepareApplicationsTransferInfo
{
    TransferInfo *transferInfo = [TransferInfo new];
    transferInfo.address = [connectionData.urlString stringByAppendingString:EiOSMethod.applyData];
    transferInfo.pathToFile = nil;
    transferInfo.parameters = @{@"fingerprint" : [EiControllerSysInfo getUdid],
                                @"data" : application.details};
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
    application = nil;
    files = nil;
    currentFile = nil;
    tryingCounter = 0;
}

@end
