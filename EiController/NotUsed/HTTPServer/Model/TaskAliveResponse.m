//
//  TaskAliveResponse.m
//  EiController
//
//  Created by Genrih Korenujenko on 20.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "TaskAliveResponse.h"
//#import "TasksTable.h"

@implementation TaskAliveResponse

#pragma mark - HTTPResponseInterface
-(NSString*)processing:(id)params
{
    NSString *response = nil;
    
    if ([self isValidRequest:params])
    {
//        NSInteger taskId = [self getTaskId:params];
//        TaskInfo *taskInfo = [[TasksTable new] get:taskId];
//        BOOL isAlive = (taskInfo == nil) ? NO : YES;
//        response = [NSDictionary responseRPCWithResult:@(isAlive)];
    }
    
    return response;
}

#pragma mark - Private Methods
-(BOOL)isValidRequest:(id)params
{
    BOOL isValid = NO;
    if (params != nil && [[params class] isSubclassOfClass:[NSDictionary class]] && [self getFingerprint:params] != nil && [self getTaskId:params] > 0)
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

@end
