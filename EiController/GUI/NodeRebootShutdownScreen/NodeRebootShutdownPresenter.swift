//
//  NodeRebootShutdownPresenter.swift
//  EiController
//
//  Created by Henrikh Koreniuzhenko on 20.09.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

class NodeRebootShutdownPresenter: NSObject
{
    weak var view: INodeRebootShutdownView?
    weak var interactor: AppInteractorInterface?
    weak var navigation: NavigationInterface?
    var commandSender: INodeCommandSender!
    var viewModel: NodeRebootShutdownViewModel?
    var fingerprint: String
    
    init(interactor : AppInteractorInterface, navigation : NavigationInterface, fingerprint: String)
    {
        self.interactor = interactor
        self.navigation = navigation
        self.fingerprint = fingerprint
        self.commandSender = NodeCommandSender.build(DeviceOperationLogsTable())
        super.init()
    }
    
    func onAttachView(_ view: INodeRebootShutdownView)
    {
        self.view = view
        createViewModel()
        view.fill(viewModel!)
    }
    
    func onDettachView()
    {
        view = nil
        viewModel = nil
    }
    
    func onClickSave()
    {
        view?.retrieveChanges()
        prepareAndSendCommands()
    }
}

private extension NodeRebootShutdownPresenter
{
    func createViewModel()
    {
        let node = interactor!.getNodeStorage().getDeviceByFingerprint(fingerprint)!
        viewModel = NodeRebootShutdownViewModel()
        viewModel?.isExtender = AppStatus.isExtendedMode()
        viewModel?.isRestartOn = node.rebootEnabled
        viewModel?.restartDate = dateFrom(node.rebootHour, node.rebootMinute, node.rebootMeridiem)
        viewModel?.restartTitle = String.from(viewModel!.restartDate, "hh:mm a", NSString.localUS())
        viewModel?.isPlaybackOn = node.playbackRestartEnabled
        viewModel?.playbackDate = dateFrom(node.playbackRestartHour, node.playbackRestartMinute, node.playbackRestartMeridiem)
        viewModel?.playbackTitle = String.from(viewModel!.playbackDate, "hh:mm a", NSString.localUS())
        viewModel?.isShutdownOn = node.shutdownEnabled
        viewModel?.shutdownDate = dateFrom(node.shutdownHour, node.shutdownMinute, node.shutdownMeridiem)
        viewModel?.shutdownTitle = String.from(viewModel!.shutdownDate, "hh:mm a", NSString.localUS())
    }
    
    private func dateFrom(_ hour : Int, _ minutes : Int, _ meridiem: String?) -> Date
    {
        var hh = (hour > 0 && hour <= 12) ? String(hour) : "01"
        if (hh.count == 1)
        {
            hh = "0" + hh
        }
        var mm = (minutes >= 0 && minutes <= 59) ? String(minutes) : "00"
        if (mm.count == 1)
        {
            mm = "0" + mm
        }
        let a = (meridiem != nil && (meridiem! == "pm" || meridiem! == "am")) ? meridiem! : "am"
        let format = hh + mm + a
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.init(identifier: NSString.localUS())
        dateFormatter.dateFormat = "hhmma"
        return dateFormatter.date(from: format)!
    }

    func formatFrom(_ date: Date?) -> (hour: Int, minute: Int, meridiem: String)
    {
        if let from = date
        {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.init(identifier: NSString.localUS())
            dateFormatter.dateFormat = "hh"
            let hour = Int(dateFormatter.string(from: from))!
            dateFormatter.dateFormat = "mm"
            let minute = Int(dateFormatter.string(from: from))!
            dateFormatter.dateFormat = "a"
            let meridiem = dateFormatter.string(from: from).lowercased()
            return (hour, minute, meridiem)
        }
        else
        {
            return(0,0,"am")
        }
    }
    
    func prepareAndSendCommands()
    {
        view?.showProcessing()
        let node = interactor!.getNodeStorage().getDeviceByFingerprint(fingerprint)!
        let commands : [AnyHashable:Any?] = [ENodeCommand.SET_SCHEDULE_REBOOT_AND_SHUTDOWN : getRestartParams(),
                                              "\(ENodeCommand.SET_SCHEDULE_REBOOT_AND_SHUTDOWN.rawValue)" : getPlaybackParams(),
                                              ENodeCommand.SET_SCHEDULE_REBOOT_AND_SHUTDOWN.rawValue : getShutdownParams()]
        commandSender.send(commands: commands, node: node, endedCommand: nil) { (result) in
            self.view?.hideProgress()
            if result.error == nil
            {
                self.update(node: node)
                self.view?.showAlert(withTitle: "Info", message: "Successful")
            }
            else
            {
                self.view?.showAlert(withTitle: "Error", message: result.error)
            }
        }
    }
    
    func getRestartParams() -> [String:Any]
    {
        return getParamsBy(enable: viewModel!.isRestartOn, date: viewModel!.restartDate, type: "reboot_scheduler")
    }
    
    func getPlaybackParams() -> [String:Any]
    {
        return getParamsBy(enable: viewModel!.isPlaybackOn, date: viewModel!.playbackDate, type: "reboot_playback")
    }
    
    func getShutdownParams() -> [String:Any]
    {
        return getParamsBy(enable: viewModel!.isShutdownOn, date: viewModel!.shutdownDate, type: "shutdown_appliance")
    }
    
    func getParamsBy(enable: Bool, date: Date, type: String) -> [String:Any]
    {
        let format = formatFrom(date)
        let result : [String:Any] = [
            "status" : enable,
            "hour" : format.hour,
            "minute" : format.minute,
            "meridiem" : format.meridiem,
            "type" : type
        ]
        return result
    }
    
    func update(node: Device)
    {
        let restartFormat = formatFrom(viewModel!.restartDate)
        node.rebootEnabled = viewModel!.isRestartOn
        node.rebootHour = restartFormat.hour
        node.rebootMinute = restartFormat.minute
        node.rebootMeridiem = restartFormat.meridiem
        let playbackFormat = formatFrom(viewModel!.playbackDate)
        node.playbackRestartEnabled = viewModel!.isPlaybackOn
        node.playbackRestartHour = playbackFormat.hour
        node.playbackRestartMinute = playbackFormat.minute
        node.playbackRestartMeridiem = playbackFormat.meridiem
        let shutdownFormat = formatFrom(viewModel!.shutdownDate)
        node.shutdownEnabled = viewModel!.isShutdownOn
        node.shutdownHour = shutdownFormat.hour
        node.shutdownMinute = shutdownFormat.minute
        node.shutdownMeridiem = shutdownFormat.meridiem
    }
}
