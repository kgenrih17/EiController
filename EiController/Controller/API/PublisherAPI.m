//
//  PublisherAPI.m
//  EiController
//
//  Created by Genrih Korenujenko on 22.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "PublisherAPI.h"
#import "CentralMethod.h"

@implementation PublisherAPI

@synthesize connectionData;

#pragma mark - Init
-(instancetype)init
{
    self = [super init];
    
    if (self)
    {
        requestSender = [RequestSender new];
        requestSender.timeout = SECOND_IN_ONE_MINUTE;
    }
    
    return self;
}

#pragma mark - Public Init Methods
+(instancetype)build:(ConnectionData*)connectionData;
{
    PublisherAPI *api = [PublisherAPI new];
    api.connectionData = connectionData;
    return api;
}

#pragma mark - PublisherAPIInterface
-(void)cancel
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [requestSender cancel];
}

-(NSInteger)getErrorCode
{
    return code;
}

-(NSString*)getErrorMessage
{
    return message;
}

-(void)getApplications:(NSString*)fingerprint
                 token:(NSString*)token
               isForce:(BOOL)isForce
            completion:(void(^)(NSDictionary*applications))completion
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:fingerprint, @"fingerprint", [EiControllerSysInfo getUdid], @"device_system_id", @(isForce), @"force", nil];
    if (token != nil)
        params[@"token"] = token;
    NSString *parameters = [NSMutableDictionary RPCWithMethod:IPMethod.getScheduleApplications
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

-(void)downloadAppliactionFile:(NSString*)filename toPath:(NSString*)path completion:(void (^)(NSInteger))completion
{
    code = 0;
    message = nil;
    NSString *parameters = [NSMutableDictionary RPCWithMethod:IPMethod.downloadFile
                                                       params:@{@"filename" : filename,
                                                                @"device_system_id" : [EiControllerSysInfo getUdid]}];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *request = [self prepareDownloadAppliactionFileRequest:parameters];
    NSURLSessionTask *downloadTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error)
    {
        NSInteger length = 0;
        if (error != nil)
        {
            if (isResendDownloadRequest)
            {
                if (![[NSFileManager defaultManager] fileExistsAtPath:path])
                {
                    code = REQUEST_ERROR;
                    message = error.localizedDescription;
                }
                else
                    length = (NSInteger)[[[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil] fileSize];
                isResendDownloadRequest = NO;
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    completion(length);
                }];
            }
            else
            {
                isResendDownloadRequest = YES;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                {
                    [self downloadAppliactionFile:filename toPath:path completion:completion];
                });
            }
        }
        else
        {
            isResendDownloadRequest = NO;
            [[NSFileManager defaultManager] moveItemAtPath:location.path toPath:path error:nil];
            length = response.expectedContentLength;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                completion(length);
            }];
        }
    }];
    [downloadTask resume];
}

-(void)setUploadedFiles:(NSArray<NSDictionary*>*)files completion:(void(^)(void))completion
{
    NSString *parameters = [NSMutableDictionary RPCWithMethod:IPMethod.setUploadedFiles
                                                       params:@{@"files" : files,
                                                                @"device_system_id" : [EiControllerSysInfo getUdid]}];
    [requestSender setUrl:[self getUrl]];
    [requestSender setParameters:parameters];
    [self sendRequestCompletion:^(RequestResult *_result)
    {
        completion();
    }];
}

#pragma mark - Private Methods
-(NSString*)getUrl
{
    return [NSString stringWithFormat:@"%@%@", connectionData.url.absoluteString, CentralMethod.dasJsonPHP];
}

-(NSURLRequest*)prepareDownloadAppliactionFileRequest:(NSString*)parameters
{
    NSURL *url = [NSURL URLWithString:[self getUrl]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *command = [parameters dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:requestSender.timeout];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[command length]] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:command];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    return request;
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

@end
