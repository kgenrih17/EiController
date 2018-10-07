//
//  HTTPTransfer.m
//  EiController
//
//  Created by Genrih Korenujenko on 29.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "HTTPTransfer.h"
#import <MobileCoreServices/MobileCoreServices.h>

@implementation HTTPTransfer

@synthesize listener;
@synthesize settings;
@synthesize completion;

#pragma mark - TransferInterface
+(instancetype)build:(id<TransferListener>)listener settings:(TransferInfo*)settings
{
    HTTPTransfer *result = [HTTPTransfer new];
    result.listener = listener;
    result.settings = settings;
    return result;
}

-(void)upload:(TransferCompletion)aCompletion
{
    completion = aCompletion;
    [self prepareRequest];
    task = [[self getSession] uploadTaskWithRequest:request fromFile:[NSURL URLWithString:pathToBody] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
        [self completion:data error:error];
    }];
    [self performTask];
}

-(void)download:(TransferCompletion)aCompletion
{
    completion = aCompletion;
    [self prepareRequest];
    [request setHTTPBody:[NSData dataWithContentsOfFile:pathToBody]];
    task = [[self getSession] downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        NSData *data = [NSData dataWithContentsOfURL:location];
        [self completion:data error:error];
    }];
    [self performTask];
}

-(void)sendRequest:(TransferCompletion)aCompletion
{
    completion = aCompletion;
    [self prepareRequest];
    [request setHTTPBody:[NSData dataWithContentsOfFile:pathToBody]];
    task = [[self getSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        [self completion:data error:error];
    }];
    [self performTask];
}

-(void)cancel
{
    [task cancel];
    [self clear];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

#pragma mark - NSURLSessionTaskDelegate
-(void)URLSession:(NSURLSession*)session task:(NSURLSessionTask*)aTask
  didSendBodyData:(int64_t)bytesSent
   totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    if ([listener respondsToSelector:@selector(transferProgress:)])
    {
        CGFloat percent = (CGFloat)totalBytesSent / (CGFloat)totalBytesExpectedToSend;
        if (percent - lastPercent >= 0.1)
        {
            lastPercent = percent;
            [listener transferProgress:percent];
        }
    }
}

#pragma mark - Private Methods
-(void)prepareRequest
{
    boundary = [NSUUID UUID].UUIDString;
    NSURL *url = [NSURL URLWithString:settings.address];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    [self prepareBody];
}

-(NSURLSession*)getSession
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    return [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
}

-(void)performTask
{
    lastPercent = 0;
    [task resume];
    if ([listener respondsToSelector:@selector(startOfTransmission)])
        [listener startOfTransmission];
}

-(void)completion:(NSData*)data error:(NSError*)error
{
    NSString *message = nil;
    id answer = nil;
    
    if (error != nil)
    {
        message = error.localizedDescription;
    }
    else if (data == nil)
    {
        message = [ErrorDescription getError:ANSWER_DATA_IS_NIL];
    }
    else if (data.length == 0)
    {
        message = [ErrorDescription getError:ANSWER_DATA_IS_EMPTY];
    }
    else if ([NSDictionary isRPC:data])
    {
        if (![NSDictionary isValidRPCAnswer:data])
            message = [NSDictionary getRPCErrorMessage:data];
        else
            answer = data.json;
    }
    else if (data.json != nil)
    {
        NSDictionary *json = data.json;
        answer = data.json;
        NSString *status = [json stringForKey:@"status"];
        NSString *error = [json stringForKey:@"error"];
        if ([status isEqualToString:@"success"])
            message = nil;
        else if (error != nil && !error.isEmpty)
            message = error;
        else
            message = [ErrorDescription getError:INCORRECT_FORMAT_ANSWER];
    }
    else
        answer = data;
    
    TransferResult *result = [TransferResult build:message data:answer];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
    {
        BLOCK_SAFE_RUN(completion, result);
        [self clear];
    });
}

-(void)prepareBody
{
    [self createBodyFile];
    [settings.parameters enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop)
    {
        NSString *disposition = [NSString stringWithFormat:@"name=\"%@\"", key];
        [self addBodyDisposition:disposition value:value];
    }];
    if (settings.pathToFile != nil)
    {
        NSString *filename = [settings.pathToFile lastPathComponent];
        NSString *disposition = [NSString stringWithFormat:@"name=\"file\"; filename=\"%@\"", filename];
        [self addBodyDisposition:disposition value:[NSNull null]];
    }
    [self addBodyBoundary:YES];
}

-(void)createBodyFile
{
    pathToBody = [[AppInfromation getPathToDocuments] stringByAppendingPathComponent:TRANSFER_HTTP_BODY_FILE_NAME];
    [[NSFileManager defaultManager] createFileAtPath:pathToBody contents:nil attributes:nil];
    fileHandle = [NSFileHandle fileHandleForWritingAtPath:pathToBody];
}

-(void)addBodyDisposition:(NSString*)name
                    value:(id)value
{
    [self addBodyBoundary:NO];
    NSString *dispositionName = [NSString stringWithFormat:@"Content-Disposition: form-data; %@\r\n\r\n", name];
    [fileHandle writeData:[dispositionName dataUsingEncoding:NSUTF8StringEncoding]];

    if (![[value class] isSubclassOfClass:[NSNull class]])
    {
        NSString *contentValue = [NSString stringWithFormat:@"%@\r\n", value];
        [fileHandle writeData:[contentValue dataUsingEncoding:NSUTF8StringEncoding]];
    }
    else
    {
        @autoreleasepool
        {
            [fileHandle writeData:[NSData dataWithContentsOfFile:settings.pathToFile]];
        }
        [fileHandle writeData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
}

-(void)addBodyBoundary:(BOOL)isStop
{
    NSString *dispositionBoundary = [NSString stringWithFormat:@"--%@%@", boundary, isStop ? @"--" : @"\r\n"];
    [fileHandle writeData:[dispositionBoundary dataUsingEncoding:NSUTF8StringEncoding]];
    if (isStop)
        [fileHandle closeFile];
}

-(void)clear
{
    boundary = nil;
    request = nil;
    task = nil;
    completion = nil;
    fileHandle = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:pathToBody])
        [[NSFileManager defaultManager] removeItemAtPath:pathToBody error:nil];
    pathToBody = nil;
}

@end
