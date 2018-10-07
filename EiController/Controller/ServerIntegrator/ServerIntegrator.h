//
//  ServerIntegrator.h
//  EiController
//
//  Created by Genrih Korenujenko on 20.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "ServerIntegratorInterface.h"
#import "ServerLogStorageInterface.h"
#import "ActionListener.h"
#import "UpdateDeviceActionListener.h"
#import "CentralConnectTracker.h"
#import "EiCentralAPI.h"
#import "PublisherAPI.h"
#import "PublisherConnectionData.h"
#import "ServerActionStatus.h"

@interface ServerIntegrator : NSObject <ServerIntegratorInterface, ActionListener, UpdateDeviceActionListener>
{
    __strong NSOperationQueue *operationQueue;
    ServerActionStatus *status;
    NSMutableArray *actions;
    NSInteger actionIndex;
    NSInteger timeout;
    NSTimer *autoSyncTimer;
    BOOL isStarted;
    BOOL isNotifyListener;
    BOOL isAutoSync;
    
    id <ServerLogStorageInterface> serverLogStorage;
}

@property (nonatomic, readonly, strong) CentralConnectTracker *connectTracker;
@property (nonatomic, readwrite, strong) EiCentralAPI *api;
@property (nonatomic, readwrite, strong) PublisherAPI *publisherAPI;
@property (nonatomic, readwrite, strong) CentralConnectionData *connectionData;

@end
