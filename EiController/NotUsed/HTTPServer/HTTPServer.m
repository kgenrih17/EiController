//
//  HTTPServer.m
//  EiController
//
//  Created by Genrih Korenujenko on 19.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "HTTPServer.h"
#import "GCDWebServer.h"
#import "GCDWebServerDataResponse.h"
#import "GCDWebServerMultiPartFormRequest.h"
#import "GCDWebServerFileResponse.h"
#import "GCDWebServerURLEncodedFormRequest.h"

#import "PingResponse.h"
#import "UpdateStatusResponse.h"
#import "ApplianceScheduleResponse.h"
#import "TaskAliveResponse.h"
#import "TaskProgressResponse.h"
#import "WriteToLogResponse.h"
#import "ContentFileResponse.h"

#import "CentralMethod.h"

@interface HTTPResponse : NSObject

@property (nonatomic, readwrite, copy) NSString *response;
@property (nonatomic, readwrite, copy) NSString *error;

@property (nonatomic, readwrite, copy) NSString *method;
@property (nonatomic, readwrite, copy) NSString *fingerprint;

@end

@implementation HTTPResponse

@end

@interface HTTPServer ()
{
    GCDWebServer *webServer;
    BOOL isStarted;
}

@property (nonatomic, readwrite, weak) id <HTTPServerObserverInterface> observer;

@end

@implementation HTTPServer

@synthesize observer;

#pragma mark - Public Methods
-(void)start
{
    if (!isStarted)
    {
        isStarted = YES;
        webServer = [GCDWebServer new];
        [self prepareMethods];
        [webServer start];
    }
}

-(void)stop
{
    if (isStarted)
    {
        [self setObserver:nil];
        [webServer stop];
        webServer = nil;
        isStarted = NO;
    }
}

-(void)setObserver:(id<HTTPServerObserverInterface>)newObserver
{
    observer = newObserver;
}

#pragma mark - Private Methods
-(void)prepareMethods
{
    __weak HTTPServer *welf = self;

    
    [webServer addHandlerForMethod:@"POST"
                              path:CentralMethod.dasJsonPHP
                      requestClass:[GCDWebServerDataRequest class]
                      processBlock:^GCDWebServerResponse *(__kindof GCDWebServerDataRequest * _Nonnull request)
     {
         HTTPResponse *httpResponse = [welf processing:request];
         GCDWebServerDataResponse *response = [GCDWebServerDataResponse responseWithText:httpResponse.response];
         return response;
     }];
    
    [webServer addHandlerForMethod:@"GET"
                    pathRegex:@"/~*"
                 requestClass:[GCDWebServerDataRequest class]
                 processBlock:^GCDWebServerResponse *(GCDWebServerDataRequest* request)
    {
        HTTPResponse *httpResponse = [welf processing:request];

        if ([[NSFileManager defaultManager] fileExistsAtPath:httpResponse.response])
            return [GCDWebServerFileResponse responseWithFile:httpResponse.response];
        else
            return [GCDWebServerDataResponse responseWithText:httpResponse.response];
    }];
}

-(HTTPResponse*)processing:(GCDWebServerDataRequest*)request
{
    HTTPResponse *httpResponse = nil;
    
    if ([self isValidPOST:request])
    {
        httpResponse = [self preparePOSTResponseByRequest:request];
    }
    else if ([self isValidGET:request])
    {
        ContentFileResponse *response = [ContentFileResponse new];
        httpResponse.response = [response processing:request.path];
    }
    else
    {
        httpResponse.error = @"Unsuported jsonrpc format";
        httpResponse.response = [NSDictionary errorRPCWithMessage:httpResponse.error code:1 exception:NSStringFromClass([self class])];
    }
    
    if (httpResponse.error != nil)
        [[Logger currentLog] writeWithObject:self selector:_cmd text:httpResponse.error logLevel:ERROR_L];
    
    [self.observer receivedRequest:request.path
                            method:httpResponse.method
                         ipAddress:request.localAddressString
                       fingerprint:httpResponse.fingerprint
                             error:httpResponse.error];
    
    return httpResponse;
}

-(BOOL)isValidPOST:(GCDWebServerDataRequest*)request
{
    return [NSDictionary isValidRPCRequest:request.data];
}

-(BOOL)isValidGET:(GCDWebServerDataRequest*)request
{
    return [request.path containsString:@"~slink"];
}

#pragma mark - Prepare Response Methods
-(HTTPResponse*)preparePOSTResponseByRequest:(GCDWebServerDataRequest*)request
{
    NSDictionary *jsonrpc = request.data.json;
    HTTPResponse *httpResponse = [HTTPResponse new];
    httpResponse.method = [jsonrpc getRPCMethod];
    httpResponse.method = [jsonrpc getRPCParams][@"fingerprint"];

    [[Logger currentLog] writeWithObject:self selector:_cmd text:httpResponse.method logLevel:DEBUG_L];
    
    id <HTTPResponseInterface> response = [self getResponseRequest:request];
    
    if (response != nil)
    {
        httpResponse.response = [response processing:[jsonrpc getRPCParams]];
        
        if (httpResponse.response == nil)
        {
            httpResponse.error = @"Invalid parameters";
            httpResponse.response = [NSDictionary errorRPCWithMessage:httpResponse.error code:1 exception:NSStringFromClass([self class])];
        }
    }
    else
    {
        httpResponse.error = [NSString stringWithFormat:@"Unsuported method %@", httpResponse.method];
        httpResponse.response = [NSDictionary errorRPCWithMessage:httpResponse.error code:1 exception:NSStringFromClass([self class])];
    }
    
    return httpResponse;
}

#pragma mark - Helper Methods
-(id<HTTPResponseInterface>)getResponseRequest:(GCDWebServerDataRequest*)request
{
    id <HTTPResponseInterface> response = nil;
//    NSDictionary *json = request.data.json;
//    NSString *method = [json getRPCMethod];

//    if ([CentralMethod.ping isEqualToString:method])
//        response = [PingResponse new];
//    else if ([TaskMethod.setTaskStatuses isEqualToString:method])
//        response = [UpdateStatusResponse new];
//    else if ([TaskMethod.getApplianceSchedule isEqualToString:method])
//        response = [ApplianceScheduleResponse new];
//    else if ([TaskMethod.isTaskAlive isEqualToString:method])
//        response = [TaskAliveResponse new];
//    else if ([TaskMethod.setTaskProgressValue isEqualToString:method])
//        response = [TaskProgressResponse new];
//    else if ([TaskMethod.writeToRequestLog isEqualToString:method])
//        response = [WriteToLogResponse new];

    return response;
}

@end
