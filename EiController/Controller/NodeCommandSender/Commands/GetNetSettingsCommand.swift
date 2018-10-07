//
//  GetNetSettingsCommand.h
//  EiController
//
//  Created by admin on 9/27/16.
//  Copyright © 2016 RadicalComputing. All rights reserved.
//

import UIKit

class GetNetSettingsCommand : NSObject, INodeCommand
{
    var method : String
    {
        return "Integration.RPN.settings.ProfilerService::getNetworkSettings"
    }
    var params : [String : Any]?
    
    var desc : String { return "Get Network Settings" }
    
    static func build(_ parameters: Any?) -> INodeCommand
    {
        return GetNetSettingsCommand()
    }
    
    func isCorrectResponse(_ response: JSONRPCResponse!) -> Bool
    {
        var isCorrect = false
        if let result = response.result as? [String : Any], let ethernet = result["ethernet"] as? [String:Any], let wifi = result["wifi"] as? [String:Any]
        {
            let ethernetValidKeys = ["ipdhcp", "ipdns1", "ipdns2", "ipdns3", "ipaddress", "ipnetmask", "ipgateway", "ip_version"]
            let wifiValidKeys = ["wifi_preferred", "ipdhcp1", "wifi_enabled", "ssid", "security_protocol", "auth_identity", "auth_key", "auth_password", "auth_private_key_passwd", "ipaddress1", "ipnetmask1", "ipgateway1", "ip_version1"]
            isCorrect = (ethernet.containsKeys(ethernetValidKeys) && wifi.containsKeys(wifiValidKeys))
        }
        return isCorrect
    }
    
    func isSuccessfulAnswer(_ response: JSONRPCResponse!) -> Bool
    {
        return true
    }
    
    func prepareResult(_ response: JSONRPCResponse!) -> Any?
    {
        let dic = response.result as! [String:Any]
        let netSettings = NetworkSettings()
        netSettings.lastSyncTimestamp = Int(NSDate.init().timeIntervalSince1970)
        fill(netSettings, ethernet: dic.dictionary("ethernet"))
        fill(netSettings, wifi: dic.dictionary("wifi"))
        return netSettings;
    }
    
    private func fill(_ networkSettings: NetworkSettings, ethernet: [String:Any])
    {
        networkSettings.ipdhcp = ethernet.int("ipdhcp")
        networkSettings.dns1 = ethernet.string("ipdns1")
        networkSettings.dns2 = ethernet.string("ipdns2")
        networkSettings.dns3 = ethernet.string("ipdns3")
        networkSettings.ethernetIP = IPSettings.build(ethernet.string("ipaddress"),
                                                      netmask: ethernet.string("ipnetmask"),
                                                      gateway: ethernet.string("ipgateway"),
                                                      version: ethernet.string("ip_version"))
    }
    
    private func fill(_ networkSettings: NetworkSettings, wifi: [String:Any])
    {
        networkSettings.wifiPreferred = wifi.int("wifi_preferred")
        networkSettings.wifiIpdhcp1 = wifi.int("ipdhcp1")
        networkSettings.wifiEnabled = wifi.int("wifi_enabled")
        networkSettings.wifiSsid = wifi.string("ssid")
        networkSettings.wifiSecurityProtocol = wifi.string("security_protocol").uppercased()
        networkSettings.wifiAuthIdentity = wifi.string("auth_identity")
        networkSettings.wifiAuthKey = wifi.string("auth_key")
        networkSettings.wifiAuthPassword = wifi.string("auth_password")
        networkSettings.wifiAuthPrivateKeyPassword = wifi.string("auth_private_key_passwd")
        networkSettings.wifiIP = IPSettings.build(wifi.string("ipaddress1"),
                                                  netmask: wifi.string("ipnetmask1"),
                                                  gateway: wifi.string("ipgateway1"),
                                                  version: wifi.string("ip_version1"))
        if networkSettings.dns1 == nil || networkSettings.dns1.isEmpty { networkSettings.dns1 = wifi.string("ipdns1") }
        if networkSettings.dns2 == nil || networkSettings.dns2.isEmpty { networkSettings.dns2 = wifi.string("ipdns2") }
        if networkSettings.dns3 == nil || networkSettings.dns3.isEmpty { networkSettings.dns3 = wifi.string("ipdns3") }
    }
}
