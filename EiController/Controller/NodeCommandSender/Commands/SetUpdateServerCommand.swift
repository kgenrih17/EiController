//
//  SetUpdateServerCommand.swift
//  EiController
//
//  Created by Genrih Korenujenko on 05.05.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

class SetUpdateServerCommand : NSObject, INodeCommand
{
    var method : String
    {
        return "Integration.RPN.settings.ManagementServer::setUpdateServer"
    }
    var params : [String : Any]?
    
    var desc : String { return "Set Update Server" }

    static func build(_ parameters: Any?) -> INodeCommand
    {
        let result = SetUpdateServerCommand()
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
