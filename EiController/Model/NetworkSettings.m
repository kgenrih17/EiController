//
//  NetworkSettings.m
//  EiController
//
//  Created by admin on 2/23/16.
//  Copyright © 2016 RadicalComputing. All rights reserved.
//

#import "NetworkSettings.h"

@implementation NetworkSettings

#pragma mark - NSCopying
-(id)copyWithZone:(NSZone *)zone
{
    NetworkSettings *object = [NetworkSettings new];
    
    object.dns1 = [self.dns1 copy];
    object.dns2 = [self.dns2 copy];
    object.dns3 = [self.dns3 copy];

    //for ethernet
    object.ipdhcp = self.ipdhcp;
    object.ethernetIP = [self.ethernetIP copy];
    
    //for wi-fi
    object.wifiEnabled = self.wifiEnabled;
    object.wifiPreferred = self.wifiPreferred;
    object.wifiIpdhcp1 = self.wifiIpdhcp1;
    object.wifiSsid = [self.wifiSsid copy];
    object.wifiSecurityProtocol = [self.wifiSecurityProtocol copy];
    object.wifiAuthKey = [self.wifiAuthKey copy];
    object.wifiAuthPassword = [self.wifiAuthPassword copy];
    object.wifiAuthPrivateKeyPassword = [self.wifiAuthPrivateKeyPassword copy];
    object.wifiIP = [self.wifiIP copy];
    
    return object;
}

#pragma mark - Override Methods
-(BOOL)isEqual:(id)object
{
    if (![[object class] isSubclassOfClass:[NetworkSettings class]])
        return NO;
    
    NetworkSettings *compareObject = (NetworkSettings*)object;
    
    if(![NSString compareStrings:self.dns1 secondString:compareObject.dns1])
        return NO;

    if(![NSString compareStrings:self.dns2 secondString:compareObject.dns2])
        return NO;

    if(![NSString compareStrings:self.dns3 secondString:compareObject.dns3])
        return NO;

    //for ethernet
    if(self.ipdhcp != compareObject.ipdhcp)
        return NO;
    
    if(![self.ethernetIP isEqual:compareObject.ethernetIP])
        return NO;
    
    //for wi-fi
    if(self.wifiEnabled != compareObject.wifiEnabled)
        return NO;
    
    if(self.wifiPreferred != compareObject.wifiPreferred)
        return NO;
    
    if(self.wifiIpdhcp1 != compareObject.wifiIpdhcp1)
        return NO;
    
    if(![NSString compareStrings:self.wifiSsid secondString:compareObject.wifiSsid])
        return NO;
    
    if(![NSString compareStrings:self.wifiSecurityProtocol secondString:compareObject.wifiSecurityProtocol])
        return NO;
    
    if(![NSString compareStrings:self.wifiAuthIdentity secondString:compareObject.wifiAuthIdentity])
        return NO;
    
    if(![NSString compareStrings:self.wifiAuthKey secondString:compareObject.wifiAuthKey])
        return NO;
    
    if(![NSString compareStrings:self.wifiAuthPassword secondString:compareObject.wifiAuthPassword])
        return NO;
    
    if(![NSString compareStrings:self.wifiAuthPrivateKeyPassword secondString:compareObject.wifiAuthPrivateKeyPassword])
        return NO;
    
    if(![self.wifiIP isEqual:compareObject.wifiIP])
        return NO;

    return YES;
}

@end
