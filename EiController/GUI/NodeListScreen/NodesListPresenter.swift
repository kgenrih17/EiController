//
//  NodesListPresenter.swift
//  EiController
//
//  Created by Henrikh Koreniuzhenko on 31.08.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import Foundation

private let AUTO_CLOSE_CENTRAL_SYNC_TIME: Int = 10

class NodesListPresenter: NSObject
{
    private var operationLogsTable = DeviceOperationLogsTable()
    private var commandSender: INodeCommandSender?
    weak var view: INodesListView?
    weak var interactor: AppInteractorInterface?
    weak var navigation: NavigationInterface?
    var viewModel = NodesListViewModel()
    var syncViewModel: NodeListCellViewModel?
    var closeCentralSyncViewTimer: Timer?
    var isUpdateLocalNodes = true
    
    init(interactor: AppInteractorInterface?, navigation: NavigationInterface?)
    {
        super.init()
        self.interactor = interactor
        self.navigation = navigation
        self.commandSender = NodeCommandSender.build(operationLogsTable)
    }
    
    deinit
    {
        interactor?.removeObserver(self)
        interactor?.removeNodeSyncListener(self)
        interactor?.removeCentralIntegratorListener(self)
    }
    
    func onCreate()
    {
        interactor?.addObserver(self)
        interactor?.addNodeSyncListener(self)
        interactor?.addCentralIntegratorListener(self)
        updateViewModel()
    }
    
    func onAttachView(_ view: INodesListView)
    {
        self.view = view
        if isUpdateLocalNodes
        {
            isUpdateLocalNodes = false
            onRefreshLocalNodes()
        }
        else
        {
            updateCellViewModels()
            viewModel.sections = prepareSections(viewModel.nodes)
        }
        view.fill(viewModel)
        if UserDefaults.standard.bool(forKey: CENTRAL_SYNC_STATUS_KEY) == false
        {
            view.closeCentralSyncProgressView()
        }
        onClickCell()
    }
    
    func onDettachView()
    {
        view = nil
        closeCentralSyncViewTimer?.invalidate()
    }
    
    func onRefreshLocalNodes()
    {
        view?.showProgress(withMessage: "Searching...")
        interactor?.findLocalDevice()
    }
    
    func onSyncWithCentral()
    {
        if viewModel.isStartedSync == false
        {
            viewModel.isStartedSync = true
            closeCentralSyncViewTimer?.invalidate()
            view?.closeCentralSyncProgressView()
            interactor?.syncWithCentral()
        }
    }

    func onSyncWithNode(_ models: [NodeListCellViewModel])
    {
        viewModel.isStartedSync = true
        for model in models
        {
            model.isEnableCommands = false
        }
        let fingerprints = models.map { return $0.fingerprint }
        interactor?.sync(withNode:fingerprints)
        view?.refreshPageControl()
        view?.changeStateActiveElements(viewModel)
    }
    
    func onClickSettings()
    {
        navigation?.showSettingsScreen()
    }
    
    func onGroupSettings(_ type: ENodeListTab, models: [NodeListCellViewModel])
    {
        if !models.isEmpty
        {
            let fingerprints = models.map { $0.fingerprint }
            switch type
            {
            case .INTEGRATION_TAB:
                navigation?.showNodeIntegrationScreen(fingerprints)
            case .NETWORK_SETTINGS_TAB:
                navigation?.showNetworkSettingsScreen(fingerprints)
            case .RESTART_TAB:
                navigation?.showDeviceRebotShutdownScreen(fingerprints.first)
            }
        }
    }
    
    func onNodeAction(_ action: EDeviceCommanTag, model: NodeListCellViewModel)
    {
        switch action
        {
        case .RESTART_NODE_TAG:
            view?.showAlert("Info", message: "Do you want to restart the Node?", acceptText: "Yes", declineText: "Cancel") { (isAccepted) in
                if isAccepted
                {
                    self.restartNode([model])
                }
            }
        case .RESTART_PLAYBACK_TAG:
            view?.showAlert("Info", message: "Do you want to restart playback?", acceptText: "Yes", declineText: "Cancel") { (isAccepted) in
                if isAccepted
                {
                    self.restartPlayback([model])
                }
            }
        case .REBOOT_AND_SHUTDOWN_TAG:
            view?.showAlert("Info", message: "Do you want to shutdown the Node?", acceptText: "Yes", declineText: "Cancel") { (isAccepted) in
                if isAccepted
                {
                    self.rebootAndShutdown([model])
                }
            }
        case .SYNC_WITH_EI_CENTRAL_TAG:
            onSyncWithNode([model])
        case .GET_INFO_TAG:
            refreshDetailsFor(model.fingerprint)
        default:
            break
        }
    }
    
    func onChangePage(_ index: Int)
    {
        viewModel.page = ENodeListPage(rawValue: index)!
        viewModel.sections = prepareSections(viewModel.nodes)
        view?.refreshPageControl()
    }
    
    func onClickCell()
    {
        if viewModel.getSelectedNodes().count == 0
        {
            view?.disableGroupOperations()
        }
        else
        {
            view?.enableGroupOperations()
        }
    }
}

private extension NodesListPresenter
{
    func updateViewModel()
    {
        viewModel.isExtenderMode = AppStatus.isExtendedMode()
        updateCellViewModels()
        viewModel.sections = prepareSections(viewModel.nodes)
        let level = interactor!.getUserLevel()
        if viewModel.isExtenderMode, level == .ADMIN_LEVEL
        {
            viewModel.isShowSections = true
            viewModel.isShowGroupOperations = true
            viewModel.isShowSyncWithCentralButton = true
            viewModel.defaultStatus = .CENTRAL_AND_LOCAL_STATUS
        }
        else
        {
            if level == .USER_LEVEL
            {
                viewModel.isShowGroupOperations = false
                viewModel.isShowSyncWithCentralButton = true
                viewModel.defaultStatus = .CENTRAL_AND_LOCAL_STATUS
            }
            else
            {
                viewModel.isShowGroupOperations = true
                viewModel.isShowSyncWithCentralButton = false
                viewModel.defaultStatus = .LOCAL_STATUS
            }
            viewModel.isShowSections = false
        }
    }
    
    func updateCellViewModels()
    {
        let devicesStorage: INodeStorage = interactor!.getNodeStorage()
        var models = [ENodeListPage:[NodeListCellViewModel]]()
        var tempItems = prepareCellViewModels(Array(devicesStorage.getNodes().values))
        if !tempItems.isEmpty
        {
            models[.NODE_PAGE] = tempItems
        }
        tempItems = prepareCellViewModels(Array(devicesStorage.getControllers().values))
        if !tempItems.isEmpty
        {
            models[.CONTROLLER_PAGE] = tempItems
        }
        tempItems = prepareCellViewModels(Array(devicesStorage.getNotSuported().values))
        if !tempItems.isEmpty
        {
            models[.NOT_SUPPORTED_PAGE] = tempItems
        }
        viewModel.cellViewModels = models
    }
    
    func prepareCellViewModels(_ nodes: [Device]) -> [NodeListCellViewModel]
    {
        let fingerprints = interactor?.getfingerprintsReadyToBeUpdated()
        var viewModels : [NodeListCellViewModel] = []
        for node in nodes
        {
            if AppStatus.isServiceMode()
            {
                if node.status == .CENTRAL_STATUS
                {
                    continue
                }
                else if node.status == .CENTRAL_AND_LOCAL_STATUS
                {
                    node.status = .LOCAL_STATUS
                }
            }
            let model: NodeListCellViewModel = createCellViewModel(node, fingerprints!)
            viewModels.append(model)
        }
        return viewModels
    }

    func createCellViewModel(_ device: Device, _ fingerprints: [String]) -> NodeListCellViewModel
    {
        let operationLog: DeviceOperationLog? = operationLogsTable.getLastByFingerprint(device.fingerprint)
        var model: NodeListCellViewModel
        if let syncModel = syncViewModel, syncModel.fingerprint == device.fingerprint
        {
            model = syncModel
        }
        else
        {
            model = NodeListCellViewModel()
        }
        model.fingerprint = device.fingerprint
        model.title = String.valueOrNA(device.title)
        model.systemId = String.valueOrNA(device.sid)
        model.serialNumber = String.valueOrNA(device.sn)
        model.productId = String.valueOrNA(device.productId)
        model.version = String.valueOrNA(device.version)
        model.edition = String.valueOrNA(device.edition)
        model.companyUnique = String.valueOrNA(device.company)
        model.timezone = String.valueOrNA(device.timezone)
        model.isShowSyncMessage = device.syncStatus != nil || operationLog != nil
        if device.model != nil && !device.model.isEmpty
        {
            model.model = device.model.uppercased()
        }
        else if device.productId != nil && !device.productId.isEmpty
        {
            model.model = device.productId.uppercased()
        }
        else
        {
            model.model = String.valueOrNA(device.model)
        }
        fillCellViewModel(byAppMode: model, node: device, fingerprintsReadyToBeUpdated: fingerprints)
        fillUserInteraction(model, status: device.status)
        if device.syncStatus != nil && device.syncStatus.processing != .SYNCED && (operationLog != nil && device.syncStatus.lastTimestamp > operationLog!.timestamp) && viewModel.isExtenderMode
        {
            fillSyncState(model, device.syncStatus)
        }
        else if operationLog != nil
        {
            fillLogState(model, operationLog!)
        }
        return model
    }
    
    func fillCellViewModel(byAppMode model: NodeListCellViewModel, node: Device, fingerprintsReadyToBeUpdated: [String])
    {
        model.isExtenderMode = viewModel.isExtenderMode
        model.swipeCommands = [.RESTART_NODE_TAG, .RESTART_PLAYBACK_TAG, .REBOOT_AND_SHUTDOWN_TAG]
        if model.isExtenderMode
        {
            if node.syncStatus == nil || (node.syncStatus.processing != .WAITING_SYNC && node.syncStatus.processing != .SYNCHRONIZING)
            {
                model.isReadyToBeUpdated = fingerprintsReadyToBeUpdated.contains(model.fingerprint) && !viewModel.isStartedSync
                model.isEnableCommands = true
                model.swipeCommands.append(.SYNC_WITH_EI_CENTRAL_TAG)
            }
            else
            {
                model.isReadyToBeUpdated = false
                model.isEnableCommands = false
            }
        }
        else
        {
            model.isReadyToBeUpdated = false
            model.isEnableCommands = true
        }
    }
    
    func fillUserInteraction(_ model: NodeListCellViewModel, status: EDeviceStatus)
    {
        model.status = status
        switch status {
        case .CENTRAL_AND_LOCAL_STATUS, .LOCAL_STATUS:
            model.isUserInteractionEnabled = true
        case .CENTRAL_STATUS:
            model.isUserInteractionEnabled = false
        }
    }
    
    func fillSyncState(_ model: NodeListCellViewModel, _ syncStatus: DeviceSyncStatus)
    {
        let date = Date(timeIntervalSince1970: TimeInterval(syncStatus.lastTimestamp))
        let dateString = String.from(date, "yyyy/MM/dd hh:mm:ss", NSString.localUS())
        switch syncStatus.processing
        {
        case .WAITING_SYNC:
            model.syncMessage = "WAITING..."
            model.syncIconName = "device_sync_progress_icon"
        case .SYNCHRONIZING:
            if let syncModel = syncViewModel, syncModel.fingerprint == model.fingerprint
            {
                model.syncMessage = syncModel.syncMessage
            }
            else
            {
                model.syncMessage = "SYNCHRONIZATION..."
            }
            model.syncIconName = "device_sync_progress_icon"
        case .END_SYNC, .SYNCED:
            model.syncMessage = "LAST SYNC ATTEMPT: \(dateString)"
            model.syncIconName = "device_sync_end_icon"
        case .ERROR_SYNC:
            model.syncMessage = syncStatus.message
            model.syncIconName = "device_sync_error_icon"
        }

        if syncStatus.processing != .ERROR_SYNC
        {
            model.isSyncError = false
        }
        else
        {
            model.isSyncError = true
        }
    }
    
    func fillLogState(_ model: NodeListCellViewModel, _ log: DeviceOperationLog)
    {
        model.syncMessage = log.actionTitle
        if log.errorMessage == nil || log.errorMessage.isEmpty
        {
            model.isSyncError = false
            model.syncIconName = "device_sync_end_icon"
        }
        else
        {
            model.isSyncError = true
            model.syncIconName = "device_sync_error_icon"
        }
    }
    
    func getCellViewModel(_ fingerprint: String) -> NodeListCellViewModel?
    {
        let models = viewModel.cellViewModels.flatMap { $0.value }
        return models.filter { $0.fingerprint == fingerprint }.first
    }
    
    func prepareSections(_ cells: [NodeListCellViewModel]) -> [NodeListSectionViewModel]
    {
        var result = [NodeListSectionViewModel]()
        var statuses : [EDeviceStatus] = []
        if viewModel.isExtenderMode && interactor?.getUserLevel() == .ADMIN_LEVEL
        {
            statuses = [.CENTRAL_AND_LOCAL_STATUS, .CENTRAL_STATUS, .LOCAL_STATUS]
        }
        else
        {
            statuses = [.LOCAL_STATUS]
        }
        
        for status in statuses
        {
            let section: NodeListSectionViewModel? = createSectionModel(status, cells: cells)
            if let lSection = section
            {
                result.append(lSection)
            }
        }
        return result
    }
    
    func createSectionModel(_ status: EDeviceStatus, cells: [NodeListCellViewModel]) -> NodeListSectionViewModel?
    {
        var model: NodeListSectionViewModel?
        if isStatusContaints(status, cells: cells)
        {
            var text: String? = nil
            switch status
            {
            case .CENTRAL_AND_LOCAL_STATUS:
                text = "FOUND"
            case .CENTRAL_STATUS:
                text = "NOT FOUND"
            case .LOCAL_STATUS:
                text = "UNDEFINED"
            }
            model = NodeListSectionViewModel.build(status, text: text)
        }
        return model
    }
    
    func isStatusContaints(_ status: EDeviceStatus, cells: [NodeListCellViewModel]) -> Bool
    {
        let filtered = cells.filter { (model) -> Bool in
            return model.status == status 
        }
        return !filtered.isEmpty
    }
    
    func parseGetInfoResponse(_ fingerprint: String, parameters: [String : Any]) -> NodeListCellViewModel
    {
        let deviceStorage:INodeStorage = interactor!.getNodeStorage()
        let device: Device = deviceStorage.getDeviceByFingerprint(fingerprint)!
        device.updateInfo(parameters)
        let fingerprints = interactor!.getfingerprintsReadyToBeUpdated()!
        return createCellViewModel(device, fingerprints)
    }
    
    func restartNode(_ models: [NodeListCellViewModel])
    {
        view?.showProcessing()
        let fingerprints = models.map { $0.fingerprint }
        let nodeStorage: INodeStorage? = interactor?.getNodeStorage()
        let nodes = nodeStorage?.getDevicesByFingerprints(fingerprints)
        commandSender?.send(command: .REBOOT_AND_SHUTDOWN, nodes: nodes!, parameters: ["type": "reboot_scheduler"], completion: { (result) in
            if result.error == nil
            {
                self.view?.showAlert(withTitle: "Info", message: "Successful")
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                    self.interactor?.findLocalDevice()
                })
            }
            else
            {
                self.view?.hideProgress()
                self.view?.showAlert(withTitle: "Error", message: result.error)
            }
        })
    }
    
    func restartPlayback(_ models: [NodeListCellViewModel])
    {
        view?.showProcessing()
        let fingerprints = models.map { $0.fingerprint }
        let nodeStorage: INodeStorage? = interactor?.getNodeStorage()
        let nodes = nodeStorage?.getDevicesByFingerprints(fingerprints)
        commandSender?.send(command: .REBOOT_AND_SHUTDOWN, nodes: nodes!, parameters: ["type": "reboot_playback"], completion: { (result) in
            self.view?.hideProgress()
            if result.error == nil
            {
                self.view?.showAlert(withTitle: "Info", message: "Successful")
            }
            else
            {
                self.view?.showAlert(withTitle: "Error", message: result.error)
            }
        })
    }
    
    func rebootAndShutdown(_ models: [NodeListCellViewModel])
    {
        view?.showProcessing()
        let fingerprints = models.map { $0.fingerprint }
        let nodeStorage: INodeStorage? = interactor?.getNodeStorage()
        let nodes = nodeStorage?.getDevicesByFingerprints(fingerprints)
        /// TODO hvk: change (REBOOT_AND_SHUTDOWN | type : reset_appliance) after implemented command class
        commandSender?.send(command: .REBOOT_AND_SHUTDOWN, nodes: nodes!, parameters: ["type": "reset_appliance"], completion: { (result) in
            self.view?.hideProgress()
            if result.error == nil
            {
                self.view?.showAlert(withTitle: "Info", message: "Successful")
            }
            else
            {
                self.view?.showAlert(withTitle: "Error", message: result.error)
            }
        })
    }
}
    
extension NodesListPresenter: IDeviceDetailsScreenAction
{
    func refreshDetailsFor(_ fingerprint: String)
    {
        let devicesStorage:INodeStorage = interactor!.getNodeStorage()
        let device: Device = devicesStorage.getDeviceByFingerprint(fingerprint)!
        let currentTime = Int(Date().timeIntervalSince1970)
        let timeoutDetailsInfoUpdate: Int = 30
        if currentTime - device.detailsLastTimestamp >= timeoutDetailsInfoUpdate
        {
            view?.showProcessing()
            commandSender!.send(command: .GET_INFO, node: device, parameters: nil, completion: { (result) in
                self.view?.hideProgress()
                if result.error == nil
                {
                    let newModel: NodeListCellViewModel = self.parseGetInfoResponse(fingerprint, parameters: result.params as! [String:Any])
                    self.viewModel.replace(newModel)
                    self.navigation?.showDeviceDetailsScreen(newModel.fingerprint, actionInterface: self)
                }
                else
                {
                    self.view?.showAlert(withTitle: "Error", message: result.error)
                }
            })
        }
        else
        {
            let newModel: NodeListCellViewModel = createCellViewModel(device, interactor!.getfingerprintsReadyToBeUpdated()!)
            self.viewModel.replace(newModel)
            self.navigation?.showDeviceDetailsScreen(newModel.fingerprint, actionInterface: self)
        }
    }
    
    func didSwipe(_ swipe: ESwipeDirection, fingerprint: String)
    {
        let sorted = viewModel.nodes.sorted { $0.status.rawValue > $1.status.rawValue }
        let adder = swipe == .SWIPE_FROM_LEFT_TO_RIGHT ?  -1 : 1
        var index = sorted.index { $0.fingerprint == fingerprint }! + adder
        if index < 0
        {
            index = sorted.count - 1
        }
        else if index >= sorted.count
        {
            index = 0
        }
        let newModel = sorted[index]
        refreshDetailsFor(newModel.fingerprint)
    }
}

extension NodesListPresenter: ServerIntegratorListener
{
    func serverSyncWillStart()
    {
        viewModel.isStartedSync = true
        view?.changeStateActiveElements(viewModel)
        let model = CentralSyncProgressViewModel()
        model.title = "STARTED SYNCHRONIZATION WITH [Ei] CENTRAL"
        model.subtitle = "Synchronization..."
        model.error = nil
        model.percent = 0
        model.isCompleted = false
        view?.refreshSyncProgress(model)
    }
    
    func serverSyncChangeProgress(_ progress: CGFloat, withMessage message: String)
    {
        viewModel.isStartedSync = true
        let model = CentralSyncProgressViewModel()
        model.title = "SYNCHRONIZATION WITH [Ei] CENTRAL"
        model.subtitle = message
        model.error = nil
        model.percent = progress
        model.isCompleted = progress + 0.5 >= 100
        view?.refreshSyncProgress(model)
    }
    
    func serverSyncError(_ error: String)
    {
        viewModel.isStartedSync = false
        let model = CentralSyncProgressViewModel()
        model.title = "SYNCHRONIZATION ERROR WITH [Ei] CENTRAL"
        model.error = error
        model.isCompleted = true
        view?.refreshSyncProgress(model)
    }
    
    func serverSyncDidEnd()
    {
        viewModel.isStartedSync = false
        let model = CentralSyncProgressViewModel()
        model.title = "SYNCHRONIZATION WITH [Ei] CENTRAL"
        model.subtitle = "Completed"
        model.error = nil
        model.percent = 100
        model.isCompleted = true
        view?.refreshSyncProgress(model)
        updateViewModel()
        view?.fill(viewModel)
        closeCentralSyncViewTimer?.invalidate()
        closeCentralSyncViewTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(AUTO_CLOSE_CENTRAL_SYNC_TIME), repeats: false, block: { (timer) in
            self.view?.closeCentralSyncProgressView()
        })
    }
}

extension NodesListPresenter: DeviceSyncListener
{
    func syncToCentralComplete()
    {
        view?.hideProgress()
        updateViewModel()
        viewModel.isStartedSync = false
        view?.fill(viewModel)
    }
    
    func startSync(_ fingerprint: String)
    {
        viewModel.isStartedSync = true
        syncViewModel = getCellViewModel(fingerprint)
        syncViewModel!.isShowSyncMessage = true
        syncViewModel!.isReadyToBeUpdated = false
        syncViewModel!.isEnableCommands = false
        syncViewModel!.syncMessage = "SYNCHRONIZATION..."
        syncViewModel!.syncIconName = "device_sync_progress_icon"
        syncViewModel!.isSyncError = false
        if let model = syncViewModel, viewModel.nodes.contains(model)
        {
            view?.updateCell(by: viewModel.getIndexPath(model))
        }
    }
    
    func syncChangeProgress(_ progress: CGFloat, withMessage message: String)
    {
        viewModel.isStartedSync = true
        syncViewModel!.isShowSyncMessage = true
        syncViewModel!.syncMessage = String(format: "%.2f%% %@", progress, message)
        syncViewModel!.syncProgress = Int(progress)
        syncViewModel!.syncIconName = "device_sync_progress_icon"
        syncViewModel!.isSyncError = false
        if let model = syncViewModel, viewModel.nodes.contains(model)
        {
            view?.updateCell(by: viewModel.getIndexPath(model))
        }
    }
    
    func syncError(_ error: String, fingerprint: String)
    {
        syncViewModel!.isShowSyncMessage = true
        syncViewModel!.isReadyToBeUpdated = true
        syncViewModel!.isEnableCommands = true
        syncViewModel!.syncMessage = error
        syncViewModel!.syncIconName = "device_sync_error_icon"
        syncViewModel!.isSyncError = true
        if let model = syncViewModel, viewModel.nodes.contains(model)
        {
            view?.updateCell(by: viewModel.getIndexPath(model))
        }
    }
    
    func endSync(_ fingerprint: String)
    {
        let date = Date()
        let dateString = String.from(date, "yyyy/MM/dd hh:mm:ss", NSString.localUS())
        syncViewModel?.isShowSyncMessage = true
        syncViewModel?.isReadyToBeUpdated = false
        syncViewModel?.isEnableCommands = true
        syncViewModel?.syncMessage = "LAST SYNC ATTEMPT: \(dateString)"
        syncViewModel?.syncIconName = "device_sync_end_icon"
        syncViewModel?.isSyncError = false
        if let model = syncViewModel, viewModel.nodes.contains(model)
        {
            view?.updateCell(by: viewModel.getIndexPath(model))
        }
        syncViewModel = nil
    }
}
    
extension NodesListPresenter: DevicesChangerInterface
{
    func userDevicesUpdated()
    {
        view?.hideProgress()
        updateViewModel()
        view?.fill(viewModel)
    }
    
    func userDevicesNotUpdated()
    {
        view?.hideProgress()
    }
}
