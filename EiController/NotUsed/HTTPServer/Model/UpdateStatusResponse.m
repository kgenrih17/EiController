//
//  UpdateStatusResponse.m
//  EiController
//
//  Created by Genrih Korenujenko on 19.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "UpdateStatusResponse.h"
//#import "TaskResultsTable.h"

@implementation UpdateStatusResponse

#pragma mark - HTTPResponseInterface
-(NSString*)processing:(id)params
{
    NSString *result = nil;
    
    if ([self isValidRequest:params])
    {
//        TaskResultsTable *taskResultsTable = [TaskResultsTable new];
//        NSString *fingerprint = [self getFingerprint:params];
//        NSDictionary *tasks = [self getTasks:params];
//
//        [tasks enumerateKeysAndObjectsUsingBlock:^(id key, NSString *obj, BOOL *stop)
//        {
//            [taskResultsTable updateStatus:[obj lowercaseString]
//                             byFingerprint:fingerprint
//                                    taskId:[key integerValue]];
//        }];
//        
//        result = [NSDictionary responseRPCWithResult:@"Status is updated"];
    }
    
    return result;
}

#pragma mark - Private Methods
-(BOOL)isValidRequest:(id)params
{
    BOOL isValid = NO;
    if (params != nil && [[params class] isSubclassOfClass:[NSDictionary class]] && ![(NSDictionary*)params isEmpty] && [self getFingerprint:params] != nil)
        isValid = YES;
    return isValid;
}

-(NSString*)getFingerprint:(id)params
{
    return params[@"fingerprint"];
}

-(NSDictionary*)getTasks:(id)params
{
    return params[@"tasks"];
}

@end
