//
//  DeviceIntegrationInfo.m
//  EiController
//
//  Created by Genrih Korenujenko on 30.05.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#import "DeviceIntegrationInfo.h"

@implementation DeviceIntegrationInfo

+(instancetype)create:(NSDictionary *)_dict
{
    DeviceIntegrationInfo *result = [DeviceIntegrationInfo new];
    result.registrationToken = [_dict stringForKey:@"register_token"];
    result.esTaskCompletionTimeout = [_dict integerForKey:@"task_timeout"];
    result.isOn = [_dict boolForKey:@"is_es_enable"];
    result.isUseUpdate = [_dict integerForKey:@"use_es_as_update_server"];
    result.isUseSFTP = [_dict integerForKey:@"use_es_ssh_connection"];
    result.host = [(NSDictionary*)_dict[@"primary_es"] stringForKey:@"host"];
    result.httpPort = [(NSDictionary*)_dict[@"primary_es"] integerForKey:@"http_port"];
    result.sshPort = [(NSDictionary*)_dict[@"primary_es"] integerForKey:@"ssh_port"];
    result.ftpPort = [(NSDictionary*)_dict[@"primary_es"] integerForKey:@"ftp_port"];
    NSDictionary *secondaryES = _dict[@"secondary_es"];
    result.secondaryHost = [secondaryES containsKey:@"secondary_es"] ? [NSString stringWithFormat:@"%@", secondaryES[@"host"]] : @"";
    result.secondaryHTTPPort = [secondaryES integerForKey:@"http_port"];
    result.secondarySSHPort = [secondaryES integerForKey:@"ssh_port"];
    result.secondaryFTPPort = [secondaryES integerForKey:@"ftp_port"];
    return result;
}

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        self.host = @"";
        self.httpPort = 0;
        self.sshPort = 0;
        self.ftpPort = 0;
        self.registrationToken = @"";
        self.esTaskCompletionTimeout = 0;
        self.isOn = NO;
        self.isUseUpdate = NO;
        self.isUseSFTP = NO;
        self.secondaryHost = @"";
        self.secondaryHTTPPort = 0;
        self.secondarySSHPort = 0;
        self.secondaryFTPPort = 0;
    }
    return self;
}

@end
