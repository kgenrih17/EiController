//
//  GetManagementServer.swift
//  EiController
//
//  Created by Genrih Korenujenko on 30.05.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

class GetManagementServer : NSObject, INodeCommand
{
    var method : String
    {
        return "Integration.RPN.settings.ManagementServer::getIntegrationParams"
    }
    var params : [String : Any]?
    
    var desc : String { return "Get Management Server" }
    
    static func build(_ parameters: Any?) -> INodeCommand
    {
        return GetManagementServer()
    }
    
    func isCorrectResponse(_ response: JSONRPCResponse!) -> Bool
    {
        var isCorrect = false
        if let dic = response.result as? [String:Any]
        {
            let validKeys = ["is_es_enable", "use_es_as_update_server", "use_es_ssh_connection", "task_timeout", "register_token", "primary_es"]
            let esKeys = ["host", "http_port", "ssh_port"]
            if dic.containsKeys(validKeys), let primaryES = dic["primary_es"] as? [String:Any]
            {
                isCorrect = primaryES.containsKeys(esKeys)
            }
        }
        return isCorrect
    }
    
    func isSuccessfulAnswer(_ response: JSONRPCResponse!) -> Bool
    {
        return true
    }

    func prepareResult(_ response: JSONRPCResponse!) -> Any?
    {
        return DeviceIntegrationInfo.create(response.result as! [String : Any])
    }
}
