//
//  ServerIntegrator.m
//  EiController
//
//  Created by Genrih Korenujenko on 20.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "ServerIntegrator.h"
#import "HTTPTransfer.h"
#import "UserDefaultsKeys.h"

/// Storages
#import "ApplicationsTable.h"
#import "ApplicationFilesTable.h"
#import "ScheduleFilesTable.h"
#import "DownloadFileStatusesTable.h"
#import "UploadFileStatusesTable.h"
#import "ServerLogsTable.h"
#import "LogFilesTable.h"

/// Actions
#import "UpdateDeviceAction.h"
#import "GetScheduleAction.h"
#import "GetApplicationAction.h"
#import "DonwloadFilesAction.h"
#import "UploadLogsAction.h"

static const NSInteger SYNC_LOGS_DAYS_MAX = 7;
static const NSInteger ACTION_TIMEOUT = 2;
static const NSInteger CONNECTION_TRACKER_TIMEOUT = 120;

@interface ServerIntegrator () <CentralConnectTrackerObserverInterface>
@end

@implementation ServerIntegrator

@synthesize api, publisherAPI, connectionData, deviceStorage, scheduleStorage, trackerObserver, listener, connectTracker;

#pragma mark - Init
-(instancetype)init
{
    self = [super init];
    if (self)
    {
        timeout = SECONDS_IN_DAY;
        operationQueue = [NSOperationQueue mainQueue];
        operationQueue.qualityOfService = NSQualityOfServiceBackground;
    }
    return self;
}

#pragma mark - ServerIntegratorInterface
+(instancetype)build:(CentralConnectionData*)connectionData
       deviceStorage:(id<INodeStorage>)deviceStorage
     scheduleStorage:(id<ScheduleStorageInterface>)scheduleStorage
             tracker:(id<CentralConnectTrackerObserverInterface>)tracker
            listener:(id<ServerIntegratorListener>)listener
{
    ServerIntegrator *result = [ServerIntegrator new];
    result.connectionData = connectionData;
    result.deviceStorage = deviceStorage;
    result.scheduleStorage = scheduleStorage;
    result.trackerObserver = tracker;
    result.listener = listener;
    return result;
}

-(void)start
{
    if (!isStarted)
    {
        isStarted = YES;
        [[Logger currentLog] writeWithObject:self selector:_cmd text:@"Started" logLevel:DEBUG_L];
        [self.welf addOperation:0 backgroundFlag:YES completion:^
        {
            [self prepareToWork];
            [self.connectTracker start];
            [self refreshTimer:[self getTimeToSync]];
        }];
    }
}

-(void)stop
{
    if (isStarted)
    {
        [self prepareToStop];
        [connectTracker stop];
        isStarted = NO;
        [[Logger currentLog] writeWithObject:self selector:_cmd text:@"Stopped" logLevel:DEBUG_L];
    }
}

-(void)deinit
{
    [self stop];
    api = nil;
    listener = nil;
    status = nil;
    actions = nil;
    connectTracker = nil;
}

-(void)run
{
    if (!status.isProcessing)
    {
        actionIndex = 0;
        status.isProcessing = YES;
        [[Logger currentLog] writeWithObject:self selector:_cmd text:@"" logLevel:DEBUG_L];
        [self updateSyncTimestamp];
        if (isNotifyListener && [listener respondsToSelector:@selector(serverSyncWillStart)])
            [self addOperation:0 backgroundFlag:NO target:listener perform:@selector(serverSyncWillStart)];
        [self performAction];
    }
}

-(void)setTimeout:(NSInteger)newTimeout
{
    timeout = newTimeout;
}

-(void)setNotifyFlag:(BOOL)isNotify
{
    isNotifyListener = isNotify;
}

-(void)setAutoStartFlag:(BOOL)isAuto
{
    isAutoSync = isAuto;
    if (!status.isProcessing && isStarted)
        [self refreshTimer:timeout];
    else if (!isAutoSync)
        [autoSyncTimer invalidate];
}

-(void)clearOldLogs
{
    NSInteger currentTimestamp = [NSDate date].timeIntervalSince1970;
    NSInteger time = currentTimestamp - SECOND_IN_ONE_DAY * SYNC_LOGS_DAYS_MAX;
    [serverLogStorage clearByTimestamp:time];
}

#pragma mark - Preparing Methods
-(void)prepareToWork
{
    status = [ServerActionStatus new];
    actions = [NSMutableArray new];
    api = [EiCentralAPI build:connectionData];
    publisherAPI = [PublisherAPI build:[PublisherConnectionData get]];
    connectTracker = [CentralConnectTracker build:self api:[EiCentralAPI build:connectionData] timeout:CONNECTION_TRACKER_TIMEOUT];
    serverLogStorage = [ServerLogsTable new];
    [self addActions];
    [self prepareFolders];
}

-(void)prepareToStop
{
    [operationQueue cancelAllOperations];
    if (autoSyncTimer.isValid)
        [autoSyncTimer invalidate];
    [self removeActions];
    actions = nil;
    actionIndex = 0;
    [api cancel];
    api = nil;
    [publisherAPI cancel];
    publisherAPI = nil;
    [connectTracker stop];
    connectTracker = nil;
    serverLogStorage = nil;
    [status clear];
    status = nil;
}

-(void)prepareFolders
{
    [AppInfromation createPathIfNeed:SCHEDULE_FILES_FOLDER_NAME];
    [AppInfromation createPathIfNeed:APPLICATIONS_FOLDER_NAME];
}

-(void)addActions
{
    [[Logger currentLog] writeWithObject:self selector:_cmd text:@"" logLevel:DEBUG_L];
    [actions addObject:[UpdateDeviceAction build:api
                                         storage:deviceStorage
                                        listener:self]];
    [actions addObject:[GetScheduleAction build:self
                                            api:api
                                        storage:scheduleStorage
                                 devicesStorage:deviceStorage
                              fileStatusStorage:[DownloadFileStatusesTable new]
                           scheduleFilesStorage:[ScheduleFilesTable new]]];
    [actions addObject:[DonwloadFilesAction build:self
                                   connectionData:connectionData
                                          storage:[ScheduleFilesTable new]
                            downloadStatusStorage:[DownloadFileStatusesTable new]
                              uploadStatusStorage:[UploadFileStatusesTable new]
                                             path:SCHEDULE_FILES_FOLDER_NAME]];
    [actions addObject:[GetApplicationAction build:publisherAPI
                                     deviceStorage:deviceStorage
                                applicationStorage:[ApplicationsTable new]
                                   fileInfoStorage:[ApplicationFilesTable new]
                             downloadStatusStorage:[DownloadFileStatusesTable new]
                               uploadStatusStorage:[UploadFileStatusesTable new]
                                          listener:self
                                            folder:APPLICATIONS_FOLDER_NAME]];
    [actions addObject:[UploadLogsAction build:self
                                connectionData:connectionData
                                      transfer:[HTTPTransfer new]
                                   fileStorage:[LogFilesTable new]
                           uploadStatusStorage:[UploadFileStatusesTable new]]];
}

-(void)removeActions
{
    [[Logger currentLog] writeWithObject:self selector:_cmd text:@"" logLevel:DEBUG_L];
    if ([actions isValidIndex:actionIndex])
    {
        id <ActionInterface> action = actions[actionIndex];
        [action cancel];
    }
    [actions removeAllObjects];
}

#pragma mark - CentralConnectTrackerObserverInterface
-(void)changeConnectionTo:(BOOL)isStable
{
    [[Logger currentLog] writeWithObject:self selector:_cmd text:@(isStable).stringValue logLevel:DEBUG_L];
    [trackerObserver changeConnectionTo:isStable];
}

#pragma mark - ActionListener
-(void)actionReport:(CGFloat)progress error:(NSString*)error description:(NSString*)desc
{
    [status setProgress:progress];
    NSString *logMessage = [NSString stringWithFormat:@"Action sync progress: %f, action progress: %f, desc: %@", progress, status.progress, desc];
    [[Logger currentLog] writeWithObject:self selector:_cmd text:logMessage logLevel:DEBUG_L];
    [self writeServerLog:[status getProgressTitle] error:error desc:desc];
    if (isNotifyListener)
        [listener serverSyncChangeProgress:status.progress withMessage:desc];
}

#pragma mark - UpdateDeviceActionListener
-(void)publisherDataUpdated
{
    [publisherAPI setConnectionData:[PublisherConnectionData get]];
}

#pragma mark - Log Methods
-(void)writeServerLog:(NSString*)title error:(NSString*)error desc:(NSString*)desc
{
    ServerLog *serverLog = [ServerLog build:title
                                       code:0
                               errorMessage:error
                                     server:[status getServerName]
                                       desc:desc];
    [serverLogStorage add:serverLog];
}

#pragma mark - Private Methods
-(void)performAction
{
    id <ActionInterface> action = actions[actionIndex];
    status.actionIndex = actionIndex;
    [action do:^(ActionResult *result)
    {
        [self refreshStatus:result];
        [self actionCompletion];
    }];
}

-(void)actionCompletion
{
    [[Logger currentLog] writeWithObject:self
                                selector:_cmd
                                    text:(status.errorText == nil || !status.errorText) ? @"" : status.errorText
                                logLevel:DEBUG_L];
    if (status.errorText == nil)
    {
        if (isNotifyListener)
        {
            [self.welf addOperation:0 backgroundFlag:NO completion:^
            {
                [listener serverSyncChangeProgress:status.progress withMessage:[status getProgressTitle]];
            }];
        }
        if (status.actionIndex < SERVER_ACTIONS_COUNT - 1)
        {
            [self.welf addOperation:ACTION_TIMEOUT backgroundFlag:YES completion:^
            {
                actionIndex++;
                [self performAction];
            }];
        }
        else
            [self prepareForNextCycle];
    }
    else
    {
        if (isNotifyListener)
        {
            [self.welf addOperation:0 backgroundFlag:NO completion:^
            {
                [listener serverSyncError:status.errorText];
                [status clear];
            }];
        }
        [self refreshTimer:timeout];
    }
}

-(void)prepareForNextCycle
{
    if (isNotifyListener && [listener respondsToSelector:@selector(serverSyncDidEnd)])
        [self.welf addOperation:0 backgroundFlag:NO target:listener perform:@selector(serverSyncDidEnd)];
    [[Logger currentLog] writeWithObject:self selector:_cmd text:@(timeout).stringValue logLevel:DEBUG_L];
    [self.publisherAPI setConnectionData:[PublisherConnectionData get]];
    [status clear];
    [self refreshTimer:timeout];
}

-(void)refreshStatus:(ActionResult*)result
{
    status.errorText = result.error;
    status.info = result.data;
    [status setProgress:100];
}

-(void)updateSyncTimestamp
{
    NSInteger currentTime = [NSDate date].timeIntervalSince1970;
    [[NSUserDefaults standardUserDefaults] setInteger:currentTime forKey:CENTRAL_LAST_SYNC_TIMESTAMP_KEY];
}

-(NSInteger)getTimeToSync
{
    NSInteger currentTime = [NSDate date].timeIntervalSince1970;
    NSInteger lastSyncTimestamp = [[NSUserDefaults standardUserDefaults] integerForKey:CENTRAL_LAST_SYNC_TIMESTAMP_KEY];
    NSInteger summ = currentTime - lastSyncTimestamp;
    return (summ >= timeout || lastSyncTimestamp == 0) ? 0 : (timeout - summ);
}

-(void)refreshTimer:(NSInteger)time
{
    if (isAutoSync)
    {
        if (autoSyncTimer.isValid)
            [autoSyncTimer invalidate];
        autoSyncTimer = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(run) userInfo:nil repeats:NO];
    }
    else
        status.isProcessing = NO;
}

#pragma mark - Queue Methods
-(void)addOperation:(NSInteger)waitingTime
     backgroundFlag:(BOOL)isBackground
             target:(id)target
            perform:(SEL)perform
{
    [self addOperation:waitingTime backgroundFlag:isBackground completion:^
    {
        ((void (*)(id, SEL))[target methodForSelector:perform])(target, perform);
    }];
}

-(void)addOperation:(NSInteger)waitingTime
     backgroundFlag:(BOOL)isBackground
         completion:(void(^)(void))completion
{
    BlockOperationDelay *operation = [BlockOperationDelay build:waitingTime completion:completion];
    operation.name = [status getProgressTitle];
    operation.queuePriority = isBackground ? NSOperationQueuePriorityVeryLow : NSOperationQueuePriorityVeryHigh;
    operation.qualityOfService = isBackground ? NSQualityOfServiceBackground : NSQualityOfServiceUserInteractive;
    [operationQueue addOperation:operation];
}

-(instancetype)welf
{
    __typeof(self) __weak welf = self;
    return welf;
}

@end
