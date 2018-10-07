//
//  NodeIntegrationPresenter.swift
//  EiController
//
//  Created by Henrikh Koreniuzhenko on 02.09.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

let MAX_TOKEN_LENGTH = 100
let MAX_TIMEOUT = 2592000

class NodeIntegrationPresenter: NSObject
{
    private weak var view: INodeIntegrationView?
    private weak var interactor: AppInteractorInterface?
    private weak var navigation: NavigationInterface?
    private var fingerprints: [String]
    
    private var commandSender: INodeCommandSender!
    private var viewModel: NodeIntegrationViewModel?
    
    init(interactor : AppInteractorInterface, navigation : NavigationInterface, fingerprints: [String])
    {
        self.interactor = interactor
        self.navigation = navigation
        self.fingerprints = fingerprints
        self.commandSender = NodeCommandSender.build(DeviceOperationLogsTable())
        super.init()
    }
    
    func onAttachView(_ view: INodeIntegrationView)
    {
        self.view = view
        createViewModel()
        view.fill(viewModel!)
    }
    
    func onDettachView()
    {
        view = nil
    }
    
    func onClickSave()
    {
        view?.retrieveChanges()
        sendSetIntegration()
    }
    
    func onClickCheckManagement()
    {
        view?.retrieveChanges()
        sendCheckConnection(command: .CHECK_CONNECTION_MANAGEMENT_SERVER, host: viewModel!.managementHost) { (isSuccess, message) in
            self.view?.showAlert(withTitle: isSuccess ? "Info" : "Error", message: message)
        }
    }
    
    func onClickCheckReverseMonitoring()
    {
        view?.retrieveChanges()
        sendCheckConnection(command: .CHECK_CONNECTION_RM_SERVER, host: viewModel!.reversMonitoringHost) { (isSuccess, message) in
            self.viewModel?.isReversMonitoringError = !isSuccess
            self.viewModel?.reversMonitoringMessage = message
            self.view?.fill(self.viewModel!)
        }
    }
    
    func onClickCheckUpdate()
    {
        view?.retrieveChanges()
        sendCheckConnection(command: .CHECK_CONNECTION_UPDATE_SERVER, host: viewModel!.updateHost) { (isSuccess, message) in
            self.viewModel?.isUpdateError = !isSuccess
            self.viewModel?.updateMessage = message
            self.view?.fill(self.viewModel!)
        }
    }
}

private extension NodeIntegrationPresenter
{
    func createViewModel()
    {
        viewModel = NodeIntegrationViewModel()
        viewModel?.isExtenderMode = AppStatus.isExtendedMode()
        if fingerprints.count == 1
        {
            let node = getFirstNode()
            if isDataUpdated(node: node)
            {
                refreshViewModel(node: node)
            }
            else
            {
                sendGetIntegration(node: node)
            }
        }
    }
    
    func isDataUpdated(node: Device) -> Bool
    {
        return !(node.esIntegrInfo == nil || node.tunnelAddress == nil || node.tunnelAddress.isEmpty || node.updateServerAddress == nil || node.updateServerAddress.isEmpty)
    }
    
    func refreshViewModel(node: Device)
    {
        viewModel?.isManagementOn = node.esIntegrInfo.isOn
        viewModel?.isUseUpdateOn = node.esIntegrInfo.isUseUpdate
        viewModel?.isUseSFTPOn = node.esIntegrInfo.isUseSFTP
        
        viewModel?.managementHost = ConnectionData.create(withAddress: node.esIntegrInfo?.host ?? "", port: 80)?.host ?? ""
        viewModel?.httpPort = String(node.esIntegrInfo.httpPort)
        viewModel?.sshPort = String(node.esIntegrInfo.sshPort)
        viewModel?.timeout = String(node.esIntegrInfo.esTaskCompletionTimeout)
        viewModel?.token = node.esIntegrInfo.registrationToken ?? ""
        
        viewModel?.isReversMonitoringOn = node.isUseTunnel
        viewModel?.reversMonitoringHost = ConnectionData.create(withAddress: node.tunnelAddress ?? "", port: 80)?.host ?? ""
        
        viewModel?.isUpdateOn = node.isEnableUpdateServer
        viewModel?.updateHost = ConnectionData.create(withAddress: node.updateServerAddress ?? "", port: 80)?.host ?? ""
    }
    
    func sendCheckConnection(command: ENodeCommand, host: String, completion: ((Bool, String) -> Void)?)
    {
        view?.showProcessing()
        commandSender.send(command: command, node: getFirstNode(), parameters: host) { (result) in
            self.view?.hideProgress()
            let isSuccess = (result.error == nil && (result.params as? NSNumber != nil) && (result.params as! NSNumber).boolValue)
            let message = isSuccess ? "The verification process completed successfully" : "A connection with the server cannot be established"
            completion?(isSuccess, message)
        }
    }
    
    func sendGetIntegration(node: Device)
    {
        view?.showProcessing()
        let commands : [ENodeCommand:Any?] = [.GET_MANAGEMENT_SERVER : nil, .GET_RM_SERVER : nil, .GET_UPDATE_SERVER : nil]
        commandSender.send(commands: commands, node: node, endedCommand: { (command, result) in
            self.parse(command: command, result: result, node: node)
        }) { (result) in
            self.view?.hideProgress()
            self.refreshViewModel(node: node)
            self.view?.fill(self.viewModel!)
        }
    }
    
    func sendSetIntegration()
    {
        view?.showProcessing()
        if fingerprints.count == 1
        {
            let node = getFirstNode()
            let commands : [ENodeCommand:Any?] = [.SET_MANAGEMENT_SERVER : getManagementParams(node: node),
                                                  .SET_RM_SERVER : getReverseMonitoringParams(),
                                                  .SET_UPDATE_SERVER : getUpdateParams()]
            commandSender.send(commands: commands, node: node, endedCommand: { (command, result) in
                if result.error == nil
                {
                    result.params = commands[command] ?? nil
                }
                self.parse(command: command, result: result, node: node)
            }) { (result) in
                self.view?.hideProgress()
                self.refreshViewModel(node: node)
            }
        }
        else
        {
            /// TODO hvk: need implemented
            let nodes = getAllNodes()
//            commandSender.send(command: ENodeCommand.SET_MANAGEMENT_SERVER, nodes: devices, parameters: integration) { (result : CommandResult?) in
//                self.parseSaveResponse(result, integration: integration, devices: devices)
//            }
        }
    }
    
    func parse(command: ENodeCommand, result: CommandResult, node: Device)
    {
        switch (command)
        {
        case .GET_MANAGEMENT_SERVER, .SET_MANAGEMENT_SERVER:
            if result.error == nil
            {
                node.esIntegrInfo = result.params as! DeviceIntegrationInfo
            }
        case .GET_RM_SERVER, .SET_RM_SERVER:
            if result.error == nil
            {
                let answer = result.params as! [String:Any]
                node.isUseTunnel = answer.bool("tunnel_enabled")
                node.tunnelAddress = answer.string("tunnel_address")
                if command == .SET_RM_SERVER
                {
                    fillReverseMonitoringBy(message: "The verification process completed successfully", isError: false)
                }
            }
            else
            {
                fillReverseMonitoringBy(message: result.error, isError: true)
            }
        case .GET_UPDATE_SERVER, .SET_UPDATE_SERVER:
            if result.error == nil
            {
                let answer = result.params as! [String:Any]
                node.isEnableUpdateServer = answer.bool("status")
                node.updateServerAddress = answer.string("host")
                if command == .SET_UPDATE_SERVER
                {
                    fillUpdateBy(message: "The verification process completed successfully", isError: false)
                }
            }
            else
            {
                fillUpdateBy(message: result.error, isError: true)
            }
        default:
            break
        }
    }
    
    func fillReverseMonitoringBy(message: String, isError: Bool)
    {
        viewModel?.isReversMonitoringOn = isError
        viewModel?.reversMonitoringMessage = message
    }
    
    func fillUpdateBy(message: String, isError: Bool)
    {
        viewModel?.isUpdateError = isError
        viewModel?.updateMessage = message
    }

    func getAllNodes() -> [Device]
    {
        return interactor!.getNodeStorage().getDevicesByFingerprints(fingerprints)
    }
    
    func getFirstNode() -> Device
    {
        return interactor!.getNodeStorage().getDeviceByFingerprint(fingerprints.first!)!
    }
    
    func getManagementParams(node: Device) -> DeviceIntegrationInfo
    {
        let params = DeviceIntegrationInfo()
        params.host = viewModel!.managementHost
        params.registrationToken = viewModel!.token
        params.httpPort = Int(viewModel!.httpPort) ?? 80
        params.sshPort = Int(viewModel!.sshPort) ?? 2222
        params.esTaskCompletionTimeout = Int(viewModel!.timeout) ?? 86400
        params.isOn = viewModel!.isManagementOn
        params.isUseUpdate = viewModel!.isUseUpdateOn
        params.isUseSFTP = viewModel!.isUseSFTPOn
        if node.esIntegrInfo != nil
        {
            params.secondaryHost = node.esIntegrInfo.secondaryHost ?? ""
            params.secondaryHTTPPort = node.esIntegrInfo.secondaryHTTPPort
            params.secondarySSHPort = node.esIntegrInfo.secondarySSHPort
            params.secondaryFTPPort = node.esIntegrInfo.secondaryFTPPort
        }
        return params
    }
    
    func getReverseMonitoringParams() -> [String:Any]
    {
        var params : [String:Any] = ["tunnel_enabled" : viewModel!.isReversMonitoringOn]
        if !viewModel!.reversMonitoringHost.isEmpty
        {
            params["tunnel_address"] = viewModel!.reversMonitoringHost
        }
        return params
    }
    
    func getUpdateParams() -> [String:Any]
    {
        return ["status" : viewModel!.isUpdateOn, "host" : viewModel!.updateHost]
    }
}
