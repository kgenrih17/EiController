//
//  DeviceCommandSender.m
//  EiController
//
//  Created by Genrih Korenujenko on 23.03.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#import "DeviceCommandSender.h"
//#import "EiController-Swift.h"
//
//static NSString * const MODEL_SBC_3_0 = @"acc";
//static NSString * const PROTOCOL_ERROR_MESSAGE = @"Node not supported: requires updated software";
//
//@interface DeviceCommandSender()
//{
//    id <ICommand> currentCommand;
//}
//@end

@implementation DeviceCommandSender

//@synthesize storage, devices, isBusy;
//
//#pragma mark - Init Methods
//-(instancetype)init
//{
//    self = [super init];
//    if (self)
//    {
//        requestSender = [RequestSender new];
//        requestSender.timeout = 30;
//        devices = [NSMutableArray new];
//        isBusy = NO;
//        errorCounter = 0;
//        successCounter = 0;
//    }
//    return self;
//}
//
//#pragma mark - DeviceCommandSenderInteface
//+(instancetype)build:(id<IDeviceOperationLogStorage>)storage
//{
//    DeviceCommandSender *result = [DeviceCommandSender new];
//    result.storage = storage;
//    return result;
//}
//
//-(void)getInfo:(Device*)processingDevice completion:(CommandResultBlock)completion
//{
////    [self prepareCommand:[GetDeviceInfoCommand class] device:processingDevice parameters:nil completion:completion];
//}
//
//-(void)setName:(Device*)processingDevice name:(NSString*)name completion:(CommandResultBlock)completion
//{
////    [self prepareCommand:[SetDeviceNameCommand class] device:processingDevice parameters:name completion:completion];
//}
//
//-(void)restartNode:(Device*)processingDevice params:(NSDictionary*)params completion:(CommandResultBlock)completion
//{
////    [self rebootAndShutdown:processingDevice params:params completion:completion];
//}
//
//-(void)restartNodeList:(NSArray<Device*>*)processingDevices params:(NSDictionary*)params completion:(CommandResultBlock)completion
//{
////    [self prepareCyclicalRequest:processingDevices parameters:params nextAction:@selector(beginRestartingNodes) completion:completion];
//}
//
//-(void)shutdown:(Device*)processingDevice params:(NSDictionary*)params completion:(CommandResultBlock)completion
//{
////    [self rebootAndShutdown:processingDevice params:params completion:completion];
//}
//
//-(void)restartPlayback:(Device*)processingDevice params:(NSDictionary*)params completion:(CommandResultBlock)completion
//{
////    [self rebootAndShutdown:processingDevice params:params completion:completion];
//}
//
//-(void)restartPlaybackList:(NSArray<Device*>*)processingDevices params:(NSDictionary*)params completion:(CommandResultBlock)completion
//{
////    [self prepareCyclicalRequest:processingDevices parameters:params nextAction:@selector(beginRestartingPlayback) completion:completion];
//}
//
//-(void)checkConnectionManagementServer:(Device*)processingDevice address:(NSString*)address completion:(CommandResultBlock)completion
//{
////    [self prepareCommand:[CheckConnectionManagementServer class] device:processingDevice parameters:address completion:completion];
//}
//
//-(void)getManagementServer:(Device*)processingDevice completion:(CommandResultBlock)completion
//{
////    [self prepareCommand:[GetManagementServer class] device:processingDevice parameters:nil completion:completion];
//}
//
//-(void)setManagementServer:(DeviceIntegrationInfo*)integration device:(Device*)processingDevice completion:(CommandResultBlock)completion
//{
////    [self prepareCommand:[SetManagementServer class] device:processingDevice parameters:integration completion:completion];
//}
//
//-(void)setManagementServerList:(DeviceIntegrationInfo*)integration device:(NSArray<Device*>*)processingDevices completion:(CommandResultBlock)completion
//{
////    [self prepareCyclicalRequest:processingDevices parameters:integration nextAction:@selector(beginManagementServers) completion:completion];
//}
//
//-(void)getNetworkSettings:(Device*)processingDevice completion:(CommandResultBlock)completion
//{
////    [self prepareCommand:[GetNetSettingsCommand class] device:processingDevice parameters:nil completion:completion];
//}
//
//-(void)setNetworkSettings:(Device*)processingDevice netSettings:(NetworkSettings*)netSettings completion:(CommandResultBlock)completion
//{
////    [self prepareCommand:[SetUpNetSettingsCommand class] device:processingDevice parameters:netSettings completion:completion];
//}
//
//-(void)setNetworkSettingsList:(NSArray<Device*>*)processingDevices networkSettings:(NetworkSettings*)netSettings completion:(CommandResultBlock)completion
//{
////    [self prepareCyclicalRequest:processingDevices parameters:netSettings nextAction:@selector(beginSetDevicesNetworkSettings) completion:completion];
//}
//
//-(void)setRestartNodeScheduler:(Device*)processingDevice scheduler:(NSDictionary*)info completion:(CommandResultBlock)completion
//{
////    [self setRebootAndShutdownSchedule:processingDevice params:info completion:completion];
//}
//
//-(void)setShutdownNodeScheduler:(Device*)processingDevice scheduler:(NSDictionary*)info completion:(CommandResultBlock)completion
//{
////    [self setRebootAndShutdownSchedule:processingDevice params:info completion:completion];
//}
//
//-(void)setRestartPlaybackScheduler:(Device*)processingDevice scheduler:(NSDictionary*)info completion:(CommandResultBlock)completion
//{
////    [self setRebootAndShutdownSchedule:processingDevice params:info completion:completion];
//}
//
//-(void)getModeConfiguration:(Device*)processingDevice completion:(CommandResultBlock)completion
//{
////    [self prepareCommand:[GetModeConfigurationCommand class] device:processingDevice parameters:nil completion:completion];
//}
//
//-(void)setModeConfiguration:(Device*)processingDevice switchConfig:(SwitchConfig*)switchConfig completion:(CommandResultBlock)completion
//{
////    [self prepareCommand:[SetModeConfigurationCommand class] device:processingDevice parameters:switchConfig completion:completion];
//}
//
//-(void)checkConnectionRMServer:(Device*)processingDevice address:(NSString*)address completion:(CommandResultBlock)completion
//{
////    [self prepareCommand:[CheckConnectionRMServerCommand class] device:processingDevice parameters:address completion:completion];
//}
//
//-(void)setReverseMonitoringServer:(Device*)processingDevice params:(NSDictionary*)parameters completion:(CommandResultBlock)completion
//{
////    [self prepareCommand:[SetRMServerCommand class] device:processingDevice parameters:parameters completion:completion];
//}
//
//-(void)setReverseMonitoringServerList:(NSArray<Device*>*)processingDevices params:(NSDictionary*)parameters completion:(CommandResultBlock)completion
//{
////    [self prepareCyclicalRequest:processingDevices parameters:parameters nextAction:@selector(beginSetReverseMonitoring) completion:completion];
//}
//
//-(void)getReverseMonitoringServer:(Device*)processingDevice completion:(CommandResultBlock)completion
//{
////    [self prepareCommand:[GetRMServerCommand class] device:processingDevice parameters:nil completion:completion];
//}
//
//-(void)checkConnectionUpdateServer:(Device*)processingDevice address:(NSString*)address completion:(CommandResultBlock)completion
//{
////    [self prepareCommand:[CheckConnectionUpdateServerCommand class] device:processingDevice parameters:address completion:completion];
//}
//
//-(void)setUpdateServer:(Device*)processingDevice params:(NSDictionary*)parameters completion:(CommandResultBlock)completion
//{
////    [self prepareCommand:[SetUpdateServerCommand class] device:processingDevice parameters:parameters completion:completion];
//}
//
//-(void)getUpdateServerCommand:(Device*)processingDevice completion:(CommandResultBlock)completion
//{
////    [self prepareCommand:[GetUpdateServerCommand class] device:processingDevice parameters:nil completion:completion];
//}
//
//#pragma mark - Private Methods
//-(void)rebootAndShutdown:(Device*)processingDevice params:(NSDictionary*)parameters completion:(CommandResultBlock)completion
//{
//    [self prepareCommand:[RebootAndShutdownCommand class] device:processingDevice parameters:params completion:completion];
//}
//
//-(void)setRebootAndShutdownSchedule:(Device*)processingDevice params:(NSDictionary*)parameters completion:(CommandResultBlock)completion
//{
//    [self prepareCommand:[SetScheduleRebootCommand class] device:processingDevice parameters:parameters completion:completion];
//}
//
//-(void)prepareCommand:(Class)commandClass device:(Device*)newDevice parameters:(id)parameters completion:(CommandResultBlock)completion
//{
//    blockResult = completion;
//    if (!isBusy)
//    {
//        device = newDevice;
//        currentCommand = [commandClass new];
//        if ([currentCommand build:device.fingerprint :parameters])
//            [self sendCommand];
//        else
//            [self retrieveError:@"Can't build command"];
//    }
//    else
//        [self retrieveError:@"Sender is busy"];
//}
//
//-(void)prepareCyclicalRequest:(NSArray*)processingDevices parameters:(id)parameters nextAction:(SEL)action completion:(CommandResultBlock)completion
//{
//    if (!isBusy)
//    {
//        [devices removeAllObjects];
//        [devices addObjectsFromArray:processingDevices];
//        params = parameters;
//        listBlockResult = completion;
//        ((void (*)(id, SEL))[self methodForSelector:action])(self, action);
//    }
//    else
//    {
//        blockResult = completion;
//        [self retrieveError:@"Sender is busy"];
//    }
//}
//
//-(void)beginRestartingNodes
//{
//    if (!devices.isEmpty)
//    {
//        __block NSMutableArray *welfDevices = devices;
//        __block DeviceCommandSender *welf = self;
//        [self restartNode:devices.lastObject params:params completion:^(CommandResult *result)
//        {
//            [welfDevices removeLastObject];
//            [welf performSelector:@selector(beginRestartingNodes) withObject:nil afterDelay:0.2f];
//        }];
//    }
//    else
//        [self completeGroupRequest];
//}
//
//-(void)beginRestartingPlayback
//{
//    if (!devices.isEmpty)
//    {
//        __block NSMutableArray *welfDevices = devices;
//        __block DeviceCommandSender *welf = self;
//        [self restartPlayback:devices.lastObject params:params completion:^(CommandResult *result)
//         {
//             [welfDevices removeLastObject];
//             [welf performSelector:@selector(beginRestartingPlayback) withObject:nil afterDelay:0.2f];
//         }];
//    }
//    else
//        [self completeGroupRequest];
//}
//
//-(void)beginManagementServers
//{
//    if (!devices.isEmpty)
//    {
//        __block NSMutableArray *welfDevices = devices;
//        __block DeviceCommandSender *welf = self;
//        [self setManagementServer:params device:devices.lastObject completion:^(id result)
//        {
//            [welfDevices removeLastObject];
//            [welf performSelector:@selector(beginManagementServers) withObject:nil afterDelay:0.2f];
//        }];
//    }
//    else
//        [self completeGroupRequest];
//}
//
//-(void)beginSetDevicesNetworkSettings
//{
//    if (!devices.isEmpty)
//    {
//        __block NSMutableArray *welfDevices = devices;
//        __block DeviceCommandSender *welf = self;
//        [self setNetworkSettings:devices.lastObject netSettings:params completion:^(id result)
//        {
//             [welfDevices removeLastObject];
//             [welf performSelector:@selector(beginSetDevicesNetworkSettings) withObject:nil afterDelay:0.2f];
//         }];
//    }
//    else
//        [self completeGroupRequest];
//}
//
//-(void)beginSetReverseMonitoring
//{
//    if (!devices.isEmpty)
//    {
//        __block NSMutableArray *welfDevices = devices;
//        __block DeviceCommandSender *welf = self;
//        [self setReverseMonitoringServer:devices.lastObject params:params completion:^(id result)
//        {
//            [welfDevices removeLastObject];
//            [welf performSelector:@selector(beginSetReverseMonitoring) withObject:nil afterDelay:0.2f];
//        }];
//    }
//    else
//        [self completeGroupRequest];
//}
//
//-(void)completeGroupRequest
//{
//    [self retrieveResult:[self getGroupRequestMessages]];
//    errorCounter = 0;
//    successCounter = 0;
//}
//
//-(NSString*)getGroupRequestMessages
//{
//    return [NSString stringWithFormat:@"%tu requests are successful and %tu requests are failed", successCounter, errorCounter];
//}
//
//-(void)sendCommand
//{
//    isBusy = YES;
//    NSString *parameters = [self getParameters];
//    NSString *url = [self getURL];
//    [requestSender setUrl:url];
//    [requestSender sendPost:parameters completion:^(RequestResult *result)
//    {
//        [self parse:result];
//    }];
//}
//
//-(void)parse:(RequestResult*)result
//{
//    if (result.errorStr != nil)
//    {
//        [self retrieveError:result.errorStr];
//    }
//    else if (result.isRPC)
//    {
//        id rpcResult = [result getRPCResult];
//        if (result.isHaveError)
//            [self retrieveError:[result getRPCErrorMessage]];
//        else if (rpcResult != nil && [currentCommand isCorrectFormat:rpcResult])
//            [self retrieveResult:[currentCommand createWithResponse:rpcResult]];
//        else
//            [self retrieveError:PROTOCOL_ERROR_MESSAGE];
//    }
//    else
//    {
//        NSDictionary *json = result.resultStr.json;
//        if ([self isValidFormat:json] && ([json containsKey:@"params"] ||
//                                          ([json containsKey:@"result"] && [json integerForKey:@"result"] > 0)))
//        {
//            id parameters = [json dictionaryForKey:@"params"];
//            if (parameters != nil && [currentCommand isCorrectFormat:parameters])
//                [self retrieveResult:[currentCommand createWithResponse:parameters]];
//            else
//                [self retrieveError:PROTOCOL_ERROR_MESSAGE];
//        }
//        else if ([json containsKey:@"error"])
//            [self retrieveError:[json objectForKey:@"error"]];
//        else
//            [self retrieveError:PROTOCOL_ERROR_MESSAGE];
//    }
//}
//
//-(BOOL)isValidFormat:(NSDictionary*)dic
//{
//    BOOL result = NO;
//    if (dic != nil && ![[dic class] isSubclassOfClass:[NSNull class]] &&
//        [[dic class] isSubclassOfClass:[NSDictionary class]] && !dic.isEmpty)
//        result = YES;
//    return result;
//}
//
//-(NSString*)getURL
//{
//    NSURLComponents *urlComponents = [NSURLComponents new];
//    urlComponents.scheme = HTTP_KEY;
//    urlComponents.port = (device.port > 0) ? @(device.port) : nil;
//    urlComponents.host = device.address;
//
//    if ([device.productId isEqualToString:MODEL_SBC_3_0])
//    {
//        NSURLQueryItem *settingsQuery = [NSURLQueryItem queryItemWithName:@"model" value:@"settings"];
//        NSURLQueryItem *methodQuery = [NSURLQueryItem queryItemWithName:@"method" value:currentCommand.command];
//        urlComponents.queryItems = @[settingsQuery, methodQuery];
//        urlComponents.path = @"/server";
//    }
//    else
//    {
//        urlComponents.queryItems = @[];
//        urlComponents.path = @"/das-json.php";
//    }
//    return urlComponents.URL.absoluteString;
//}
//
//-(NSString*)getParameters
//{
//    NSString *result = nil;
//    if ([device.productId isEqualToString:MODEL_SBC_3_0])
//        result = currentCommand.params.json;
//    else
//        result = [NSDictionary RPCWithMethod:currentCommand.command params:currentCommand.params];
//
//    return result;
//}
//
//-(NSString*)validationError:(NSString*)error
//{
//    NSString *result = nil;
//    if ([error containsString:@".php"] || [error containsString:@"html"])
//        result = PROTOCOL_ERROR_MESSAGE;
//    else
//        result = error;
//    return result;
//}
//
//-(void)retrieveError:(NSString*)error
//{
//    errorCounter++;
//    NSString *validError = [self validationError:error];
//    [self writeDeviceOperationLog:NSStringFromClass([currentCommand class]) error:validError desc:nil fingerprint:device.fingerprint];
//    [self notifBlockResult:[CommandResult initWithError:validError]];
//}
//
//-(void)retrieveResult:(id)result
//{
//    successCounter++;
//    [self writeDeviceOperationLog:NSStringFromClass([currentCommand class]) error:nil desc:@"Command executed successfully" fingerprint:device.fingerprint];
//    [self notifBlockResult:[CommandResult initWithResult:result]];
//}
//
//-(void)writeDeviceOperationLog:(NSString*)title error:(NSString*)error desc:(NSString*)desc fingerprint:(NSString*)fingerprint
//{
//    DeviceOperationLog *deviceOperationLog = [DeviceOperationLog build:title code:0 errorMessage:error desc:desc fingerprint:fingerprint];
//    [storage add:deviceOperationLog];
//}
//
//-(void)notifBlockResult:(CommandResult*)result
//{
//    BLOCK_SAFE_RUN(blockResult, result);
//    blockResult = nil;
//    isBusy = NO;
//}
//
@end
