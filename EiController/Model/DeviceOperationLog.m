//
//  DeviceOperationLogsTable.m
//  EiController
//
//  Created by Genrih Korenujenko on 26.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "DeviceOperationLog.h"

@implementation DeviceOperationLog

#pragma mark - Init
-(instancetype)init
{
    self = [super init];
    if (self)
        self.timestamp = [NSDate date].timeIntervalSince1970;
    return self;
}

#pragma mark - Public Init Methods
+(instancetype)build:(NSString*)title
                code:(NSInteger)code
        errorMessage:(NSString*)errorMessage
                desc:(NSString*)desc
         fingerprint:(NSString*)fingerprint;
{
    DeviceOperationLog *result = [DeviceOperationLog new];
    result.actionTitle = title;
    result.errorCode = code;
    result.errorMessage = errorMessage;
    result.desc = desc;
    result.fingerprint = fingerprint;
    return result;
}

@end
