//
//  RequestResult+RPC.h
//  EiController
//
//  Created by Genrih Korenujenko on 21.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import <EvogenceLib/EvogenceLib.h>

@interface RequestResult (RPC)

-(id)getRPCResult;
-(NSString*)getRPCErrorMessage;
-(NSInteger)getRPCErrorCode;
-(BOOL)isHaveError;
-(BOOL)isRPC;

@end
