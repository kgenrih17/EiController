//
//  GetReverseMonitoringServerCommand.m
//  EiController
//
//  Created by admin on 9/28/16.
//  Copyright © 2016 RadicalComputing. All rights reserved.
//

import UIKit

class GetRMServerCommand : NSObject, INodeCommand
{
    var method : String
    {
        return "Integration.RPN.settings.ManagementServer::getTunnelData"
    }
    var params : [String : Any]?
    
    var desc : String { return "Get Reverse Monitoring Configuration Server" }
    
    static func build(_ parameters: Any?) -> INodeCommand
    {
        return GetRMServerCommand()
    }
    
    func isCorrectResponse(_ response: JSONRPCResponse!) -> Bool
    {
        var isCorrect = false
        if let result = response.result as? [String : Any]
        {
            isCorrect = result.containsKeys(["tunnel_enabled"])
        }
        return isCorrect
    }
    
    func isSuccessfulAnswer(_ response: JSONRPCResponse!) -> Bool
    {
        return true
    }
    
    func prepareResult(_ response: JSONRPCResponse!) -> Any?
    {
        return response.result
    }
}
