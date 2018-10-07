//
//  CommandResult.m
//  EiController
//
//  Created by admin on 2/18/16.
//  Copyright © 2016 RadicalComputing. All rights reserved.
//

#import "CommandResult.h"

@implementation CommandResult

-(instancetype)init
{
    self = [super init];
    if (self)
    {

    }
    
    return self;
}

+(instancetype)initWithError:(NSString *)_error
{
    CommandResult *result = [CommandResult new];
    [result setError:_error];
    
    return result;
}

+(instancetype)initWithResult:(NSDictionary *)_result
{
    CommandResult *result = [CommandResult new];
    [result setParams:_result];
    
    return result;
}

-(NSDictionary*)dicParams
{
    return self.params;
}

@end
