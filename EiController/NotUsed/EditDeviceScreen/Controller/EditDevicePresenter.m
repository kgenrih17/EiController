//
//  EditDevicePresenter.m
//  EiController
//
//  Created by Genrih Korenujenko on 22.10.17.
//  Copyright © 2017 RadicalComputing. All rights reserved.
//

//#import "EditDevicePresenter.h"
//#import "DeviceOperationLogsTable.h"
//#import "EiController-Swift.h"
//
//static const NSInteger NAME_LENGTH_VALUE_MAX = 40;
//
//@interface EditDevicePresenter ()
//
//@property (nonatomic, readwrite, weak) id <EditDeviceScreenInterface> screen;
//@property (nonatomic, readwrite, weak) id <AppInteractorInterface> interactor;
//@property (nonatomic, readwrite, strong) id <INodeCommandSender> commandSender;
//@property (nonatomic, readwrite, weak) Device *device;
//@property (nonatomic, readwrite, strong) NSString *fingerprint;
//
//@end
//
//@implementation EditDevicePresenter
//
//@synthesize screen, interactor, commandSender, fingerprint, device;
//
//#pragma mark - Public Init Methods
//+(instancetype)presenterWithScreen:(id<EditDeviceScreenInterface>)screenInterface
//                        interactor:(id<AppInteractorInterface>)interactorInterface
//                       fingerprint:(NSString*)fingerprint
//{
//    EditDevicePresenter *result = [EditDevicePresenter new];
//    result.screen = screenInterface;
//    result.interactor = interactorInterface;
//    result.commandSender = [NodeCommandSender build:[DeviceOperationLogsTable new]];
//    result.fingerprint = fingerprint;
//
//    return result;
//}
//
//#pragma mark - Public Methods
//-(void)onCreate
//{
//    id <INodeStorage> devicesStorage = interactor.nodeStorageInterface;
//    device = [devicesStorage getDevicesByFingerprints:@[fingerprint]].firstObject;
//    [self refreshScreen];
//}
//
//-(void)saveTitle:(NSString*)title
//{
//    [screen showProgressWithMessage:@"Processing.."];
//    [commandSender sendWithCommand:ENodeCommandSET_NAME node:device parameters:title completion:^(CommandResult *result)
//    {
//        if (result.error == nil)
//        {
//            device.title = title;
//            [self refreshScreen];
//            [screen showAlertWithTitle:@"Info" message:@"Successful"];
//        }
//        else
//            [screen showAlertWithTitle:@"Error" message:result.error];
//        [screen hideProgress];
//    }];
//}
//
//-(BOOL)isValidateName:(NSString*)name
//{
//    BOOL isValid = !([name containsString:@"<"] || [name containsString:@">"]);
//    return (isValid && name.length <= NAME_LENGTH_VALUE_MAX);
//}
//
//#pragma mark - Private Methods
//-(void)refreshScreen
//{
//    EditDeviceViewModel *viewModel = [EditDeviceViewModel new];
//    viewModel.title = device.title;
//    [screen refresh:viewModel];
//}
//
//@end
