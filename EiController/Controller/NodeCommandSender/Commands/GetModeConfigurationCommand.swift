//
//  GetModeConfigurationCommand.h
//  EiController
//
//  Created by Genrih Korenujenko on 20.02.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

class GetModeConfigurationCommand : NSObject, INodeCommand
{
    var method : String
    {
        return "Integration.RPN.settings.ContextualDeviceService::getAuxControllerSettings"
    }
    var params : [String : Any]?
    
    var desc : String { return "Get Mode Configuration" }
    
    static func build(_ parameters: Any?) -> INodeCommand
    {
        return GetModeConfigurationCommand()
    }
    
    func isCorrectResponse(_ response: JSONRPCResponse!) -> Bool
    {
        return response.result as? [String : Any] != nil
    }
    
    func isSuccessfulAnswer(_ response: JSONRPCResponse!) -> Bool
    {
        return true
    }
    
    func prepareResult(_ response: JSONRPCResponse!) -> Any?
    {
        let result = response.result as! [String:Any]
        let modeConfiguration = ModeConfiguration.empty()
        modeConfiguration.snList = result.string("serial_list")
        modeConfiguration.snManual = result.string("serial_manual")
        modeConfiguration.typeLink = result.string("type_link")
        modeConfiguration.pairState = result.string("pair_state").isEmpty ? "disconnect" : result.string("pair_state")
        modeConfiguration.mode = result.string("mode")
        if let pair = result["pair"] as? [String:Any], !pair.isEmpty
        {
            modeConfiguration.ip = pair.string("ip")
            modeConfiguration.edition = pair.string("edition")
            modeConfiguration.model = pair.string("model")
            modeConfiguration.systemID = pair.string("systemid")
            modeConfiguration.title = pair.string("title")
            modeConfiguration.version = pair.string("version")
            modeConfiguration.status = pair.string("status")
            modeConfiguration.pairSN = pair.string("serial")
        }
        
        var isFound = false
        if let controllers = result["controllers"] as? [String:Any], let aux = controllers["aux"] as? [[String:Any]]
        {
            for sensor in aux
            {
                if let actions = sensor["action"] as? [[String:Any]]
                {
                    for action in actions
                    {
                        guard let type = action["type"] as? String
                            else { continue }
                        if type == "ei_switch_20", let actionParams = action["params"] as? [String:Any]
                        {
                            isFound = true
                            modeConfiguration.isEnablePort = true
                            modeConfiguration.ipNodeWatchdog = actionParams.string("nodeip")
                            modeConfiguration.titleNodeWatchdog = actionParams.string("node_title")
                            modeConfiguration.watchdogFingerprint = actionParams.string("fingerprint")
                            modeConfiguration.snWatchdog = actionParams.string("serial")
                            modeConfiguration.timeout = actionParams.int("timeout")
                            modeConfiguration.isEnableWatchdog = modeConfiguration.timeout > 0
                        }
                        if isFound
                        { break }
                    }
                }
                if isFound
                { break }
            }
        }
        return modeConfiguration
    }
}
