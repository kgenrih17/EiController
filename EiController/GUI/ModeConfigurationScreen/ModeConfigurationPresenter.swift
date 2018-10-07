//
//  ModeConfigurationPresenter.swift
//  EiController
//
//  Created by Genrih Korenujenko on 15.05.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

class ModeConfigurationPresenter: NSObject
{
    var screen : ModeConfigurationScreenInterface
    var interactor : AppInteractorInterface
    var commandSender : INodeCommandSender
    var nodeController = Device()
    var localEiGrids = [EiGridNodeViewModel]()
    var lastError: String?
    
    init(screen: ModeConfigurationScreenInterface, interactor : AppInteractorInterface, fingerprint: String)
    {
        self.screen = screen
        self.interactor = interactor
        self.nodeController.fingerprint = fingerprint
        self.commandSender = NodeCommandSender.build(DeviceOperationLogsTable())
        super.init()
    }
    
    public func onCreate()
    {
        prepareInitialData()
        screen.setViewModels(localEiGrids)
        screen.setMode(.AUXILIAURY)
        refreshModeConfiguration()
    }
}

private extension ModeConfigurationPresenter
{
    func prepareInitialData()
    {
        let localNodes : [Device] = interactor
            .getNodeStorage()
            .getLocalDevices()
        for node in localNodes
        {
            if node.fingerprint != nil && node.fingerprint == self.nodeController.fingerprint
            {
                nodeController = node
            }
            else if node.sn != nil && !node.sn.isEmpty
            {
                let viewModel = createEiGridViewModel(node)
                localEiGrids.append(viewModel)
            }
        }
    }
    
    func createEiGridViewModel(_ node: Device) -> EiGridNodeViewModel
    {
        let viewModel = EiGridNodeViewModel(fingerprint: node.fingerprint,
                                            title: node.title,
                                            ip: node.address,
                                            snList: node.sn,
                                            snManual: "",
                                            typeLink: "list",
                                            model: node.model,
                                            osVersion: node.version,
                                            isOnline: false)
        viewModel.isExtender = AppStatus.isExtendedMode()
        return viewModel
    }
    
    func createEiGridViewModel(byConfig config: ModeConfiguration) -> EiGridNodeViewModel
    {
        let viewModel = EiGridNodeViewModel(fingerprint: "",
                                            title: config.title,
                                            ip: config.ip,
                                            snList: config.snList,
                                            snManual: config.snManual,
                                            typeLink: config.typeLink,
                                            model: config.model,
                                            osVersion: config.version,
                                            isOnline: config.isOnline)
        viewModel.isExtender = AppStatus.isExtendedMode()
        return viewModel
    }
    
    func getNode(byFingerprint fingerprint: String) -> Device?
    {
        return interactor
            .getNodeStorage()
            .getLocalDevices()
            .filter { return $0.fingerprint == fingerprint }
            .first
    }
    
    func getNode(bySN sn: String) -> Device?
    {
        return interactor
            .getNodeStorage()
            .getLocalDevices()
            .filter { return ($0.sn != nil && !$0.sn.isEmpty && !sn.isEmpty && $0.sn == sn) }
            .first
    }
    
    func getGrid(bySN sn: String) -> EiGridNodeViewModel?
    {
        return localEiGrids
            .filter { return (!$0.sn().isEmpty && !sn.isEmpty && $0.sn() == sn) }
            .first
    }
    
    func showPairing(_ sn: String?, _ model: EiGridNodeViewModel?)
    {
        if let lModel = model
        {
            screen.buildListPairing(lModel)
        }
        else if let lSN = sn
        {
            screen.buildManualPairing(lSN)
        }
        else
        {
            screen.buildManualPairing("")
        }
        screen.clearWatchdog()
    }
    
    func showPaired(_ sn: String?, _ model: EiGridNodeViewModel?)
    {
        var grid : EiGridNodeViewModel
        if let lModel = model
        {
            grid = lModel
        }
        else
        {
            grid = EiGridNodeViewModel()
            grid.isExtender = AppStatus.isExtendedMode()
            grid.snManual = (sn != nil) ? sn! : ""
            grid.typeLink = "manual"
        }
        grid.isOnline = getGrid(bySN: grid.sn()) != nil
        screen.buildPaired(with: grid)
        if nodeController.modeConfiguration == nil
        {
            nodeController.modeConfiguration = ModeConfiguration.empty()
        }
        let watchdogModel = createWatchdog(grid.sn(), nodeController.modeConfiguration)
        screen.buildWatchdog(model: watchdogModel)
    }
    
    func createWatchdog(_ sn: String, _ config: ModeConfiguration) -> WatchdogViewModel
    {
//        var message : String? = nil
//        if localEiGrids.count <= 0
//        {
//            message = "No [Ei] Nodes currently set up"
//        }
//        var grid : EiGridNodeViewModel? = nil
//        if let lWatchdogSN = config.snWatchdog
//        {
//            if let lGrid = getGrid(bySN: lWatchdogSN)
//            {
//                grid = lGrid
//            }
//            else
//            {
//                grid = EiGridNodeViewModel()
//                grid?.snManual = lWatchdogSN
//                grid?.typeLink = "manual"
//                if let lWatchdogIP = config.ipNodeWatchdog
//                {
//                    grid?.ip = !lWatchdogIP.isEmpty ? lWatchdogIP : "N/A"
//                }
//                if let lWatchdogTitle = config.titleNodeWatchdog
//                {
//                    grid?.title = !lWatchdogTitle.isEmpty ? lWatchdogTitle : "N/A"
//                }
//            }
//        }
//        else
//        {
//            message = "Please select [Ei] Node"
//        }
//        let isShowMessage = message != nil
        return WatchdogViewModel(isShowSelectGridMessage: false,
                                 message: nil,
                                 isEnablePort: config.isEnablePort,
                                 isEnableWatchdog: config.isEnableWatchdog,
                                 timeout: config.timeout,
                                 grid: nil,
                                 serial: sn)
    }
    
    func mergeError(_ nodeError: String?, _ controllerError: String?) -> String?
    {
        var errorText : String?
        if let error = nodeError
        {
            errorText = error
        }
        if let error = controllerError
        {
            if var lError = errorText
            {
                lError.append("\n\(error)")
            }
            else
            {
                errorText = error
            }
        }
        return errorText
    }
    
    func preparePairedModel(_ config: ModeConfiguration) -> EiGridNodeViewModel
    {
        if !config.sn().isEmpty, let node = getNode(bySN: config.sn())
        {
            var model : EiGridNodeViewModel?
            if let lModel = getGrid(bySN: node.sn)
            {
                model = lModel
            }
            else
            {
                model = createEiGridViewModel(node)
            }
            return model!
        }
        else
        {
            return createEiGridViewModel(byConfig: config)
        }
    }
    
    func preparePairingModel(_ config: ModeConfiguration) -> EiGridNodeViewModel?
    {
        var model : EiGridNodeViewModel?
        let device = getNode(bySN: config.sn())
        if let node = device
        {
            if let lModel = getGrid(bySN: node.sn)
            {
                model = lModel
            }
            else
            {
                model = createEiGridViewModel(node)
            }
        }
        return model
    }
}

/// Parsing Command Result
private extension ModeConfigurationPresenter
{
    func parseResponseRefreshModeConfiguration(_ result: CommandResult)
    {
        if let config = result.params as? ModeConfiguration
        {
            nodeController.modeConfiguration = config
            if config.pairState == "pair"
            {
                let model = preparePairedModel(config)
                showPaired(nil, model)
            }
            else
            {
                let model = preparePairingModel(config)
                showPairing(config.sn(), model)
            }
        }
        else
        {
            showPairing(nil, nil)
            screen.showAlert(withTitle: "Error", message: result.error)
        }
    }
    
    func parseResponsePairNode(_ result: CommandResult, _ model: EiGridNodeViewModel, _ sn: String?,  _ node: Device)
    {
        if let status = result.params as? String
        {
            switch status
            {
            case "pair_another":
                screen.showAlert("Info", message: "Already Paired with another device", acceptText: "Force", declineText: "Ok")
                {
                    if $0 == true
                    {
                        self.pair(model, sn, true)
                    }
                }
            case let value where (value == "pair" || value == "pair_now"):
                pairController(model.sn(), node)
            default:
                break
            }
        }
        else
        {
            self.screen.showAlert(withTitle: "Error", message: "[Ei] Node is unreachable")
        }
    }
    
    func parseResponsePairController(_ result: CommandResult, _ sn: String, _ pairedNode: Device?)
    {
        var error : String? = result.error
        if let status = result.params as? String
        {
            if status == "pair" || status == "pair_now"
            {
                if let model = getGrid(bySN: sn)
                {
                    showPaired(nil, model)
                }
                else if let node = getNode(bySN: sn)
                {
                    let model = createEiGridViewModel(node)
                    showPaired(nil, model)
                }
                else
                {
                    showPaired(sn, nil)
                }
            }
            else
            {
                error = "Pairing status: \(status)"
            }
        }
        if let lError = self.mergeError(lastError, error)
        {
            if let node = pairedNode
            {
                commandSender.send(command: ENodeCommand.SET_DISCONNECT_CONTROLLER, node:node, parameters: nil) { _ in }
            }
            self.screen.showAlert(withTitle: "Error", message: lError)
        }
    }
}

/// Send commands
extension ModeConfigurationPresenter
{
    func refreshModeConfiguration()
    {
        screen.showProgress(withMessage: "Processing...")
        commandSender.send(command: ENodeCommand.GET_MODE_CONFIGURATION, node: nodeController, parameters: nil) { (result : CommandResult?) in
            self.screen.hideProgress()
            self.parseResponseRefreshModeConfiguration(result!)
        }
    }

    func pair(_ model: EiGridNodeViewModel?, _ sn: String?, _ force: Bool)
    {
        if (model != nil) || (sn != nil && !sn!.isEmpty)
        {
            if let lModel = (model == nil) ? getGrid(bySN: sn!) : model
            {
                screen.showProgress(withMessage: "Processing...")
                let node : Device
                if let lNode = getNode(byFingerprint: lModel.fingerprint)
                {
                    node = lNode
                }
                else
                {
                    node = getNode(bySN: lModel.sn())!
                }
                let params = PairControllerParams(serial: nodeController.sn, force: force)
                commandSender.send(command: ENodeCommand.SET_PAIR_CONTROLLER, node:node, parameters: params) { (result : CommandResult?) in
                    self.screen.hideProgress()
                    self.parseResponsePairNode(result!, lModel, sn, node)
                }
            }
            else
            {
                self.screen.showAlert(withTitle: "Error", message: "[Ei] Node is unreachable")
            }
        }
        else
        {
            screen.showAlert(withTitle: "Info", message: "Please enter a serial number or select a Node from the list")
        }
    }
    
    private func pairController(_ sn: String?, _ pairedNode: Device?)
    {
        if let lSN = sn
        {
            screen.showProgress(withMessage: "Processing...")
            let params : PairNodeParams
            if let grid = getGrid(bySN: lSN)
            {
                params = PairNodeParams(serialManual: grid.snManual, serialList: grid.snList, typeLink: "list", force: true)
            }
            else
            {
                params = PairNodeParams(serialManual: lSN, serialList: "", typeLink: "manual", force: true)
            }
            commandSender.send(command: ENodeCommand.SET_PAIR_NODE, node:nodeController, parameters: params) { (result : CommandResult?) in
                self.screen.hideProgress()
                self.parseResponsePairController(result!, lSN, pairedNode)
            }
        }
        else
        {
            screen.showAlert(withTitle: "Info", message: "Please enter a serial number or select a Node from the list")
        }
    }
    
    func saveWatchdog(_ model: WatchdogViewModel)
    {
        let timeout = (model.isEnablePort && model.isEnableWatchdog) ? model.timeout : 0
        let sn = (model.isEnablePort && model.grid?.sn() != nil) ? model.grid!.sn() : ""
        let params = RemoteNodeSwitchSettingsParams(serial: model.serial, enable: model.isEnablePort ? 1 : 0, watchdogNodeSN: sn, watchdogTimeout: timeout)
        screen.showProgress(withMessage: "Processing...")
        commandSender.send(command: ENodeCommand.SET_REMOTE_NODE_SWITCH_SETTINGS, node: nodeController, parameters: params) { (result : CommandResult?) in
            self.screen.hideProgress()
            if (result?.error == nil)
            {
                self.screen.showAlert(withTitle: "Info", message: "Successful")
            }
            else
            {
                self.screen.showAlert(withTitle: "Error", message: result!.error)
            }
        }
    }
    
    func disconnect(_ model: EiGridNodeViewModel)
    {
        screen.showProgress(withMessage: "Processing...")
        var node : Device? = nil
        if let lNode = getNode(bySN: model.sn())
        {
            node = lNode
        }
        else if !model.fingerprint.isEmpty, let lNode = getNode(byFingerprint: model.fingerprint)
        {
            node = lNode
        }
        if let lNode = node
        {
            commandSender.send(command: ENodeCommand.SET_DISCONNECT_CONTROLLER, node:lNode, parameters: nil) { (result : CommandResult?) in
                self.disconnectController(model, result?.error)
            }
        }
        else
        {
            self.disconnectController(model, "Node not found on local network")
        }
    }
    
    private func disconnectController(_ model: EiGridNodeViewModel, _ nodeDisconnectError: String?)
    {
        commandSender.send(command: ENodeCommand.SET_DISCONNECT_NODE, node:nodeController, parameters: nil) { (result : CommandResult?) in
            self.screen.hideProgress()
            self.nodeController.modeConfiguration = ModeConfiguration.empty()
            self.showPairing(nil, nil)
            if let error = self.mergeError(nodeDisconnectError, result?.error)
            {
                self.screen.showAlert(withTitle: "Error", message: error)
            }
        }
    }
}

