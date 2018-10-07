//
//  SetManagementServer.swift
//  EiController
//
//  Created by Genrih Korenujenko on 30.05.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

class SetManagementServer : NSObject, INodeCommand
{
    var method : String
    {
        return "Integration.RPN.settings.ManagementServer::setIntegrationParams"
    }
    var params : [String : Any]?
    
    var desc : String { return "Set Management Server" }
    
    static func build(_ parameters: Any?) -> INodeCommand
    {
        let result = SetManagementServer()
        if let integration = parameters as? DeviceIntegrationInfo
        {
            let primaryES = ["host" : integration.host,
                             "http_port" : integration.httpPort,
                             "ssh_port" : integration.sshPort,
                             "ftp_port" : integration.ftpPort] as [String : Any]
            let secondaryES = ["host" : integration.secondaryHost,
                               "http_port" : integration.secondaryHTTPPort,
                               "ssh_port" : integration.secondarySSHPort,
                               "ftp_port" : integration.secondaryFTPPort] as [String : Any]
            let paramsDict = ["is_es_enable" : integration.isOn,
                              "use_es_as_update_server" : integration.isUseUpdate,
                              "use_es_ssh_connection" : integration.isUseSFTP,
                              "task_timeout" : integration.esTaskCompletionTimeout,
                              "register_token" : integration.registrationToken,
                              "primary_es" : primaryES,
                              "secondary_es" : secondaryES] as [String : Any]
            result.params = ["params" : paramsDict]
        }
        return result
    }
    
    func isCorrectResponse(_ response: JSONRPCResponse!) -> Bool
    {
        return response.result as? NSNumber != nil
    }
    
    func isSuccessfulAnswer(_ response: JSONRPCResponse!) -> Bool
    {
        return (response.result as! NSNumber).boolValue
    }
    
    func prepareResult(_ response: JSONRPCResponse!) -> Any?
    {
        return response.result
    }
}

