//
//  NodeCommandSender.swift
//  EiController
//
//  Created by Genrih Korenujenko on 12.06.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit
import RxSwift

let MODEL_SBC_3_0 = "acc"
let PROTOCOL_ERROR_MESSAGE = "Node not supported: requires updated software"
let OPERATION_FAILED_ERROR_MESSAGE = "Operation Failed"

class NodeCommandSender: NSObject, INodeCommandSender
{
    var operationLogStorage : IDeviceOperationLogStorage!
    var apiService : INodeApiService?
    var disposable : Disposable?
    var commandResult : CommandResult?
    
    static func build(_ storage: IDeviceOperationLogStorage) -> INodeCommandSender
    {
        let result = NodeCommandSender()
        result.operationLogStorage = storage
        return result
    }
    
    func send(command nodeCommand: ENodeCommand, node: Device, parameters: Any?, completion: ((CommandResult) -> Void)?)
    {
        let command = buildCommand(nodeCommand, parameters: parameters)
        disposable = buildRequest(node, command)
            .observeOn(MainScheduler.instance)
            .subscribeOn(OperationQueueScheduler.init(operationQueue: OperationQueue()))
            .subscribe({_ in self.completion(completion) })
    }
    
    func send(command nodeCommand: ENodeCommand, nodes: [Device], parameters: Any?, completion: ((CommandResult) -> Void)?)
    {
        let command = buildCommand(nodeCommand, parameters: parameters)
        disposable = Observable.from(nodes)
            .observeOn(MainScheduler.instance)
            .flatMap({ (node) -> Observable<JSONRPCResponse> in
                return self.buildRequest(node, command)
                    .asObservable()
                    .catchErrorJustReturn(JSONRPCResponse.build(error: "Node Unavailable"))
            })
            .subscribeOn(OperationQueueScheduler.init(operationQueue: OperationQueue()))
            .subscribe(onCompleted: {
                self.commandResult = CommandResult.initWithResult(NSNumber(value: true))
                self.completion(completion)
            })
    }
    
    func send(commands: [AnyHashable : Any?], node: Device, endedCommand: ((ENodeCommand,CommandResult) -> Void)?, completion: ((CommandResult) -> Void)?)
    {
        disposable = Observable.from(commands)
            .observeOn(MainScheduler.instance)
            .flatMap({ (item) -> Observable<JSONRPCResponse> in
                let key : ENodeCommand!
                if (item.key as? String) != nil
                {
                    key = ENodeCommand.init(rawValue: Int(item.key as! String)!)!
                }
                else if (item.key as? Int) != nil
                {
                    key = ENodeCommand.init(rawValue: item.key as! Int)!
                }
                else
                {
                    key = ENodeCommand(rawValue:item.key.hashValue)!
                }
                let command = self.buildCommand(key, parameters: item.value)
                return self.buildRequest(node, command)
                    .asObservable()
                    .do(onNext: { response in
                        endedCommand?(key,self.commandResult!)
                    })
                    .catchErrorJustReturn(JSONRPCResponse.build(error: "Node Unavailable"))
            })
            .subscribeOn(OperationQueueScheduler.init(operationQueue: OperationQueue()))
            .subscribe(onCompleted: {
                self.commandResult = CommandResult.initWithResult(NSNumber(value: true))
                self.completion(completion)
            })
    }
    
    func cancel()
    {
        disposable?.dispose()
        completion(nil)
    }
    
    private func buildApi(_ node: Device!) -> INodeApiService
    {
        let connectionData = ConnectionData.create(withScheme: HTTP_KEY, host: node.address, port: node.port)
        return NodeApiService.build(connectionData!, node.fingerprint)
    }
    
    private func buildCommand(_ nodeCommand: ENodeCommand, parameters: Any?) -> INodeCommand
    {
        let command : INodeCommand!
        switch nodeCommand
        {
        case .GET_INFO:
            command = GetDeviceInfoCommand.build(parameters)
        case .GET_MANAGEMENT_SERVER:
            command = GetManagementServer.build(parameters)
        case .GET_MODE_CONFIGURATION:
            command = GetModeConfigurationCommand.build(parameters)
        case .GET_NET_SETTINGS:
            command = GetNetSettingsCommand.build(parameters)
        case .GET_RM_SERVER:
            command = GetRMServerCommand.build(parameters)
        case .GET_UPDATE_SERVER:
            command = GetUpdateServerCommand.build(parameters)
        case .CHECK_CONNECTION_MANAGEMENT_SERVER:
            command = CheckConnectionManagementServer.build(parameters)
        case .CHECK_CONNECTION_RM_SERVER:
            command = CheckConnectionRMServerCommand.build(parameters)
        case .CHECK_CONNECTION_UPDATE_SERVER:
            command = CheckConnectionUpdateServerCommand.build(parameters)
        case .REBOOT_AND_SHUTDOWN:
            command = RebootAndShutdownCommand.build(parameters)
        case .RESET:
            command = ResetCommand.build(parameters)
        case .UPDATE:
            command = UpdateCommand.build(parameters)
        case .FILE_SYSTEM_CHECK:
            command = FileSystemCheckCommand.build(parameters)
        case .STORAGE_CLEANUP:
            command = StorageCleanupCommand.build(parameters)
        case .SET_NAME:
            command = SetDeviceNameCommand.build(parameters)
        case .SET_MANAGEMENT_SERVER:
            command = SetManagementServer.build(parameters)
        case .SET_SCHEDULE_REBOOT_AND_SHUTDOWN:
            command = SetScheduleRebootCommand.build(parameters)
        case .SET_RM_SERVER:
            command = SetRMServerCommand.build(parameters)
        case .SET_UPDATE_SERVER:
            command = SetUpdateServerCommand.build(parameters)
        case .SET_NET_SETTINGS:
            command = SetUpNetSettingsCommand.build(parameters)
        case .SET_PAIR_CONTROLLER:
            command = SetPairControllerCommand.build(parameters)
        case .SET_DISCONNECT_CONTROLLER:
            command = SetDisconnectControllerCommand.build(parameters)
        case .SET_PAIR_NODE:
            command = SetPairNodeCommand.build(parameters)
        case .SET_DISCONNECT_NODE:
            command = SetDisconnectNodeCommand.build(parameters)
        case .SET_REMOTE_NODE_SWITCH_SETTINGS:
            command = SetRemoteNodeSwitchSettingsCommand.build(parameters)
        }
        return command
    }

    private func buildRequest(_ node: Device, _ command: INodeCommand) -> Single<JSONRPCResponse>
    {
        apiService = buildApi(node)
        let request = JSONRPCRequest.build(command.method, command.params)
        return apiService!.request(request)
            .do(onSuccess: { response in self.processingResponse(response, fingerprint: node.fingerprint, command: command) },
                onError: { error in self.processingError(error.localizedDescription, fingerprint: node.fingerprint, command: command) })
    }
    
    private func processingResponse(_ response: JSONRPCResponse, fingerprint: String, command: INodeCommand)
    {
        if command.isCorrectResponse(response)
        {
            if command.isSuccessfulAnswer(response)
            {
                writeOperationLog(command.desc, message: nil, desc: "Command executed successfully", fingerprint: fingerprint)
                commandResult = CommandResult.initWithResult(command.prepareResult(response))
            }
            else
            {
                processingError(OPERATION_FAILED_ERROR_MESSAGE, fingerprint: fingerprint, command: command)
            }
        }
        else
        {
            if response.error != nil
            {
                processingError(response.error!.message, fingerprint: fingerprint, command: command)
            }
            else
            {
                processingError(PROTOCOL_ERROR_MESSAGE, fingerprint: fingerprint, command: command)
            }
        }
    }
    
    private func processingError(_ error: String, fingerprint: String, command: INodeCommand)
    {
        var validError : String
        if error.contains(".php") || error.contains("html")
        {
            validError = PROTOCOL_ERROR_MESSAGE;
        }
        else if error.contains("Could not connect to the server")
        {
            validError = "[Ei] Node is unreachable"
        }
        else
        {
            validError = error
        }
        writeOperationLog(command.desc, message: validError, desc: "Command execution failed", fingerprint: fingerprint)
        commandResult = CommandResult.initWithError(validError)
    }
    
    private func completion(_ completion: ((CommandResult) -> Void)?)
    {
        let result = commandResult
        commandResult = nil
        apiService = nil
        disposable = nil
        completion?(result!)
    }
    
    private func writeOperationLog(_ title: String, message: String?, desc: String?, fingerprint: String)
    {
        let operationLog = DeviceOperationLog.build(title, code: 0, errorMessage: message, desc: desc, fingerprint: fingerprint)
        operationLogStorage.add(operationLog)
    }
}

