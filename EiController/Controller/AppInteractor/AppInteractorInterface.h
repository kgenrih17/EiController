//
//  AppInteractorInterface.h
//  EiController
//
//  Created by Genrih Korenujenko on 13.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DevicesChangerInterface.h"
#import "DeviceSyncListener.h"
#import "ServerIntegratorListener.h"
#import "AuthManagerInterface.h"
#import "EUserLevel.h"
#import "RequestSenderInterface.h"
#import "CentralAPIInterface.h"
#import "StorageInterface.h"

@protocol AppInteractorInterface <NSObject>

@property (nonatomic, readwrite, weak) id nodeStorageInterface;

@required
-(void)findLocalDevice;
/// for swift classes
-(id<CentralAPIInterface>)getCentralAPI;
-(id<RequestSenderInterface>)getRequestSender;

///
-(id<AuthManagerInterface>)getAuthManager;

-(void)addObserver:(id<DevicesChangerInterface>)observerInterface;
-(void)removeObserver:(id<DevicesChangerInterface>)observerInterface;

-(void)addNodeSyncListener:(id<DeviceSyncListener>)listener;
-(void)removeNodeSyncListener:(id<DeviceSyncListener>)listener;

-(void)addCentralIntegratorListener:(id<ServerIntegratorListener>)listener;
-(void)removeCentralIntegratorListener:(id<ServerIntegratorListener>)listener;

-(NSArray<NSString*>*)getfingerprintsReadyToBeUpdated;
-(EUserLevel)getUserLevel;

-(void)syncWithNode:(NSArray<NSString*>*)fingerprints;
-(void)refreshServerIntegratorSettings;
-(void)syncWithCentral;

@end
