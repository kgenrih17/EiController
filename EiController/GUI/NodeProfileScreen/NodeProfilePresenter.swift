//
//  NodeProfilePresenter.swift
//  EiController
//
//  Created by Henrikh Koreniuzhenko on 04.09.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

class NodeProfilePresenter: NSObject
{
    weak var view: INodeProfileView?
    weak var interactor: AppInteractorInterface?
    weak var navigation: NavigationInterface?
    var commandSender: INodeCommandSender!
    var viewModel: NodeProfileViewModel?
    var fingerprint: String
    
    init(interactor : AppInteractorInterface, navigation : NavigationInterface, fingerprint: String)
    {
        self.interactor = interactor
        self.navigation = navigation
        self.fingerprint = fingerprint
        self.commandSender = NodeCommandSender.build(DeviceOperationLogsTable())
        super.init()
    }
    
    func onAttachView(_ view: INodeProfileView)
    {
        self.view = view
        createViewModel()
        view.fill(viewModel)
    }
    
    func onDettachView()
    {
        view = nil
        viewModel = nil
    }
    
    func onClick(action: EProfileAction)
    {
        switch action
        {
        case .REBOOT_ACTION:
            send(command: .REBOOT_AND_SHUTDOWN, parameters: ["type" : "reboot_scheduler"], completion: nil)
        case .RESTART_ACTION:
            send(command: .REBOOT_AND_SHUTDOWN, parameters: ["type" : "reboot_playback"], completion: nil)
        case .RESET_ACTION:
            send(command: .RESET, parameters: nil, completion: nil)
        case .SHUTDOWN_ACTION:
            send(command: .REBOOT_AND_SHUTDOWN, parameters: ["type" : "shutdown_appliance"], completion: nil)
        case .UPDATE_ACTION:
            send(command: .UPDATE, parameters: nil, completion: nil)
        case .CHECK_ACTION:
            send(command: .FILE_SYSTEM_CHECK, parameters: nil, completion: nil)
        case .CLEANUP_ACTION:
            send(command: .STORAGE_CLEANUP, parameters: nil, completion: nil)
        case .SYNC_ACTION:
            interactor?.sync(withNode: [viewModel!.fingerprint])
            viewModel?.isNeedUpdate = false
            viewModel?.isEnableCommands = false
            view?.fill(viewModel)
        }
    }
}

private extension NodeProfilePresenter
{
    func createViewModel()
    {
        let device = interactor?.getNodeStorage().getDeviceByFingerprint(fingerprint)
        viewModel = NodeProfileViewModel()
        viewModel?.isEnableCommands = true
        viewModel?.isExtenderMode = AppStatus.isExtendedMode()
        viewModel?.fingerprint = fingerprint
        viewModel?.edition = String.valueOrNA(device?.edition.capitalized)
        viewModel?.systemID = String.valueOrNA(device?.sid)
        viewModel?.location = String.valueOrNA(device?.location.capitalized)
        viewModel?.company = String.valueOrNA(device?.company.capitalized)
        viewModel?.ipAddress = String.valueOrNA(device?.address.capitalized)
        viewModel?.timeZone = String.valueOrNA(device?.timezone.capitalized)
        viewModel?.upTime = String.valueOrNA(device?.upTime)
        viewModel?.systemTime = String.valueOrNA(device?.sysTime)
        viewModel?.isUserMode = interactor?.getUserLevel() == .USER_LEVEL
        if let lDevice = device
        {
            if lDevice.registrationDate > 0
            {
                let date = Date.init(timeIntervalSince1970: TimeInterval(lDevice.registrationDate))
                viewModel?.registrationDate = String.from(date, "dd/MM/yyyy hh:mm a", NSString.localUS()).capitalized
            }
            else
            {
                viewModel?.registrationDate = "N/A"
            }
            if lDevice.rebootEnabled
            {
                let schedulerDate = Date.today(lDevice.rebootHour, lDevice.rebootMinute)
                let time = String.from(schedulerDate, "hh:mm a", NSString.localUS())
                viewModel?.rebootScheduler = "Every day at \(time)"
            }
            else
            {
                viewModel?.rebootScheduler = "Disabled";
            }
        }
        else
        {
            viewModel?.registrationDate = "N/A"
            viewModel?.rebootScheduler = "Disabled";
        }
        viewModel?.eiInfo = "Video channels: \((device?.videoChannelsCount != nil) ? device!.videoChannelsCount : 0)\nAudio channels: \((device?.audioChannelsCount != nil) ? device!.audioChannelsCount : 0)"
        if let period = device?.period
        {
            viewModel?.activity = "\(period) day(s)"
        }
        else
        {
            viewModel?.activity = "N/A"
        }
        
        if viewModel!.isExtenderMode
        {
            if device!.syncStatus == nil || (device!.syncStatus.processing != .WAITING_SYNC && device!.syncStatus.processing != .SYNCHRONIZING)
            {
                viewModel?.isNeedUpdate = interactor!.getfingerprintsReadyToBeUpdated().contains(device!.fingerprint)
            }
            else
            {
                viewModel?.isNeedUpdate = false
            }
        }
        else
        {
            viewModel?.isNeedUpdate = false
        }
    }
    
    func send(command: ENodeCommand, parameters: Any?, completion: ((Any) -> Void)?)
    {
        view?.showProcessing()
        let node = interactor?.getNodeStorage().getDeviceByFingerprint(fingerprint)
        commandSender.send(command: command, node: node!, parameters: parameters, completion: { (result) in
            self.view?.hideProgress()
            if result.error == nil
            {
                completion?(result.params)
                self.view?.showAlert(withTitle: "Info", message: "Successful")
            }
            else
            {
                self.view?.showAlert(withTitle: "Error", message: result.error)
            }
        })
    }
}
