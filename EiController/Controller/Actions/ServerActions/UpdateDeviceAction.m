//
//  UpdateApplianceAction.m
//  EiController
//
//  Created by Genrih Korenujenko on 20.12.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "UpdateDeviceAction.h"
#import "PublisherConnectionData.h"

@implementation UpdateDeviceAction

@synthesize api, storage, listener, validator;

#pragma mark - Public Init Methods
+(instancetype)build:(id<CentralAPIInterface>)api
             storage:(id<INodeStorage>)storage
            listener:(id<UpdateDeviceActionListener>)listener
{
    UpdateDeviceAction *result = [UpdateDeviceAction new];
    result.api = api;
    result.storage = storage;
    result.listener = listener;
    return result;
}

#pragma mark - ActionInterface
-(void)do:(Completion)completion
{
    [api getDevices:^(NSDictionary*answer)
    {
        [[Logger currentLog] writeWithObject:self selector:_cmd text:@"Received a response from the server" logLevel:DEBUG_L];
        validator = [[UpdateDeviceValidator alloc] initWithError:[api getErrorMessage] response:answer];
        if (validator.isValid)
        {
            [self parse:answer];
            [listener actionReport:100 error:nil description:@"Node list updated"];
        }
        else
            [listener actionReport:100 error:validator.error description:@"Node list not updated"];
        completion([ActionResult build:validator.error data:nil]);
    }];
}

-(void)cancel
{
    [api cancel];
    [listener actionReport:100 error:[ErrorDescription getError:PROCESS_CANCELED] description:[ErrorDescription getError:PROCESS_CANCELED]];
}

#pragma mark - Private Methods
-(void)parse:(NSDictionary*)answer;
{
    [self saveDevices:answer[@"nodes"]];
    [self savePublisher:answer[@"publisher"]];
}

-(void)saveDevices:(NSArray<NSDictionary*>*)items
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:items.count];
    [items enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        Device *item = [Device centralDevice:obj];
        [result addObject:item];
    }];
    if (result.isEmpty)
        [[Logger currentLog] writeWithObject:self selector:_cmd text:@"Data is empty" logLevel:DEBUG_L];
    [storage setCentralDevices:result];
}

-(void)savePublisher:(NSDictionary*)item
{
    PublisherConnectionData *result = [PublisherConnectionData createWithScheme:HTTP_KEY
                                                                           host:item[@"host"]
                                                                           port:[item[@"port"] integerValue]];
    PublisherConnectionData *oldPublisher = [PublisherConnectionData get];
    if (![result isEqual:oldPublisher])
    {
        [result save];
        [listener publisherDataUpdated];
    }
}

@end
