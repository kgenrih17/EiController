//
//  UpdateServerPresenter.swift
//  EiController
//
//  Created by Genrih Korenujenko on 05.05.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

class UpdateServerPresenter: NSObject
{
    var screen : UpdateServerScreenInterface!
    var interactor : AppInteractorInterface!
    var commandSender : INodeCommandSender!
    var fingerprint : String!
    
    init(screen: UpdateServerScreenInterface!, interactor : AppInteractorInterface!, fingerprint : String)
    {
        self.screen = screen
        self.interactor = interactor
        self.fingerprint = fingerprint
        super.init()
    }
    
    public func onCreate()
    {
        commandSender = NodeCommandSender.build(DeviceOperationLogsTable())
        let device = getDevice()
        if (device.updateServerAddress == nil || device.updateServerAddress.isEmpty) { refreshUpdateServer(device: device) }
        else { screen.refresh(model: prepareViewModel(device: device)) }
    }
    
    public func changeEnableFlag(model: UpdateServerViewModel)
    {
        model.address = nil
        model.message = nil
        model.messageColor = getMessageColor(isError: false)
        screen.refresh(model: model)
    }
    
    public func save(model : UpdateServerViewModel)
    {
        let device = getDevice()
        if device.isEnableUpdateServer == model.isEnable && device.updateServerAddress == model.address
        {
            prepareAndShowMessage(model: model, message: "Domain name or IP Address of Update Server have not been changed")
            screen.setFieldColor(color: UIColor.clear)
        }
        else { setUpdateServer(model: model) }
    }
    
    public func checkConnection(model : UpdateServerViewModel)
    {
        let validResult = isValid(model)
        if validResult.isValid
        {
            screen.setFieldColor(color: UIColor.clear)
            screen.showProgress(withMessage: "Processing...")
            let address = ConnectionData.create(withAddress: model.address, port: 80).urlString
            commandSender.send(command: ENodeCommand.CHECK_CONNECTION_UPDATE_SERVER, node: getDevice(), parameters: address) { (result : CommandResult?) in
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
    
    private func setUpdateServer(model : UpdateServerViewModel)
    {
        let validResult = isValid(model)
        if validResult.isValid
        {
            screen.showProgress(withMessage: "Processing...")
            screen.setFieldColor(color: UIColor.clear)
            let params : [String:Any] = ["status" : NSNumber.init(value: model.isEnable), "host" : model.address!]
            commandSender.send(command: ENodeCommand.SET_UPDATE_SERVER, node: getDevice(), parameters: params) { (result : CommandResult?) in
                self.screen.hideProgress()
                if result?.error == nil
                {
                    self.updateAddress(isEnable: model.isEnable, address: model.address!)
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
        }
        else { prepareAndShowMessage(model: model, message: validResult.message!) }
    }
    
    private func refreshUpdateServer(device : Device)
    {
        screen.showProgress(withMessage: "Processing...")
        commandSender.send(command: ENodeCommand.GET_UPDATE_SERVER, node: device, parameters: nil) { (result : CommandResult?) in
            self.screen.hideProgress()
            let model : UpdateServerViewModel?
            if result?.error == nil
            {
                var isEnable = false
                var host = ""
                if let answer = result!.params as? [String:Any]
                {
                    isEnable = answer.bool("status")
                    host = answer.string("host")
                }
                self.updateAddress(isEnable: isEnable, address: host)
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
    
    private func prepareViewModel(device : Device) -> UpdateServerViewModel
    {
        let model = UpdateServerViewModel.init(isEnable: device.isEnableUpdateServer, address: device.updateServerAddress)
        return model
    }
    
    private func updateAddress(isEnable : Bool, address : String)
    {
        let device = getDevice()
        device.isEnableUpdateServer = isEnable
        device.updateServerAddress = address
    }
    
    private func isValid(_ model: UpdateServerViewModel) -> (isValid: Bool, message: String?)
    {
        var result : (isValid: Bool, message: String?) = (false, nil)
        if (model.isEnable == true && (model.address == nil || model.address!.isEmpty)) { result.message = "Specify Domain name or IP Address of Update Server and try again" }
        else if model.isEnable && URL(string: model.address!) == nil { result.message = "Please enter a valid Server IP Address or Domain" }
        else { result.isValid = true }
        return result
    }
    
    private func getDevice() -> Device
    {
        let deviceStorage :INodeStorage = interactor.getNodeStorage()
        return deviceStorage.getDeviceByFingerprint(fingerprint)!
    }
    
    private func getMessageColor(isError : Bool) -> UIColor
    {
        if isError == true {return UIColor.init(red: 0.957, green: 0, blue: 0.149, alpha: 1) }
        else { return UIColor.init(red: 0, green: 0.82, blue: 0.486, alpha: 1) }
    }
    
    private func prepareAndShowMessage(model: UpdateServerViewModel, message : String)
    {
        model.message = message
        model.messageColor = getMessageColor(isError: true)
        screen.refresh(model: model)
        screen.setFieldColor(color: getMessageColor(isError: true))
    }
}

