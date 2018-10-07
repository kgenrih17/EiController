//
//  GetFilesInfoAction.m
//  EiController
//
//  Created by Genrih Korenujenko on 20.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "GetScheduleAction.h"

@implementation GetScheduleAction

@synthesize api,listener, storage, devicesStorage, fileStatusStorage, scheduleFilesStorage, completion, validator;

#pragma mark - Public Init Methods
+(instancetype)build:(id<ActionListener>)listener
                 api:(id<CentralAPIInterface>)api
             storage:(id<ScheduleStorageInterface>)storage
      devicesStorage:(id<INodeStorage>)devicesStorage
   fileStatusStorage:(id<DownloadFileStatusStorageInterface>)fileStatusStorage
scheduleFilesStorage:(id<FileInfoStorageInterface>)scheduleFilesStorage
{
    GetScheduleAction *result = [GetScheduleAction new];
    result.api = api;
    result.listener = listener;
    result.storage = storage;
    result.devicesStorage = devicesStorage;
    result.fileStatusStorage = fileStatusStorage;
    result.scheduleFilesStorage = scheduleFilesStorage;
    return result;
}

#pragma mark - Init
-(instancetype)init
{
    self = [super init];
    if (self)
        cleaner = [StorageCleaner new];
    return self;
}

#pragma mark - ActionInterface
-(void)do:(Completion)aCompletion
{
    completion = aCompletion;
    fingerprints = [NSMutableArray arrayWithArray:[devicesStorage getCentralFingerprints]];
    [self getSchedules];
}

-(void)cancel
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    if (block)
        dispatch_block_cancel(block);
    [api cancel];
    [self clearCache];
    [listener actionReport:100 error:[ErrorDescription getError:PROCESS_CANCELED] description:[ErrorDescription getError:PROCESS_CANCELED]];
}

#pragma mark - Private Methods
-(void)getSchedules
{
    [self prepareNextFingerprint];
    if (fingerprint != nil)
    {
        [api getSchedules:fingerprint completion:^(NSDictionary *response)
        {
            validator = [[GetScheduleValidator alloc] initWithError:[api getErrorMessage] response:response];
            [self notifListener:validator.error];
            if (validator.isValid)
                [self parse:response];
            
            block = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, ^
            {
                [self getSchedules];
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(REQUEST_TIMEOUT * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
        }];
    }
    else
        [self completion:[ActionResult build:nil data:nil]];
}

-(void)prepareNextFingerprint
{
    fingerprint = nil;
    if (!fingerprints.isEmpty)
    {
        fingerprint = fingerprints.firstObject;
        [fingerprints removeObjectAtIndex:0];
    }
}

-(void)parse:(NSDictionary*)response
{
    [[Logger currentLog] writeWithObject:self selector:_cmd text:@"Received a response from the server" logLevel:DEBUG_L];
    Schedule *schedule = [self parseSchedule:response];
    Schedule *duplicateSchedule = [storage getByMD5:schedule.md5 fingerprint:fingerprint];
    if (duplicateSchedule == nil)
    {
        Schedule *oldSchedules = [storage getByFingerprint:schedule.fingerprint];
        if (oldSchedules != nil)
            [cleaner clearUnnecessaryDeviceData:@[oldSchedules.fingerprint]];
        NSArray *files = [self parseContentFiles:[response arrayForKey:@"files"]];
        NSArray *statuses = [self prepareFileStatuses:files];
        [self save:files schedule:schedule fileStatuses:statuses];
    }
}

-(Schedule*)parseSchedule:(NSDictionary*)dic
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
    NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    Schedule *item = [Schedule new];
    item.fingerprint = fingerprint;
    item.details = result;
    item.md5 = item.details.md5;
    return item;
}

-(NSArray*)parseContentFiles:(NSArray<NSDictionary*>*)items
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:items.count];
    [items enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        ScheduleFile *item = [ScheduleFile new];
        item.fingerprint = fingerprint;
        item.unique = [obj stringForKey:@"unique"];
        item.fileUrl = [obj stringForKey:@"file_url"];
        item.md5 = [obj stringForKey:@"md5"];
        item.esID = [obj stringForKey:@"es_id"];
        [result addObject:item];
    }];
    return result;
}

-(NSArray*)prepareFileStatuses:(NSArray<ScheduleFile*>*)items
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:items.count];
    [items enumerateObjectsUsingBlock:^(ScheduleFile * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        DownloadFileStatus *item = [DownloadFileStatus new];
        item.fingerprint = fingerprint;
        item.fileId = obj.unique;
        [result addObject:item];
    }];
    return result;
}

-(void)save:(NSArray<ScheduleFile*>*)files schedule:(Schedule*)schedule fileStatuses:(NSArray<DownloadFileStatus*>*)statuses
{
    [[Logger currentLog] writeWithObject:self selector:_cmd text:@"" logLevel:DEBUG_L];
    [storage update:schedule];
    if (!files.isEmpty)
        [scheduleFilesStorage updateItems:files];
    
    if (!statuses.isEmpty)
        [fileStatusStorage update:statuses];
}

-(void)notifListener:(NSString*)error;
{
    NSMutableString *desc = [NSMutableString stringWithString:[self getDescription:error]];
    CGFloat progress = 100.0 / (CGFloat)(fingerprints.count + 1.0);
    [listener actionReport:progress error:error description:desc];
}

-(NSString*)getDescription:(NSString*)error
{
    NSString *result = nil;
    if (error == nil)
        result = [NSString stringWithFormat:@"Schedule received for fingerprint: %@", fingerprint];
    else
        result = [NSString stringWithFormat:@"Schedule not received for fingerprint: %@", fingerprint];
    return result;
}

-(void)completion:(ActionResult*)result
{
    [self clearCache];
    completion(result);
}

-(void)clearCache
{
    fingerprints = nil;
    fingerprint = nil;
}

@end
