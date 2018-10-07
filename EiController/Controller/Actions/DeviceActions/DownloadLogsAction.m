//
//  DownloadLogsAction.m
//  EiController
//
//  Created by Genrih Korenujenko on 02.01.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#import "DownloadLogsAction.h"
#import "HTTPTransfer.h"
#import "CentralMethod.h"

@implementation DownloadLogsAction

@synthesize listener;
@synthesize fileInfoStorage;
@synthesize downloadStatusStorage;
@synthesize uploadStatusStorage;
@synthesize localPath;

#pragma mark - Public Init Methods
+(instancetype)build:(id<ActionListener>)listener
     fileInfoStorage:(id<FileInfoStorageInterface>)fileInfoStorage
downloadStatusStorage:(id<DownloadFileStatusStorageInterface>)downloadStatusStorage
 uploadStatusStorage:(id<UploadFileStatusStorageInterface>)uploadStatusStorage
                path:(NSString*)path
{
    DownloadLogsAction *result = [DownloadLogsAction new];
    result.listener = listener;
    result.fileInfoStorage = fileInfoStorage;
    result.downloadStatusStorage = downloadStatusStorage;
    result.uploadStatusStorage = uploadStatusStorage;
    result.localPath = path;
    return result;
}

#pragma mark - ActionInterface
-(void)setDevice:(Device*)device byConnectionData:(ConnectionData*)newConnectionData
{
    currentDevice = device;
    connectionData = newConnectionData;
}

-(void)do:(Completion)aCompletion
{
    completion = aCompletion;
    transfer = [HTTPTransfer build:self settings:nil];
    fullPath = [[AppInfromation getPathToDocuments] stringByAppendingPathComponent:localPath];
    files = [NSMutableArray new];
    [self getLogFiles];
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

#pragma mark - Private Methods
-(void)getLogFiles
{
    transfer.settings = [self prepareTransferInfoGetFiles];
    [transfer sendRequest:^(TransferResult *result)
    {
        if (result.error == nil)
        {
            if ([self isValidLogFilesList:result.data])
            {
                [self parseFiles:result.data];
                NSString *desc = [NSString stringWithFormat:@"List of logs to download: %tu", files.count];
                [self notifListener:100.0 error:nil desc:desc];
                block = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, ^{
                    [self downloadFiles];
                });
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(REQUEST_TIMEOUT * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
            }
            else
            {
                NSString *desc = [NSString stringWithFormat:@"The response data type \"%@\", the expected type of \"json\"", NSStringFromClass([result.data class])];
                [self notifListener:100.0 error:@"incorrect format response" desc:desc];
                [self completion:result];
            }
        }
        else
        {
            [self notifListener:100.0 error:result.error desc:@"Error retrieving files"];
            [self completion:result];
        }
    }];
}

-(BOOL)isValidLogFilesList:(id)data
{
    BOOL result = NO;
    if ([[data class] isSubclassOfClass:[NSDictionary class]] && [(NSDictionary*)data containsKey:@"files"])
        result = [[data[@"files"] class] isSubclassOfClass:[NSArray class]];
    return result;
}

-(void)downloadFiles
{
    if (!files.isEmpty)
    {
        currentFile = files.firstObject;
        [files removeObjectAtIndex:0];
        transfer.settings = [self prepareTransferInfoDownloadFile];
        [transfer download:^(TransferResult *result)
        {
            [self parseDownloadFile:result];
        }];
    }
    else
        [self completion:[TransferResult build:nil data:nil]];
}

-(void)parseDownloadFile:(TransferResult*)result
{
    [self saveDownloadFileStatus:result.error];
    if (result.error == nil)
    {
        [self notifListener:100.0 error:nil desc:[NSString stringWithFormat:@"Downloaded file: %@", currentFile]];
        [downloadedFiles addObject:@{@"filename" : currentFile}];
        [self saveLogFile:result.data];
        [self saveUploadFileStatus];
    }
    else
        [self notifListener:100.0 error:result.error desc:[NSString stringWithFormat:@"Download failed: %@ by file name: %@ ", result.error, currentFile]];
    
    if (files.isEmpty)
    {
        block = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, ^{
            [self setDownloadedLogFiles];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(REQUEST_TIMEOUT * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
    }
    else
    {
        block = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, ^{
            [self downloadFiles];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(REQUEST_TIMEOUT * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
    }
}

-(void)setDownloadedLogFiles
{
    if (!downloadedFiles.isEmpty)
    {
        transfer.settings = [self prepareTransferInfoReport];
        [transfer sendRequest:^(TransferResult *result)
        {
            NSString *desc = nil;
            if (result.error == nil)
                desc = [NSString stringWithFormat:@"Downloaded logs report sent: %tu", downloadedFiles.count];
            else
                desc = [NSString stringWithFormat:@"Downloaded logs report not sent"];
            [self notifListener:100.0 error:result.error desc:desc];
            [self completion:result];
        }];
    }
    else
        [self completion:[TransferResult build:nil data:nil]];
}

-(TransferInfo*)prepareTransferInfoGetFiles
{
    TransferInfo *transferInfo = [TransferInfo new];
    transferInfo.address = [connectionData.urlString stringByAppendingString:EiOSMethod.getLogFiles];
    transferInfo.pathToFile = nil;
    transferInfo.parameters = @{@"fingerprint" : [EiControllerSysInfo getUdid]};
    return transferInfo;
}

-(TransferInfo*)prepareTransferInfoDownloadFile
{
    TransferInfo *transferInfo = [TransferInfo new];
    transferInfo.address = [connectionData.urlString stringByAppendingString:EiOSMethod.downloadLogFile];
    transferInfo.pathToFile = nil;
    transferInfo.parameters = @{@"filename" : currentFile};
    return transferInfo;
}

-(TransferInfo*)prepareTransferInfoReport
{
    TransferInfo *transferInfo = [TransferInfo new];
    transferInfo.address = [connectionData.urlString stringByAppendingString:EiOSMethod.setUploadedLogFiles];
    transferInfo.pathToFile = nil;
    transferInfo.parameters = @{@"fingerprint" : [EiControllerSysInfo getUdid],
                                @"files" : [downloadedFiles.json stringByReplacingOccurrencesOfString:@"\n" withString:@""]};
    return transferInfo;
}

-(void)parseFiles:(NSDictionary*)json
{
    [files removeAllObjects];
    NSArray *newFiles = [json arrayForKey:@"files"];
    NSMutableArray *items = [NSMutableArray new];
    [newFiles enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        NSString *fileName = [obj stringForKey:@"filename"];
        [items addObject:fileName];
    }];
    [files addObjectsFromArray:items];
    downloadedFiles = [NSMutableArray new];
}

-(void)saveLogFile:(NSData*)data
{
    LogFile *item = [LogFile new];
    item.fileSize = data.length;
    item.fingerprint = currentDevice.fingerprint;
    item.unique = currentFile;
    item.localPath = [localPath stringByAppendingPathComponent:currentFile];
    [fileInfoStorage updateItems:@[item]];
    NSString *absolutePath = [fullPath stringByAppendingPathComponent:currentFile];
    [data writeToFile:absolutePath atomically:YES];
}

-(void)saveDownloadFileStatus:(NSString*)error
{
    BOOL isSuccess = (error == nil);
    NSInteger code = isSuccess ? 0 : DOWNLOAD_FILE_ERROR;
    DownloadFileStatus *item = [DownloadFileStatus new];
    item.fingerprint = currentDevice.fingerprint;
    item.fileId = currentFile;
    item.errorCode = code;
    item.isDownloaded = isSuccess;
    [downloadStatusStorage update:@[item]];
    [downloadStatusStorage updateFlag:isSuccess code:code byFileId:currentFile fingerprint:item.fingerprint];
}

-(void)saveUploadFileStatus
{
    UploadFileStatus *result = [UploadFileStatus new];
    result.fingerprint = currentDevice.fingerprint;
    result.fileId = currentFile;
    result.destination = CENTRAL_DESTINATION;
    [uploadStatusStorage update:@[result]];
}

-(void)notifListener:(CGFloat)progress error:(NSString*)error desc:(NSString*)desc
{
    CGFloat percent = [self calculateProgress:progress];
    [listener actionReport:percent error:error description:desc];
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
    files = nil;
    downloadedFiles = nil;
    currentFile = nil;
    fullPath = nil;
}

@end
