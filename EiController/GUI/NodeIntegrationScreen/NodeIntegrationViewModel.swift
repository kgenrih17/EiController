//
//  NodeIntegrationViewModel.swift
//  EiController
//
//  Created by Henrikh Koreniuzhenko on 02.09.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

class NodeIntegrationViewModel: NSObject
{
    var isExtenderMode = false

    var isManagementOn = false
    var isUseUpdateOn = false
    var isUseSFTPOn = false
    
    var managementHost = ""
    var httpPort = "80"
    var sshPort = "2222"
    var timeout = "86400"
    var token = ""
    
    var isReversMonitoringOn = false
    var isReversMonitoringError = false
    var reversMonitoringHost = ""
    var reversMonitoringMessage = ""
    var reversMonitoringMessageColor : UIColor { return getMessageColor(isError: isReversMonitoringError) }

    var isUpdateOn = false
    var isUpdateError = false
    var updateHost = ""
    var updateMessage = ""
    var updateMessageColor : UIColor { return getMessageColor(isError: isUpdateError) }
    
    func getContainerColor() -> UIColor
    {
        if isExtenderMode
        {
            return UIColor.white
        }
        else
        {
            return UIColor.init(red: 0.329, green: 0.318, blue: 0.404, alpha: 1)
        }
    }

    func getBackgroundColor() -> UIColor
    {
        if isExtenderMode
        {
            return UIColor.init(red: 0.91, green: 0.906, blue: 0.91, alpha: 1)
        }
        else
        {
            return UIColor.init(red: 0.129, green: 0.125, blue: 0.157, alpha: 1)
        }
    }
    
    private func getMessageColor(isError: Bool) -> UIColor
    {
        if isError
        {
            return UIColor.init(red: 1, green: 0.125, blue: 0.263, alpha: 1)
        }
        else
        {
            return UIColor.init(red: 0, green: 0.82, blue: 0.486, alpha: 1)
        }
    }
}
