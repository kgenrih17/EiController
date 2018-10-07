//
//  DonwloadFilesAction.m
//  EiController
//
//  Created by Genrih Korenujenko on 20.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "DonwloadFilesAction.h"

@implementation DonwloadFilesAction

@synthesize listener;
@synthesize connectionData;
@synthesize storage;
@synthesize downloadStatusStorage;
@synthesize uploadStatusStorage;
@synthesize localPath;

#pragma mark - Public Init Methods
+(instancetype)build:(id<ActionListener>)listener
      connectionData:(ConnectionData*)connectionData
             storage:(id<FileInfoStorageInterface>)storage
downloadStatusStorage:(id<DownloadFileStatusStorageInterface>)downloadStatusStorage
 uploadStatusStorage:(id<UploadFileStatusStorageInterface>)uploadStatusStorage
                path:(NSString*)path
{
    DonwloadFilesAction *result = [DonwloadFilesAction new];
    result.listener = listener;
    result.connectionData = connectionData;
    result.storage = storage;
    result.downloadStatusStorage = downloadStatusStorage;
    result.uploadStatusStorage = uploadStatusStorage;
    result.localPath = path;
    return result;
}

#pragma mark - Init
-(instancetype)init
{
    self = [super init];
    if (self)
        fileDownloader = [[FileDownloader alloc] initWithDelegate:self];
    return self;
}

#pragma mark - ActionInterface
-(void)do:(Completion)aCompletion
{
    completion = aCompletion;
    files = [storage getNotDownload];
    fullPath = [[AppInfromation getPathToDocuments] stringByAppendingPathComponent:localPath];
    [self downloadFiles];
}

-(void)cancel
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    if (block)
        dispatch_block_cancel(block);
    [fileDownloader cancel];
    [self clearCache];
    [listener actionReport:100 error:[ErrorDescription getError:PROCESS_CANCELED] description:[ErrorDescription getError:PROCESS_CANCELED]];
}

#pragma mark - FileDownloaderDelegate
-(void)didSuccessfullDownload:(NSString*)path
{
    [self updateFileInfo:path];
    [downloadStatusStorage updateFlag:YES code:0 byFileId:currentFile.unique fingerprint:currentFile.fingerprint];
    [self notifListener:nil];
    [self saveUploadFileStatus:currentFile];
    block = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, ^{
        [self downloadFiles];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(REQUEST_TIMEOUT * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}

-(void)didFailedDownload:(NSString*)path withEror:(NSString*)error
{
    [[Logger currentLog] writeWithObject:self selector:_cmd text:error logLevel:DEBUG_L];
    [downloadStatusStorage updateFlag:NO code:DOWNLOAD_FILE_ERROR byFileId:currentFile.unique fingerprint:currentFile.fingerprint];
    [self notifListener:error];
    block = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, ^{
        [self downloadFiles];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(REQUEST_TIMEOUT * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}

#pragma mark - Private Methods
-(void)downloadFiles
{
    if (!files.isEmpty)
    {
        currentFile = files.firstObject;
        [files removeObjectAtIndex:0];
        NSString *fullURL = [connectionData.url.absoluteString stringByAppendingPathComponent:currentFile.fileUrl];
        NSString *absolutePath = [fullPath stringByAppendingPathComponent:currentFile.fileUrl.lastPathComponent];
        if (![[NSFileManager defaultManager] fileExistsAtPath:absolutePath])
            [fileDownloader downloadFrom:fullURL to:absolutePath];
        else
            [self didSuccessfullDownload:absolutePath];
    }
    else
        [self completion:[ActionResult build:nil data:nil]];
}

-(void)updateFileInfo:(NSString*)path
{
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSString *logMessage = [NSString stringWithFormat:@"File downloaded: %tu", data.length];
    [[Logger currentLog] writeWithObject:self selector:_cmd text:logMessage logLevel:DEBUG_L];
    currentFile.fileSize = data.length;
    currentFile.localPath = [localPath stringByAppendingPathComponent:path.lastPathComponent];
    [storage update:currentFile];
}
-(void)saveUploadFileStatus:(id<FileInfoInterface>)item
{
    UploadFileStatus *result = [UploadFileStatus new];
    result.fingerprint = item.fingerprint;
    result.fileId = item.unique;
    result.destination = EINODE_DESTINATION;
    [uploadStatusStorage update:@[result]];
}

-(void)notifListener:(NSString*)error;
{
    NSMutableString *desc = [NSMutableString stringWithString:[self getDescription:error]];
    CGFloat progress = 100.0 / (CGFloat)(files.count + 1);
    [listener actionReport:progress error:error description:desc];
}

-(NSString*)getDescription:(NSString*)error
{
    NSString *result = nil;
    if (currentFile != nil)
    {
        if (error == nil)
            result = [NSString stringWithFormat:@"Downloaded file: %@ for fingerprint: %@", currentFile.fileUrl.lastPathComponent, currentFile.fingerprint];
        else
            result = [NSString stringWithFormat:@"Download failed: %@ for fingerprint: %@", currentFile.fileUrl.lastPathComponent, currentFile.fingerprint];
    }
    else
        result = [NSString stringWithFormat:@"No files to download"];
    return result;
}

-(void)completion:(ActionResult*)result
{
    [self notifListener:result.error];
    [self clearCache];
    completion(result);
}

-(void)clearCache
{
    files = nil;
    currentFile = nil;
    fullPath = nil;
}

@end
