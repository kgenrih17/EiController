//
//  NodeNetworkSettingsViewModel.swift
//  EiController
//
//  Created by Henrikh Koreniuzhenko on 21.09.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

class NodeNetworkSettingsViewModel: NSObject
{
    var isExtender = true
    
    var ethernet = EthernetViewModel()
    var wifi = WiFiViewModel()
    
    var dns1 = [String]()
    var dns2 = [String]()
    var dns3 = [String]()
    
    func getProtocols() -> [String : String]
    {
        return ["NONE" : "NONE", "WEP" : "WEP", "WPA-PSK" : "WPA/WPA2", "WPA-EAP-PEAP" : "WPA/WPA2 EAP PEAP"]
    }
    
    func getBackgroundColor() -> UIColor
    {
        if isExtender
        {
            return UIColor.init(red: 0.922, green: 0.922, blue: 0.922, alpha: 1)
        }
        else
        {
            return UIColor.init(red: 0.129, green: 0.125, blue: 0.157, alpha: 1)
        }
    }
    
    func getContainerColor() -> UIColor
    {
        if isExtender
        {
            return UIColor.white
        }
        else
        {
            return UIColor.init(red: 0.329, green: 0.318, blue: 0.404, alpha: 1)
        }
    }
    
    func getDisableTabLineColor() -> UIColor
    {
        if isExtender
        {
            return UIColor.init(red: 0.933, green: 0.933, blue: 0.933, alpha: 1)
        }
        else
        {
            return UIColor.init(red: 0.314, green: 0.302, blue: 0.384, alpha: 1)
        }
    }
}

class EthernetViewModel: NSObject
{
    var isUseDHCP = true
    var isIP6 = true
    var ip4 = NetworkIP4ViewModel()
    var ip6 = NetworkIP6ViewModel()
}

class WiFiViewModel: NSObject
{
    var isStatusOn = true
    var isPreferredOn = true
    var isUseDHCP = true
    var isIP6 = true
    var ssid = ""
    var securityProtocol = ""
    var authKey = ""
    var authIdentity = ""
    var authPassword = ""
    var authPrivateKeyPassword = ""
    
    var ip4 = NetworkIP4ViewModel()
    var ip6 = NetworkIP6ViewModel()
}


class NetworkIP6ViewModel: NSObject
{
    var ipAddress = ""
    var netmask = ""
    var gateway = ""
}

class NetworkIP4ViewModel: NSObject
{
    var ipAddress = [String]()
    var netmask = [String]()
    var gateway = [String]()
}
