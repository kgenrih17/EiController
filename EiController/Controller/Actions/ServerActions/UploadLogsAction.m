//
//  UploadFilesAction.m
//  EiController
//
//  Created by Genrih Korenujenko on 20.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "UploadLogsAction.h"
#import "CentralMethod.h"

@implementation UploadLogsAction

@synthesize listener;
@synthesize connectionData;
@synthesize transfer;
@synthesize fileStorage;
@synthesize uploadStatusStorage;

#pragma mark - Public Init Methods
+(instancetype)build:(id<ActionListener>)listener
      connectionData:(ConnectionData*)connectionData
            transfer:(id<TransferInterface>)transfer
         fileStorage:(id<FileInfoStorageInterface>)fileStorage
 uploadStatusStorage:(id<UploadFileStatusStorageInterface>)uploadStatusStorage
{
    UploadLogsAction *result = [UploadLogsAction new];
    result.listener = listener;
    result.connectionData = connectionData;
    result.transfer = transfer;
    result.fileStorage = fileStorage;
    result.uploadStatusStorage = uploadStatusStorage;
    return result;
}

#pragma mark - ActionInterface
-(void)do:(Completion)aCompletion
{
    completion = aCompletion;
    pathToDocuments = [AppInfromation getPathToDocuments];
    files = [fileStorage getAllNotUpload];
    transfer.listener = self;
    if (files.isEmpty)
        [self completion];
    else
        [self processing];
}

-(void)cancel
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    if (block)
        dispatch_block_cancel(block);
    [transfer cancel];
    [self clearCache];
    [listener actionReport:100 error:[ErrorDescription getError:PROCESS_CANCELED] description:[ErrorDescription getError:PROCESS_CANCELED]];
}

#pragma mark - TransferListener
-(void)transferProgress:(CGFloat)progress
{
    NSString *logMessage = [NSString stringWithFormat:@"Upload progress: %.2f", [self calculateProgress:progress]];
    [[Logger currentLog] writeWithObject:self selector:_cmd text:logMessage logLevel:DEBUG_L];
}

#pragma mark - Private Methods
-(void)clearCache
{
    files = nil;
    currentFile = nil;
    pathToDocuments = nil;
}

-(void)processing
{
    if (!files.isEmpty)
    {
        currentFile = files.firstObject;
        [files removeObjectAtIndex:0];
        transfer.settings = [self prepareFileTransferInfo:currentFile];
        [transfer upload:^(TransferResult *result)
        {
            [self notifListener:100.0 error:result.error];
            [self updateUploadStatus:result.error];
            block = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, ^{
                [self processing];
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(REQUEST_TIMEOUT * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
        }];
    }
    else
        [self completion];
}

-(void)completion
{
    [self notifListener:100 error:nil];
    completion([ActionResult build:nil data:nil]);
    [self clearCache];
}

-(TransferInfo*)prepareFileTransferInfo:(id<FileInfoInterface>)file
{
    TransferInfo *transferInfo = [TransferInfo new];
    transferInfo.address = [[self getUrl] stringByAppendingString:CentralMethod.uploadLogFiles];
    transferInfo.pathToFile = [pathToDocuments stringByAppendingPathComponent:file.localPath];
    transferInfo.parameters = @{@"fingerprint" : [EiControllerSysInfo getUdid]};
    return transferInfo;
}

-(NSString*)getUrl
{
    return [NSString stringWithFormat:@"%@%@?", connectionData.url.absoluteString, CentralMethod.dasJsonPHP];
}

-(void)updateUploadStatus:(NSString*)error
{
    BOOL isSuccess = (error == nil);
    NSInteger code = isSuccess ? 0 : UPLOAD_FILE_ERROR;
    [uploadStatusStorage updateFlag:isSuccess code:code byFileId:currentFile.unique fingerprint:currentFile.fingerprint];
}

-(void)notifListener:(CGFloat)progress error:(NSString*)error
{
    CGFloat percent = [self calculateProgress:progress];
    NSString *desc = nil;
    if (currentFile != nil)
    {
        if (error == nil)
            desc = [NSString stringWithFormat:@"Uploaded log file: %@", currentFile.localPath.lastPathComponent];
        else
            desc = [NSString stringWithFormat:@"Upload log failed: %@\n", currentFile.localPath.lastPathComponent];
    }
    else
        desc = [NSString stringWithFormat:@"No Logs to upload"];
    [listener actionReport:percent error:error description:desc];
}

-(CGFloat)calculateProgress:(CGFloat)progress
{
    NSInteger fileCount = files.count + 1;
    CGFloat partOfProgress = 100.0 / (CGFloat)fileCount;
    CGFloat result = partOfProgress / 100.0 * progress;
    return result;
}

@end
