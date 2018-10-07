//
//  ServerIntegratorInterface.h
//  EiController
//
//  Created by Genrih Korenujenko on 20.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "ServerIntegratorListener.h"
#import "CentralConnectionData.h"
#import "ScheduleStorageInterface.h"
#import "CentralConnectTrackerObserverInterface.h"

#import "EiController-Swift.h"

@protocol ServerIntegratorInterface <NSObject>

@property (nonatomic, readwrite, weak) id <INodeStorage> deviceStorage;
@property (nonatomic, readwrite, weak) id <ScheduleStorageInterface> scheduleStorage;
@property (nonatomic, readwrite, weak) id <CentralConnectTrackerObserverInterface> trackerObserver;
@property (nonatomic, readwrite, weak) id <ServerIntegratorListener> listener;

@required
+(instancetype)build:(CentralConnectionData*)connectionData
       deviceStorage:(id<INodeStorage>)deviceStorage
     scheduleStorage:(id<ScheduleStorageInterface>)scheduleStorage
             tracker:(id<CentralConnectTrackerObserverInterface>)tracker
            listener:(id<ServerIntegratorListener>)listener;
-(void)start;
-(void)stop;
-(void)deinit;
-(void)run;
-(void)setTimeout:(NSInteger)timeout;
-(void)setNotifyFlag:(BOOL)isNotify;
-(void)setAutoStartFlag:(BOOL)isAuto;
-(void)clearOldLogs;

@end
