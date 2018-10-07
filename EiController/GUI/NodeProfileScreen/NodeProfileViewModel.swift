//
//  NodeProfileViewModel.swift
//  EiController
//
//  Created by Henrikh Koreniuzhenko on 04.09.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

struct NodeProfileViewModel
{
    var fingerprint : String = ""
    var edition : String?
    var systemID : String?
    var location : String?
    var company : String?
    var ipAddress : String?
    var timeZone : String?
    var registrationDate : String?
    var eiInfo : String?
    var activity : String?
    var rebootScheduler : String?
    var upTime : String?
    var systemTime : String?
    var isEnableCommands = false
    var isExtenderMode = true
    var isNeedUpdate = false
    var isUserMode = false
    
    var rebootSchedulerColor : UIColor
    {
        get
        {
            if let lRebootScheduler = rebootScheduler, !lRebootScheduler.isEmpty, lRebootScheduler != "disabled"
            {
                return getTitleColor()
            }
            else
            {
                return UIColor.init(red: 0.925, green: 0, blue: 0.0863, alpha: 1)
            }
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
    
    func getTitleColor() -> UIColor
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
}
