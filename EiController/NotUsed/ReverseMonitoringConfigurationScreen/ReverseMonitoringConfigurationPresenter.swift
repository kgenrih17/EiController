//
//  ReverseMonitoringConfigurationPresenter.swift
//  EiController
//
//  Created by Genrih Korenujenko on 05.05.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

class ReverseMonitoringConfigurationPresenter: NSObject
{
    var screen : ReverseMonitoringConfigurationScreenInterface!
    var interactor : AppInteractorInterface!
    var commandSender : INodeCommandSender!
    var fingerprints : [String]!
    
    init(screen: ReverseMonitoringConfigurationScreenInterface!, interactor : AppInteractorInterface!, fingerprints : [String])
    {
        self.screen = screen
        self.interactor = interactor
        self.fingerprints = fingerprints
        super.init()
    }
    
    public func onCreate()
    {
        commandSender = NodeCommandSender.build(DeviceOperationLogsTable())
        if fingerprints.count == 1
        {
            let device = getFirstDevice()
            if (device.tunnelAddress == nil || device.tunnelAddress.isEmpty) { refreshTunnelInfo(device: device) }
            else { screen.refresh(model: prepareViewModel(device: device)) }
        }
        else { screen.refresh(model: ReverseMonitoringConfigurationViewModel.init(isEnable: false, address: nil)) }
    }
    
    public func changeEnableFlag(model: ReverseMonitoringConfigurationViewModel)
    {
        model.address = nil
        model.message = nil
        model.messageColor = getMessageColor(isError: false)
        screen.refresh(model: model)
    }
    
    public func save(model : ReverseMonitoringConfigurationViewModel)
    {
        let device = fingerprints.count == 1 ? getFirstDevice() : nil
        if device != nil && device!.isUseTunnel == model.isEnable && device!.tunnelAddress == model.address
        {
            model.message = "Configuration has not been changed"
            model.messageColor = getMessageColor(isError: true)
            screen.refresh(model: model)
            screen.setFieldColor(color: UIColor.clear)
        }
        else { setReverseMonitoring(model: model) }
    }
    
    public func checkConnection(model : ReverseMonitoringConfigurationViewModel)
    {
        let validResult = isValid(model)
        if validResult.isValid
        {
            screen.setFieldColor(color: UIColor.clear)
            screen.showProgress(withMessage: "Processing...")
            let address = ConnectionData.create(withAddress: model.address, port: 80).urlString
            commandSender.send(command: ENodeCommand.CHECK_CONNECTION_RM_SERVER, node: getFirstDevice(), parameters: address) { (result : CommandResult?) in
                self.screen.hideProgress()
                if (result?.error == nil && (result?.params as? NSNumber != nil) && (result!.params as! NSNumber).boolValue)
                {
                    model.message = "The verification process completed successfully"
                    model.messageColor = self.getMessageColor(isError: false)
                }
                else
                {
                    model.message = "A connection with the server cannot be established."
                    model.messageColor = self.getMessageColor(isError: true)
                }
                self.screen.refresh(model: model)
            }
        }
        else { prepareAndShowMessage(model: model, message: validResult.message!) }
    }
    
    private func setReverseMonitoring(model : ReverseMonitoringConfigurationViewModel)
    {
        let validResult = isValid(model)
        if validResult.isValid
        {
            screen.setFieldColor(color: UIColor.clear)
            screen.showProcessing()
            var params : [String : Any] = ["tunnel_enabled" : model.isEnable]
            if model.address != nil, !model.address!.isEmpty
            {
                params["tunnel_address"] = model.address
            }
            let devices = interactor.getNodeStorage().getDevicesByFingerprints(fingerprints)
            if fingerprints.count == 1
            {
                commandSender.send(command: ENodeCommand.SET_RM_SERVER, node: devices.first!, parameters: params) { (result : CommandResult?) in
                    self.parseSaveResponse(result, model: model, devices: devices)
                }
            }
            else
            {
                commandSender.send(command: ENodeCommand.SET_RM_SERVER, nodes: devices, parameters: params) { (result : CommandResult?) in
                    self.parseSaveResponse(result, model: model, devices: devices)
                }
            }
        }
        else { prepareAndShowMessage(model: model, message: validResult.message!) }
    }
    
    private func parseSaveResponse(_ result : CommandResult?, model : ReverseMonitoringConfigurationViewModel, devices: [Device])
    {
        self.screen.hideProgress()
        if result?.error == nil
        {
            for device in devices
            {
                self.updateDevice(device, isEnable: model.isEnable, address: model.address!)
            }
            model.message = "Save successful"
            model.messageColor = self.getMessageColor(isError: false)
        }
        else
        {
            model.message = result!.error
            model.messageColor = self.getMessageColor(isError: true)
        }
        self.screen.refresh(model: model)
    }
    
    private func refreshTunnelInfo(device : Device)
    {
        screen.showProgress(withMessage: "Processing...")
        commandSender.send(command: ENodeCommand.GET_RM_SERVER, node: device, parameters: nil) { (result : CommandResult?) in
            self.screen.hideProgress()
            let model : ReverseMonitoringConfigurationViewModel?
            if result?.error == nil
            {
                var isUseTunnel = false
                var address = ""
                if let answer = result!.params as? [String:Any]
                {
                    isUseTunnel = answer.bool("tunnel_enabled")
                    address = answer.string("tunnel_address")
                }
                self.updateDevice(device, isEnable: isUseTunnel, address: address)
                model = self.prepareViewModel(device: device)
                model!.message = ""
                model!.messageColor = self.getMessageColor(isError: false)
            }
            else
            {
                model = self.prepareViewModel(device: device)
                model!.message = result!.error
                model!.messageColor = self.getMessageColor(isError: true)
            }
            self.screen.refresh(model: model!)
        }
    }
    
    private func prepareViewModel(device : Device) -> ReverseMonitoringConfigurationViewModel
    {
        let model = ReverseMonitoringConfigurationViewModel.init(isEnable: device.isUseTunnel, address: device.tunnelAddress)
        return model
    }
    
    private func updateDevice(_ device: Device, isEnable : Bool, address : String)
    {
        device.isUseTunnel = isEnable
        device.tunnelAddress = address
    }
    
    private func getFirstDevice() -> Device
    {
        let deviceStorage :INodeStorage = interactor.getNodeStorage()
        return deviceStorage.getDeviceByFingerprint(fingerprints.first!)!
    }
    
    private func isValid(_ model: ReverseMonitoringConfigurationViewModel) -> (isValid: Bool, message: String?)
    {
        var result : (isValid: Bool, message: String?) = (false, nil)
        if (model.isEnable == true && (model.address == nil || model.address!.isEmpty)) { result.message = "Specify Tunnel Address and try again" }
        else if model.isEnable && URL(string: model.address!) == nil { result.message = "Please enter a valid Tunnel Address" }
        else { result.isValid = true }
        return result
    }
    
    private func getMessageColor(isError : Bool) -> UIColor
    {
        if isError == true
        {
            return UIColor.init(red: 0.957, green: 0, blue: 0.149, alpha: 1)
        }
        else
        {
            return UIColor.init(red: 0, green: 0.82, blue: 0.486, alpha: 1)
        }
    }
    
    private func prepareAndShowMessage(model: ReverseMonitoringConfigurationViewModel, message : String)
    {
        model.message = message
        model.messageColor = getMessageColor(isError: true)
        screen.refresh(model: model)
        screen.setFieldColor(color: getMessageColor(isError: true))
    }
}
