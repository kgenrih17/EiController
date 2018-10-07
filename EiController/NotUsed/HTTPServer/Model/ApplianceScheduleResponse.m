//
//  ApplianceScheduleResponse.m
//  EiController
//
//  Created by Genrih Korenujenko on 19.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "ApplianceScheduleResponse.h"
//#import "TasksTable.h"

@implementation ApplianceScheduleResponse

#pragma mark - HTTPResponseInterface
-(NSString*)processing:(id)params
{
    NSString *response = nil;
    
    if ([self isValidRequest:params])
    {
//        NSInteger taskId = [self getTaskId:params];
//        NSString *parameters = [[TasksTable new] getParametersByTaskId:taskId];
        
//        if (parameters != nil)
//            response = [NSDictionary responseRPCWithResult:parameters.json];
//        else
//            response = [NSDictionary errorRPCWithMessage:@"doesn't have task id" code:1 exception:@(taskId).stringValue];
    }
    
    return response;
}

#pragma mark - Private Methods
-(BOOL)isValidRequest:(id)params
{
    BOOL isValid = NO;
    if (params != nil && [[params class] isSubclassOfClass:[NSDictionary class]] && [self getTaskId:params] > 0)
        isValid = YES;
    
    return isValid;
}

-(NSInteger)getTaskId:(NSDictionary*)params
{
    return [params[@"esTaskID"] integerValue];
}

@end
