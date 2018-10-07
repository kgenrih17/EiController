//
//  CheckCpnnectionManagementServer.swift
//  EiController
//
//  Created by Genrih Korenujenko on 07.06.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

class CheckConnectionManagementServer : NSObject, INodeCommand
{
    var method : String
    {
        return "Integration.RPN.settings.ManagementServer::checkIntegrationParams"
    }
    var params : [String : Any]?
    
    var desc : String { return "Check Connection to Management Server" }
    
    static func build(_ parameters: Any?) -> INodeCommand
    {
        let result = CheckConnectionManagementServer()
        if parameters != nil, let host = parameters as? String
        {
            result.params = ["host" : host]
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
