//
//  RequestResult+RPC.m
//  EiController
//
//  Created by Genrih Korenujenko on 21.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "RequestResult+RPC.h"
#import "NSDictionary+RPC.h"

@implementation RequestResult (RPC)

#pragma mark - Public Methods
-(id)getRPCResult
{
    id result = nil;
    
    if ([NSDictionary isValidRPCAnswer:self.data])
        result = [self.data.json getRPCResult];
    
    return result;
}

-(NSString*)getRPCErrorMessage
{
    return [NSDictionary getRPCErrorMessage:self.data];
}

-(NSInteger)getRPCErrorCode
{
    return [NSDictionary getRPCErrorCode:self.data];
}

-(BOOL)isHaveError
{
    return ![NSDictionary isValidRPCAnswer:self.data];
}

-(BOOL)isRPC
{
    return [NSDictionary isRPC:self.data];
}

@end
