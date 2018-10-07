//
//  AppliancesDiscovery.m
//  TestProj
//
//  Created by admin on 2/16/16.
//  Copyright © 2016 RadicalComputing. All rights reserved.
//

#define kWebServiceType @"_http._tcp."
#define kInitialDomain  @"local."
#define kServicePort  80
#define kServiceName  @"iPhone 6"

#import "DevicesDiscovery.h"
#import "Device.h"
#include <arpa/inet.h>

@interface DevicesDiscovery() <NSNetServiceBrowserDelegate, NSNetServiceDelegate>
{
    NSNetServiceBrowser *netServiceBrowser;
    NSNetService *currentResolve;
    
    NSMutableArray *services;
    NSMutableArray *devices;
    NSMutableDictionary *devicesTemp;
    
    CompletionBlock complation;
    
    NSString *myId;
    
    NSMutableArray *peers;
}
@end

@implementation DevicesDiscovery

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        services = [NSMutableArray new];
        devices = [NSMutableArray new];
        devicesTemp = [NSMutableDictionary new];
        peers = [NSMutableArray new];
        
        myId = [NSUUID UUID].UUIDString;
    }
    
    return self;
}

-(void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

-(void)searchDevices:(CompletionBlock)_complation;
{
    [self recreateAndPrepare];
    complation = _complation;
    
    [self performSelector:@selector(stopSearchByTimeout) withObject:nil afterDelay:10.f];
    [netServiceBrowser searchForServicesOfType:kWebServiceType inDomain:kInitialDomain];
}

-(void)stop
{
    complation = nil;
    [self recreateAndPrepare];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

-(void)stopSearchByTimeout
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [netServiceBrowser stop];
#warning TODO hvk: for test
    [self addTestDevices];
    complation(devices, nil);
//        if (devices.count == 0)
//            complation(nil, @"Cant find devices");
//        else
//            complation(devices, nil);
}

-(void)addTestDevices
{
    //        Device *device = [Device new];
    //        device.fingerprint = @"f667c935b7c38d6ff53cb9644ee11ff8";
    //        device.title = @"222";
    //        device.sn = @"12322146772";
    //        device.model = @"m10";
    //        device.port = 80;
    //        device.host = @"192.168.101.222";
    //        device.address = @"192.168.101.222";
    //        [devices addObject:device];
    //
    //        Device *device2 = [Device new];
    //        device2.fingerprint = @"87f215d19bf9e81decd06d5f5f26db66";
    //        device2.title = @"113";
    //        device2.sn = @"88822146772";
    //        device2.model = @"m10_7";
    //        device2.port = 80;
    //        device2.host = @"192.168.101.113";
    //        device2.address = @"192.168.101.113";
    //        [devices addObject:device2];
    //
//    Device *device3 = [Device new];
//    device3.fingerprint = @"2377c33bb304630fea60b92c0bf972cc";
//    device3.title = @".159";
//    device3.model = @"eic100";
//    device3.address = @"192.168.101.159";
//    device3.version = @"4.0.2.p1";
//    [devices addObject:device3];
    //
    //    Device *device4 = [Device new];
    //    device4.fingerprint = @"914ca5a6dbef9a424b7963ff45d410a2";
    //    device4.title = @"192.168.101.142";
    //    device4.sn = @"45756876861";
    //    device4.model = @"m12";
    //    device4.port = 80;
    //    device4.host = @"192.168.101.142";
    //    device4.address = @"192.168.101.142";
    //    [devices addObject:device4];
    //
    //    Device *device5 = [Device new];
    //    device5.fingerprint = @"33c4e557d2d0891fcddc8ca3152b6181";
    //    device5.title = @"m12_7";
    //    device5.sn = @"224141534352";
    //    device5.model = @"m12_7";
    //    device5.port = 80;
    //    device5.host = @"192.168.101.131";
    //    device5.address = @"192.168.101.131";
    //    [devices addObject:device5];
    //
    //    Device *device6 = [Device new];
    //    device6.fingerprint = @"02757bbc9c63b5364701c66a8d86b2bc";
    //    device6.title = @"192.168.101.203";
    //    device6.sn = @"1312as3123123";
    //    device6.model = @"m12_10";
    //    device6.port = 80;
    //    device6.host = @"192.168.101.203";
    //    device6.address = @"192.168.101.203";
    //    [devices addObject:device6];
    //
    //    Device *device7 = [Device new];
    //    device7.fingerprint = @"c6bd612d32e1b4f7af05d385ee96c0be";
    //    device7.title = @"iPad";
    //    device7.sn = @"13123123123";
    //    device7.model = @"iPad";
    //    device7.port = 80;
    //    device7.host = @"192.168.101.139";
    //    device7.address = @"192.168.101.139";
    //    [devices addObject:device7];
    //
//
    Device *device8 = [Device new];
    device8.fingerprint = @"004ea82006d629fd9bce1d2db974f455";
    device8.title = @".150.54";
    device8.sn = @"EiC30003";
    device8.model = @"eic100";
    device8.address = @"192.168.150.54";
    device8.version = @"4.0.1.p1";
    [devices addObject:device8];

    Device *device9 = [Device new];
    device9.fingerprint = @"34b61ddb98b575b30e6c468164d34f67";
    device9.title = @".150.55";
    device9.sn = @"19216815055";
    device9.model = @"e2225";
    device9.address = @"192.168.150.55";
    device9.version = @"4.0.2.p.1_dev D";
    [devices addObject:device9];

    Device *device10 = [Device new];
    device10.fingerprint = @"e0d239de5516ba992eccac4ab1638765";
    device10.title = @".150.52";
    device10.sn = @"54578755665436";
    device10.model = @"s1137";
    device10.address = @"192.168.150.52";
    device10.version = @"4.0.2.p.1_dev T";
    [devices addObject:device10];
    
//    Device *device10 = [Device new];
//    device10.fingerprint = @"34b61ddb98b575b30e6c468164d34f67";
//    device10.title = @".12.109";
//    device10.sn = @"45787544577";
//    device10.model = @"eic100";
//    device10.address = @"192.168.12.109";
//    device10.version = @"4.0.0.p1";
//    [devices addObject:device10];
//
//    Device *device11 = [Device new];
//    device11.fingerprint = @"54c905fdcec7ca81b54b12d7ca800336";
//    device11.title = @".117";
//    device11.sn = @"45756778678";
//    device11.address = @"192.168.101.117";
//    device11.version = @"4.0.2.p1";
//    [devices addObject:device11];
//
    //    Device *device12 = [Device new];
    //    device12.fingerprint = @"ca330a69a63738c55042e993ce6ecb76";
    //    device12.title = @".150.230";
    //    device12.sn = @"49949949";
//        device12.model = @"dev.4.0.2";
    //    device12.port = 80;
    //    device12.host = @"192.168.150.230";
    //    device12.address = @"192.168.150.230";
    //    [devices addObject:device12];
}

#pragma mark - Private Methods
-(void)recreateAndPrepare
{
    if (netServiceBrowser)
    {
        netServiceBrowser.delegate = nil;
        [netServiceBrowser stop];
        netServiceBrowser = nil;
    }
    
    netServiceBrowser = [NSNetServiceBrowser new];
    [netServiceBrowser setDelegate:self];
    
    [devices removeAllObjects];
    [services removeAllObjects];
    [devicesTemp removeAllObjects];
    
    complation = nil;
}

-(void)createDeviceFrom:(NSNetService*)_netService
{
    /// The answer from bonjour
    /**
     txt = ["vendor=Ei" "productid=m12" "title=192.168.101.153" "version=2.0.0" "sid=7046ba45066bf91f" "serial=032954906874978" "token=ad1ee8bbaa677d17d860d579b52e1476"]
     =   eth0 IPv4 RPN #15                                       Web Site             local
     hostname = [EiOS.local]
     address = [192.168.101.157]
     */
    
    
    NSDictionary *decodedResult = [self decodeUTF8ValuesInDict:[NSNetService dictionaryFromTXTRecordData:_netService.TXTRecordData]];
    NSString *fingerprint = [decodedResult stringForKey:@"fingerprint"];
    NSString *vendor = [decodedResult stringForKey:@"vendor"];
    [[Logger currentLog] writeWithObject:self selector:_cmd text:[NSString stringWithFormat:@"%@", decodedResult] logLevel:DEBUG_L];
    if (decodedResult != nil && [vendor isEqualToString:@"Ei"] && fingerprint != nil && !fingerprint.isEmpty)
    {
        Device *device = [Device new];
        device.vendor = vendor; //
        device.model = [decodedResult objectForKey:@"productid"]; //
        device.sid = [decodedResult objectForKey:@"sid"]; //
        device.sn = [decodedResult objectForKey:@"serial"]; //
        device.fingerprint = fingerprint; //
        device.title = [decodedResult objectForKey:@"title"]; //
        device.token = [decodedResult objectForKey:@"token"]; //
        device.version = [decodedResult objectForKey:@"version"]; //
        struct sockaddr_in *socketAddress = nil;
        for (NSData *address in _netService.addresses)
        {
            socketAddress = (struct sockaddr_in *)[address bytes];
            NSString *ip = [NSString stringWithFormat:@"%s", inet_ntoa(socketAddress->sin_addr)];
            
            if (ip.length > 0 && ![ip isEqualToString:@"0.0.0.0"])
            {
                device.address = ip;
                break;
            }
        }
        device.port = [_netService port];
        device.host = [_netService hostName];
        
        [devices addObject:device];
    }
    
    [_netService stop];
    [services removeObject:_netService];
}

-(NSDictionary*)decodeUTF8ValuesInDict:(NSDictionary*)dict
{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    for (NSString *key in [dict allKeys])
    {
        NSData *data = [dict objectForKey:key];
        if (data)
        {
            NSString *value = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            [result setObject:value forKey:key];
        }
    }
    
    return result;
}

#pragma mark - NSNetServiceBrowserDelegate
-(void)netServiceBrowser:(NSNetServiceBrowser*)netServiceBrowser didFindService:(NSNetService*)service moreComing:(BOOL)moreComing
{
    [services addObject:service];
    
    [service setDelegate:self];
    [service resolveWithTimeout:0.0f];
    [service startMonitoring];
}

#pragma mark - NSNetServiceDelegate
-(void)netService:(NSNetService *)sender didNotResolve:(NSDictionary<NSString *, NSNumber *> *)errorDict
{
    [services removeObject:sender];
    
    if (services.count == 0)
        complation(devices, nil);
}

-(void)netServiceDidResolveAddress:(NSNetService *)sender
{
    [self createDeviceFrom:sender];
    
    if (services.count == 0)
        complation(devices, nil);
}

@end
