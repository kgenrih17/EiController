//
//  EiCentralAPI.m
//  EiController
//
//  Created by Genrih Korenujenko on 13.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "EiCentralAPI.h"
#import "CentralMethod.h"

static NSString * const APP_KEY = @"ei_controller";

@interface EiCentralAPI ()
{
    RequestSender *requestSender;
    CentralConnectionData *connectionData;
    
    NSInteger code;
    NSString *message;
}
@end

@implementation EiCentralAPI

#pragma mark - Init
-(instancetype)init
{
    self = [super init];
    
    if (self)
    {
        requestSender = [RequestSender new];
        requestSender.timeout = 30;
    }
    
    return self;
}

#pragma mark - Public Init Methods
+(instancetype)build:(CentralConnectionData*)connectionData
{
    EiCentralAPI *api = [EiCentralAPI new];
    [api setConnectionData:connectionData];
    return api;
}

#pragma mark - CentralAPIInterface
-(void)setConnectionData:(CentralConnectionData*)centralConnectionData
{
    connectionData = centralConnectionData;
}

-(NSInteger)getErrorCode
{
    return code;
}
-(NSString*)getErrorMessage
{
    return message;
}

-(void)cancel
{
    [requestSender cancel];
}

-(void)checkConnection:(void (^)(BOOL))completion
{
    NSString *fingerprint = [EiControllerSysInfo getUdid];
    NSString *parameters = [NSMutableDictionary RPCWithMethod:CentralMethod.echo
                                                       params:@{@"data" : [EiControllerSysInfo getUdid]}];
    [requestSender setUrl:[self getUrl]];
    [requestSender setParameters:parameters];
    [self sendRequestCompletion:^(RequestResult *_result)
    {
        BOOL isSuccess = NO;
        
        if (code == 0)
            isSuccess = [[_result getRPCResult] isEqualToString:fingerprint];
        
        completion(isSuccess);
    }];
}

-(void)getDevices:(void(^)(NSDictionary*))completion
{
    NSString *parameters = [NSMutableDictionary RPCWithMethod:CentralMethod.getNodesByToken
                                                       params:@{@"token" : connectionData.token,
                                                                @"company_id" : connectionData.companyUniq}];
    [requestSender setUrl:[self getUrl]];
    [requestSender setParameters:parameters];
    [self sendRequestCompletion:^(RequestResult *_result)
    {
        NSDictionary *answer = nil;
        if (code == 0)
            answer = [_result getRPCResult];
        
        completion(answer);
    }];
}

-(void)authByPin:(NSString*)pin
     compenyCode:(NSString*)compenyCode
      completion:(void(^)(NSDictionary*))completion
{
    NSDictionary *params = @{@"pin" : pin, @"company_code" : compenyCode};
    [self authByMethod:ServerAllowMethod.authEmployeeByPin params:params completion:completion];
}

-(void)authByLogin:(NSString*)login
          password:(NSString*)password
       compenyCode:(NSString*)compenyCode
        completion:(void(^)(NSDictionary*))completion
{
    NSDictionary *params = @{@"login" : login, @"password" : password, @"company_code" : compenyCode};
    [self authByMethod:ServerAllowMethod.authEmployee params:params completion:completion];
}

-(void)getSchedules:(NSString*)fingerprint completion:(void(^)(NSDictionary*result))completion
{
    NSString *parameters = [NSMutableDictionary RPCWithMethod:TaskMethod.getScheduleData
                                                       params:@{@"fingerprint" : fingerprint}];
    [requestSender setUrl:[self getUrl]];
    [requestSender setParameters:parameters];
    [self sendRequestCompletion:^(RequestResult *_result)
    {
        NSDictionary *answer = nil;
        if (code == 0)
            answer = [_result getRPCResult];
        
        completion(answer);
    }];

}

#pragma mark - Private Methods
-(void)authByMethod:(NSString*)method
             params:(NSDictionary*)params
         completion:(void(^)(NSDictionary*))completion
{
    NSString *parameters = [NSMutableDictionary RPCWithMethod:method
                                                       params:params];
    [requestSender setUrl:[self getUrl]];
    [requestSender setParameters:parameters];
    [self sendRequestCompletion:^(RequestResult *_result)
    {
        NSDictionary *answer = nil;
        if (code == 0)
            answer = [_result getRPCResult];
        
        completion(answer);
    }];
}

-(void)sendRequestCompletion:(RequestCompleted)completion;
{
    code = 0;
    message = nil;
    [requestSender sendRequestCompletion:^(RequestResult *_result)
    {
        if (_result.errorStr != nil)
        {
            code = REQUEST_ERROR;
            message = _result.errorStr;
        }
        else if ([_result isHaveError])
        {
            code = [_result getRPCErrorCode];
            message = [_result getRPCErrorMessage];
        }
        
        BLOCK_SAFE_RUN(completion, _result);
    }];
}

-(NSString*)getUrl
{
    return [NSString stringWithFormat:@"%@%@", connectionData.url.absoluteString, CentralMethod.dasJsonPHP];
}

@end
