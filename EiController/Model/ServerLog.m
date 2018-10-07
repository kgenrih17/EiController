//
//  ServerLog.m
//  EiController
//
//  Created by Genrih Korenujenko on 26.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "ServerLog.h"

@implementation ServerLog

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
              server:(NSString*)server
                desc:(NSString*)desc
{
    ServerLog *result = [ServerLog new];
    result.actionTitle = title;
    result.errorCode = code;
    result.errorMessage = errorMessage;
    result.server = server;
    result.desc = desc;
    return result;
}

@end
