//
//  DeviceDetailsViewModel.swift
//  EiController
//
//  Created by Henrikh Koreniuzhenko on 27.08.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

class DeviceDetailsViewModel
{
    var managementConnectionStatus = EConnectionStatusServer.NO_CONNECTION_STATUS
    var managementConnectionImageName : String
    {
        switch managementConnectionStatus
        {
        case .CONNECTED_STATUS:
            return "node_status_management_server_active_icon"
        case .DISCONNECTED_STATUS:
            return "node_status_management_server_inactive_icon"
        case .NO_CONNECTION_STATUS:
            return "node_status_management_server_undefined_icon"
        }
    }
    var reverseMonitoringConnectionStatus = EConnectionStatusServer.NO_CONNECTION_STATUS
    var reverseMonitoringConnectionImageName : String
    {
        switch reverseMonitoringConnectionStatus
        {
        case .CONNECTED_STATUS:
            return "node_status_support_server_active_icon"
        case .DISCONNECTED_STATUS:
            return "node_status_support_server_inactive_icon"
        case .NO_CONNECTION_STATUS:
            return "node_status_support_server_undefined_icon"
        }
    }
    var updateConnectionStatus = EConnectionStatusServer.NO_CONNECTION_STATUS
    var updateConnectionImageName : String
    {
        switch updateConnectionStatus
        {
        case .CONNECTED_STATUS:
            return "node_status_update_server_active_icon"
        case .DISCONNECTED_STATUS:
            return "node_status_update_server_inactive_icon"
        case .NO_CONNECTION_STATUS:
            return "node_status_update_server_undefined_icon"
        }
    }
    ///
    var name : String?
    var model : String?
    var version : String?
    var sn : String?
    var isController = false
    var isExtenderMode = true
    var isUserMode = false
    
    //    ///
    //    var syncMessage : String?
    //    var syncIconName : String?
    //    var isSyncError = false
    //    var isShowSyncMessage = false
    ///

    var fingerprint : String = ""
    var title : String?
    var isCanEdit : Bool = false
    var isSynced : Bool = false
    var selectedTab = EDetailsTab.PROFILE_TAB
    /// Update Info
    var lastUpdateTimestamp : Int = 0
    
    /// Sync progress
    var isSyncError = false
    var syncMessage : String?
    var syncColor : UIColor
    {
        get
        {
            if isSyncError
            {
                return UIColor.init(red: 0.867, green: 0, blue: 0, alpha: 1)
            }
            else
            {
                return UIColor.init(red: 0.345, green: 0.345, blue: 0.345, alpha: 1)
            }
        }
    }
    var syncIconName : String?
    var syncProgress : Int?
    
    func getRefreshAttempt() -> NSAttributedString
    {
        let title = "Last Refresh attempt: "
        let subtitle = String.from(Date.init(timeIntervalSince1970: TimeInterval(lastUpdateTimestamp)), "yyyy/MM/dd hh:mm:ss a", NSString.localUS())
        let fullServerName = title + subtitle
        let attrName = NSMutableAttributedString.init(string: fullServerName)
        var range = fullServerName.range(of: title)
        let titleRange = NSRange.init(location: range!.lowerBound.encodedOffset,
                                      length: range!.upperBound.encodedOffset - range!.lowerBound.encodedOffset)
        attrName.setAttributes([NSAttributedStringKey.foregroundColor: UIColor.init(red: 0.486, green: 0.506, blue: 0.549, alpha: 1),
                                NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15, weight: .light)],
                               range: titleRange)
        range = fullServerName.range(of: subtitle)
        let subtitleRange = NSRange.init(location: range!.lowerBound.encodedOffset,
                                         length: range!.upperBound.encodedOffset - range!.lowerBound.encodedOffset)
        attrName.addAttributes([NSAttributedStringKey.foregroundColor: UIColor.init(red: 0.212, green: 0.22, blue: 0.235, alpha: 1),
                                NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16, weight: .light)],
                               range: subtitleRange)
        return attrName
    }
    
    func getSyncIcon() -> UIImage?
    {
        if let name = syncIconName
        {
            return UIImage.init(named: name)
        }
        else
        {
            return nil
        }
    }

    func getNameColor() -> UIColor
    {
        if isExtenderMode
        {
            return UIColor.init(red: 0.212, green: 0.204, blue: 0.267, alpha: 1)
        }
        else
        {
            return UIColor.white
        }
    }
    
    func getVersionBackgroundColor() -> UIColor
    {
        if isExtenderMode
        {
            return UIColor.init(red: 0.561, green: 0.553, blue: 0.6, alpha: 1)
        }
        else
        {
            return UIColor.init(red: 0.231, green: 0.22, blue: 0.298, alpha: 1)
        }
    }
    
    func getVersionTextColor() -> UIColor
    {
        if isExtenderMode
        {
            return UIColor.white
        }
        else
        {
            return UIColor.init(red: 0.608, green: 0.631, blue: 0.678, alpha: 1)
        }
    }
    
    func getNodeBorderColor() -> UIColor
    {
        if isExtenderMode
        {
            return UIColor.init(red: 0.635, green: 0.651, blue: 0.702, alpha: 1)
        }
        else
        {
            return UIColor.init(red: 0.333, green: 0.329, blue: 0.4, alpha: 1)
        }
    }

    func getNodeBackgrondColor() -> UIColor
    {
        if isExtenderMode
        {
            return UIColor.init(red: 0.973, green: 0.973, blue: 0.973, alpha: 1)
        }
        else
        {
            return UIColor.init(red: 0.231, green: 0.22, blue: 0.298, alpha: 1)
        }
    }
    
    func getNodeDescriptionBackgroundColor() -> UIColor
    {
        if isExtenderMode
        {
            
            return UIColor.white
        }
        else
        {
            return UIColor.init(red: 0.235, green: 0.224, blue: 0.298, alpha: 1)
        }
    }

    func getImageFor(tab: EDetailsTab) -> UIImage?
    {
        switch tab
        {
        case .PROFILE_TAB:
            if selectedTab == tab
            {
                return UIImage.init(named: "details_icon_active_profile.png")
            }
            else
            {
                return UIImage.init(named: "details_icon_inactive_profile.png")
            }
        case .PERFORMANCE_TAB:
            if selectedTab == tab
            {
                return UIImage.init(named: "details_icon_active_performance.png")
            }
            else
            {
                return UIImage.init(named: "details_icon_inactive_performance.png")
            }
        case .INTEGRATION_TAB:
            if selectedTab == tab
            {
                return UIImage.init(named: "details_icon_active_integration.png")
            }
            else
            {
                return UIImage.init(named: "details_icon_inactive_integration.png")
            }
        case .NETWORK_SETTINGS_TAB:
            if selectedTab == tab
            {
                return UIImage.init(named: "details_icon_active_network.png")
            }
            else
            {
                return UIImage.init(named: "details_icon_inactive_network.png")
            }
        case .RESTART_SCHEDULER_TAB:
            if selectedTab == tab
            {
                return UIImage.init(named: "details_icon_active_restart.png")
            }
            else
            {
                return UIImage.init(named: "details_icon_inactive_restart.png")
            }
        case .MODE_TAB:
            if selectedTab == tab
            {
                return UIImage.init(named: "details_icon_active_mode.png")
            }
            else
            {
                return UIImage.init(named: "details_icon_inactive_mode.png")
            }
        case .LOG_TAB:
            if selectedTab == tab
            {
                return UIImage.init(named: "details_icon_active_log.png")
            }
            else
            {
                return UIImage.init(named: "details_icon_inactive_log.png")
            }
        }
    }
    
    func getModelIcon() -> UIImage
    {
        return UIImage.nodeIconBy(model: model)
    }
}

