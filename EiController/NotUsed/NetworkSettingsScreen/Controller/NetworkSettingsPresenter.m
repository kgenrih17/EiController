//
//  NetworkSettingsPresenter.m
//  EiController
//
//  Created by Genrih Korenujenko on 22.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

#import "NetworkSettingsPresenter.h"
#import "DeviceOperationLogsTable.h"
#import "EiController-Swift.h"

@interface NetworkSettingsPresenter ()
{
    NetworkSettingsViewModel *model;
}
@property (nonatomic, readwrite, weak) id <NetworkSettingsScreenInterface> screen;
@property (nonatomic, readwrite, weak) id <AppInteractorInterface> interactor;
//@property (nonatomic, readwrite, strong) id <INodeCommandSender> commandSender;
@property (nonatomic, readwrite, strong) NSArray <NSString*> *fingerprints;

@end

@implementation NetworkSettingsPresenter

//@synthesize screen, interactor, commandSender, fingerprints;
//
//#pragma mark - Public Init Methods
//+(instancetype)presenterWithScreen:(id<NetworkSettingsScreenInterface>)screenInterface
//                        interactor:(id<AppInteractorInterface>)interactorInterface
//                      fingerprints:(NSArray<NSString*>*)fingerprints
//{
//    NetworkSettingsPresenter *result = [NetworkSettingsPresenter new];
//    result.screen = screenInterface;
//    result.interactor = interactorInterface;
//    result.commandSender = [NodeCommandSender build:[DeviceOperationLogsTable new]];
//    result.fingerprints = fingerprints;
//
//    return result;
//}
//
//#pragma mark - Public Methods
//-(void)onCreate
//{
//    model = [NetworkSettingsViewModel new];
//    if (fingerprints.count == 1)
//    {
//        id <INodeStorage> deviceStorage = interactor.nodeStorageInterface;
//        Device *device = [deviceStorage getDeviceByFingerprint:fingerprints.firstObject];
//        NSInteger currentTime = [NSDate date].timeIntervalSince1970;
//        NSInteger timeoutDetailsInfoUpdate = SECOND_IN_ONE_MINUTE / 2;
//        if (currentTime - device.netSettings.lastSyncTimestamp >= timeoutDetailsInfoUpdate)
//            [self getSettingsFromViewModel:model];
//        else
//            [self refreshScreen:device];
//    }
//    else
//        [screen refresh:model];
//}
//
//-(void)save:(NetworkSettingsViewModel*)viewModel
//{
//    model = viewModel;
//    [screen showProgressWithMessage:@"Processing..."];
//    id <INodeStorage> deviceStorage = interactor.nodeStorageInterface;
//    NSArray *devices = [deviceStorage getDevicesByFingerprints:fingerprints];
//    [commandSender sendWithCommand:ENodeCommandSET_NET_SETTINGS nodes:devices parameters:viewModel.tempSettings completion:^(CommandResult *result)
//     {
//        [screen hideProgress];
//        if (result.error == nil)
//        {
//            [self updateNetworkSettings:viewModel.tempSettings];
//            [screen showAlertWithTitle:@"Info" message:@"Successful"];
//        }
//        else
//            [screen showAlertWithTitle:@"Error" message:result.error];
//    }];
//}
//
//#pragma mark - Private Methods
//-(void)getSettingsFromViewModel:(NetworkSettingsViewModel*)viewModel
//{
//    [screen showProgressWithMessage:@"Processing..."];
//
//    id <INodeStorage> deviceStorage = interactor.nodeStorageInterface;
//    Device *device = [deviceStorage getDeviceByFingerprint:fingerprints.firstObject];
//    [commandSender sendWithCommand:ENodeCommandGET_NET_SETTINGS node:device parameters:nil completion:^(CommandResult *result)
//    {
//        [screen hideProgress];
//       if (result.error == nil)
//        {
//            Device *device = [self updateNetworkSettings:(NetworkSettings*)result.params];
//            [self refreshScreen:device];
//            [screen hideError];
//        }
//        else
//            [screen showError:result.error];
//    }];
//}
//
//-(void)refreshScreen:(Device*)device
//{
//    model.settings = device.netSettings;
//    model.tempSettings = [model.settings copy];
//    model.securityProtocols = [self getProtocols];
//    NSArray *protocols = [model.securityProtocols objectForKey:@"keys"];
//    model.selectedProtocolIndex = ([protocols containsObject:model.settings.wifiSecurityProtocol]) ? [protocols indexOfObject:model.settings.wifiSecurityProtocol] : 0;
//    [screen refresh:model];
//}
//
//-(Device*)updateNetworkSettings:(NetworkSettings*)networkSettings
//{
//    id <INodeStorage> deviceStorage = interactor.nodeStorageInterface;
//    Device *device = [deviceStorage getDeviceByFingerprint:fingerprints.firstObject];
//    device.netSettings = networkSettings;
//    return device;
//}
//
//-(NSDictionary*)getProtocols
//{
//    return @{@"keys" : @[@"NONE", @"WEP", @"WPA-PSK", @"WPA-EAP-PEAP"],
//             @"values" : @[@"NONE", @"WEP", @"WPA/WPA2 PSK", @"WPA/WPA2 EAP PEAP"]};
//}

@end
