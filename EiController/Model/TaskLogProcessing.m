//
//  TaskLogProcessing.m
//  EiController
//
//  Created by Genrih Korenujenko on 03.11.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "TaskLogProcessing.h"

@implementation TaskLogProcessing

#pragma mark - Public Init Methods
+(instancetype)create:(NSDictionary*)dic
{
    TaskLogProcessing *result = [self new];
    
    result.taskId = [dic integerForKey:@"id_request"];
    result.timestamp = [NSDate date].timeIntervalSince1970;
    result.fingerprint = [dic stringForKey:@"fingerprint"];
    result.message = [dic stringForKey:@"message"];

    return result;
}
@end
