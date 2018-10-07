//
//  SettingsViewModel.swift
//  EiController
//
//  Created by Henrikh Koreniuzhenko on 02.09.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

private let MINUTES_INTERVAL_MIN: Int = 1
private let INTERVAL_LENGTH_MAX: Int = 4

class SettingsViewModel: NSObject
{
    var eiCentralAddress = ""
    var eiPublisherAddress = ""
    var version = ""
    var space = ""
    var progress: CGFloat = 0.0
    var isHideIntegrationModules = false
    
    var interval = ""
    var isAutoSyncOn = false
    var isShowStatusOn = false
    ///
    var isExtenderMode = true
    
    func getBackgroundColor() -> UIColor
    {
        if isExtenderMode
        {
            return UIColor.init(red: 0.973, green: 0.973, blue: 0.973, alpha: 1)
        }
        else
        {
            return UIColor.init(red: 0.137, green: 0.133, blue: 0.165, alpha: 1)
        }
    }
    
    func getTextColor() -> UIColor
    {
        if isExtenderMode
        {
            return UIColor.init(red: 0.212, green: 0.22, blue: 0.235, alpha: 1)
        }
        else
        {
            return UIColor.white
        }
    }
    
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
    
    func getSpaceTrackColor() -> UIColor
    {
        if isExtenderMode
        {
            return UIColor.hex("ebebeb")
        }
        else
        {
            return UIColor.hex("4c4b5e")
        }
    }
}
