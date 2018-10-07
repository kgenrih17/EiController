//
//  NetworkSettingsViewModel.h
//  EiController
//
//  Created by Genrih Korenujenko on 22.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkSettings.h"

typedef NS_ENUM(NSInteger, ENetworkViewMode)
{
    ETHERNET_MODE = 0,
    WIFI_MODE
};

@interface NetworkSettingsViewModel : NSObject

@property (nonatomic, readwrite, strong) NetworkSettings *settings;
@property (nonatomic, readwrite, strong) NetworkSettings *tempSettings;
@property (nonatomic, readwrite, strong) NSDictionary *securityProtocols;
@property (nonatomic, readwrite) NSInteger selectedProtocolIndex;
@property (nonatomic, readwrite) ENetworkViewMode viewMode;

@end
