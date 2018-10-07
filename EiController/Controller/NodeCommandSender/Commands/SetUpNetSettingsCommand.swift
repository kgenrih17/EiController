//
//  SetUpServerCommand.m
//  EiController
//
//  Created by admin on 2/22/16.
//  Copyright © 2016 RadicalComputing. All rights reserved.
//

import UIKit

class SetUpNetSettingsCommand : NSObject, INodeCommand
{
    var method : String
    {
        return "Integration.RPN.settings.ProfilerService::setNetworkSettings"
    }
    var params : [String : Any]?
    
    var desc : String { return "Set Network Settings" }

    static func build(_ parameters: Any?) -> INodeCommand
    {
        let result = SetUpNetSettingsCommand()
        if let netSetting = parameters as? NetworkSettings
        {
            var paramsDict = [String:Any]()
            paramsDict["ethernet"] = ["ipdhcp" : netSetting.ipdhcp,
                                      "ipaddress" : netSetting.ethernetIP.address,
                                      "ipnetmask" : netSetting.ethernetIP.netmask,
                                      "ipgateway" : netSetting.ethernetIP.gateway,
                                      "ipdns1" : netSetting.dns1,
                                      "ipdns2" : netSetting.dns2,
                                      "ipdns3" : netSetting.dns3,
                                      "ipversion" : netSetting.ethernetIP.version] as [String : Any]
            paramsDict["wifi"] = ["wifi_enabled" : netSetting.wifiEnabled,
                                  "wifi_preferred" : netSetting.wifiPreferred,
                                  "ssid" : netSetting.wifiSsid,
                                  "security_protocol" : netSetting.wifiSecurityProtocol,
                                  "auth_identity" : netSetting.wifiAuthIdentity,
                                  "auth_key" : netSetting.wifiAuthKey,
                                  "auth_password" : netSetting.wifiAuthPassword,
                                  "ipdhcp1" : netSetting.wifiIpdhcp1,
                                  "ipaddress1" : netSetting.wifiIP.address,
                                  "ipnetmask1" : netSetting.wifiIP.netmask,
                                  "ipgateway1" : netSetting.wifiIP.gateway,
                                  "ipdns1" : netSetting.dns1,
                                  "ipdns2" : netSetting.dns2,
                                  "ipdns3" : netSetting.dns3,
                                  "ipversion1" : netSetting.wifiIP.version]  as [String : Any]
            result.params = ["params" : paramsDict]
        }
        return result
    }
    
    func isCorrectResponse(_ response: JSONRPCResponse!) -> Bool
    {
        var isCorrect = false
        if let result = response.result as? [String : Any]
        {
            isCorrect = !result.dictionary("ethernet").isEmpty || !result.dictionary("wifi").isEmpty
        }
        return isCorrect
    }
    
    func isSuccessfulAnswer(_ response: JSONRPCResponse!) -> Bool
    {
        return true
    }
    
    func prepareResult(_ response: JSONRPCResponse!) -> Any?
    {
        return NSNumber.init(value: true)
    }
}

