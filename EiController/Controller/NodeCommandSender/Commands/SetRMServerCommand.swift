//
//  SetReverseMonitoringServerCommand.swift
//  EiController
//
//  Created by Genrih Korenujenko on 05.05.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

class SetRMServerCommand : NSObject, INodeCommand
{
    var method : String
    {
        return "Integration.RPN.settings.ManagementServer::setTunnelData"
    }
    var params : [String : Any]?
    
    var desc : String { return "Set Reverse Monitoring Configuration Server" }
    
    static func build(_ parameters: Any?) -> INodeCommand
    {
        let result = SetRMServerCommand()
        if parameters != nil
        {
            result.params = ["params" : parameters!]
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
