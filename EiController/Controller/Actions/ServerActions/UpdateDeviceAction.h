//
//  UpdateApplianceAction.h
//  EiController
//
//  Created by Genrih Korenujenko on 20.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "ActionInterface.h"
#import "UpdateDeviceActionListener.h"
#import "CentralAPIInterface.h"
#import "EiController-Swift.h"

@interface UpdateDeviceAction : NSObject <ActionInterface>

@property (nonatomic, readonly, strong) UpdateDeviceValidator *validator;
@property (nonatomic, readwrite, weak) id <CentralAPIInterface> api;
@property (nonatomic, readwrite, weak) id <INodeStorage> storage;
@property (nonatomic, readwrite, weak) id <UpdateDeviceActionListener> listener;

+(instancetype)build:(id<CentralAPIInterface>)api
             storage:(id<INodeStorage>)storage
            listener:(id<UpdateDeviceActionListener>)listener;

@end
