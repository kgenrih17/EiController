//
//  IPSettings.m
//  EiController
//
//  Created by Genrih Korenujenko on 29.03.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#import "IPSettings.h"

static NSString * const IPv4_KEY = @"Ipv4";
static NSString * const IPv6_KEY = @"Ipv6";

@implementation IPSettings

@synthesize versionType;

#pragma mark - Public Init Methods
+(instancetype)build:(NSString*)address
             netmask:(NSString*)netmask
             gateway:(NSString*)gateway
             version:(NSString*)version
{
    IPSettings *result = [IPSettings new];
    result.address = address;
    result.netmask = netmask;
    result.gateway = gateway;
    result.version = version;
    return result;
}

#pragma mark - Override Methods
-(EIPVersionType)versionType
{
    return [self.version isEqualToString:IPv4_KEY] ? IP4_VERSION_TYPE : IP6_VERSION_TYPE;
}

-(void)setVersionType:(EIPVersionType)versionType
{
    self.address = @"";
    self.netmask = @"";
    self.gateway = @"";
    self.version = (versionType == IP4_VERSION_TYPE) ? IPv4_KEY : IPv6_KEY;
}

-(BOOL)isEqual:(id)object
{
    if (![[object class] isSubclassOfClass:[NetworkSettings class]])
        return NO;
    
    IPSettings *compareObject = (IPSettings*)object;
    
    if(![NSString compareStrings:self.address secondString:compareObject.address])
        return NO;
    
    if(![NSString compareStrings:self.netmask secondString:compareObject.netmask])
        return NO;
    
    if(![NSString compareStrings:self.gateway secondString:compareObject.gateway])
        return NO;
    
    if(![NSString compareStrings:self.version secondString:compareObject.version])
        return NO;

    return YES;
}

#pragma mark - NSCopying
-(id)copyWithZone:(NSZone *)zone
{
    IPSettings *object = [IPSettings new];
    object.address = self.address;
    object.netmask = self.netmask;
    object.gateway = self.gateway;
    object.version = self.version;
    return object;
}

@end
