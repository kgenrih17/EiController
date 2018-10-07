//
//  WriteToLogResponse.m
//  EiController
//
//  Created by Genrih Korenujenko on 03.11.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "WriteToLogResponse.h"

@implementation WriteToLogResponse

#pragma mark - HTTPResponseInterface
-(NSString*)processing:(id)params
{
    NSString *response = nil;
    
    if ([self isValidRequest:params])
    {
//        TaskLogProcessing *item = [TaskLogProcessing create:params];
//        [[TaskLogProcessingsTable new] add:item];
//        response = [NSDictionary responseRPCWithResult:@(YES)];
    }
    
    return response;
}

#pragma mark - Private Methods
-(BOOL)isValidRequest:(id)params
{
    BOOL isValid = NO;
    if (params != nil && [[params class] isSubclassOfClass:[NSDictionary class]] && [self getFingerprint:params] != nil && [self getMessage:params] != nil && [self getTaskId:params] > 0)
        isValid = YES;
    
    return isValid;
}

-(NSString*)getFingerprint:(NSDictionary*)params
{
    return params[@"fingerprint"];
}

-(NSInteger)getTaskId:(NSDictionary*)params
{
    return [params[@"id_request"] integerValue];
}

-(NSString*)getMessage:(NSDictionary*)params
{
    return params[@"message"];
}

@end
