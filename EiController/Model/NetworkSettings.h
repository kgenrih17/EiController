//
//  NetworkSettings.h
//  EiController
//
//  Created by admin on 2/23/16.
//  Copyright © 2016 RadicalComputing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPSettings.h"

typedef NS_ENUM(NSInteger, EWiFiSecurityProtocol)
{
    NONE_PROTOCOL = 0,
    WEP_PROTOCOL,
    WPA_PSK_PROTOCOL,
    WPA_2_EAP_PROTOCOL
};

@interface NetworkSettings : NSObject <NSCopying>

/// The time of the last synchronization of network settings.
@property (nonatomic, readwrite) NSInteger lastSyncTimestamp;

@property (nonatomic, readwrite, strong) NSString *dns1;
@property (nonatomic, readwrite, strong) NSString *dns2;
@property (nonatomic, readwrite, strong) NSString *dns3;

/// Ethernet
@property (nonatomic) NSInteger ipdhcp;
@property (nonatomic, readwrite, strong) IPSettings *ethernetIP;

/// WI-FI
@property (nonatomic) NSInteger wifiEnabled;
@property (nonatomic) NSInteger wifiPreferred;
@property (nonatomic) NSInteger wifiIpdhcp1;

@property (nonatomic, strong) NSString *wifiSsid;
@property (nonatomic, strong) NSString *wifiSecurityProtocol;
@property (nonatomic, strong) NSString *wifiAuthIdentity;
@property (nonatomic, strong) NSString *wifiAuthKey;
@property (nonatomic, strong) NSString *wifiAuthPassword;
@property (nonatomic, strong) NSString *wifiAuthPrivateKeyPassword;

@property (nonatomic, readwrite, strong) IPSettings *wifiIP;

@end


