//
//  NSDictionary+RPC.m
//  EiController
//
//  Created by Genrih Korenujenko on 20.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "NSDictionary+RPC.h"

@implementation NSDictionary (RPC)

#pragma mark - Public Methods
+(NSString*)errorRPCWithMessage:(NSString*)message code:(NSInteger)code exception:(NSString*)exception
{
    NSMutableDictionary *result = [NSMutableDictionary new];
    [result setObject:[NSNull null] forKey:@"id"];
    [result setObject:@"2.0" forKey:@"jsonrpc"];
    [result setObject:[NSString valueOrEmptyString:exception] forKey:@"Exception"];
    [result setObject:@(code) forKey:@"code"];
    
    NSMutableDictionary *error = [NSMutableDictionary new];
    [error setObject:[NSString valueOrEmptyString:message] forKey:@"message"];
    [error setObject:@(code) forKey:@"code"];

    [result setObject:error forKey:@"error"];
    return result.json;
}

+(NSString*)responseRPCWithResult:(id)item;
{
    NSMutableDictionary *result = [NSMutableDictionary new];
    [result setObject:[NSNull null] forKey:@"id"];
    [result setObject:@"2.0" forKey:@"jsonrpc"];
    [result setObject:item forKey:@"result"];
    return result.json;
}

+(NSString*)RPCWithMethod:(NSString*)method params:(NSDictionary*)parameters
{
    NSMutableDictionary *result = [NSMutableDictionary new];
    [result setObject:parameters forKey:@"params"];
    [result setObject:method forKey:@"method"];
    [result setObject:@"2.0" forKey:@"jsonrpc"];
    [result setObject:[NSNull null] forKey:@"id"];
    return result.json;
}

+(NSString*)getRPCErrorMessage:(NSData*)data
{
    return [self parseRPCError:data byKey:@"message"];
}

+(NSInteger)getRPCErrorCode:(NSData*)data
{
    return [[self parseRPCError:data byKey:@"code"] integerValue];
}

+(BOOL)isRPC:(NSData*)data
{
    BOOL isValid = NO;
    if (data.length > 0)
    {
        id result = data.json;
        if ([[result class] isSubclassOfClass:[NSDictionary class]])
        {
            NSDictionary *rpc = (NSDictionary*)result;
            isValid = [rpc containsKey:@"jsonrpc"];
        }
    }
    return isValid;
}

+(BOOL)isValidRPCAnswer:(NSData*)data
{
    BOOL isValid = NO;
    if (data.length > 0)
    {
        id result = data.json;
        if ([[result class] isSubclassOfClass:[NSDictionary class]])
        {
            NSDictionary *rpc = (NSDictionary*)result;
            isValid = [rpc containsKeys:@[@"jsonrpc", @"result"]];
        }
    }
    return isValid;
}

-(id)getRPCResult
{
    return [self objectForKey:@"result"];
}


#pragma mark - Request
+(BOOL)isValidRPCRequest:(NSData*)data
{
    BOOL isValid = NO;
    if (data.length > 0)
    {
        id result = data.json;
        if ([[result class] isSubclassOfClass:[NSDictionary class]])
        {
            NSDictionary *rpc = (NSDictionary*)result;
            isValid = [rpc containsKeys:@[@"jsonrpc", @"params", @"method"]];
        }
    }
    return isValid;
}

-(id)getRPCParams
{
    return [self objectForKey:@"params"];
}

-(NSString*)getRPCMethod
{
    return [self stringForKey:@"method"];
}

#pragma mark - Private Methods
+(id)parseRPCError:(NSData*)data byKey:(NSString*)key;
{
    id result = nil;
    if (data.length > 0)
    {
        NSDictionary *json = (NSDictionary*)data.json;
        if ([[json class] isSubclassOfClass:[NSDictionary class]])
        {
            NSDictionary *error = [json dictionaryForKey:@"error"];
            result = [error objectForKey:key];
        }
        else if ([key isEqualToString:@"message"])
            result = @"incorrect format response";
        else
            result = @(422);
    }
    return result;
}


@end
