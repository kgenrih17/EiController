//
//  CheckConnectionUpdateServerCommand.swift
//  EiController
//
//  Created by Genrih Korenujenko on 05.05.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

class CheckConnectionUpdateServerCommand : NSObject, INodeCommand
{
    var method : String
    {
        return "Integration.RPN.settings.ManagementServer::checkUpdateServer"
    }
    var params : [String : Any]?
    
    var desc : String { return "Check Connection to Update Server" }

    static func build(_ parameters: Any?) -> INodeCommand
    {
        let result = CheckConnectionUpdateServerCommand()
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
