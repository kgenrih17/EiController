//
//  GetApplicationAction.m
//  EiController
//
//  Created by Genrih Korenujenko on 20.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "GetApplicationAction.h"

static NSString * const FILE_NAME_KEY = @"filename";
static NSString * const DATA_KEY = @"data";

static const NSInteger MAX_TRY_COUNT_FOR_APPLICATIONS_LIST = 50;
static const NSInteger RAPEAT_WAITING_TIME = 30;

@implementation GetApplicationAction

@synthesize api, completion, deviceStorage, applicationStorage, downloadStatusStorage, uploadStatusStorage, listener, fileInfoStorage, folder, validator;

#pragma mark - Public Init Methods
+(instancetype)build:(id<PublisherAPIInterface>)api
       deviceStorage:(id<INodeStorage>)deviceStorage
  applicationStorage:(id<ApplicationStorageInterface>)applicationStorage
     fileInfoStorage:(id<FileInfoStorageInterface>)fileInfoStorage
downloadStatusStorage:(id<DownloadFileStatusStorageInterface>)downloadStatusStorage
 uploadStatusStorage:(id<UploadFileStatusStorageInterface>)uploadStatusStorage
            listener:(id<ActionListener>)listener
              folder:(NSString*)folder
{
    GetApplicationAction *result = [GetApplicationAction new];
    result.api = api;
    result.deviceStorage = deviceStorage;
    result.applicationStorage = applicationStorage;
    result.fileInfoStorage = fileInfoStorage;
    result.downloadStatusStorage = downloadStatusStorage;
    result.uploadStatusStorage = uploadStatusStorage;
    result.listener = listener;
    result.folder = folder;
    return result;
}

#pragma mark - ActionInterface
-(void)do:(Completion)aCompletion
{
    completion = aCompletion;
    fingerprints = [NSMutableArray arrayWithArray:[deviceStorage getCentralFingerprints]];
    files = [NSMutableArray new];
    pathToDocument = [AppInfromation getPathToDocuments];
    rapeatCounter = 0;
    [self processing];
}

-(void)cancel
{
    if (block)
        dispatch_block_cancel(block);
    [api cancel];
    [listener actionReport:100 error:[ErrorDescription getError:PROCESS_CANCELED] description:[ErrorDescription getError:PROCESS_CANCELED]];
    [self clearCache];
}

#pragma mark - Private Methods
-(void)processing
{
    block = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, ^{
        rapeatCounter = 0;
        if (!fingerprints.isEmpty)
        {
            fingerprint = fingerprints.firstObject;
            [fingerprints removeObjectAtIndex:0];
            sessionToken = nil;
            [self getApplications];
        }
        else if (!files.isEmpty)
        {
            [self setUploadedFiles];
        }
        else
        {
            [self notifListener:nil desc:@"No apps to download"];
            [self clearCache];
            completion([ActionResult build:nil data:nil]);
        }
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}

-(void)getApplications
{
    BOOL isForce = ([applicationStorage getBy:fingerprint] == nil);
    [api getApplications:fingerprint token:sessionToken isForce:isForce completion:^(NSDictionary*apps)
    {
        sessionToken = apps[@"token"];
        validator = [[GetApplicationValidator alloc] initWithError:[api getErrorMessage] response:apps];
        NSString *desc = nil;
        if (validator.error == nil)
            desc = [NSString stringWithFormat:@"List of applications received for fingerprint: %@", fingerprint];
        else if (!validator.isValid)
            desc = [NSString stringWithFormat:@"Format for list of applications is invalid for fingerprint: %@", fingerprint];
        else
            desc = [NSString stringWithFormat:@"Not received list of applications for fingerprint: %@", fingerprint];
        [self notifListener:validator.error desc:desc];
        [self parseApps:apps];
    }];
}

-(void)parseApps:(NSDictionary*)apps
{
    if (validator.isValid && [validator isReadyAppList:apps[validator.FILES_KEY]])
    {
        fileInfos = [NSMutableArray new];
        id data = apps[DATA_KEY];
        if (data != nil && [data isDictionary] && ![(NSDictionary*)data isEmpty])
        {
            Application *application = [self prepareApplication:apps];
            [applicationStorage update:application];
        }
        [fileInfos addObjectsFromArray:apps[validator.FILES_KEY]];
        [self processingDownloadFileInfo];
    }
    else if (validator.isValid && !validator.isPublisherHaveError)
    {
        NSArray *appList = apps[validator.FILES_KEY];
        if (rapeatCounter <= MAX_TRY_COUNT_FOR_APPLICATIONS_LIST && !appList.isEmpty)
        {
            NSString *desc = [NSString stringWithFormat:@"Application files are not ready, reattempting after %tu seconds", RAPEAT_WAITING_TIME];
            [self notifListener:validator.error desc:desc];
            rapeatCounter++;
            block = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, ^{
                [self getApplications];
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(RAPEAT_WAITING_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
        }
        else if (appList == nil || appList.isEmpty)
        {
            NSString *desc = [NSString stringWithFormat:@"No app files for fingerprint: %@", fingerprint];
            [self notifListener:nil desc:desc];
            [self processing];
        }
        else
        {
            NSString *desc = [NSString stringWithFormat:@"No app files for fingerprint: %@", fingerprint];
            [self notifListener:@"Exceeded attempt limit" desc:desc];
            [self processing];
        }
    }
    else
        [self processing];
}

-(void)processingDownloadFileInfo
{
    if (!fileInfos.isEmpty)
    {
        fileInfo = fileInfos.firstObject;
        [fileInfos removeObjectAtIndex:0];
        if ([self isAppFileDownloaded])
        {
            NSString *logMessage = [NSString stringWithFormat:@"fingerprint: %@, file info: %@", fingerprint, fileInfo];
            [[Logger currentLog] writeWithObject:self selector:_cmd text:logMessage logLevel:DEBUG_L];
            [self processingDownloadFileInfoAfter:0.1];
        }
        else
            [self downloadFile];
    }
    else
        [self processing];
}

-(void)processingDownloadFileInfoAfter:(CGFloat)time
{
    block = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, ^{
        [self processingDownloadFileInfo];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}

-(BOOL)isAppFileDownloaded
{
    NSString *path = [self getAppFileAbsolutePath];
    NSString *status = fileInfo[validator.FILE_STATUS_KEY];
    return ([NSFileManager.defaultManager fileExistsAtPath:path] && [status isEqualToString:validator.FILE_STATUS_NOT_MODIFIED]);
}

-(void)downloadFile
{
    [api downloadAppliactionFile:[NSString valueOrEmptyString:fileInfo[FILE_NAME_KEY]]
                          toPath:[self getAppFileAbsolutePath]
                      completion:^(NSInteger length)
    {
        NSInteger code = [api getErrorCode];
        NSString *desc = nil;
        if (code == 0)
            desc = [NSString stringWithFormat:@"Downloaded App file: %@", fileInfo[FILE_NAME_KEY]];
        else if (length == 0)
            desc = [NSString stringWithFormat:@"Download App file failed: %@, no data", fileInfo[FILE_NAME_KEY]];
        else
            desc = [NSString stringWithFormat:@"Download App file failed: %@", fileInfo[FILE_NAME_KEY]];
        
        [self notifListener:[api getErrorMessage] desc:desc];
        if (length != 0)
        {
            ApplicationFile *item = [self createApplicationFile:length];
            [self updateApplicationFile:item];
        }
        else
            [self saveUploadStatus];
        [self saveDownloadStatus:code];
        
        if ([api getErrorMessage] != nil)
            completion([ActionResult build:[api getErrorMessage] data:nil]);
        else
            [self processingDownloadFileInfoAfter:0.1];
    }];
}

-(void)updateApplicationFile:(ApplicationFile*)item
{
    [fileInfoStorage update:item];
    if (fileInfo != nil)
        [files addObject:fileInfo];
    [self saveUploadStatus];
}

-(void)setUploadedFiles
{
    [api setUploadedFiles:files completion:^
    {
        [self clearOldApplications];
        [self clearCache];
        completion([ActionResult build:[api getErrorMessage] data:nil]);
    }];
}

-(void)clearOldApplications
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *pathToApplications = [pathToDocument stringByAppendingPathComponent:folder];
    NSArray *filesFromDirectory = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:pathToApplications error:nil];
    NSArray *namesOfApplications = [files valueForKey:FILE_NAME_KEY];
    for (NSString *fileName in filesFromDirectory)
    {
        if (![namesOfApplications containsObject:fileName])
        {
            NSString *fullPath = [pathToApplications stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:fullPath error:nil];
        }
    }
}

-(Application*)prepareApplication:(NSDictionary*)apps
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:apps options:0 error:nil];
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    Application *item = [Application new];
    item.fingerprint = fingerprint;
    item.details = json;
    item.md5 = item.details.md5;
    return item;
}

-(ApplicationFile*)createApplicationFile:(NSInteger)length
{
    ApplicationFile *item = [ApplicationFile new];
    item.fileSize = length;
    item.fingerprint = fingerprint;
    item.unique = [NSString valueOrEmptyString:fileInfo[FILE_NAME_KEY]];
    item.fileName = [NSString valueOrEmptyString:fileInfo[FILE_NAME_KEY]];
    item.localPath = [self getAppFileLocalPath];
    return item;
}

-(NSString*)getAppFileAbsolutePath
{
    return [pathToDocument stringByAppendingPathComponent:[self getAppFileLocalPath]];
}

-(NSString*)getAppFileLocalPath
{
    return [folder stringByAppendingPathComponent:[NSString valueOrEmptyString:fileInfo[FILE_NAME_KEY]]];
}

-(void)saveDownloadStatus:(NSInteger)code
{
    DownloadFileStatus *item = [DownloadFileStatus new];
    item.errorCode = code;
    item.isDownloaded = (code == 0);
    item.fingerprint = fingerprint;
    item.fileId = [NSString valueOrEmptyString:fileInfo[FILE_NAME_KEY]];
    [downloadStatusStorage update:@[item]];
    [downloadStatusStorage updateFlag:item.isDownloaded code:code byFileId:item.fileId fingerprint:item.fingerprint];
}

-(void)saveUploadStatus
{
    UploadFileStatus *item = [UploadFileStatus new];
    item.errorCode = 0;
    item.isUpload = 0;
    item.fingerprint = fingerprint;
    item.fileId = [NSString valueOrEmptyString:fileInfo[FILE_NAME_KEY]];
    [uploadStatusStorage update:@[item]];
}

-(void)notifListener:(NSString*)error desc:(NSString*)desc
{
    NSMutableString *fullDesc = [NSMutableString stringWithString:desc];
    CGFloat progress = 100.0 / (CGFloat)(fingerprints.count + 1.0);
    [listener actionReport:progress error:error description:fullDesc];
}

-(void)clearCache
{
    fingerprints = nil;
    fingerprint = nil;
    fileInfos = nil;
    fileInfo = nil;
    pathToDocument = nil;
    sessionToken = nil;
}

@end
