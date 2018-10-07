//
//  TaskProgressResponse.m
//  EiController
//
//  Created by Genrih Korenujenko on 03.11.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "TaskProgressResponse.h"

@implementation TaskProgressResponse

#pragma mark - HTTPResponseInterface
-(NSString*)processing:(id)params
{
    NSString *response = nil;
    
    if ([self isValidRequest:params])
    {
//        response = [NSDictionary responseRPCWithResult:@(YES)];
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
    return [params[@"task_id"] integerValue];
}

@end
