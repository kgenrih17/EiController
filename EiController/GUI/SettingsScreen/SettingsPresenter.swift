//
//  SettingsPresenter.swift
//  EiController
//
//  Created by Henrikh Koreniuzhenko on 02.09.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

private let CF_BUNDLE_SHORT_VERSION_KEY = "CFBundleShortVersionString"
private let SECONDS_IN_5_MINS = 300
private let SECOND_IN_ONE_HOUR = 3600

class SettingsPresenter: NSObject
{
    weak var view: ISettingsView?
    var interactor: AppInteractorInterface & AuthInterface
    weak var navigation: NavigationInterface?
    var viewModel: SettingsViewModel?
    
    init(interactor : AppInteractorInterface & AuthInterface, navigation : NavigationInterface)
    {
        self.interactor = interactor
        self.navigation = navigation
        super.init()
    }
    
    func onAttachView(_ view: ISettingsView)
    {
        self.view = view
        createViewModel()
        view.fill(viewModel!)
    }
    
    func onDettachView()
    {
        view = nil
    }
    
    func onClickLogout()
    {
        view?.showAlert("Are you sure you want to logout?", message: "", acceptText: "Logout", declineText: "Cancel", completion: { (isAccepted) in
            if isAccepted
            {
                self.navigation?.closeAllScreens()
                self.interactor.logout()
            }
        })
    }
    
    func onClickLogs()
    {
        navigation?.showServerSyncLogScreen()
    }
    
    func onClickAccept()
    {
        view?.retrieveChanges()
        let userDefaults = UserDefaults.standard
        let interval: Int = Int(viewModel!.interval)! * SECOND_IN_ONE_HOUR
        userDefaults.set(interval, forKey: CENTRAL_SYNC_TIMEOUT_KEY)
        userDefaults.set(viewModel!.isShowStatusOn, forKey: CENTRAL_SYNC_STATUS_KEY)
        userDefaults.set(viewModel!.isAutoSyncOn, forKey: CENTRAL_AUTO_SYNC_KEY)
        interactor.updateSyncSettings()
        view?.showAlert(withTitle: "Info", message: "Successful")
    }
}

private extension SettingsPresenter
{
    func createViewModel()
    {
        let byteFormatter = ByteCountFormatter()
        byteFormatter.countStyle = .file
        byteFormatter.allowedUnits = .useGB
        let totalFlesh : Float = Float(NSObject.getStorage(EMemoryType.TOTAL))
        let usedFlesh : Float = Float(NSObject.getStorage(EMemoryType.USED))
        let totalGB = byteFormatter.string(fromByteCount: Int64(totalFlesh))
        let usedGB = byteFormatter.string(fromByteCount: Int64(usedFlesh))
        viewModel = SettingsViewModel()
        viewModel?.isExtenderMode = AppStatus.isExtendedMode()
        viewModel?.version = Bundle.main.infoDictionary![CF_BUNDLE_SHORT_VERSION_KEY] as! String
        viewModel?.space = "\(usedGB) of \(totalGB) Used"
        viewModel?.progress = CGFloat(usedFlesh / totalFlesh)
        let userDefaults = UserDefaults.standard
        let syncTimeout: Int = userDefaults.integer(forKey: CENTRAL_SYNC_TIMEOUT_KEY)
        let interval: Int = (syncTimeout == 0) ? SECONDS_IN_5_MINS : syncTimeout
        viewModel?.interval = "\(interval / SECOND_IN_ONE_HOUR)"
        viewModel?.isShowStatusOn = userDefaults.bool(forKey: CENTRAL_SYNC_STATUS_KEY)
        viewModel?.isAutoSyncOn = userDefaults.bool(forKey: CENTRAL_AUTO_SYNC_KEY)
        if viewModel!.isExtenderMode
        {
            viewModel?.eiCentralAddress = CentralConnectionData.get().urlString
            viewModel?.eiPublisherAddress = PublisherConnectionData.get().urlString
            viewModel?.isHideIntegrationModules = false
        }
        else
        {
            viewModel?.isHideIntegrationModules = true
        }
    }
}
