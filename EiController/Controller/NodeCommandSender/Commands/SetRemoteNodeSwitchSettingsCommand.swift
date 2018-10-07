//
//  SetRemoteNodeSwitchSettingsCommand.swift
//  EiController
//
//  Created by Genrih Korenujenko on 03.08.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

class SetRemoteNodeSwitchSettingsCommand: NSObject, INodeCommand
{
    var method : String
    {
        return "Integration.RPN.settings.ContextualDeviceService::remoteNodeSetSwitchSettings"
    }
    var params : [String : Any]?
    
    var desc : String { return "Set Remote [Ei] Node Switch Settings" }
    
    static func build(_ parameters: Any?) -> INodeCommand
    {
        let result = SetRemoteNodeSwitchSettingsCommand()
        if let item = parameters as? RemoteNodeSwitchSettingsParams
        {
            result.params = item.buildJson
        }
        return result
    }
    
    func isCorrectResponse(_ response: JSONRPCResponse!) -> Bool
    {
        return response.result as? [String:Any] != nil
    }
    
    func isSuccessfulAnswer(_ response: JSONRPCResponse!) -> Bool
    {
        let result = response.result as! [String:Any]
        return (result.keys.contains("status") && result.bool("status"))
    }
    
    func prepareResult(_ response: JSONRPCResponse!) -> Any?
    {
        let result = response.result as! [String:Any]
        return result.bool("status")
    }
}
