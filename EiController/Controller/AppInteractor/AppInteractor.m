//
//  AppInteractor.m
//  EiController
//
//  Created by Genrih Korenujenko on 13.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "AppInteractor.h"
#import "PublisherConnectionData.h"
#import "Navigation.h"
#import "UserDefaultsKeys.h"
#import "User.h"
#import "AuthManager.h"

#import "ServerIntegrator.h"
#import "DeviceIntegrator.h"

#import "DevicesDiscovery.h"
#import "StorageCleaner.h"

#import "DevicesChangerInterface.h"

#import "ServerLogsTable.h"
#import "DeviceSyncStatusesTable.h"
#import "DownloadFileStatusesTable.h"
#import "UploadFileStatusesTable.h"
#import "ScheduleFilesTable.h"
#import "ApplicationsTable.h"

#import "ScheduleStorage.h"

#import "EiController-Swift.h"

@interface AppInteractor () <INodeStorageListener, ScheduleStorageListener, CentralConnectTrackerObserverInterface, ServerIntegratorListener, DeviceIntegratorListener, AuthManagerListener>
{
    AuthManager *authManager;
    StorageCleaner *storageCleaner;
    Reachability *reachability;
    NodeStorage *nodeStorage;
    ScheduleStorage *scheduleStorage;
    ApplicationsTable *applicationStorage;
    DeviceSyncStatusesTable *deviceSyncStatusesTable;
    ServerIntegrator *serverIntegrator;
    DeviceIntegrator *deviceIntegrator;
    DevicesDiscovery *devicesDiscovery;
    
    CentralConnectionData *connectionData;
    ConnectionData *publisherConnectionData;
    
    NSMutableArray <id <DevicesChangerInterface>> *observers;
    NSMutableArray <id <DeviceSyncListener>> *syncListeners;
    NSMutableArray <id <ServerIntegratorListener>> *serverIntegratorListeners;
    id <AuthObserverInterface> authObserver;
    
    BOOL isFirstStart;
}
@end

@implementation AppInteractor

@synthesize nodeStorageInterface;

#pragma mark - Init
-(instancetype)init
{
    self = [super init];
    
    if (self)
    {
        isFirstStart = YES;
        connectionData = [CentralConnectionData get];
        authManager = [AuthManager build:self connectionData:connectionData];
        storageCleaner = [StorageCleaner new];
        reachability = [Reachability reachabilityForInternetConnection];
        nodeStorage = [[NodeStorage alloc] buildWithStorageCleaner:storageCleaner];
        scheduleStorage = [ScheduleStorage new];
        applicationStorage = [ApplicationsTable new];
        deviceSyncStatusesTable = [DeviceSyncStatusesTable new];
        devicesDiscovery = [DevicesDiscovery new];
    }
    
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - AppInteractorInterface
-(id<INodeStorage>)nodeStorageInterface
{
    return nodeStorage;
}

-(void)start
{
    [authManager auth];
}

-(void)stop
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    [reachability stopNotifier];
    [nodeStorage removeAllObservers];
    scheduleStorage.listener = nil;
    [serverIntegrator stop];
    [serverIntegrator deinit];
    serverIntegrator = nil;
    [deviceIntegrator stop];
    [deviceIntegrator deinit];
    deviceIntegrator = nil;
    [devicesDiscovery stop];
    connectionData = nil;
    [observers removeAllObjects];
    observers = nil;
    [syncListeners removeAllObjects];
    syncListeners = nil;
    [serverIntegratorListeners removeAllObjects];
    serverIntegratorListeners = nil;
    [authManager prepareForLogout];
}

-(void)findLocalDevice
{
    [devicesDiscovery searchDevices:^(NSArray *result, NSString *error)
    {
        if (error != nil)
        {
            for (id <DevicesChangerInterface> observer in observers)
                [observer userDevicesUpdated];
        }
        else
            [nodeStorage setLocalDevices:result];
        [self restoreSynchronization];
        [devicesDiscovery stop];
    }];
}

-(id<CentralAPIInterface>)getCentralAPI
{
    return [EiCentralAPI new];
}

-(id<RequestSenderInterface>)getRequestSender
{
    return (id<RequestSenderInterface>)[RequestSender new];
}

-(id<INodeStorage>)getNodeStorage
{
    return nodeStorage;
}

-(id<AuthManagerInterface>)getAuthManager
{
    return authManager;
}

-(void)addObserver:(id<DevicesChangerInterface>)observerInterface
{
    [observers addObject:observerInterface];
}

-(void)removeObserver:(id<DevicesChangerInterface>)observerInterface
{
    [observers removeObject:observerInterface];
}

-(void)addNodeSyncListener:(id<DeviceSyncListener>)listener
{
    [syncListeners addObject:listener];
}

-(void)removeNodeSyncListener:(id<DeviceSyncListener>)listener
{
    [syncListeners removeObject:listener];
}

-(void)addCentralIntegratorListener:(id<ServerIntegratorListener>)listener
{
    [serverIntegratorListeners addObject:listener];
}

-(void)removeCentralIntegratorListener:(id<ServerIntegratorListener>)listener
{
    [serverIntegratorListeners removeObject:listener];
}

-(NSArray<NSString*>*)getfingerprintsReadyToBeUpdated
{
    NSArray *scheduleFingerprints = [[scheduleStorage getNotUpload] valueForKey:pNameForClass(Schedule, fingerprint)];
    NSArray *applicationFingerprints = [[applicationStorage getNotUpload] valueForKey:pNameForClass(Schedule, fingerprint)];
    NSMutableSet *setFingerprints = [NSMutableSet new];
    [setFingerprints addObjectsFromArray:scheduleFingerprints];
    [setFingerprints addObjectsFromArray:applicationFingerprints];
    NSArray *deviceFingerprints = [[nodeStorage getLocalDevices] valueForKey:pNameForClass(Device, fingerprint)];
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings)
    {
        return [deviceFingerprints containsObject:evaluatedObject];
    }];
    return [setFingerprints.allObjects filteredArrayUsingPredicate:predicate];
}

-(EUserLevel)getUserLevel
{
    return [authManager getLoggedUser].level;
}

-(void)syncWithNode:(NSArray<NSString*>*)fingerprints
{
    NSArray *fingerprintsReadyToBeUpdated = [self getfingerprintsReadyToBeUpdated];
    NSMutableArray *filteredFingerprints = [NSMutableArray new];
    for (NSString *finger in fingerprints)
    {
        if ([fingerprintsReadyToBeUpdated containsObject:finger])
            [filteredFingerprints addObject:finger];
    }
    [deviceIntegrator start:filteredFingerprints];
}

-(void)refreshServerIntegratorSettings
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [serverIntegrator setTimeout:[userDefaults integerForKey:CENTRAL_SYNC_TIMEOUT_KEY]];
    [serverIntegrator setNotifyFlag:[userDefaults boolForKey:CENTRAL_SYNC_STATUS_KEY]];
    [serverIntegrator setAutoStartFlag:[userDefaults boolForKey:CENTRAL_AUTO_SYNC_KEY]];
}

-(void)syncWithCentral
{
    [serverIntegrator run];
}

#pragma mark - AuthManagerListener
-(void)authWithStatus:(EAuthStatus)status
{
    switch (status)
    {
        case OFFLINE_AUTH:
        case ONLINE_AUTH:
            [self runModuls];
            break;
            
        case NON_AUTH:
            [authObserver showAuthScreen];
            break;
    }
}

-(void)authError:(NSString*)error
{
    [authObserver showAuthScreen];
    [self.navigation showAlertWithTitle:nil message:error];
}

#pragma mark - AuthInterface
-(void)authIsSuccessful
{
    if (AppStatus.isExtendedMode)
    {
        connectionData = [CentralConnectionData get];
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:CENTRAL_LAST_SYNC_TIMESTAMP_KEY];
    }
    else
        connectionData = nil;
    [self runModuls];
}

-(void)updateSyncSettings
{
    [self refreshServerIntegratorSettings];
}

-(void)logout
{
    [self restartWithBlock:^{
        connectionData = [CentralConnectionData get];
    }];
}

-(void)setAuthObserver:(id<AuthObserverInterface>)newAuthObserver
{
    authObserver = newAuthObserver;
}

-(void)removeAuth
{
    authObserver = nil;
}

#pragma mark - INodeStorageListener
-(void)devicesUpdated
{
    NSMutableDictionary *userDevices = [self prepareUserDevices];
    [nodeStorage setLiveDevices:userDevices];
    for (id <DevicesChangerInterface> observer in observers)
        [observer userDevicesUpdated];
}

-(void)devicesNotUpdated
{
    for (id <DevicesChangerInterface> observer in observers)
        [observer userDevicesNotUpdated];
}

#pragma mark - ScheduleStorageListener
-(void)previousScheduleFoundFor:(NSString*)fingerprint;
{
    [deviceIntegrator stop];
    [storageCleaner clearDataForNewSchedule:fingerprint];
}

#pragma mark - Private Methods
-(void)runModuls
{
    observers = [NSMutableArray new];
    syncListeners = [NSMutableArray new];
    serverIntegratorListeners = [NSMutableArray new];
    [nodeStorage addObserver:self];
    scheduleStorage.listener = self;
    [self clearLogs];
    [self initDeviceIntegrator];
    if (AppStatus.isExtendedMode)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeInternetConnection:) name:kReachabilityChangedNotification object:nil];
        [reachability startNotifier];
        [self performSelector:@selector(initServerIntegrator) withObject:nil afterDelay:0.1];
        [self.navigation setShowServerConnection:YES];
        [self.navigation setBackgroundColor:[UIColor colorWithRed:0.973 green:0.973 blue:0.973 alpha:1]];
    }
    else
    {
        [self.navigation setShowServerConnection:NO];
        [self.navigation setBackgroundColor:[UIColor colorWithRed:0.137 green:0.133 blue:0.165 alpha:1]];
    }
    [authObserver showNodesListScreen];
    [nodeStorage performSelector:@selector(load) withObject:nil afterDelay:0.1];
}

-(void)initDeviceIntegrator
{
    deviceIntegrator = [DeviceIntegrator build:scheduleStorage
                                 deviceStorage:nodeStorage
                           deviceStatusStorage:deviceSyncStatusesTable
                                      listener:self];
}

-(void)initServerIntegrator
{
    serverIntegrator = [ServerIntegrator build:connectionData
                                 deviceStorage:nodeStorage
                               scheduleStorage:scheduleStorage
                                       tracker:self
                                      listener:self];
    [self refreshServerIntegratorBy:[reachability currentReachabilityStatus]];
}

-(void)refreshServerIntegratorBy:(NetworkStatus)networkStatus
{
    switch (networkStatus)
    {
        case ReachableViaWiFi:
        case ReachableViaWWAN:
        {
            [self refreshServerIntegratorSettings];
            [serverIntegrator start];
        }
            break;
            
        case NotReachable:
        {
            [serverIntegrator stop];
            [self serverSyncError:@"No internet connection"];
        }
            break;
    }
}

-(NSMutableDictionary*)prepareUserDevices
{
    NSMutableDictionary *devices = [NSMutableDictionary new];
    NSArray *centralDevices = [nodeStorage getCentralDevices];
    NSArray *localDevices = [nodeStorage getLocalDevices];
    NSMutableArray *allDevices = [NSMutableArray new];
    [allDevices addObjectsFromArray:centralDevices];
    [allDevices addObjectsFromArray:localDevices];
    NSArray *fingerprints = [allDevices valueForKey:pNameForClass(Device, fingerprint)];
    NSDictionary *syncStatuses = [deviceSyncStatusesTable getByFingerprints:fingerprints];
    
    for (Device *device in allDevices)
    {
        [self determineStatusOfDevice:device centralDevices:centralDevices localDevice:localDevices];
        BOOL isValidStatus = [self isValidDeviceStatus:device forUserLevel:[self getUserLevel]];
        if (isValidStatus)
        {
            device.syncStatus = [syncStatuses objectForKey:device.fingerprint];
            Device *containtDevice = [devices objectForKey:device.fingerprint];
            
            if (containtDevice != nil && [localDevices containsObject:containtDevice])
            {
                Device *localDevice = localDevices[[localDevices indexOfObject:containtDevice]];
                NSInteger centralIndex = [centralDevices indexOfObject:containtDevice];
                if (centralIndex != NSNotFound)
                {
                    Device *centralDevice = centralDevices[centralIndex];
                    [self combiningDeviceData:localDevice centralDevice:centralDevice];
                }
                else
                    containtDevice.syncStatus = device.syncStatus;
                [devices setObject:localDevice forKey:device.fingerprint];
            }
            else
            {
                containtDevice.syncStatus = device.syncStatus;
                [devices setObject:device forKey:device.fingerprint];
            }
        }
    }
    
    return devices;
}

-(void)combiningDeviceData:(Device*)localDevice centralDevice:(Device*)centralDevice
{
    if (localDevice.esIntegrInfo == nil)
        localDevice.esIntegrInfo = centralDevice.esIntegrInfo;
    if (localDevice.netSettings == nil)
        localDevice.netSettings = centralDevice.netSettings;
    if (localDevice.modeConfiguration == nil)
        localDevice.modeConfiguration = centralDevice.modeConfiguration;
    if (localDevice.syncStatus == nil)
        localDevice.syncStatus = centralDevice.syncStatus;
    if (localDevice.sid == nil)
        localDevice.sid = centralDevice.sid;
    if (localDevice.sn == nil)
        localDevice.sn = centralDevice.sn;
    if (localDevice.version == nil)
        localDevice.version = centralDevice.version;
    if (localDevice.edition == nil)
        localDevice.edition = centralDevice.edition;
    if (localDevice.model == nil)
        localDevice.model = centralDevice.model;
    if (localDevice.company == nil)
        localDevice.company = centralDevice.company;
    if (localDevice.timezone == nil)
        localDevice.timezone = centralDevice.timezone;
    if (localDevice.address == nil || localDevice.address.isEmpty)
        localDevice.address = centralDevice.address;
    if (localDevice.host == nil)
        localDevice.host = centralDevice.host;
    if (localDevice.port == 0)
        localDevice.port = centralDevice.port;
    localDevice.title = centralDevice.title;
}

-(void)determineStatusOfDevice:(Device*)device
                centralDevices:(NSArray*)centralDevices
                   localDevice:(NSArray*)localDevices
{
    if ([[centralDevices valueForKey:pNameForClass(Device, fingerprint)] containsObject:device.fingerprint] &&
        [[localDevices valueForKey:pNameForClass(Device, fingerprint)] containsObject:device.fingerprint])
        device.status = CENTRAL_AND_LOCAL_STATUS;
    else if ([[centralDevices valueForKey:pNameForClass(Device, fingerprint)] containsObject:device.fingerprint])
        device.status = CENTRAL_STATUS;
    else if ([[localDevices valueForKey:pNameForClass(Device, fingerprint)] containsObject:device.fingerprint])
        device.status = LOCAL_STATUS;
}

-(BOOL)isValidDeviceStatus:(Device*)device forUserLevel:(EUserLevel)level
{
    BOOL isValidStatus = NO;
    switch (level)
    {
        case USER_LEVEL:
            isValidStatus = (device.status == CENTRAL_AND_LOCAL_STATUS);
            break;
            
        case ADMIN_LEVEL:
            isValidStatus = YES;
            break;
    }
    return isValidStatus;
}

-(void)clearLogs
{
    [deviceIntegrator clearOldLogs];
    [serverIntegrator clearOldLogs];
}

-(void)restartWithBlock:(void(^)(void))block
{
    [self stop];
    BLOCK_SAFE_RUN(block);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self start];
    });
}

-(void)restoreSynchronization
{
    if (isFirstStart)
    {
        isFirstStart = NO;
        NSArray *syncStatuses = [deviceSyncStatusesTable getWithProgressWaitingAndSync];
        if (!syncStatuses.isEmpty)
            [deviceIntegrator start:[syncStatuses valueForKey:pNameForClass(DeviceSyncStatus, fingerprint)]];
    }
}

#pragma mark - kReachabilityChangedNotification
-(void)changeInternetConnection:(NSNotification*)notification
{
    Reachability *reach = notification.object;
    [self refreshServerIntegratorBy:[reach currentReachabilityStatus]];
}

#pragma mark - ServerIntegratorListener
-(void)serverSyncChangeProgress:(CGFloat)progress withMessage:(NSString*)message
{
    for (id <ServerIntegratorListener> listener in serverIntegratorListeners)
        [listener serverSyncChangeProgress:progress withMessage:message];
}

-(void)serverSyncError:(NSString*)error
{
    for (id <ServerIntegratorListener> listener in serverIntegratorListeners)
        [listener serverSyncError:error];
}

-(void)serverSyncWillStart
{
    for (id <ServerIntegratorListener> listener in serverIntegratorListeners)
    {
        if ([listener respondsToSelector:@selector(serverSyncWillStart)])
            [listener serverSyncWillStart];
    }
}

-(void)serverSyncDidEnd
{
    publisherConnectionData = [PublisherConnectionData get];
    for (id <ServerIntegratorListener> listener in serverIntegratorListeners)
    {
        if ([listener respondsToSelector:@selector(serverSyncDidEnd)])
            [listener serverSyncDidEnd];
    }
}

#pragma mark - DeviceIntegratorListener
-(void)deviceSyncWillStartFor:(NSString*)fingerprint
{
    Device *device = [nodeStorage getDevicesByFingerprints:@[fingerprint]].firstObject;
    device.syncStatus.processing = SYNCHRONIZING;
    device.syncStatus.message = @"SYNCHRONIZATION...";
    dispatch_async(dispatch_get_main_queue(), ^{
        for (id <DeviceSyncListener> syncListener in syncListeners)
            [syncListener startSync:fingerprint];
    });
}

-(void)deviceSyncChangeProgress:(CGFloat)progress withMessage:(NSString*)message fingerprint:(NSString *)fingerprint
{
    Device *device = [nodeStorage getDeviceByFingerprint:fingerprint];
    device.syncStatus.lastTimestamp = [NSDate date].timeIntervalSince1970;
    for (id <DeviceSyncListener> syncListener in syncListeners)
        [syncListener syncChangeProgress:progress withMessage:message];
}

-(void)deviceSyncError:(NSString*)error fingerprint:(NSString *)fingerprint
{
    Device *device = [nodeStorage getDevicesByFingerprints:@[fingerprint]].firstObject;
    device.syncStatus.processing = ERROR_SYNC;
    device.syncStatus.lastTimestamp = [NSDate date].timeIntervalSince1970;
    device.syncStatus.message = error;
    for (id <DeviceSyncListener> syncListener in syncListeners)
        [syncListener syncError:error fingerprint:fingerprint];
    [deviceSyncStatusesTable update:device.syncStatus];
}

-(void)deviceSyncDidEnd:(NSString*)fingerprint
{
    Device *device = [nodeStorage getDevicesByFingerprints:@[fingerprint]].firstObject;
    device.syncStatus.processing = END_SYNC;
    device.syncStatus.lastTimestamp = [NSDate date].timeIntervalSince1970;
    NSString *dateString = [NSString getStringFromDate:[NSDate date] dateFormate:@"yyyy/MM/dd hh:mm:ss" forLocal:[NSString localUS]];
    device.syncStatus.message = [NSString stringWithFormat:@"LAST SYNC ATTEMPT: %@", dateString];
    for (id <DeviceSyncListener> syncListener in syncListeners)
        [syncListener endSync:fingerprint];
    [deviceSyncStatusesTable update:device.syncStatus];
}

-(void)deviceSyncDidEnd
{
    for (id <DeviceSyncListener> syncListener in syncListeners)
    {
        if ([syncListener respondsToSelector:@selector(syncToCentralComplete)])
            [syncListener syncToCentralComplete];
    }
}

#pragma mark - CentralConnectTrackerObserverInterface
-(void)changeConnectionTo:(BOOL)isStable
{
    [self.navigation changeConnection:connectionData.url.absoluteString connectStable:isStable];
}

@end
