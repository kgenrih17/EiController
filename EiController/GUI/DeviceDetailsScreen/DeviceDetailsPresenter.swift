//
//  DeviceDetailsPresenterNew.swift
//  EiController
//
//  Created by Henrikh Koreniuzhenko on 29.08.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

let MODE_DEVICE_PRODUCT_ID_EIC100 = "eic100"

class DeviceDetailsPresenter: NSObject
{
    var view : IDeviceDetailsScreen?
    var interactor : AppInteractorInterface
    var navigation : NavigationInterface
    var listener : IDeviceDetailsScreenAction?
    var commandSender : INodeCommandSender
    var statusedUpdater : NodeIntegrationStatusedUpdater?
    var viewModel : DeviceDetailsViewModel?
    var fingerprint : String
    var lastSwipeAction : ESwipeDirection?
    
    init(interactor: AppInteractorInterface, navigation : NavigationInterface, _ fingerprint: String)
    {
        self.interactor = interactor
        self.navigation = navigation
        self.fingerprint = fingerprint
        self.commandSender = NodeCommandSender.build(DeviceOperationLogsTable())
        super.init()
        self.statusedUpdater = NodeIntegrationStatusedUpdater.init(node: device)
    }

    func onAttachView(_ view: IDeviceDetailsScreen, listener: IDeviceDetailsScreenAction?)
    {
        self.view = view
        self.listener = listener
        interactor.addNodeSyncListener(self)
        let isShowedTab = viewModel == nil
        createViewModel()
        view.fill(viewModel)
        if isShowedTab
        {
            onSelectTab(.PROFILE_TAB)
        }
        statusedUpdater?.start { (connectionStatus, server) in
            switch (server)
            {
            case .MANAGEMENT:
                self.viewModel?.managementConnectionStatus = connectionStatus
            case .REVERSE_MONITORING:
                self.viewModel?.reverseMonitoringConnectionStatus = connectionStatus
            case .UPDATE:
                self.viewModel?.updateConnectionStatus = connectionStatus
            }
            self.view?.updateImageBy(serverType: server)
        }
    }
    
    func onDettachView()
    {
        view = nil
        listener = nil
        interactor.removeNodeSyncListener(self)
        statusedUpdater?.stop()
    }
    
//    func onRefreshInfo(_ model: DeviceDetailsViewModel)
//    {
//        wasUsedSwipeAction = false
//        viewModel?.isCanRefresh = false
//        device.detailsLastTimestamp = 0
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1)
//        {
//            self.listener?.refreshDetailsFor(model.fingerprint)
//        }
//    }
//
    func onDidUpdateInfo(_ fingerprint: String)
    {
        if let swipe = lastSwipeAction
        {
            if swipe == .SWIPE_FROM_LEFT_TO_RIGHT
            {
                navigation.leftAnimationChangeDetailsView(fingerprint, actionInterface: listener!)
            }
            else
            {
                navigation.rigthAnimationChangeDetailsView(fingerprint, actionInterface: listener!)
            }
            lastSwipeAction = nil
        }
        else
        {
            self.fingerprint = fingerprint
            createViewModel()
            view?.fill(viewModel)
        }
    }
    
    func onSwipe(_ swipe: ESwipeDirection)
    {
        lastSwipeAction = swipe
        listener?.didSwipe(swipe, fingerprint: fingerprint)
    }
    
    func onSelectTab(_ tab: EDetailsTab)
    {
        viewModel?.selectedTab = tab
        switch tab
        {
        case .PROFILE_TAB:
            viewModel?.title = "Profile"
            view?.showProfile(fingerprint)
        case .PERFORMANCE_TAB:
            viewModel?.title = "Performance"
            view?.showPerformance(fingerprint)
        case .NETWORK_SETTINGS_TAB:
            viewModel?.title = "Network Settings"
            view?.showNetworkSettings(fingerprint)
        case .INTEGRATION_TAB:
            viewModel?.title = "Integration"
            view?.showIntegration(fingerprint)
        case .RESTART_SCHEDULER_TAB:
            viewModel?.title = "Reboot & Shutdown"
            view?.showRestartScheduler(fingerprint)
        case .MODE_TAB:
            viewModel?.title = "Mode"
            view?.showMode(fingerprint)
        case .LOG_TAB:
            viewModel?.title = "Node Operation Log"
            view?.showLog(fingerprint)
        }
        view?.fill(viewModel!)
    }
    
    func onClickSave(title: String)
    {
        view?.showProcessing()
        commandSender.send(command: .SET_NAME, node: device, parameters: title) { (result) in
            self.view?.hideProgress()
            if (result.error == nil)
            {
                self.device.title = title
                self.viewModel?.name = title
                self.view?.fill(self.viewModel!)
                self.view?.showAlert(withTitle: "Info", message: "Successful")
            }
            else
            {
                self.view?.showAlert(withTitle: "Error", message: result.error)
            }
        }
    }
}

private extension DeviceDetailsPresenter
{
    var device : Device
    {
        return interactor.getNodeStorage().getDeviceByFingerprint(fingerprint)!
    }
    
    func createViewModel()
    {
        viewModel = DeviceDetailsViewModel()
        viewModel?.fingerprint = device.fingerprint
        viewModel?.lastUpdateTimestamp = device.detailsLastTimestamp
        viewModel?.name = String.valueOrNA(device.title)
        viewModel?.model = String.valueOrNA(device.model?.uppercased())
        viewModel?.version = String.valueOrNA(device.version)
        viewModel?.sn = String.valueOrNA(device.sn)
        viewModel?.isExtenderMode = AppStatus.isExtendedMode()
        viewModel?.isController = String.valueOrNA(device.model?.lowercased()) == MODE_DEVICE_PRODUCT_ID_EIC100
        viewModel?.isUserMode = interactor.getUserLevel() == .USER_LEVEL
        fillSyncState()
    }
    
    func fillSyncState()
    {
        if device.syncStatus == nil || (device.syncStatus != nil && device.syncStatus.processing != .WAITING_SYNC && device.syncStatus.processing != .SYNCHRONIZING)
        {
            viewModel?.isSynced = false
            viewModel?.isCanEdit = interactor.getUserLevel() == .ADMIN_LEVEL
        }
        else
        {
            viewModel?.isSynced = true
            viewModel?.isCanEdit = false
            viewModel?.syncMessage = device.syncStatus.message
            viewModel?.syncIconName = "device_sync_progress_icon"
            viewModel?.syncProgress = 0
            viewModel?.isSyncError = false
        }
    }
    
}

extension DeviceDetailsPresenter: DeviceSyncListener
{
    func syncToCentralComplete()
    {
        createViewModel()
        view?.fill(viewModel)
    }
    
    func startSync(_ fingerprint: String!)
    {
        if self.fingerprint == fingerprint
        {
            viewModel?.isSynced = true
            viewModel?.syncMessage = "SYNCHRONIZATION..."
            viewModel?.syncIconName = "device_sync_progress_icon"
            viewModel?.isSyncError = false
            view?.fill(viewModel)
        }
    }
    
    func syncChangeProgress(_ progress: CGFloat, withMessage message: String!)
    {
        if self.fingerprint == fingerprint
        {
            viewModel?.isSynced = true
            viewModel?.syncMessage = String(format: "%.2f%% ", progress) + message
            viewModel?.syncProgress = Int(progress)
            viewModel?.syncIconName = "device_sync_progress_icon"
            viewModel?.isSyncError = false
            view?.fill(viewModel)
        }
    }
    
    func syncError(_ error: String!, fingerprint: String!)
    {
        if self.fingerprint == fingerprint
        {
            viewModel?.isSynced = false
            viewModel?.isCanEdit = interactor.getUserLevel() == .ADMIN_LEVEL
            viewModel?.syncMessage = error
            viewModel?.syncIconName = "device_sync_error_icon"
            viewModel?.isSyncError = true
            view?.fill(viewModel)
        }
    }
    
    func endSync(_ fingerprint: String!)
    {
        if self.fingerprint == fingerprint
        {
            let dateString = String.from(Date.init(), "yyyy/MM/dd hh:mm:ss", NSString.localUS())
            viewModel?.isSynced = false
            viewModel?.isCanEdit = interactor.getUserLevel() == .ADMIN_LEVEL
            viewModel?.syncMessage = "LAST SYNC ATTEMPT: \(dateString)"
            viewModel?.syncIconName = "device_sync_end_icon"
            viewModel?.isSyncError = false
            view?.fill(viewModel)
        }
    }
}
