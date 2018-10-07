//
//  ManagementServerPresenter.swift
//  EiController
//
//  Created by Genrih Korenujenko on 17.05.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

class ManagementServerPresenter: NSObject
{
    var screen : ManagementServerScreenInterface!
    var interactor : AppInteractorInterface!
    var commandSender : INodeCommandSender!
    var fingerprints : [String]!
    let portMaxLength = 4
    let tokenMaxLength = 100
    let secondsInDay = 86400
    var timeoutMaxValue : Int { return secondsInDay * 30 }
    
    init(screen: ManagementServerScreenInterface, interactor : AppInteractorInterface, fingerprints: [String])
    {
        super.init()
        self.screen = screen
        self.interactor = interactor
        self.fingerprints = fingerprints
    }
    
    public func onCreate()
    {
        commandSender = NodeCommandSender.build(DeviceOperationLogsTable())
        if fingerprints.count == 1
        {
            if getFirstDevice().esIntegrInfo == nil
            {
                refreshManagementServer(device: getFirstDevice())
            }
            else
            {
                refreshScreen(getFirstDevice().esIntegrInfo!)
            }
        }
        else
        {
            refreshScreen(DeviceIntegrationInfo())
        }
    }
    
    public func isValidPort(_ port: String) -> Bool
    {
        return (port.isEmpty || (Int(port) != nil && Int(port)! > 0 && port.count <= portMaxLength))
    }
    
    public func isValidTimeout(_ timeout: String) -> Bool
    {
        return (timeout.isEmpty || (Int(timeout) != nil && Int(timeout)! > 0 && timeout.count <= timeoutMaxValue))
    }

    public func isValidToken(_ token: String) -> Bool
    {
        return (token.isEmpty || token.count <= tokenMaxLength)
    }
    
    public func checkConnection(integration: DeviceIntegrationInfo)
    {
        let validResult = isValid(integration: integration)
        if validResult.isValid
        {
            screen.showProgress(withMessage: "Checking...")
            commandSender.send(command: ENodeCommand.CHECK_CONNECTION_MANAGEMENT_SERVER, node: getFirstDevice(), parameters: integration.host) { (result : CommandResult?) in
                self.screen.hideProgress()
                let isSuccess = (result?.error == nil && (result?.params as? NSNumber != nil) && (result!.params as! NSNumber).boolValue)
                let message = isSuccess ? "The verification process completed successfully" : "A connection with the server cannot be established"
                self.showMessage(message, isError: !isSuccess)
            }
        }
        else { self.showMessage(validResult.message!, isError: true) }
    }
    
    public func save(integration: DeviceIntegrationInfo)
    {
        let validResult = isValid(integration: integration)
        if validResult.isValid
        {
            screen.showProcessing()
            let devices = interactor.getNodeStorage().getDevicesByFingerprints(fingerprints)
            if fingerprints.count == 1
            {
                commandSender.send(command: ENodeCommand.SET_MANAGEMENT_SERVER, node: devices.first!, parameters: integration) { (result : CommandResult?) in
                    self.parseSaveResponse(result, integration: integration, devices: devices)
                }
            }
            else
            {
                commandSender.send(command: ENodeCommand.SET_MANAGEMENT_SERVER, nodes: devices, parameters: integration) { (result : CommandResult?) in
                    self.parseSaveResponse(result, integration: integration, devices: devices)
                }
            }
        } else { self.showMessage(validResult.message!, isError: true) }
    }
    
    public func enableChanged(_ isEnbled: Bool)
    {
        let integration = DeviceIntegrationInfo()
        integration.isOn = isEnbled
        refreshScreen(integration)
    }
    
    private func parseSaveResponse(_ result : CommandResult?, integration: DeviceIntegrationInfo, devices: [Device])
    {
        self.screen.hideProgress()
        if (result?.error == nil)
        {
            for device in devices { device.esIntegrInfo = integration }
            self.showMessage("Save process completed successfully", isError: false)
        }
        else { self.showMessage(result!.error, isError: true) }
    }
    
    private func refreshManagementServer(device : Device)
    {
        screen.showProgress(withMessage: "Processing...")
        commandSender.send(command: ENodeCommand.GET_MANAGEMENT_SERVER, node: device, parameters: nil) { (result : CommandResult?) in
            self.screen.hideProgress()
            if result?.error == nil
            {
                device.esIntegrInfo = result?.params as! DeviceIntegrationInfo
                self.refreshScreen(device.esIntegrInfo)
            }
            else { self.showMessage(result!.error, isError: true) }
        }
    }
    
    private func fillDefaultValues(integration : DeviceIntegrationInfo)
    {
        if integration.httpPort <= 0 { integration.httpPort = 80 }
        if integration.sshPort <= 0 { integration.sshPort = 2222 }
        if integration.esTaskCompletionTimeout <= 0 { integration.esTaskCompletionTimeout = secondsInDay }
    }
    
    private func refreshScreen(_ integration : DeviceIntegrationInfo)
    {
        let model : DeviceIntegrationInfo
        if integration.isOn
        {
            fillDefaultValues(integration: integration)
            model = integration
        }
        else
        {
            model = DeviceIntegrationInfo()
        }
        screen.refresh(integration: model)
    }
    
    private func getFirstDevice() -> Device
    {
        let deviceStorage :INodeStorage = interactor.getNodeStorage()
        return deviceStorage.getDeviceByFingerprint(fingerprints.first!)!
    }

    private func isValid(integration: DeviceIntegrationInfo) -> (isValid: Bool, message: String?)
    {
        var result : (isValid: Bool, message: String?) = (false, nil)
        if ((integration.isOn && !integration.host.isEmpty && integration.httpPort > 0))
        {
            if URL(string: integration.host) != nil { result.isValid = true }
            else { result.message = "Please enter a valid Server IP Address or Domain" }
        }
        else if !integration.isOn { result.isValid = true }
        else { result.message = "Please complete all fields" }
        return result
    }
    
    private func showMessage(_ message: String, isError: Bool)
    {
        let color = isError ? UIColor.init(red: 1, green: 0, blue: 0, alpha: 1) : UIColor.init(red: 0, green: 0.816, blue: 0.459, alpha: 1)
        self.screen.showMessage(message, color: color)
    }
}
