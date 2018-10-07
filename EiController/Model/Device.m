//
//  Device.m
//  TestProj
//
//  Created by admin on 2/17/16.
//  Copyright © 2016 RadicalComputing. All rights reserved.
//

#import "Device.h"

#import "EiController-Swift.h"

@implementation Device

#pragma mark - Init
-(instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.cpusLoad = [NSMutableArray new];
        self.cpusTemp = [NSMutableArray new];
        self.gpusTemp = [NSMutableArray new];
        self.audioChannelsCount = 0;
        self.videoChannelsCount = 0;
        self.detailsLastTimestamp = 0;
        self.detailsLastTimestamp = 0;
        self.model = @"";
        self.version = @"";
        self.sn = @"";
        self.edition = @"";
        self.sid = @"";
        self.modeConfiguration = [ModeConfiguration empty];
    }
    
    return self;
}

#pragma mark - Override Methods
-(BOOL)isEqual:(id)object
{
    if (![[object class] isSubclassOfClass:[self class]])
        return NO;
    
    Device *devie = (Device*)object;
    
    if (![devie.fingerprint isEqualToString:self.fingerprint])
        return NO;
    
    return YES;
}

#pragma mark - Public Methods
+(instancetype)centralDevice:(NSDictionary*)dic
{
    Device *device = [self new];
    device.fingerprint = [dic stringForKey:@"fingerprint"];
    device.sn = [dic stringForKey:@"serial_number"];
    device.sid = [dic stringForKey:@"system_id"];
    device.version = [dic stringForKey:@"version"];
    device.edition = [dic stringForKey:@"edition"];
    device.model = [dic stringForKey:@"model"];
    device.company = [dic stringForKey:@"company_unique"];
    device.timezone = [dic stringForKey:@"timezone"];
    device.title = [dic stringForKey:@"title"];
    NSDictionary *values = [dic dictionaryWithValuesForKeys:@[@"fingerprint", @"serial_number", @"system_id", @"version",
                                                              @"edition", @"model", @"company_unique",
                                                              @"timezone", @"title"]];
    device.md5 = values.json.md5;
    
    return device;
}

-(void)updateInfo:(NSDictionary*)answer
{
    [self clearInfo];
    NSDictionary *hardware = answer[@"hardware"];
    NSDictionary *summary = answer[@"summary"];
    NSDictionary *companyInfo = summary[@"company"];
    NSDictionary *locationInfo = summary[@"location"];
    self.location = [locationInfo stringForKey:@"title"];
    self.company = [companyInfo stringForKey:@"title"];
    self.macAddress = [hardware stringForKey:@"mac_address"];
    [self updateSchedules:summary];
    [self updateSummary:summary];
    [self updateChannels:summary];
    [self updateRAM:hardware];
    [self updateStorage:hardware];
    [self updateCPU:hardware[@"cpu"]];
    [self updateGPU:hardware[@"gpu_temperature"]];
#warning TODO hvk: interface_traffic - data doesn't come in response
    [self updateInterfaceProtocol:hardware[@"interface_traffic"]];
}

#pragma mark - Private Methods
-(void)clearInfo
{
    [self.cpusLoad removeAllObjects];
    [self.cpusTemp removeAllObjects];
    [self.gpusTemp removeAllObjects];
    self.esIntegrInfo = nil;
    self.netSettings = nil;
    self.modeConfiguration = nil;
    self.isEnableUpdateServer = NO;
    self.updateServerAddress = nil;
    self.isUseTunnel = NO;
    self.tunnelAddress = nil;
}

-(void)updateRAM:(NSDictionary*)hardware
{
    NSDictionary *ramInfo = hardware[@"ram"];
    self.ramFree = [[ramInfo stringForKey:@"free"] isEqual:@"n/a"] ? NO_HARDWARE_DATA : [ramInfo integerForKey:@"free"] * 1024;
    self.ramTotal = [[ramInfo stringForKey:@"total"] isEqual:@"n/a"] ? NO_HARDWARE_DATA : [ramInfo integerForKey:@"total"] * 1024;
    self.motherboard = [hardware stringForKey:@"motherboard"];
}

-(void)updateStorage:(NSDictionary*)hardware
{
    NSDictionary *hddInfo = hardware[@"hdd"];
    self.hddTotal = [[hddInfo stringForKey:@"total"] isEqual:@"n/a"] ? NO_HARDWARE_DATA : [hddInfo integerForKey:@"total"];
    self.hddFree = [[hddInfo stringForKey:@"free"] isEqual:@"n/a"] ? NO_HARDWARE_DATA : [hddInfo integerForKey:@"free"];
    self.detailsLastTimestamp = [NSDate date].timeIntervalSince1970;
}

-(void)updateChannels:(NSDictionary*)summary
{
    NSDictionary *channels = summary[@"info"][@"channels"];
    self.videoChannelsCount = [channels integerForKey:@"video"];
    self.audioChannelsCount = [channels integerForKey:@"audio"];
}

-(void)updateSummary:(NSDictionary*)summary
{
    self.model = [summary stringForKey:@"model"];
    self.edition = [summary stringForKey:@"edition"];
    self.title = [summary stringForKey:@"title"];
    self.version = [summary stringForKey:@"version"];
    self.sn = [summary stringForKey:@"serial_number"];
    self.sid = [summary stringForKey:@"system_id"];
    self.address = [summary stringForKey:@"ip"];
    self.sysTime = [summary stringForKey:@"system_time"];
    self.upTime = [summary stringForKey:@"uptime"];
    self.timezone = [summary stringForKey:@"timezone"];
    self.period = [summary integerForKey:@"log_period"];
    self.protocol = [summary stringForKey:@"protocol"];
#warning TODO hvk: registration_time - data doesn't come in response
    self.registrationDate = [summary integerForKey:@"registration_time"];
}

-(void)updateSchedules:(NSDictionary*)summary
{
    NSDictionary *scheduleRebootNode = summary[@"schedule_reboot"][@"reboot_scheduler"];
    NSDictionary *scheduleRestartPlayback = summary[@"schedule_reboot"][@"reboot_playback"];
    NSDictionary *scheduleShutdownNode = summary[@"schedule_reboot"][@"shutdown_appliance"];
    self.rebootHour = [scheduleRebootNode integerForKey:@"hour"];
    self.rebootMinute = [scheduleRebootNode integerForKey:@"minute"];
    self.rebootMeridiem = [scheduleRebootNode stringForKey:@"meridiem"];
    self.rebootEnabled = [scheduleRebootNode boolForKey:@"status"];
    self.playbackRestartHour = [scheduleRestartPlayback integerForKey:@"hour"];
    self.playbackRestartMinute = [scheduleRestartPlayback integerForKey:@"minute"];
    self.playbackRestartMeridiem = [scheduleRestartPlayback stringForKey:@"meridiem"];
    self.playbackRestartEnabled = [scheduleRestartPlayback boolForKey:@"status"];
    self.shutdownHour = [scheduleShutdownNode integerForKey:@"hour"];
    self.shutdownMinute = [scheduleShutdownNode integerForKey:@"minute"];
    self.shutdownMeridiem = [scheduleShutdownNode stringForKey:@"meridiem"];
    self.shutdownEnabled = [scheduleShutdownNode boolForKey:@"status"];
}

-(void)updateInterfaceProtocol:(NSDictionary*)protocol
{
    self.interfaceTrafficDate = [protocol integerForKey:@"date"];
    self.interfaceTrafficSendLAN = [protocol integerForKey:@"send_lan"];
    self.interfaceTrafficReceivedLAN = [protocol integerForKey:@"received_lan"];
    self.interfaceTrafficSendWiFi = [protocol integerForKey:@"send_wifi"];
    self.interfaceTrafficReceivedWiFi = [protocol integerForKey:@"received_wifi"];
}

-(void)updateCPU:(id)cpu
{
    if ([cpu isDictionary])
    {
        id load = cpu[@"load"];
        if ([load isArray])
            [self addItems:load to:self.cpusLoad];
        id temperature = cpu[@"temperature"];
        if ([temperature isArray])
            [self addItems:temperature to:self.cpusTemp];
    }
    else if ([cpu isArray])
    {
        for (id item in cpu)
            [self updateCPU:item];
    }
}

-(void)updateGPU:(id)gpu
{
    if ([gpu isArray])
        [self addItems:gpu to:self.gpusTemp];
}

-(void)addItems:(NSArray*)fromArray to:(NSMutableArray*)array
{
    for (id item in fromArray)
    {
        if ([item isString] && ![(NSString*)item isEqual:@"n/a"] && ![(NSString*)item isEmpty] && [(NSString*)item integerValue] >= 0 && [(NSString*)item integerValue] < NSNotFound)
            [array addObject:item];
        else if ([item isNumber] && [item integerValue] > 0 && [item integerValue] < NSNotFound)
            [array addObject:item];
    }
}

@end
