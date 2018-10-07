//
//  PingResponse.m
//  EiController
//
//  Created by Genrih Korenujenko on 19.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "PingResponse.h"
//#import "TasksTable.h"
#import "DevicesTable.h"

@implementation PingResponse

static const NSString *TRAFFIC_OPTIMIZATION_KEY = @"TRAFFIC_OPTIMIZATION_ON";
static const NSString *TASKS_NEW_KEY = @"TASKS_NEW";
static const NSString *TASKS_IN_PROCESS_KEY = @"TASKS_IN_PROCESS";
static const NSString *ADDITIONAL_DATA_KEY = @"ADDITIONAL_DATA";

#pragma mark - HTTPResponseInterface
-(NSString*)processing:(id)params
{
    NSString *result = nil;
    
    if ([self isValidRequest:params])
    {
        NSMutableDictionary *response = [NSMutableDictionary new];
        [response setObject:@(1) forKey:TRAFFIC_OPTIMIZATION_KEY];
        
        NSString *fingerprint = [self getFingerprint:params];
        [self addTasks:response byFingerprint:fingerprint];
        [self addAdditionalData:response byFingerprint:fingerprint];
        
        result = [NSDictionary responseRPCWithResult:response];
    }
    
    return result;

}

#pragma mark - Private Methods
-(BOOL)isValidRequest:(id)params
{
    BOOL isValid = NO;
    if (params != nil && [[params class] isSubclassOfClass:[NSDictionary class]] && [self getFingerprint:params] != nil)
        isValid = YES;
    
    return isValid;
}

-(NSString*)getFingerprint:(NSDictionary*)params
{
    return params[@"fingerprint"];
}

-(void)addTasks:(NSMutableDictionary*)response byFingerprint:(NSString*)fingerprint
{
//    NSArray *tasks = [[TasksTable new] getByFingerprint:fingerprint];
//    NSMutableArray *newTasks = [NSMutableArray new];
//    NSMutableArray *taskInProgress = [NSMutableArray new];
//
//    for (NSMutableDictionary *task in tasks)
//    {
//        NSString *status = [task stringForKey:@"status"];
//        [task removeObjectForKey:@"status"];
//
//        if ([status isEqualToString:TASK_STATUS_RECEIVED] || [status isEqualToString:TASK_STATUS_PROCESS])
//        {
//            [task removeObjectForKey:@"task_name"];
//            [task removeObjectForKey:@"task_params"];
//            [taskInProgress addObject:task];
//        }
//        else
//            [newTasks addObject:task];
//    }
//
//    if (!newTasks.isEmpty)
//        [response setObject:newTasks forKey:TASKS_NEW_KEY];
//    else
//        [response setObject:[NSNull null] forKey:TASKS_NEW_KEY];
//
//    if (!taskInProgress.isEmpty)
//        [response setObject:taskInProgress forKey:TASKS_IN_PROCESS_KEY];
//    else
//        [response setObject:[NSNull null] forKey:TASKS_IN_PROCESS_KEY];
}

-(void)addAdditionalData:(NSMutableDictionary*)response byFingerprint:(NSString*)fingerprint
{
//    NSMutableDictionary *result = [NSMutableDictionary new];
//    NSUserDefaults *usersDefaults = [NSUserDefaults standardUserDefaults];
//    NSString *publisherHost = [usersDefaults stringForKey:@"publisher_host"];
//    NSString *companyUnique = [[DevicesTable new] getCompanyUniqByFingerprint:fingerprint];
//
//    if ((publisherHost != nil) && !publisherHost.isEmpty && !companyUnique.isEmpty)
//    {
//        [result setObject:companyUnique forKey:@"appliance_company_unique"];
//        [result setObject:publisherHost forKey:@"publisher_host"];
//        [result setObject:@([usersDefaults integerForKey:@"publisher_port"]) forKey:@"publisher_port"];
//        [response setObject:result forKey:ADDITIONAL_DATA_KEY];
//    }
}

@end
