//
//  NSDictionary+RPC.h
//  EiController
//
//  Created by Genrih Korenujenko on 20.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (RPC)

+(NSString*)errorRPCWithMessage:(NSString*)message code:(NSInteger)code exception:(NSString*)exception;
+(NSString*)responseRPCWithResult:(id)result;
+(NSString*)RPCWithMethod:(NSString*)method params:(NSDictionary*)parameters;
+(NSString*)getRPCErrorMessage:(NSData*)data;
+(NSInteger)getRPCErrorCode:(NSData*)data;
+(BOOL)isRPC:(NSData*)data;
+(BOOL)isValidRPCAnswer:(NSData*)data;
-(id)getRPCResult;


/// Request
+(BOOL)isValidRPCRequest:(NSData*)data;
-(id)getRPCParams;
-(NSString*)getRPCMethod;

@end
